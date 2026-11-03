USE blood_bank_db;

-- 1. View of available donors
CREATE OR REPLACE VIEW View_Available_Donors AS
SELECT donor_id, full_name, blood_group, phone,
       reliability, last_donation_date
FROM Donors
WHERE is_available = TRUE;

-- 2. View of emergency requests with hospital details
CREATE OR REPLACE VIEW View_Request_Details AS
SELECT r.request_id, h.name AS hospital_name,
       r.required_bg, r.units_needed,
       r.urgency_level, r.status, r.created_at
FROM Emergency_Requests r
JOIN Hospitals h
ON r.hospital_id = h.hospital_id;

-- 3. View of allocation details
CREATE OR REPLACE VIEW View_Allocation_Details AS
SELECT a.allocation_id, a.request_id,
       d.full_name AS donor_name, d.blood_group,
       a.assigned_status, a.response_sec,
       a.allocated_at
FROM Allocations a
JOIN Donors d
ON a.donor_id = d.donor_id;

-- 4. Index for donor matching
CREATE INDEX idx_donor_match
ON Donors(blood_group, is_available, last_donation_date);

-- 5. Index for emergency request filtering
CREATE INDEX idx_request_status
ON Emergency_Requests(status, urgency_level);

-- 6. Index for allocation lookup
CREATE INDEX idx_allocation_request
ON Allocations(request_id, assigned_status);
