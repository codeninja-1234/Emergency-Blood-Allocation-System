import os
import mysql.connector
from werkzeug.security import generate_password_hash

connection = mysql.connector.connect(
    host=os.getenv("DB_HOST", "127.0.0.1"),
    port=int(os.getenv("DB_PORT", "3306")),
    user=os.getenv("DB_USER", "root"),
    password=os.getenv("DB_PASSWORD", ""),
    database=os.getenv("DB_NAME", "blood_bank_db"),
)
cursor = connection.cursor()
cursor.execute(
    "UPDATE App_Users SET password_hash=%s WHERE username=%s",
    (generate_password_hash("ChangeMe123!"), "admin"),
)
connection.commit()
print("PASSWORD_RESET_OK")
cursor.close()
connection.close()
