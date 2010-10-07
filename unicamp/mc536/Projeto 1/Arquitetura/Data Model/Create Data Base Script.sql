-- MySQL dump 10.9
--
-- Host: localhost    Database: forum
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
-- Table structure for table `comentario_documento`
--

DROP TABLE IF EXISTS `comentario_documento`;
CREATE TABLE `comentario_documento` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_comentario` varchar(255) NOT NULL default '',
  `dt_inclusao` datetime NOT NULL default '0000-00-00 00:00:00',
  `tp_referencia_documento` int(11) NOT NULL default '0',
  `version` int(11) default NULL,
  `id_comentario` bigint(20) default NULL,
  `id_documento` bigint(20) NOT NULL default '0',
  `id_usuario` bigint(20) default NULL,
  PRIMARY KEY  (`id`),
  KEY `FK4B988FD64580C13D` (`id_documento`),
  KEY `FK4B988FD6F63EF371` (`id_usuario`),
  KEY `FK4B988FD6F6F17011` (`id_comentario`),
  CONSTRAINT `FK4B988FD6F6F17011` FOREIGN KEY (`id_comentario`) REFERENCES `comentario_documento` (`id`),
  CONSTRAINT `FK4B988FD64580C13D` FOREIGN KEY (`id_documento`) REFERENCES `documento` (`id`),
  CONSTRAINT `FK4B988FD6F63EF371` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `descricao_documento`
--

DROP TABLE IF EXISTS `descricao_documento`;
CREATE TABLE `descricao_documento` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_documento` varchar(255) NOT NULL default '',
  `version` int(11) default NULL,
  `id_documento` bigint(20) NOT NULL default '0',
  `id_idioma_documento` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FK9923EC3E25A527EA` (`id_idioma_documento`),
  KEY `FK9923EC3E4580C13D` (`id_documento`),
  CONSTRAINT `FK9923EC3E4580C13D` FOREIGN KEY (`id_documento`) REFERENCES `documento` (`id`),
  CONSTRAINT `FK9923EC3E25A527EA` FOREIGN KEY (`id_idioma_documento`) REFERENCES `idioma` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `documento`
--

DROP TABLE IF EXISTS `documento`;
CREATE TABLE `documento` (
  `id` bigint(20) NOT NULL auto_increment,
  `documento` varchar(255) NOT NULL default '',
  `ds_documento` text NOT NULL,
  `ds_email_autor` varchar(100) default NULL,
  `dt_criacao` datetime NOT NULL default '0000-00-00 00:00:00',
  `dt_inclusao` datetime NOT NULL default '0000-00-00 00:00:00',
  `nm_arquivo` varchar(255) NOT NULL default '',
  `nm_autor` varchar(255) default NULL,
  `nm_documento` varchar(255) NOT NULL default '',
  `qtd_visualizacao` bigint(20) NOT NULL default '0',
  `version` int(11) default NULL,
  `id_idioma_documento` bigint(20) NOT NULL default '0',
  `id_programa` bigint(20) default NULL,
  `id_usuario_autor` bigint(20) default NULL,
  `id_usuario_responsavel` bigint(20) default NULL,
  `tipo_documento` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FK383D52B4603D80F2` (`id_usuario_responsavel`),
  KEY `FK383D52B425A527EA` (`id_idioma_documento`),
  KEY `FK383D52B410F27F95` (`id_usuario_autor`),
  KEY `FK383D52B4EDD17EC2` (`tipo_documento`),
  KEY `FK383D52B44535FA45` (`id_programa`),
  CONSTRAINT `FK383D52B44535FA45` FOREIGN KEY (`id_programa`) REFERENCES `programa` (`id`),
  CONSTRAINT `FK383D52B410F27F95` FOREIGN KEY (`id_usuario_autor`) REFERENCES `usuario` (`id`),
  CONSTRAINT `FK383D52B425A527EA` FOREIGN KEY (`id_idioma_documento`) REFERENCES `idioma` (`id`),
  CONSTRAINT `FK383D52B4603D80F2` FOREIGN KEY (`id_usuario_responsavel`) REFERENCES `usuario` (`id`),
  CONSTRAINT `FK383D52B4EDD17EC2` FOREIGN KEY (`tipo_documento`) REFERENCES `tipo_documento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `idioma`
--

DROP TABLE IF EXISTS `idioma`;
CREATE TABLE `idioma` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_detalhada_idioma` varchar(255) default NULL,
  `ds_idioma` varchar(255) NOT NULL default '',
  `nm_idioma` varchar(50) NOT NULL default '',
  `nm_regiao` varchar(255) default NULL,
  `sg_idioma` varchar(4) NOT NULL default '',
  `version` int(11) default NULL,
  `id_pais` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FKB8DF70D5C21BD8C1` (`id_pais`),
  CONSTRAINT `FKB8DF70D5C21BD8C1` FOREIGN KEY (`id_pais`) REFERENCES `pais` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `pais`
--

DROP TABLE IF EXISTS `pais`;
CREATE TABLE `pais` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_pais` varchar(255) NOT NULL default '',
  `nm_pais` varchar(50) NOT NULL default '',
  `version` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `palavra_documento`
--

DROP TABLE IF EXISTS `palavra_documento`;
CREATE TABLE `palavra_documento` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_palavras_chaves` varchar(200) NOT NULL default '',
  `version` int(11) default NULL,
  `id_documento` bigint(20) NOT NULL default '0',
  `id_idioma` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FKE7D716B44580C13D` (`id_documento`),
  KEY `FKE7D716B492F95DF5` (`id_idioma`),
  CONSTRAINT `FKE7D716B492F95DF5` FOREIGN KEY (`id_idioma`) REFERENCES `idioma` (`id`),
  CONSTRAINT `FKE7D716B44580C13D` FOREIGN KEY (`id_documento`) REFERENCES `documento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `programa`
--

DROP TABLE IF EXISTS `programa`;
CREATE TABLE `programa` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_detalhada_programa` varchar(255) default NULL,
  `ds_programa` varchar(255) NOT NULL default '',
  `nm_programa` varchar(255) NOT NULL default '',
  `version` int(11) default NULL,
  `id_usuario` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FKC454B25DF63EF371` (`id_usuario`),
  CONSTRAINT `FKC454B25DF63EF371` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `rede_trabalho`
--

DROP TABLE IF EXISTS `rede_trabalho`;
CREATE TABLE `rede_trabalho` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_detalhado_redetrabalho` varchar(255) default NULL,
  `ds_redetrabalho` varchar(255) NOT NULL default '',
  `dt_inclusao` datetime NOT NULL default '0000-00-00 00:00:00',
  `nm_redetrabalho` varchar(255) NOT NULL default '',
  `version` int(11) default NULL,
  `id_usuario` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FK1ACB4FFCF63EF371` (`id_usuario`),
  CONSTRAINT `FK1ACB4FFCF63EF371` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `rede_trabalho_usuario`
--

DROP TABLE IF EXISTS `rede_trabalho_usuario`;
CREATE TABLE `rede_trabalho_usuario` (
  `id` bigint(20) NOT NULL auto_increment,
  `version` int(11) default NULL,
  `id_rede_trabalho` bigint(20) NOT NULL default '0',
  `id_usuario` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FKB60E2DEBF63EF371` (`id_usuario`),
  KEY `FKB60E2DEB2ACACB64` (`id_rede_trabalho`),
  CONSTRAINT `FKB60E2DEB2ACACB64` FOREIGN KEY (`id_rede_trabalho`) REFERENCES `rede_trabalho` (`id`),
  CONSTRAINT `FKB60E2DEBF63EF371` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `tipo_documento`
--

DROP TABLE IF EXISTS `tipo_documento`;
CREATE TABLE `tipo_documento` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_detalhado_tipo_documento` varchar(255) default NULL,
  `ds_tipo_documento` varchar(255) NOT NULL default '',
  `nm_tipo_documento` varchar(50) NOT NULL default '',
  `version` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `id` bigint(20) NOT NULL auto_increment,
  `ds_login` varchar(10) NOT NULL default '',
  `ds_senha` varchar(10) NOT NULL default '',
  `dt_inclusao` datetime NOT NULL default '0000-00-00 00:00:00',
  `email` varchar(255) NOT NULL default '',
  `fl_ativo` tinyint(1) NOT NULL default '0',
  `fl_institucional` tinyint(1) NOT NULL default '0',
  `nm_instituicao` varchar(255) default NULL,
  `nm_usuario` varchar(255) NOT NULL default '',
  `tp_usuario` int(11) NOT NULL default '0',
  `version` int(11) default NULL,
  `id_idioma` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FKF814F32E92F95DF5` (`id_idioma`),
  CONSTRAINT `FKF814F32E92F95DF5` FOREIGN KEY (`id_idioma`) REFERENCES `idioma` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Table structure for table `usuario_documento`
--

DROP TABLE IF EXISTS `usuario_documento`;
CREATE TABLE `usuario_documento` (
  `id` bigint(20) NOT NULL auto_increment,
  `dt_inclusao` datetime NOT NULL default '0000-00-00 00:00:00',
  `version` int(11) default NULL,
  `id_documento` bigint(20) NOT NULL default '0',
  `id_usuario` bigint(20) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `FKA5579EE34580C13D` (`id_documento`),
  KEY `FKA5579EE3F63EF371` (`id_usuario`),
  CONSTRAINT `FKA5579EE3F63EF371` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id`),
  CONSTRAINT `FKA5579EE34580C13D` FOREIGN KEY (`id_documento`) REFERENCES `documento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

