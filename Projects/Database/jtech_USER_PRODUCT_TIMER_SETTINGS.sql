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
-- Table structure for table `USER_PRODUCT_TIMER_SETTINGS`
--

DROP TABLE IF EXISTS `USER_PRODUCT_TIMER_SETTINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCT_TIMER_SETTINGS` (
  `serial_number` varchar(45) NOT NULL,
  `setting_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  `relay_id` int(11) NOT NULL,
  `timer_id` int(11) NOT NULL,
  `start_weekdays` varchar(45) DEFAULT NULL,
  `end_weekdays` varchar(45) DEFAULT NULL,
  `start_timer` varchar(45) DEFAULT NULL,
  `end_timer` varchar(45) DEFAULT NULL,
  `timer_enabled` varchar(1) DEFAULT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`,`setting_id`,`module_id`,`relay_id`,`timer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_TIMER_SETTINGS`
--

LOCK TABLES `USER_PRODUCT_TIMER_SETTINGS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_TIMER_SETTINGS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCT_TIMER_SETTINGS` VALUES ('9T7V02IN6K',1,1,0,1,'wed,','thu,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,1,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,2,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,3,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,4,1,'mon,','mon,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,4,2,'wed,','thu,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,5,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,6,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,7,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,8,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,9,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,10,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,11,1,'mon,tue,wed,thu,fri,sat,sun,','mon,tue,wed,thu,fri,sat,sun,','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,12,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,13,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:57','2017/01/06 14:59:57'),('9T7V02IN6K',1,1,14,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,15,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,16,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,17,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,18,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,19,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,20,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,21,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,22,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,23,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,24,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,25,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,26,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,27,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,28,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,29,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,30,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,31,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,32,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,33,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,34,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,35,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,36,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,37,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,38,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,39,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,40,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,41,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,42,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,43,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,44,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,45,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,46,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,47,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58'),('9T7V02IN6K',1,1,48,1,'mon,tue,wed,thu,fri,sat,sun','mon,tue,wed,thu,fri,sat,sun','8:00','17:00','N','2017/01/06 14:59:58','2017/01/06 14:59:58');
/*!40000 ALTER TABLE `USER_PRODUCT_TIMER_SETTINGS` ENABLE KEYS */;
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
