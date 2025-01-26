-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: cms-db
-- Generation Time: Jan 26, 2025 at 10:52 PM
-- Server version: 10.11.8-MariaDB-ubu2204
-- PHP Version: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cms`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(11) NOT NULL,
  `location_id` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `location_id`, `address`) VALUES
(1, 68, 'Hviezdoslavovo námestie 1'),
(2, 29, 'Divadelná ulica 5'),
(3, 5, 'Hlavné námestie 10'),
(4, 47, 'Galéria moderného umenia 2'),
(5, 35, 'Knižnica 3'),
(6, 37, 'Letné kino 4'),
(7, 20, 'Športový areál 6'),
(8, 33, 'Historické múzeum 7'),
(9, 67, 'Jazzový klub 8'),
(12, 65, 'Košická cesta 7'),
(13, 2, 'Hlavná 7');

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `event_type` enum('Koncert','Divadlo','Výstava','Festival','Iné') NOT NULL,
  `event_date` date NOT NULL,
  `location_id` int(11) NOT NULL,
  `lastUpdate` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isPrivate` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `content`, `event_type`, `event_date`, `location_id`, `lastUpdate`, `isPrivate`) VALUES
(1, 'Koncert pod hviezdami', 'Večer plný hudby pod otvoreným nebom.', 'Koncert', '2025-06-15', 68, '2025-01-20 10:00:00', 0),
(2, 'Divadelná noc', 'Nočné predstavenie s tematikou hororu.', 'Divadlo', '2025-07-10', 29, '2025-01-21 11:00:00', 0),
(3, 'Festival jedla', 'Ochutnávka jedál z celého sveta.', 'Festival', '2024-11-21', 2, '2025-01-26 23:45:17', 0),
(4, 'Výstava moderného umenia', 'Prezentácia diel súčasných umelcov.', 'Výstava', '2025-09-01', 47, '2025-01-23 13:00:00', 0),
(6, 'Film pod holým nebom', 'Letné kino na námestí.', 'Iné', '2025-11-20', 37, '2025-01-25 15:00:00', 0),
(7, 'Športový deň', 'Súťaže a aktivity pre všetky vekové kategórie.', 'Iné', '2025-12-05', 20, '2025-01-26 16:00:00', 0),
(8, 'Historická výstava', 'Výstava historických artefaktov.', 'Výstava', '2024-12-12', 33, '2025-01-26 23:18:38', 1),
(9, 'Jazzový večer', 'Koncert jazzovej hudby.', 'Koncert', '2025-03-31', 65, '2025-01-26 23:42:52', 0);

--
-- Triggers `articles`
--
DELIMITER $$
CREATE TRIGGER `set_event_public_on_update` BEFORE UPDATE ON `articles` FOR EACH ROW BEGIN
    IF NEW.event_date >= CURDATE() THEN
        SET NEW.isPrivate = 0;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `article_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `comment` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `article_id`, `username`, `comment`, `created_at`) VALUES
(1, 1, 'user', 'Tešíme sa na úžasnú atmosféru a skvelé zážitky.', '2025-01-15 10:00:00'),
(2, 1, 'admin', 'Prípravy prebiehajú hladko, bude to nezabudnuteľné.', '2025-01-16 11:00:00'),
(3, 1, 'melodyFan', 'Tento koncert pod hviezdami vyzerá sľubne, už mám lístok!', '2025-01-17 12:00:00'),
(4, 1, 'starGazer', 'Hudba a nočná obloha? Počítam dni!', '2025-01-18 13:00:00'),
(5, 1, 'nightOwl', 'Program vyzerá úžasne, vidíme sa tam.', '2025-01-19 14:00:00'),
(6, 2, 'user', 'Divadelná noc bude určite strhujúca!', '2025-01-15 10:00:00'),
(7, 2, 'admin', 'Pripravujeme špeciálne kulisy, bude to jedinečné.', '2025-01-16 11:00:00'),
(8, 2, 'horrorLover', 'Teším sa na mrazivé momenty v podaní skvelých hercov.', '2025-01-17 12:00:00'),
(9, 2, 'stageCritic', 'Tento koncept divadelnej noci je zaujímavý, držím palce.', '2025-01-18 13:00:00'),
(10, 2, 'nightCrawler', 'Predpoveď vyzerá dobre, ideálne na divadelnú noc.', '2025-01-19 14:00:00'),
(11, 3, 'user', 'Festival jedla bude výnimočný, som zvedavý na ponuku.', '2025-01-15 10:00:00'),
(12, 3, 'admin', 'Chystáme pestrý výber jedál pre každého.', '2025-01-16 11:00:00'),
(13, 3, 'foodie', 'Určite ochutnám aj exotické špeciality!', '2025-01-17 12:00:00'),
(14, 3, 'spiceHunter', 'Neviete, či bude aj niečo pikantné? Teším sa!', '2025-01-18 13:00:00'),
(15, 3, 'worldEater', 'Festival jedla je pre gurmánov ako ja zážitok!', '2025-01-19 14:00:00'),
(16, 4, 'user', 'Výstava moderného umenia sľubuje inšpiratívne diela.', '2025-01-15 10:00:00'),
(17, 4, 'admin', 'Prezentácia bude skutočne pestrá, pripravujeme posledné detaily.', '2025-01-16 11:00:00'),
(18, 4, 'artLover', 'Na výstavách vždy nájdem nové nápady, teším sa.', '2025-01-17 12:00:00'),
(19, 4, 'designFan', 'Milujem moderné umenie, dúfam, že bude veľa inštalácií.', '2025-01-18 13:00:00'),
(20, 4, 'canvasDreamer', 'Konečne udalosť, ktorá sa oplatí vidieť!', '2025-01-19 14:00:00'),
(26, 6, 'user', 'Letné kino v novembri? Bude to zaujímavé!', '2025-01-15 10:00:00'),
(27, 6, 'admin', 'Pripravujeme priestor a premietanie, atmosféra bude čarovná.', '2025-01-16 11:00:00'),
(28, 6, 'movieBuff', 'Dúfam, že výber filmov bude rovnako kvalitný ako vlani.', '2025-01-17 12:00:00'),
(29, 6, 'skyLover', 'K letnému kinu sa hodí jasná nočná obloha, teším sa.', '2025-01-18 13:00:00'),
(30, 6, 'cinemaFan', 'Takéto akcie vždy spríjemnia večery, ďakujem.', '2025-01-19 14:00:00'),
(31, 7, 'user', 'Športový deň bude určite plný energie a nadšenia.', '2025-01-15 10:00:00'),
(32, 7, 'admin', 'Pre každého bude niečo zaujímavé, pripravujeme súťaže.', '2025-01-16 11:00:00'),
(34, 7, 'funSeeker', 'Verím, že to bude vhodné aj pre deti a rodiny.', '2025-01-18 13:00:00'),
(35, 7, 'teamPlayer', 'Teším sa na atmosféru tímového ducha.', '2025-01-19 14:00:00'),
(36, 8, 'user', 'História ožila v každom kúsku výstavy.', '2024-12-02 10:00:00'),
(37, 8, 'admin', 'Výborne spracované, bolo vidieť profesionalitu.', '2024-12-02 11:00:00'),
(38, 8, 'historyBuff', 'Každý artefakt mal svoj vlastný príbeh.', '2024-12-02 12:00:00'),
(39, 8, 'pastLover', 'Prenieslo ma to do inej doby, veľmi obohacujúce.', '2024-12-02 13:00:00'),
(40, 8, 'museumFan', 'Chcem viac takýchto výstav, skvelé spracovanie.', '2024-12-02 14:00:00'),
(41, 9, 'user', 'Jazzový večer bol plný života a rytmu.', '2024-11-16 10:00:00'),
(42, 9, 'admin', 'Úžasná hudobná zostava a výborná akustika.', '2024-11-16 11:00:00'),
(43, 9, 'jazzLover', 'Milujem jazz, toto bolo dokonalé.', '2024-11-16 12:00:00'),
(44, 9, 'saxFan', 'Ten saxofón bol nezabudnuteľný, bravo!', '2024-11-16 13:00:00'),
(45, 9, 'swingDancer', 'Tancoval som celú noc, bolo to perfektné.', '2024-11-16 14:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(11) NOT NULL,
  `location` varchar(100) NOT NULL,
  `district` varchar(100) NOT NULL,
  `region` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `location`, `district`, `region`) VALUES
(12, 'Bánovce nad Bebravou', 'Bánovce nad Bebravou', 'Trenčiansky'),
(39, 'Banská Bystrica', 'Banská Bystrica', 'Banskobystrický'),
(40, 'Banská Štiavnica', 'Banská Štiavnica', 'Banskobystrický'),
(50, 'Bardejov', 'Bardejov', 'Prešovský'),
(1, 'Bratislava', 'Bratislava', 'Bratislavský'),
(41, 'Brezno', 'Brezno', 'Banskobystrický'),
(28, 'Bytča', 'Bytča', 'Žilinský'),
(29, 'Čadca', 'Čadca', 'Žilinský'),
(42, 'Detva', 'Detva', 'Banskobystrický'),
(30, 'Dolný Kubín', 'Dolný Kubín', 'Žilinský'),
(5, 'Dunajská Streda', 'Dunajská Streda', 'Trnavský'),
(6, 'Galanta', 'Galanta', 'Trnavský'),
(62, 'Gelnica', 'Gelnica', 'Košický'),
(7, 'Hlohovec', 'Hlohovec', 'Trnavský'),
(51, 'Humenné', 'Humenné', 'Prešovský'),
(13, 'Ilava', 'Ilava', 'Trenčiansky'),
(52, 'Kežmarok', 'Kežmarok', 'Prešovský'),
(21, 'Komárno', 'Komárno', 'Nitriansky'),
(63, 'Košice', 'Košice', 'Košický'),
(69, 'Košice I', 'Košice', 'Košický'),
(70, 'Košice II', 'Košice', 'Košický'),
(71, 'Košice III', 'Košice', 'Košický'),
(72, 'Košice IV', 'Košice', 'Košický'),
(43, 'Krupina', 'Krupina', 'Banskobystrický'),
(31, 'Kysucké Nové Mesto', 'Kysucké Nové Mesto', 'Žilinský'),
(22, 'Levice', 'Levice', 'Nitriansky'),
(53, 'Levoča', 'Levoča', 'Prešovský'),
(32, 'Liptovský Mikuláš', 'Liptovský Mikuláš', 'Žilinský'),
(44, 'Lučenec', 'Lučenec', 'Banskobystrický'),
(2, 'Malacky', 'Malacky', 'Bratislavský'),
(33, 'Martin', 'Martin', 'Žilinský'),
(54, 'Medzilaborce', 'Medzilaborce', 'Prešovský'),
(64, 'Michalovce', 'Michalovce', 'Košický'),
(14, 'Myjava', 'Myjava', 'Trenčiansky'),
(34, 'Námestovo', 'Námestovo', 'Žilinský'),
(23, 'Nitra', 'Nitra', 'Nitriansky'),
(15, 'Nové Mesto nad Váhom', 'Nové Mesto nad Váhom', 'Trenčiansky'),
(24, 'Nové Zámky', 'Nové Zámky', 'Nitriansky'),
(16, 'Partizánske', 'Partizánske', 'Trenčiansky'),
(3, 'Pezinok', 'Pezinok', 'Bratislavský'),
(8, 'Piešťany', 'Piešťany', 'Trnavský'),
(45, 'Poltár', 'Poltár', 'Banskobystrický'),
(55, 'Poprad', 'Poprad', 'Prešovský'),
(17, 'Považská Bystrica', 'Považská Bystrica', 'Trenčiansky'),
(56, 'Prešov', 'Prešov', 'Prešovský'),
(18, 'Prievidza', 'Prievidza', 'Trenčiansky'),
(19, 'Púchov', 'Púchov', 'Trenčiansky'),
(46, 'Revúca', 'Revúca', 'Banskobystrický'),
(47, 'Rimavská Sobota', 'Rimavská Sobota', 'Banskobystrický'),
(65, 'Rožňava', 'Rožňava', 'Košický'),
(35, 'Ružomberok', 'Ružomberok', 'Žilinský'),
(57, 'Sabinov', 'Sabinov', 'Prešovský'),
(25, 'Šaľa', 'Šaľa', 'Nitriansky'),
(4, 'Senec', 'Senec', 'Bratislavský'),
(9, 'Senica', 'Senica', 'Trnavský'),
(10, 'Skalica', 'Skalica', 'Trnavský'),
(58, 'Snina', 'Snina', 'Prešovský'),
(66, 'Sobrance', 'Sobrance', 'Košický'),
(67, 'Spišská Nová Ves', 'Spišská Nová Ves', 'Košický'),
(59, 'Stará Ľubovňa', 'Stará Ľubovňa', 'Prešovský'),
(60, 'Svidník', 'Svidník', 'Prešovský'),
(26, 'Topoľčany', 'Topoľčany', 'Nitriansky'),
(68, 'Trebišov', 'Trebišov', 'Košický'),
(20, 'Trenčín', 'Trenčín', 'Trenčiansky'),
(11, 'Trnava', 'Trnava', 'Trnavský'),
(36, 'Turčianske Teplice', 'Turčianske Teplice', 'Žilinský'),
(37, 'Tvrdošín', 'Tvrdošín', 'Žilinský'),
(48, 'Veľký Krtíš', 'Veľký Krtíš', 'Banskobystrický'),
(61, 'Vranov nad Topľou', 'Vranov nad Topľou', 'Prešovský'),
(38, 'Žilina', 'Žilina', 'Žilinský'),
(27, 'Zlaté Moravce', 'Zlaté Moravce', 'Nitriansky'),
(49, 'Zvolen', 'Zvolen', 'Banskobystrický');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `roles` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `roles`) VALUES
(1, 'user', '$argon2id$v=19$m=65536,t=3,p=4$aL1m2p7bH7ti9wBAN9wa5w$IcAtukOVRp7DK1lMZEJ0aUVC1NLYmKY0cXmqiAss//M', 'user'),
(2, 'admin', '$argon2id$v=19$m=65536,t=3,p=4$1H9C6NUlZHjVTGZxxRbMQw$8A5xsRAkf+fv5cntPcFx+7lz0s2DwoBg2FOwAr0NuJ4', 'admin');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location_id` (`location_id`);

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `location_id` (`location_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `article_id` (`article_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_location` (`location`,`district`,`region`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=301;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`article_id`) REFERENCES `articles` (`id`) ON DELETE CASCADE;

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`%` EVENT `update_event_privacy` ON SCHEDULE EVERY 1 MINUTE STARTS '2025-01-25 11:05:37' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE `articles` SET isPrivate = 1 WHERE event_date < CURDATE() AND isPrivate = 0$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
