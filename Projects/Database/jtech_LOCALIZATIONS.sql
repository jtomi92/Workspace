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
-- Table structure for table `LOCALIZATIONS`
--

DROP TABLE IF EXISTS `LOCALIZATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LOCALIZATIONS` (
  `locale_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_name` varchar(45) DEFAULT NULL,
  `string_key` varchar(45) DEFAULT NULL,
  `en` varchar(2000) DEFAULT NULL,
  `hu` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LOCALIZATIONS`
--

LOCK TABLES `LOCALIZATIONS` WRITE;
/*!40000 ALTER TABLE `LOCALIZATIONS` DISABLE KEYS */;
INSERT INTO `LOCALIZATIONS` VALUES (1,'console','page-title','jTech Console','jTech Konzol'),(2,'console','controls-title','Controls','Vezérlés'),(3,'console','settings-title','Settings','Beállítások'),(4,'console','users-title','Users','Felhasználók'),(5,'console','registration-title','Registration','Regisztráció'),(6,'console','relay-controls','Relay Controls','Relé Vezérlők'),(7,'console','select-relays','Select Relays','Relé választó'),(8,'console','module-id','Module ID','Modul Azon.'),(9,'console','relay-id','Relay ID','Relé Azon.'),(10,'console','relay-name','Relay Name','Relé Név'),(11,'console','relay-state','State','Állapot'),(12,'console','relay-switch','Switch','Kapcsoló'),(13,'console','device-online','Device is ONLINE','Eszköz elérhető'),(14,'console','device-offline','Device is OFFLINE','Eszköz nem elérhető'),(15,'console','state-on','ON','BE'),(16,'console','state-off','OFF','KI'),(17,'wrapper','contact-us',' CONTACT US',' KAPCSOLAT'),(18,'wrapper','sign-out','Sign <b>out</b>','Kijelentkezés'),(21,'wrapper','my-account','<b>My</b> Account','Profilom'),(22,'wrapper','my-console','<b>My</b> Account','Konzolom'),(23,'console','select-my-product','Select My Product','Eszközeim'),(24,'login','login-to-my-console','Login to My Console','Bejelentkezés'),(25,'login','email-address','Email Address','Email cím'),(26,'login','password','Password','Jelszó'),(27,'login','remember-me','Remember Me ','Emlékezz Rám '),(28,'login','login','LOGIN','BEJELENTKEZÉS'),(29,'login','create-account','Create jTech Account','Fiók Létrehozása'),(30,'login','page-title','jTech Login','jTech Bejelentkezés'),(31,'login','invalid-message','Invalid username or password.','Hibás felhasználó vagy jelszó'),(32,'login','logout-message','You have been logged out.','Sikeres kijelentkezés.'),(33,'register','create-account','Create jTech Account','jTech Fiók Létrehozása'),(34,'register','email','*Email Address','*Email Cím'),(35,'register','first-name','*First Name','*Utónév'),(36,'register','last-name','*Last Name','*Vezetéknév'),(37,'register','phone-number','Phone Number','Telefonszám'),(38,'register','password','*Password','*Jelszó'),(39,'register','create-account','CREATE ACCOUNT','FIÓK LÉTREHOZÁSA'),(40,'register','page-title','jTech Registration','jTech Regisztráció'),(41,'register','register-error','User already exists','A felhasználó már létezik'),(42,'register','register-success','Registration successful','Sikeres regisztráció'),(43,'register','email-title','Verify Your Email','Email Cím Megerősítése'),(44,'register','email-content','As the last step of creating your jTech Account, please activate your email address.</br>Click here:','A jTech fiókod utolsó lépéseként, kérlek aktiváld az e-mail címed. Kattints ide:'),(46,'verification','page-title','jTech Registration','jTech Regisztráció'),(47,'verification','create-account','Create <b>jTech</b> Account','jTech Fiók Létrehozása'),(48,'verification','content','Great! <b>Your</b> account has been created! The last step is to activate your account with the url sent to your e-mail address. ','Szuper! A fiókod elkészült! Utolsó lépésként kérlek aktiváld a fiókod az e-mail címedre küldött hivatkozás segítségével.'),(49,'verified','page-title','jTech Registration','jTech Regisztráció'),(50,'verified','create-account','Create <b>jTech</b> Account','jTech Fiók Létrehozása'),(51,'verified','content-1','<b>Your</b> email is verified. Click ','A fiókod aktiválásra került. Bejelentkezéshez kattints '),(52,'verified','content-2','here','ide.'),(53,'verified','content-3',' to login.',NULL),(54,'account','my-account','My Account','Profilom'),(55,'account','page-title','jTech MyAccount','jTech Profilom'),(56,'account','login-information','<b>Login</b> Information','Bejelentkezési Adatok'),(57,'account','old-password','Old Password','Régi Jelszó'),(58,'account','new-password','New Password','Új Jelszó'),(59,'account','confirm-password','Confirm New Password','Jelszó Újra'),(60,'account','my-information','<b>My<b> Information','Felhasználói Adatok'),(61,'account','first-name','First Name','Utónév'),(62,'account','last-name','Last Name','Keresztnév'),(63,'account','email-address','Email Address','Email Cím'),(64,'account','phone-number','Phone Number','Telefonszám'),(65,'account','address','Address','Lakcím'),(66,'account','city','City','Város'),(67,'account','save-changes','SAVE CHANGES','MENTÉS'),(68,'account','message-password-updated','Password successfully updated.','Jelszó sikeresen frissítve.'),(69,'account','message-old-password-incorrect','Old password is incorrect.','Hibás régi jelszó.'),(70,'account','message-password-not-match','New password doesn\'t match with password confirmation.','Az új jelszó nem egyezik meg a jeszó ellenőrzéssel.'),(71,'account','message-new-password-incorrect','New password is incorrect.','Hibás új jelszó.'),(72,'account','message-save-error','Error during saving user data.','Hiba lépett fel mentés során.'),(73,'account','message-save-success','User information saved.','Felhasználói adatok mentve.');
/*!40000 ALTER TABLE `LOCALIZATIONS` ENABLE KEYS */;
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
