
CREATE DATABASE IF NOT EXISTS blood_bank_db;
USE blood_bank_db;

-- 1. HOSPITALS
CREATE TABLE Hospitals (
    hospital_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    license_no VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    city VARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8)
);

-- 2. DONORS
CREATE TABLE Donors (
    donor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    blood_group VARCHAR(5) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    last_donation_date DATE,
    reliability DECIMAL(3,2) DEFAULT 1.00,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    is_available BOOLEAN DEFAULT TRUE,
    CHECK (blood_group IN
    ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    CHECK (reliability BETWEEN 0 AND 1)
);

-- 3. EMERGENCY REQUESTS
CREATE TABLE Emergency_Requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    hospital_id INT NOT NULL,
    required_bg VARCHAR(5) NOT NULL,
    units_needed INT NOT NULL,
    urgency_level VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hospital_id)
        REFERENCES Hospitals(hospital_id),
    CHECK (units_needed > 0),
    CHECK (required_bg IN
    ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
    CHECK (urgency_level IN
    ('Low','Medium','High','Critical'))
);

-- 4. ALLOCATIONS
CREATE TABLE Allocations (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    donor_id INT NOT NULL,
    assigned_status VARCHAR(20) DEFAULT 'Pending',
    response_sec INT,
    allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (request_id)
        REFERENCES Emergency_Requests(request_id),
    FOREIGN KEY (donor_id)
        REFERENCES Donors(donor_id),
    UNIQUE (request_id, donor_id)
);

-- 5. BLOOD MATRIX
CREATE TABLE Blood_Matrix (
    recipient_bg VARCHAR(5),
    donor_bg VARCHAR(5),
    is_compatible BOOLEAN NOT NULL,
    PRIMARY KEY (recipient_bg, donor_bg)
);

-- 6. DONATION HISTORY
CREATE TABLE Donation_History (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    hospital_id INT NOT NULL,
    donated_date DATE NOT NULL,
    units_donated INT NOT NULL,
    remarks VARCHAR(255),
    FOREIGN KEY (donor_id)
        REFERENCES Donors(donor_id),
    FOREIGN KEY (hospital_id)
        REFERENCES Hospitals(hospital_id),
    CHECK (units_donated > 0)
);

-- 7. NOTIFICATIONS
CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    donor_id INT NOT NULL,
    channel VARCHAR(30),
    sent_status VARCHAR(20) DEFAULT 'Pending',
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id)
        REFERENCES Emergency_Requests(request_id),
    FOREIGN KEY (donor_id)
        REFERENCES Donors(donor_id)
);

