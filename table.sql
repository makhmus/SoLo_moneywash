CREATE TABLE `money_wash` (
    `id` INT AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `marked_bills` INT NOT NULL,
    `cash_amount` INT NOT NULL,
    `end_time` BIGINT NOT NULL,
    PRIMARY KEY (`id`)
);
