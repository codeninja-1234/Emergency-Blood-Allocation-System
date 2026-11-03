
USE blood_bank_db;

-- 1. Display all hospitals
SELECT * FROM Hospitals;

-- 2. Display available donors
SELECT * FROM Donors
WHERE is_available = TRUE;

-- 3. Find donors by blood group
SELECT full_name, blood_group, phone
FROM Donors
WHERE blood_group = 'B+';

-- 4. INNER JOIN: Hospital and emergency requests
SELECT h.name, r.request_id, r.required_bg,
       r.units_needed, r.urgency_level
FROM Hospitals h
INNER JOIN Emergency_Requests r
ON h.hospital_id = r.hospital_id;

-- 5. INNER JOIN: Allocation and donor details
SELECT a.allocation_id, d.full_name,
       d.blood_group, a.assigned_status
FROM Allocations a
INNER JOIN Donors d
ON a.donor_id = d.donor_id;

-- 6. COUNT: Total donors by blood group
SELECT blood_group, COUNT(*) AS total_donors
FROM Donors
GROUP BY blood_group;

-- 7. COUNT: Number of requests per hospital
SELECT h.name, COUNT(r.request_id) AS total_requests
FROM Hospitals h
LEFT JOIN Emergency_Requests r
ON h.hospital_id = r.hospital_id
GROUP BY h.hospital_id, h.name;

-- 8. GROUP BY and HAVING
SELECT blood_group, COUNT(*) AS donor_count
FROM Donors
GROUP BY blood_group
HAVING COUNT(*) >= 2;

-- 9. ORDER BY: Most reliable donors
SELECT full_name, blood_group, reliability
FROM Donors
ORDER BY reliability DESC;

-- 10. Subquery: Donors with above-average reliability
SELECT full_name, reliability
FROM Donors
WHERE reliability >
    (SELECT AVG(reliability) FROM Donors);

-- 11. Subquery: Hospitals with emergency requests
SELECT name
FROM Hospitals
WHERE hospital_id IN
    (SELECT hospital_id FROM Emergency_Requests);

-- 12. Donors who have never been allocated
SELECT full_name
FROM Donors
WHERE donor_id NOT IN
    (SELECT donor_id FROM Allocations);

-- 13. Find pending emergency requests
SELECT *
FROM Emergency_Requests
WHERE status = 'Pending';

-- 14. Count successful allocations
SELECT COUNT(*) AS accepted_allocations
FROM Allocations
WHERE assigned_status = 'Accepted';

-- 15. Average donor reliability
SELECT ROUND(AVG(reliability), 2) AS average_reliability
FROM Donors;

-- 16. Display donation history with donor names
SELECT d.full_name, h.name,
       dh.donated_date, dh.units_donated
FROM Donation_History dh
JOIN Donors d ON dh.donor_id = d.donor_id
JOIN Hospitals h ON dh.hospital_id = h.hospital_id;

-- 17. Find requests with more than one allocated donor
SELECT request_id, COUNT(*) AS donor_count
FROM Allocations
GROUP BY request_id
HAVING COUNT(*) > 1;

-- 18. Find available compatible donors for every request
SELECT r.request_id, r.required_bg,
       d.full_name, d.blood_group
FROM Emergency_Requests r
JOIN Blood_Matrix b
ON r.required_bg = b.recipient_bg
JOIN Donors d
ON d.blood_group = b.donor_bg
WHERE b.is_compatible = TRUE
AND d.is_available = TRUE
ORDER BY r.request_id;

