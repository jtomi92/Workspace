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
-- Table structure for table `USER_PROFILES`
--

DROP TABLE IF EXISTS `USER_PROFILES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PROFILES` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` varchar(45) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `user_name` varchar(45) DEFAULT NULL,
  `user_password` varchar(400) DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `address` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `enabled` varchar(1) NOT NULL,
  `token` varchar(45) DEFAULT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PROFILES`
--

LOCK TABLES `USER_PROFILES` WRITE;
/*!40000 ALTER TABLE `USER_PROFILES` DISABLE KEYS */;
INSERT INTO `USER_PROFILES` VALUES (15,'1',NULL,'admin','admin','Józsa','Tamás','+36309225427','Zsák 17','Debrecen','Y',NULL,'2016/12/01 15:35:51','2017/01/10 00:18:34'),(16,'1',NULL,'asd','admin','Test','Test',NULL,NULL,NULL,'Y',NULL,'2016/12/02 11:42:49','2016/12/02 11:42:49'),(40,'1',NULL,'jtomi92@hotmail.com','asdasdasd','asdasd','asdasd','',NULL,NULL,'Y','KEYYF9G0FA47A3BZJ268C0J1VYA37P','2017/01/06 15:46:46','2017/01/06 15:54:20');
/*!40000 ALTER TABLE `USER_PROFILES` ENABLE KEYS */;
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
