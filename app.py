import os
from datetime import date

from functools import wraps
from flask import Flask, jsonify, redirect, render_template, request, session, url_for
import mysql.connector
from mysql.connector import Error
from werkzeug.security import check_password_hash

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "change-this-development-secret")

def login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if "user_id" not in session:
            if request.is_json:
                return json_error("Login required.", 401)
            return redirect(url_for("login", next=request.path))
        return view(*args, **kwargs)
    return wrapped

def role_required(*roles):
    def decorator(view):
        @wraps(view)
        def wrapped(*args, **kwargs):
            if session.get("role") not in roles:
                return json_error("You do not have permission for this action.", 403)
            return view(*args, **kwargs)
        return wrapped
    return decorator


def db_config():
    return {
        "host": os.getenv("DB_HOST", "127.0.0.1"),
        "port": int(os.getenv("DB_PORT", "3306")),
        "user": os.getenv("DB_USER", "root"),
        "password": os.getenv("DB_PASSWORD", ""),
        "database": os.getenv("DB_NAME", "blood_bank_db"),
    }


def query(sql, params=(), *, dictionary=True, commit=False):
    connection = mysql.connector.connect(**db_config())
    cursor = connection.cursor(dictionary=dictionary)
    try:
        cursor.execute(sql, params)
        rows = cursor.fetchall() if cursor.description else []
        if commit:
            connection.commit()
        return rows, cursor.lastrowid
    finally:
        cursor.close()
        connection.close()


def json_error(message, status=400):
    return jsonify({"error": message}), status


@app.get("/")
@login_required
def dashboard():
    try:
        hospitals, _ = query("SELECT * FROM Hospitals ORDER BY name")
        donors, _ = query("SELECT * FROM Donors ORDER BY is_available DESC, full_name")
        requests_, _ = query("SELECT * FROM View_Request_Details ORDER BY created_at DESC")
        allocations, _ = query("""
            SELECT a.*, d.full_name AS donor_name, d.blood_group,
                   r.required_bg, h.name AS hospital_name
            FROM Allocations a
            JOIN Donors d ON d.donor_id = a.donor_id
            JOIN Emergency_Requests r ON r.request_id = a.request_id
            JOIN Hospitals h ON h.hospital_id = r.hospital_id
            ORDER BY a.allocated_at DESC
        """)
        return render_template("dashboard.html", hospitals=hospitals, donors=donors,
                               requests=requests_, allocations=allocations,
                               blood_groups=["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
                               urgencies=["Low", "Medium", "High", "Critical"])
    except Error as exc:
        return render_template("error.html", message=str(exc)), 503

@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        try:
            rows, _ = query("SELECT * FROM App_Users WHERE username=%s AND is_active=TRUE", (username,))
            user = rows[0] if rows else None
            if user and check_password_hash(user["password_hash"], password):
                session.update(user_id=user["user_id"], username=user["username"], role=user["role"], hospital_id=user["hospital_id"])
                return redirect(request.args.get("next") or url_for("dashboard"))
            return render_template("login.html", error="Invalid username or password."), 401
        except Error as exc:
            return render_template("login.html", error=f"Database error: {exc}"), 503
    return render_template("login.html")

@app.get("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


@app.post("/hospitals")
@login_required
@role_required("Admin")
def create_hospital():
    data = request.form or request.get_json(silent=True) or {}
    required = ["name", "license_no", "phone", "city", "address"]
    if any(not str(data.get(k, "")).strip() for k in required):
        return json_error("All hospital fields are required.")
    try:
        _, hospital_id = query("""
            INSERT INTO Hospitals (name, license_no, phone, city, address)
            VALUES (%s, %s, %s, %s, %s)
        """, tuple(data[k] for k in required), commit=True)
        if request.is_json:
            return jsonify({"hospital_id": hospital_id}), 201
        return redirect(url_for("dashboard"))
    except Error as exc:
        return json_error(str(exc))


@app.post("/requests")
@login_required
@role_required("Admin", "Hospital")
def create_request():
    data = request.form or request.get_json(silent=True) or {}
    try:
        values = (int(data["hospital_id"]), data["required_bg"], int(data["units_needed"]), data["urgency_level"])
        _, request_id = query("""
            INSERT INTO Emergency_Requests (hospital_id, required_bg, units_needed, urgency_level)
            VALUES (%s, %s, %s, %s)
        """, values, commit=True)
        if request.is_json:
            return jsonify({"request_id": request_id}), 201
        return redirect(url_for("dashboard"))
    except (KeyError, ValueError):
        return json_error("Hospital, blood group, units, and urgency are required.")
    except Error as exc:
        return json_error(str(exc))


@app.get("/api/donors")
def available_donors():
    try:
        rows, _ = query("SELECT * FROM View_Available_Donors ORDER BY reliability DESC, full_name")
        return jsonify(rows)
    except Error as exc:
        return json_error(str(exc), 503)


@app.get("/api/requests/<int:request_id>/compatible-donors")
def compatible_donors(request_id):
    connection = mysql.connector.connect(**db_config())
    cursor = connection.cursor(dictionary=True)
    try:
        cursor.callproc("sp_find_compatible_donors", (request_id,))
        rows = []
        for result in cursor.stored_results():
            rows.extend(result.fetchall())
        return jsonify(rows)
    except Error as exc:
        return json_error(str(exc), 503)
    finally:
        cursor.close()
        connection.close()


@app.post("/allocations")
@login_required
@role_required("Admin", "Hospital")
def create_allocation():
    data = request.form or request.get_json(silent=True) or {}
    try:
        values = (int(data["request_id"]), int(data["donor_id"]), data.get("assigned_status", "Pending"), data.get("response_sec") or None)
        _, allocation_id = query("""
            INSERT INTO Allocations (request_id, donor_id, assigned_status, response_sec)
            VALUES (%s, %s, %s, %s)
        """, values, commit=True)
        if request.is_json:
            return jsonify({"allocation_id": allocation_id}), 201
        return redirect(url_for("dashboard"))
    except (KeyError, ValueError):
        return json_error("Request and donor are required.")
    except Error as exc:
        return json_error(str(exc))


@app.patch("/allocations/<int:allocation_id>")
@login_required
@role_required("Admin", "Hospital")
def update_allocation(allocation_id):
    data = request.get_json(silent=True) or request.form
    status = data.get("assigned_status")
    if status not in {"Pending", "Accepted", "Rejected", "Completed"}:
        return json_error("Invalid allocation status.")
    try:
        # Keep the request summary in sync with the allocation workflow.
        query("UPDATE Allocations SET assigned_status=%s, completed_at=%s WHERE allocation_id=%s",
              (status, date.today() if status == "Completed" else None, allocation_id), commit=True)
        if status == "Completed":
            query("""
                UPDATE Emergency_Requests r
                JOIN Allocations a ON a.request_id = r.request_id
                SET r.status = 'Completed'
                WHERE a.allocation_id = %s
            """, (allocation_id,), commit=True)
        return jsonify({"allocation_id": allocation_id, "assigned_status": status})
    except Error as exc:
        return json_error(str(exc))


@app.get("/api/health")
def health():
    try:
        query("SELECT 1")
        return jsonify({"status": "ok", "database": "blood_bank_db"})
    except Error as exc:
        return jsonify({"status": "error", "message": str(exc)}), 503


if __name__ == "__main__":
    app.run(debug=os.getenv("FLASK_DEBUG", "0") == "1")
