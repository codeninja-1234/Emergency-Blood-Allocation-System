USE blood_bank_db;
CREATE TABLE IF NOT EXISTS App_Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    hospital_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (hospital_id) REFERENCES Hospitals(hospital_id),
    CHECK (role IN ('Admin', 'Hospital'))
);
