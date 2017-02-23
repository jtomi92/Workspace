-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: jtech.cr2mzdew7yg9.eu-west-1.rds.amazonaws.com    Database: jtech
-- ------------------------------------------------------
-- Server version	5.6.27-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `CONNECTIONS`
--

DROP TABLE IF EXISTS `CONNECTIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CONNECTIONS` (
  `serial_number` varchar(45) NOT NULL,
  `host` varchar(100) NOT NULL,
  `device_port` varchar(45) NOT NULL,
  `console_port` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CONNECTIONS`
--

LOCK TABLES `CONNECTIONS` WRITE;
/*!40000 ALTER TABLE `CONNECTIONS` DISABLE KEYS */;
INSERT INTO `CONNECTIONS` VALUES ('1T6A08SMWT','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/09 22:48:06','2017/01/09 22:48:46'),('35W575TL0K','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/11 22:12:39','2017/01/11 22:48:08'),('9T7V02IN6K','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/03 19:49:21','2017/01/09 22:45:38'),('GRXIVV01JH','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/02 23:17:19','2017/01/03 19:46:34'),('JQ5PXAR7CE','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','CONNECTED','2017/01/11 22:49:05','2017/01/13 18:56:57'),('MHOAILZ7VI','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/02/15 21:34:50','2017/02/16 18:37:17'),('MQ8PAMOPRG','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/09 22:46:10','2017/01/09 22:47:49'),('OLCZ1LRLUZ','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/02 20:20:48','2017/01/02 23:13:19'),('ON6FAVXXUF','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/03 19:46:33','2017/01/03 19:49:03'),('QU5ZU41HME','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/09 23:02:14','2017/01/11 21:50:30'),('XV3LRWY7XG','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/02 20:19:07','2017/01/02 20:25:42'),('YBDNJ1EL32','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2016/10/10 22:50:53','2017/02/16 15:43:48'),('ZC5RMI57L9','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2090','DISCONNECTED','2017/01/02 23:13:32','2017/01/02 23:17:02');
/*!40000 ALTER TABLE `CONNECTIONS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-17 14:26:20
