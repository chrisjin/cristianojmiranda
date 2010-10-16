-- MySQL dump 10.9
--
-- Host: localhost    Database: mega
-- ------------------------------------------------------
-- Server version	4.1.18-nt

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `tbconcurso`
--

DROP TABLE IF EXISTS `tbconcurso`;
CREATE TABLE `tbconcurso` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `dtSorteio` datetime NOT NULL default '0000-00-00 00:00:00',
  `vrArrecadacao` float NOT NULL default '0',
  `qtGanhadoresSena` int(10) unsigned NOT NULL default '0',
  `vrRateioSena` float NOT NULL default '0',
  `qtGanhadoresQuina` int(10) unsigned NOT NULL default '0',
  `vrRateioQuina` float NOT NULL default '0',
  `qtGanhadoresQuadra` int(10) unsigned NOT NULL default '0',
  `vrRateioQuadra` float NOT NULL default '0',
  `flAcumulado` tinyint(1) NOT NULL default '0',
  `vrEstimativaPremio` float NOT NULL default '0',
  `vrAcumuladoNatal` float NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Concursos Mega Sena';

--
-- Table structure for table `tbdezenas`
--

DROP TABLE IF EXISTS `tbdezenas`;
CREATE TABLE `tbdezenas` (
  `idConcurso` int(10) unsigned NOT NULL default '0',
  `nuOrdem` int(10) unsigned NOT NULL default '0',
  `vrDezena` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  USING BTREE (`idConcurso`,`nuOrdem`),
  CONSTRAINT `FK_TbDezenas_TbConcurso` FOREIGN KEY (`idConcurso`) REFERENCES `tbconcurso` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Dezenas por concurso';

--
-- Table structure for table `tbfrequenciadezenas`
--

DROP TABLE IF EXISTS `tbfrequenciadezenas`;
CREATE TABLE `tbfrequenciadezenas` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `dezena` int(10) unsigned NOT NULL default '0',
  `qtdSorteada` int(10) unsigned NOT NULL default '0',
  `atrasoAtual` int(10) unsigned NOT NULL default '0',
  `atrasoUltimo` int(10) unsigned NOT NULL default '0',
  `atrasoMaior` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `tbfrequenciaduplas`
--

DROP TABLE IF EXISTS `tbfrequenciaduplas`;
CREATE TABLE `tbfrequenciaduplas` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `dezena1` int(10) unsigned NOT NULL default '0',
  `dezena2` int(10) unsigned NOT NULL default '0',
  `qtdSorteada` int(10) unsigned NOT NULL default '0',
  `atrasoAtual` int(10) unsigned NOT NULL default '0',
  `atrasoUltimo` int(10) unsigned NOT NULL default '0',
  `atrasoMaior` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

