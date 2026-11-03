USE blood_bank_db;

DELIMITER //

CREATE PROCEDURE sp_find_compatible_donors(
    IN p_request_id INT
)
BEGIN
    SELECT
        r.request_id,
        r.required_bg,
        d.donor_id,
        d.full_name,
        d.blood_group,
        d.phone,
        d.reliability,
        d.last_donation_date
    FROM Emergency_Requests r
    JOIN Blood_Matrix b
        ON r.required_bg = b.recipient_bg
    JOIN Donors d
        ON b.donor_bg = d.blood_group
    WHERE r.request_id = p_request_id
      AND b.is_compatible = TRUE
      AND d.is_available = TRUE
    ORDER BY d.reliability DESC;
END//

DELIMITER ;
