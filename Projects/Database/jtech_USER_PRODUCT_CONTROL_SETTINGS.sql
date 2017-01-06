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
  `setting_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL DEFAULT '1',
  `relay_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `has_access` varchar(1) NOT NULL,
  `call_access` varchar(1) NOT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`,`setting_id`,`relay_id`,`user_id`,`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_CONTROL_SETTINGS`
--

LOCK TABLES `USER_PRODUCT_CONTROL_SETTINGS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_CONTROL_SETTINGS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCT_CONTROL_SETTINGS` VALUES ('9T7V02IN6K',1,1,0,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,1,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,2,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,3,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,4,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,5,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,6,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,7,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,8,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,9,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,10,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,11,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,12,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,13,15,'Y','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,14,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,15,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,16,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,17,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,18,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,19,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,20,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,21,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,22,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,23,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,24,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,25,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,26,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,27,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,28,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,29,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,30,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,31,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,32,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,33,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,34,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,35,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,36,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,37,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,38,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,39,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,40,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,41,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,42,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,43,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,44,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,45,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,46,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,47,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,48,15,'Y','N','2017/01/06 14:59:58','2017/01/06 14:59:58');
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

-- Dump completed on 2017-01-06 16:46:06
