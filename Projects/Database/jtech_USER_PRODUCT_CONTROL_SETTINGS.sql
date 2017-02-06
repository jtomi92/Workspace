-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: jtech
-- ------------------------------------------------------
-- Server version	5.7.13-log

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
-- Table structure for table `USER_PRODUCT_CONTROL_SETTINGS`
--

DROP TABLE IF EXISTS `USER_PRODUCT_CONTROL_SETTINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCT_CONTROL_SETTINGS` (
  `serial_number` varchar(45) NOT NULL,
  `module_id` int(11) NOT NULL DEFAULT '1',
  `relay_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `has_access` varchar(1) NOT NULL,
  `call_access` varchar(1) NOT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`,`relay_id`,`user_id`,`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_CONTROL_SETTINGS`
--

LOCK TABLES `USER_PRODUCT_CONTROL_SETTINGS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_CONTROL_SETTINGS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCT_CONTROL_SETTINGS` VALUES ('JQ5PXAR7CE',1,0,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,0,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',1,1,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,1,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',1,2,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,2,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',1,3,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,3,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,4,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,4,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,5,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,5,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,6,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,6,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,7,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,7,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,8,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,8,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,9,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,9,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,10,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,10,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('JQ5PXAR7CE',1,11,15,'Y','N','2017/01/13 19:06:03','2017/01/13 19:06:03'),('JQ5PXAR7CE',2,11,15,'Y','N','2017/01/13 19:06:04','2017/01/13 19:06:04'),('QU5ZU41HME',1,0,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,0,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,1,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,1,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,2,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,2,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,3,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,3,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,4,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,4,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,5,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,5,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,6,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,6,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,7,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,7,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,8,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,8,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,9,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,9,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,10,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,10,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',1,11,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('QU5ZU41HME',2,11,15,'Y','N','2017/01/11 21:49:22','2017/01/11 21:49:22'),('YBDNJ1EL32',1,0,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,0,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,0,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,0,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,0,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,0,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,1,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,1,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,1,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,1,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,1,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,1,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,2,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,2,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,2,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,2,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,2,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,2,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,3,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,3,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,3,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,3,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,3,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,3,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,4,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,4,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,4,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,4,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,4,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,4,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,5,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,5,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,5,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,5,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,5,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,5,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,6,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,6,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,6,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,6,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,6,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,6,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,7,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,7,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,7,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,7,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,7,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,7,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,8,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,8,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,8,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,8,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,8,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,8,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,9,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,9,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,9,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,9,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',2,9,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',4,9,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,10,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,10,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,10,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,10,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,11,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,11,15,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,11,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,11,40,'Y','N','2017/01/17 16:47:45','2017/01/17 16:47:45'),('YBDNJ1EL32',1,12,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,12,15,'Y','N','2017/01/11 13:37:24','2017/01/11 13:37:24'),('YBDNJ1EL32',1,12,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',1,13,15,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,13,15,'Y','N','2017/01/11 13:37:24','2017/01/11 13:37:24'),('YBDNJ1EL32',1,13,40,'Y','N','2017/01/17 16:47:44','2017/01/17 16:47:44'),('YBDNJ1EL32',4,14,15,'Y','N','2017/01/11 13:37:24','2017/01/11 13:37:24');
/*!40000 ALTER TABLE `USER_PRODUCT_CONTROL_SETTINGS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-18 15:23:13
