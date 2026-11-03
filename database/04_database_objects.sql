-- MySQL dump 10.13  Distrib 26.7.0, for macos15 (arm64)
--
-- Host: localhost    Database: blood_bank_db
-- ------------------------------------------------------
-- Server version	26.7.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'a37e9870-9add-11f1-9e91-df0889975c05:1-375';

--
-- Table structure for table `Allocations`
--

DROP TABLE IF EXISTS `Allocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Allocations` (
  `allocation_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `donor_id` int NOT NULL,
  `assigned_status` varchar(20) DEFAULT 'Pending',
  `response_sec` int DEFAULT NULL,
  `allocated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`allocation_id`),
  UNIQUE KEY `request_id` (`request_id`,`donor_id`),
  KEY `donor_id` (`donor_id`),
  KEY `idx_allocation_request` (`request_id`,`assigned_status`),
  CONSTRAINT `allocations_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `Emergency_Requests` (`request_id`),
  CONSTRAINT `allocations_ibfk_2` FOREIGN KEY (`donor_id`) REFERENCES `Donors` (`donor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_allocation` AFTER INSERT ON `allocations` FOR EACH ROW BEGIN
    INSERT INTO Notifications
    (request_id, donor_id, channel, sent_status)
    VALUES
    (NEW.request_id, NEW.donor_id, 'SMS', 'Pending');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_donor_unavailable` AFTER UPDATE ON `allocations` FOR EACH ROW BEGIN
    IF NEW.assigned_status = 'Completed'
       AND OLD.assigned_status <> 'Completed' THEN

        UPDATE Donors
        SET is_available = FALSE
        WHERE donor_id = NEW.donor_id;

    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Blood_Matrix`
--

DROP TABLE IF EXISTS `Blood_Matrix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Blood_Matrix` (
  `recipient_bg` varchar(5) NOT NULL,
  `donor_bg` varchar(5) NOT NULL,
  `is_compatible` tinyint(1) NOT NULL,
  PRIMARY KEY (`recipient_bg`,`donor_bg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Donation_History`
--

DROP TABLE IF EXISTS `Donation_History`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Donation_History` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `donor_id` int NOT NULL,
  `hospital_id` int NOT NULL,
  `donated_date` date NOT NULL,
  `units_donated` int NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`history_id`),
  KEY `donor_id` (`donor_id`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `donation_history_ibfk_1` FOREIGN KEY (`donor_id`) REFERENCES `Donors` (`donor_id`),
  CONSTRAINT `donation_history_ibfk_2` FOREIGN KEY (`hospital_id`) REFERENCES `Hospitals` (`hospital_id`),
  CONSTRAINT `donation_history_chk_1` CHECK ((`units_donated` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Donors`
--

DROP TABLE IF EXISTS `Donors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Donors` (
  `donor_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `blood_group` varchar(5) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `last_donation_date` date DEFAULT NULL,
  `reliability` decimal(3,2) DEFAULT '1.00',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`donor_id`),
  UNIQUE KEY `phone` (`phone`),
  KEY `idx_donor_match` (`blood_group`,`is_available`,`last_donation_date`),
  CONSTRAINT `donors_chk_1` CHECK ((`blood_group` in (_utf8mb4'A+',_utf8mb4'A-',_utf8mb4'B+',_utf8mb4'B-',_utf8mb4'AB+',_utf8mb4'AB-',_utf8mb4'O+',_utf8mb4'O-'))),
  CONSTRAINT `donors_chk_2` CHECK ((`reliability` between 0 and 1))
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Emergency_Requests`
--

DROP TABLE IF EXISTS `Emergency_Requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Emergency_Requests` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `hospital_id` int NOT NULL,
  `required_bg` varchar(5) NOT NULL,
  `units_needed` int NOT NULL,
  `urgency_level` varchar(20) NOT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`request_id`),
  KEY `hospital_id` (`hospital_id`),
  KEY `idx_request_status` (`status`,`urgency_level`),
  CONSTRAINT `emergency_requests_ibfk_1` FOREIGN KEY (`hospital_id`) REFERENCES `Hospitals` (`hospital_id`),
  CONSTRAINT `emergency_requests_chk_1` CHECK ((`units_needed` > 0)),
  CONSTRAINT `emergency_requests_chk_2` CHECK ((`required_bg` in (_utf8mb4'A+',_utf8mb4'A-',_utf8mb4'B+',_utf8mb4'B-',_utf8mb4'AB+',_utf8mb4'AB-',_utf8mb4'O+',_utf8mb4'O-'))),
  CONSTRAINT `emergency_requests_chk_3` CHECK ((`urgency_level` in (_utf8mb4'Low',_utf8mb4'Medium',_utf8mb4'High',_utf8mb4'Critical')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Hospitals`
--

DROP TABLE IF EXISTS `Hospitals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Hospitals` (
  `hospital_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `license_no` varchar(50) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `city` varchar(50) NOT NULL,
  `address` text NOT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  PRIMARY KEY (`hospital_id`),
  UNIQUE KEY `license_no` (`license_no`),
  UNIQUE KEY `phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Notifications`
--

DROP TABLE IF EXISTS `Notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `donor_id` int NOT NULL,
  `channel` varchar(30) DEFAULT NULL,
  `sent_status` varchar(20) DEFAULT 'Pending',
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `request_id` (`request_id`),
  KEY `donor_id` (`donor_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `Emergency_Requests` (`request_id`),
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`donor_id`) REFERENCES `Donors` (`donor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `view_allocation_details`
--

DROP TABLE IF EXISTS `view_allocation_details`;
/*!50001 DROP VIEW IF EXISTS `view_allocation_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_allocation_details` AS SELECT 
 1 AS `allocation_id`,
 1 AS `request_id`,
 1 AS `donor_name`,
 1 AS `blood_group`,
 1 AS `assigned_status`,
 1 AS `response_sec`,
 1 AS `allocated_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_available_donors`
--

DROP TABLE IF EXISTS `view_available_donors`;
/*!50001 DROP VIEW IF EXISTS `view_available_donors`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_available_donors` AS SELECT 
 1 AS `donor_id`,
 1 AS `full_name`,
 1 AS `blood_group`,
 1 AS `phone`,
 1 AS `reliability`,
 1 AS `last_donation_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_request_details`
--

DROP TABLE IF EXISTS `view_request_details`;
/*!50001 DROP VIEW IF EXISTS `view_request_details`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_request_details` AS SELECT 
 1 AS `request_id`,
 1 AS `hospital_name`,
 1 AS `required_bg`,
 1 AS `units_needed`,
 1 AS `urgency_level`,
 1 AS `status`,
 1 AS `created_at`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'blood_bank_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_find_compatible_donors` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_find_compatible_donors`(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `view_allocation_details`
--

/*!50001 DROP VIEW IF EXISTS `view_allocation_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_allocation_details` AS select `a`.`allocation_id` AS `allocation_id`,`a`.`request_id` AS `request_id`,`d`.`full_name` AS `donor_name`,`d`.`blood_group` AS `blood_group`,`a`.`assigned_status` AS `assigned_status`,`a`.`response_sec` AS `response_sec`,`a`.`allocated_at` AS `allocated_at` from (`allocations` `a` join `donors` `d` on((`a`.`donor_id` = `d`.`donor_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_available_donors`
--

/*!50001 DROP VIEW IF EXISTS `view_available_donors`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_available_donors` AS select `donors`.`donor_id` AS `donor_id`,`donors`.`full_name` AS `full_name`,`donors`.`blood_group` AS `blood_group`,`donors`.`phone` AS `phone`,`donors`.`reliability` AS `reliability`,`donors`.`last_donation_date` AS `last_donation_date` from `donors` where (`donors`.`is_available` = true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_request_details`
--

/*!50001 DROP VIEW IF EXISTS `view_request_details`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_request_details` AS select `r`.`request_id` AS `request_id`,`h`.`name` AS `hospital_name`,`r`.`required_bg` AS `required_bg`,`r`.`units_needed` AS `units_needed`,`r`.`urgency_level` AS `urgency_level`,`r`.`status` AS `status`,`r`.`created_at` AS `created_at` from (`emergency_requests` `r` join `hospitals` `h` on((`r`.`hospital_id` = `h`.`hospital_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-03 10:24:21
