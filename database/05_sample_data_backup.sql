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
-- Dumping data for table `Allocations`
--

LOCK TABLES `Allocations` WRITE;
/*!40000 ALTER TABLE `Allocations` DISABLE KEYS */;
INSERT INTO `Allocations` VALUES (1,1,1,'Accepted',120,'2026-11-03 03:24:51',NULL),(2,1,2,'Pending',NULL,'2026-11-03 03:24:51',NULL),(3,2,9,'Accepted',90,'2026-11-03 03:24:51',NULL),(4,3,3,'Rejected',180,'2026-11-03 03:24:51',NULL);
/*!40000 ALTER TABLE `Allocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Blood_Matrix`
--

LOCK TABLES `Blood_Matrix` WRITE;
/*!40000 ALTER TABLE `Blood_Matrix` DISABLE KEYS */;
INSERT INTO `Blood_Matrix` VALUES ('A-','A-',1),('A-','A+',0),('A-','AB-',0),('A-','AB+',0),('A-','B-',0),('A-','B+',0),('A-','O-',1),('A-','O+',0),('A+','A-',1),('A+','A+',1),('A+','AB-',0),('A+','AB+',0),('A+','B-',0),('A+','B+',0),('A+','O-',1),('A+','O+',1),('AB-','A-',1),('AB-','A+',0),('AB-','AB-',1),('AB-','AB+',0),('AB-','B-',1),('AB-','B+',0),('AB-','O-',1),('AB-','O+',0),('AB+','A-',1),('AB+','A+',1),('AB+','AB-',1),('AB+','AB+',1),('AB+','B-',1),('AB+','B+',1),('AB+','O-',1),('AB+','O+',1),('B-','A-',0),('B-','A+',0),('B-','AB-',0),('B-','AB+',0),('B-','B-',1),('B-','B+',0),('B-','O-',1),('B-','O+',0),('B+','A-',0),('B+','A+',0),('B+','AB-',0),('B+','AB+',0),('B+','B-',1),('B+','B+',1),('B+','O-',1),('B+','O+',1),('O-','A-',0),('O-','A+',0),('O-','AB-',0),('O-','AB+',0),('O-','B-',0),('O-','B+',0),('O-','O-',1),('O-','O+',0),('O+','A-',0),('O+','A+',0),('O+','AB-',0),('O+','AB+',0),('O+','B-',0),('O+','B+',0),('O+','O-',1),('O+','O+',1);
/*!40000 ALTER TABLE `Blood_Matrix` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Donation_History`
--

LOCK TABLES `Donation_History` WRITE;
/*!40000 ALTER TABLE `Donation_History` DISABLE KEYS */;
INSERT INTO `Donation_History` VALUES (1,1,1,'2026-01-10',1,'Successful donation'),(2,2,2,'2025-12-15',1,'Emergency donation'),(3,3,3,'2026-02-20',1,'Regular donation'),(4,4,1,'2025-11-10',1,'Successful donation');
/*!40000 ALTER TABLE `Donation_History` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Donors`
--

LOCK TABLES `Donors` WRITE;
/*!40000 ALTER TABLE `Donors` DISABLE KEYS */;
INSERT INTO `Donors` VALUES (1,'Rahul Sharma','B+','9100000001','2026-01-10',0.95,12.96000000,77.64000000,1),(2,'Ananya Iyer','O-','9100000002','2025-12-15',0.98,12.95000000,77.63000000,1),(3,'Vikram Verma','A+','9100000003','2026-02-20',0.90,12.89000000,77.60000000,1),(4,'Priya Nair','AB+','9100000004','2025-11-10',0.99,12.90000000,77.61000000,1),(5,'Arjun Rao','O+','9100000005','2026-03-01',0.85,12.97000000,77.65000000,1),(6,'Sneha Reddy','B-','9100000006','2025-10-10',0.92,12.91000000,77.62000000,1),(7,'Karan Mehta','A-','9100000007','2025-09-15',0.88,12.94000000,77.64000000,1),(8,'Meera Das','AB-','9100000008','2025-08-20',0.93,12.93000000,77.63000000,0),(9,'Rohan Gupta','O-','9100000009','2025-07-15',0.97,12.96000000,77.66000000,1),(10,'Divya Menon','B+','9100000010','2026-02-01',0.91,12.92000000,77.61000000,1);
/*!40000 ALTER TABLE `Donors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Emergency_Requests`
--

LOCK TABLES `Emergency_Requests` WRITE;
/*!40000 ALTER TABLE `Emergency_Requests` DISABLE KEYS */;
INSERT INTO `Emergency_Requests` VALUES (1,1,'B+',3,'Critical','Pending','2026-11-03 03:24:51'),(2,2,'O-',2,'High','Pending','2026-11-03 03:24:51'),(3,3,'A+',2,'Medium','Pending','2026-11-03 03:24:51'),(4,1,'AB+',1,'High','Pending','2026-11-03 03:24:51');
/*!40000 ALTER TABLE `Emergency_Requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Hospitals`
--

LOCK TABLES `Hospitals` WRITE;
/*!40000 ALTER TABLE `Hospitals` DISABLE KEYS */;
INSERT INTO `Hospitals` VALUES (1,'Manipal Hospital','KA1001','9000000001','Bangalore','Old Airport Road',12.95920000,77.64700000),(2,'Apollo Hospital','KA1002','9000000002','Bangalore','Bannerghatta Road',12.89500000,77.59960000),(3,'Fortis Hospital','KA1003','9000000003','Bangalore','Bannerghatta Road',12.89450000,77.59900000);
/*!40000 ALTER TABLE `Hospitals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `Notifications`
--

LOCK TABLES `Notifications` WRITE;
/*!40000 ALTER TABLE `Notifications` DISABLE KEYS */;
INSERT INTO `Notifications` VALUES (1,1,1,'SMS','Sent','2026-11-03 03:24:51'),(2,1,2,'SMS','Sent','2026-11-03 03:24:51'),(3,2,9,'Email','Sent','2026-11-03 03:24:51'),(4,3,3,'SMS','Sent','2026-11-03 03:24:51');
/*!40000 ALTER TABLE `Notifications` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-03 10:24:29
