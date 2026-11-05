# Emergency Blood & Donor Allocation System

Flask backend and browser dashboard for the existing MySQL database `blood_bank_db`.

## Run

1. Create/activate a virtual environment and install dependencies: `pip install -r requirements.txt`
2. Copy `.env.example` to `.env` and set the MySQL password. Export those values in your shell (or load them with your preferred dotenv tool).
3. Ensure the supplied SQL scripts have been run, including `06_procedures.sql`, then run `07_users.sql`.
4. Start the app: `python app.py`
5. Open `http://127.0.0.1:5000`.

Create a password hash for an account:

```powershell
python -c "from werkzeug.security import generate_password_hash; print(generate_password_hash('ChangeMe123!'))"
```

Insert the printed hash into `App_Users`, for example:

```sql
INSERT INTO App_Users (username, password_hash, role) VALUES ('admin', 'PASTE_HASH_HERE', 'Admin');
```

The compatible-donor endpoint uses the database routine directly: `CALL sp_find_compatible_donors(?)`. Completing an allocation relies on the existing database trigger to mark the donor unavailable and updates the related request status to `Completed`.

## Routes

- `GET /` dashboard for hospitals, requests, donors, compatible matching, allocations, and status updates
- `POST /hospitals` and `POST /requests`
- `GET /api/donors` and `GET /api/requests/<request_id>/compatible-donors`
- `POST /allocations` and `PATCH /allocations/<allocation_id>`
- `GET /api/health`

This is an academic demonstration and does not replace clinical eligibility or medical approval.
