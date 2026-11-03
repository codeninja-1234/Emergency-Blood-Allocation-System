USE blood_bank_db;

-- Add valid blood group constraints to Blood_Matrix
ALTER TABLE Blood_Matrix
ADD CONSTRAINT chk_recipient_bg
CHECK (recipient_bg IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'));

ALTER TABLE Blood_Matrix
ADD CONSTRAINT chk_donor_bg
CHECK (donor_bg IN ('A+','A-','B+','B-','AB+','AB-','O+','O-'));

-- Replace the donor availability trigger with corrected NULL handling
DROP TRIGGER IF EXISTS trg_donor_unavailable;

DELIMITER //

CREATE TRIGGER trg_donor_unavailable
AFTER UPDATE ON Allocations
FOR EACH ROW
BEGIN
    IF NEW.assigned_status = 'Completed'
       AND (OLD.assigned_status IS NULL
            OR OLD.assigned_status <> 'Completed') THEN

        UPDATE Donors
        SET is_available = FALSE
        WHERE donor_id = NEW.donor_id;

    END IF;
END//

DELIMITER ;

