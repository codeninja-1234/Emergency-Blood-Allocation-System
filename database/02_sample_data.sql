
USE blood_bank_db;

-- 1. HOSPITAL DATA
INSERT INTO Hospitals
(name, license_no, phone, city, address, latitude, longitude)
VALUES
('Manipal Hospital', 'KA1001', '9000000001', 'Bangalore', 'Old Airport Road', 12.9592, 77.6470),
('Apollo Hospital', 'KA1002', '9000000002', 'Bangalore', 'Bannerghatta Road', 12.8950, 77.5996),
('Fortis Hospital', 'KA1003', '9000000003', 'Bangalore', 'Bannerghatta Road', 12.8945, 77.5990);

-- 2. DONOR DATA
INSERT INTO Donors
(full_name, blood_group, phone, last_donation_date,
 reliability, latitude, longitude, is_available)
VALUES
('Rahul Sharma', 'B+', '9100000001', '2026-01-10', 0.95, 12.96, 77.64, TRUE),
('Ananya Iyer', 'O-', '9100000002', '2025-12-15', 0.98, 12.95, 77.63, TRUE),
('Vikram Verma', 'A+', '9100000003', '2026-02-20', 0.90, 12.89, 77.60, TRUE),
('Priya Nair', 'AB+', '9100000004', '2025-11-10', 0.99, 12.90, 77.61, TRUE),
('Arjun Rao', 'O+', '9100000005', '2026-03-01', 0.85, 12.97, 77.65, TRUE),
('Sneha Reddy', 'B-', '9100000006', '2025-10-10', 0.92, 12.91, 77.62, TRUE),
('Karan Mehta', 'A-', '9100000007', '2025-09-15', 0.88, 12.94, 77.64, TRUE),
('Meera Das', 'AB-', '9100000008', '2025-08-20', 0.93, 12.93, 77.63, FALSE),
('Rohan Gupta', 'O-', '9100000009', '2025-07-15', 0.97, 12.96, 77.66, TRUE),
('Divya Menon', 'B+', '9100000010', '2026-02-01', 0.91, 12.92, 77.61, TRUE);

-- 3. EMERGENCY REQUESTS
INSERT INTO Emergency_Requests
(hospital_id, required_bg, units_needed, urgency_level, status)
VALUES
(1, 'B+', 3, 'Critical', 'Pending'),
(2, 'O-', 2, 'High', 'Pending'),
(3, 'A+', 2, 'Medium', 'Pending'),
(1, 'AB+', 1, 'High', 'Pending');

-- 4. BLOOD GROUP COMPATIBILITY MATRIX
INSERT INTO Blood_Matrix (recipient_bg, donor_bg, is_compatible)
SELECT
    r.recipient_bg,
    d.donor_bg,
    CASE
        WHEN r.recipient_bg = 'A+' AND d.donor_bg IN ('O-','O+','A-','A+') THEN TRUE
        WHEN r.recipient_bg = 'A-' AND d.donor_bg IN ('O-','A-') THEN TRUE
        WHEN r.recipient_bg = 'B+' AND d.donor_bg IN ('O-','O+','B-','B+') THEN TRUE
        WHEN r.recipient_bg = 'B-' AND d.donor_bg IN ('O-','B-') THEN TRUE
        WHEN r.recipient_bg = 'AB+' THEN TRUE
        WHEN r.recipient_bg = 'AB-' AND d.donor_bg IN ('O-','A-','B-','AB-') THEN TRUE
        WHEN r.recipient_bg = 'O+' AND d.donor_bg IN ('O-','O+') THEN TRUE
        WHEN r.recipient_bg = 'O-' AND d.donor_bg = 'O-' THEN TRUE
        ELSE FALSE
    END
FROM
    (SELECT 'A+' AS recipient_bg UNION ALL
     SELECT 'A-' UNION ALL SELECT 'B+' UNION ALL
     SELECT 'B-' UNION ALL SELECT 'AB+' UNION ALL
     SELECT 'AB-' UNION ALL SELECT 'O+' UNION ALL
     SELECT 'O-') r
CROSS JOIN
    (SELECT 'A+' AS donor_bg UNION ALL
     SELECT 'A-' UNION ALL SELECT 'B+' UNION ALL
     SELECT 'B-' UNION ALL SELECT 'AB+' UNION ALL
     SELECT 'AB-' UNION ALL SELECT 'O+' UNION ALL
     SELECT 'O-') d;

-- 5. ALLOCATIONS
INSERT INTO Allocations
(request_id, donor_id, assigned_status, response_sec)
VALUES
(1, 1, 'Accepted', 120),
(1, 2, 'Pending', NULL),
(2, 9, 'Accepted', 90),
(3, 3, 'Rejected', 180);

-- 6. DONATION HISTORY
INSERT INTO Donation_History
(donor_id, hospital_id, donated_date, units_donated, remarks)
VALUES
(1, 1, '2026-01-10', 1, 'Successful donation'),
(2, 2, '2025-12-15', 1, 'Emergency donation'),
(3, 3, '2026-02-20', 1, 'Regular donation'),
(4, 1, '2025-11-10', 1, 'Successful donation');

-- 7. NOTIFICATIONS
INSERT INTO Notifications
(request_id, donor_id, channel, sent_status)
VALUES
(1, 1, 'SMS', 'Sent'),
(1, 2, 'SMS', 'Sent'),
(2, 9, 'Email', 'Sent'),
(3, 3, 'SMS', 'Sent');


