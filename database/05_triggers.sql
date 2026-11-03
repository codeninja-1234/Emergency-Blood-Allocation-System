USE blood_bank_db;

DELIMITER //

-- Trigger 1: Create notification after a new allocation
CREATE TRIGGER trg_after_allocation
AFTER INSERT ON Allocations
FOR EACH ROW
BEGIN
    INSERT INTO Notifications
    (request_id, donor_id, channel, sent_status)
    VALUES
    (NEW.request_id, NEW.donor_id, 'SMS', 'Pending');
END//

-- Trigger 2: Mark donor unavailable after completed allocation
CREATE TRIGGER trg_donor_unavailable
AFTER UPDATE ON Allocations
FOR EACH ROW
BEGIN
    IF NEW.assigned_status = 'Completed'
       AND OLD.assigned_status <> 'Completed' THEN

        UPDATE Donors
        SET is_available = FALSE
        WHERE donor_id = NEW.donor_id;

    END IF;
END//

DELIMITER ;
