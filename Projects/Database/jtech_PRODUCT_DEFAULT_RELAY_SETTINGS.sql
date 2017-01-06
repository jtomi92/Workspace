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
-- Table structure for table `PRODUCT_DEFAULT_RELAY_SETTINGS`
--

DROP TABLE IF EXISTS `PRODUCT_DEFAULT_RELAY_SETTINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PRODUCT_DEFAULT_RELAY_SETTINGS` (
  `product_id` int(11) NOT NULL,
  `setting_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL DEFAULT '1',
  `relay_id` int(11) NOT NULL,
  `relay_name` varchar(45) DEFAULT NULL,
  `weekdays` varchar(45) DEFAULT NULL,
  `start_timer` varchar(45) DEFAULT NULL,
  `end_timer` varchar(45) DEFAULT NULL,
  `delay` varchar(45) DEFAULT NULL,
  `relay_displayed` varchar(1) NOT NULL,
  `relay_enabled` varchar(1) NOT NULL,
  `delay_enabled` varchar(1) NOT NULL,
  `timer_enabled` varchar(1) NOT NULL,
  `mode` varchar(1) NOT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`product_id`,`setting_id`,`relay_id`,`module_id`),
  KEY `setting_id_idx` (`setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT_DEFAULT_RELAY_SETTINGS`
--

LOCK TABLES `PRODUCT_DEFAULT_RELAY_SETTINGS` WRITE;
/*!40000 ALTER TABLE `PRODUCT_DEFAULT_RELAY_SETTINGS` DISABLE KEYS */;
INSERT INTO `PRODUCT_DEFAULT_RELAY_SETTINGS` VALUES (1,1,1,1,'test relay 1','MO,TU,WE','13:20','15:40','0','Y','Y','Y','N','Y','2016/08/21 15:48:40','2016/08/21 20:36:02'),(1,1,1,2,'test relay 2','MO,TU,WE','13:20','15:40','0','Y','Y','Y','N','Y','2016/08/21 15:48:40','2016/08/21 20:36:02'),(1,1,1,3,'test relay 3','MO,TU,WE','13:20','15:40','0','Y','Y','Y','N','Y','2016/08/21 15:48:40','2016/08/21 20:36:02'),(1,2,1,1,'test relay 1','MO,TU,WE','13:20','15:40','0','Y','Y','Y','N','Y','2016/08/21 15:48:40','2016/08/21 20:36:02'),(1,2,1,2,'test relay 2','MO,TU,WE','13:20','15:40','0','Y','Y','Y','N','Y','2016/08/21 15:48:40','2016/08/21 20:36:02'),(1,2,1,3,'test relay 3','MO,TU,WE','13:20','15:40','0','Y','Y','Y','N','Y','2016/08/21 15:48:40','2016/08/21 20:36:02'),(2,1,1,1,'test relay 1','MO,TU,WE','test start timer','test end timer','test delay','Y','Y','Y','N','Y','2016/08/21 15:53:45','2016/08/21 15:53:45'),(2,1,1,2,'test relay 2','MO,TU,WE','test start timer','test end timer','test delay','Y','Y','Y','N','Y','2016/08/21 15:53:45','2016/08/21 15:53:45'),(2,1,1,3,'test relay 3','MO,TU,WE','test start timer','test end timer','test delay','Y','Y','Y','N','Y','2016/08/21 15:53:45','2016/08/21 15:53:45'),(2,2,1,1,'test relay 1','MO,TU,WE','test start timer','test end timer','test delay','Y','Y','Y','N','Y','2016/08/21 15:53:45','2016/08/21 15:53:45'),(2,2,1,2,'test relay 2','MO,TU,WE','test start timer','test end timer','test delay','Y','Y','Y','N','Y','2016/08/21 15:53:45','2016/08/21 15:53:45'),(2,2,1,3,'test relay 3','MO,TU,WE','test start timer','test end timer','test delay','Y','Y','Y','N','Y','2016/08/21 15:53:45','2016/08/21 15:53:45');
/*!40000 ALTER TABLE `PRODUCT_DEFAULT_RELAY_SETTINGS` ENABLE KEYS */;
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
