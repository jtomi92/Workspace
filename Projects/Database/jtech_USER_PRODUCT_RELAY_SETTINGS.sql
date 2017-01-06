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
-- Table structure for table `USER_PRODUCT_RELAY_SETTINGS`
--

DROP TABLE IF EXISTS `USER_PRODUCT_RELAY_SETTINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCT_RELAY_SETTINGS` (
  `serial_number` varchar(45) NOT NULL,
  `setting_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `relay_id` int(11) NOT NULL,
  `relay_status` varchar(1) DEFAULT NULL,
  `relay_name` varchar(45) NOT NULL,
  `delay` varchar(45) DEFAULT NULL,
  `relay_enabled` varchar(1) NOT NULL,
  `delay_enabled` varchar(1) NOT NULL,
  `mode` varchar(1) NOT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`,`setting_id`,`relay_id`,`module_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_RELAY_SETTINGS`
--

LOCK TABLES `USER_PRODUCT_RELAY_SETTINGS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_RELAY_SETTINGS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCT_RELAY_SETTINGS` VALUES ('9T7V02IN6K',1,1,0,'Y','Relay 1/0','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,1,'N','test relay 1','0','Y','Y','N','2017/01/04 21:55:45','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,2,'N','test relay 2','0','Y','Y','N','2017/01/04 21:55:45','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,3,'N','test relay 3','0','Y','Y','N','2017/01/04 21:55:45','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,4,'N','Relay 1/4','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,5,'N','Relay 1/5','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,6,'N','Relay 1/6','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,7,'N','Relay 1/7','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,8,'N','Relay 1/8','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,9,'N','Relay 1/9','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,10,'N','Relay 1/10','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,11,'N','Relay 1/11','0','Y','N','N','2017/01/04 21:56:22','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,12,'N','Relay 1/12','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,13,'N','Relay 1/13','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,14,'N','Relay 1/14','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,15,'N','Relay 1/15','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,16,'N','Relay 1/16','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,17,'N','Relay 1/17','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,18,'N','Relay 1/18','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,19,'N','Relay 1/19','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,20,'N','Relay 1/20','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,21,'N','Relay 1/21','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,22,'N','Relay 1/22','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,23,'N','Relay 1/23','0','N','N','N','2017/01/05 23:26:25','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,24,'N','Relay 1/24','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,25,'N','Relay 1/25','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,26,'N','Relay 1/26','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,27,'N','Relay 1/27','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,28,'N','Relay 1/28','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,29,'N','Relay 1/29','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,30,'N','Relay 1/30','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,31,'N','Relay 1/31','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,32,'N','Relay 1/32','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,33,'N','Relay 1/33','0','N','N','N','2017/01/05 23:47:43','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,34,'N','Relay 1/34','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,35,'N','Relay 1/35','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,36,'N','Relay 1/36','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,37,'N','Relay 1/37','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,38,'N','Relay 1/38','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,39,'N','Relay 1/39','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,40,'N','Relay 1/40','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,41,'N','Relay 1/41','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,42,'N','Relay 1/42','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,43,'N','Relay 1/43','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,44,'N','Relay 1/44','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,45,'N','Relay 1/45','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,46,'N','Relay 1/46','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,47,'N','Relay 1/47','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,48,'N','Relay 1/48','0','N','N','N','2017/01/05 23:47:44','2017/01/06 14:59:58'),('9T7V02IN6K',2,1,1,'N','test relay 1','0','Y','Y','Y','2017/01/04 21:55:45','2017/01/06 14:59:58'),('9T7V02IN6K',2,1,2,'N','test relay 2','0','Y','Y','Y','2017/01/04 21:55:45','2017/01/06 14:59:58'),('9T7V02IN6K',2,1,3,'N','test relay 3','0','Y','Y','Y','2017/01/04 21:55:45','2017/01/06 14:59:58');
/*!40000 ALTER TABLE `USER_PRODUCT_RELAY_SETTINGS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-06 16:46:07
