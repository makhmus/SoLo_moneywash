CREATE TABLE IF NOT EXISTS `money_wash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL,
  `marked_bills` int(11) NOT NULL,
  `cash_amount` int(11) NOT NULL,
  `end_time` datetime NOT NULL,
  `ready` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;