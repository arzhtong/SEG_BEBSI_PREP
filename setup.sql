 /*
 * SETUP SCRIPT FOR DB - Alexandros Doganis
 * To start and use DB:
 * 1.   enable sql services with "sudo service mysql start"
 * 2.   set up database for the first time with  "mysql -u root < setup.sql" make sure you are in Heliotrope/private directory
 * 3.   you can access the db through terminal by typing "mysql -u root CGS"
 * 4.   editing can be done by hand in the terminal or you can "drop database CGS" edit this file then repeat steps 1-3.
 * 
 * NOTE: to add initial data, see private/setup-data/info-(desired table)
 */


create database if not exists CGS;
use CGS;

create table if not exists members (
    member_id        INT(7) unsigned NOT NULL AUTO_INCREMENT,
    name             VARCHAR(255) NOT NULL,
    surname          VARCHAR(255) NOT NULL,
    pending_fine     FLOAT NOT NULL,
    ban_status       BOOLEAN NOT NULL,
    violations       INT NOT NULL,
    
    PRIMARY KEY     (member_id)
);

create table if not exists platform (
    name        VARCHAR(255) NOT NULL,
    
    PRIMARY KEY (name)
);

create table if not exists rules (
    rules_id            INT(7) unsigned NOT NULL AUTO_INCREMENT,
    rental_length       VARCHAR(255) NOT NULL,
    max_rentals         INT(2) NOT NULL,
    ban_length          VARCHAR(255) NOT NULL,
    extension_length    VARCHAR(255) NOT NULL,
    max_extensions      INT(2) NOT NULL,
    max_violations      INT(2) NOT NULL,
    
    PRIMARY KEY (rules_id)
);

create table if not exists games (
    game_id       INT(7) unsigned NOT NULL AUTO_INCREMENT,
    title         VARCHAR(255) NOT NULL,
    platform      VARCHAR(255) NOT NULL,
    release_year  YEAR NOT NULL,
    broken        BOOLEAN NOT NULL,
    available     BOOLEAN NOT NULL,
    price         FLOAT NOT NULL,
    info          VARCHAR(512),
    image         VARCHAR(512),
    
    PRIMARY KEY (game_id) ,
    CONSTRAINT
        FOREIGN KEY (platform) REFERENCES platform(name)
);

create table if not exists rentals (
    rental_id         INT(7) unsigned NOT NULL AUTO_INCREMENT,
    member_id         INT(7) unsigned NOT NULL,
    game_id           INT(7) unsigned NOT NULL,
    date_rented       DATE NOT NULL,
    date_due          DATE NOT NULL,
    extensions        INT NOT NULL,
    returned          BOOLEAN NOT NULL,
    

    PRIMARY KEY (rental_id),

    CONSTRAINT
        FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
        FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);


create table if not exists staff (
    id int NOT          NULL PRIMARY KEY AUTO_INCREMENT,
    first_name          VARCHAR(255),
    last_name           VARCHAR(255),
    email               VARCHAR(255),
    username            VARCHAR(30) NOT NULL UNIQUE,
    hashed_password     VARCHAR(255) NOT NULL,
    secretary           BOOLEAN DEFAULT '0'
);

ALTER TABLE staff ADD INDEX index_username (username);

# basic data set

#preset rules
INSERT INTO rules ( rental_length, max_rentals, ban_length, extension_length, max_extensions, max_violations) VALUES ('+3 weeks', '2', '+6 months', '+1 weeks', '2', '3');

LOAD DATA LOCAL INFILE "Heliotrope/private/setup-data/info-platform.txt" INTO TABLE platform
    FIELDS TERMINATED BY ','  LINES STARTING BY 'xxx';
LOAD DATA LOCAL INFILE "Heliotrope/private/setup-data/info-games.txt" INTO TABLE games
    FIELDS TERMINATED BY ','  LINES STARTING BY 'xxx';
LOAD DATA LOCAL INFILE "Heliotrope/private/setup-data/info-members.txt" INTO TABLE members
    FIELDS TERMINATED BY ','  LINES STARTING BY 'xxx';
LOAD DATA LOCAL INFILE "Heliotrope/private/setup-data/info-rentals.txt" INTO TABLE rentals
    FIELDS TERMINATED BY ','  LINES STARTING BY 'xxx';

#password = Password1234!
INSERT INTO staff(first_name, last_name, email, username, hashed_password, secretary) VALUES ('admin', 'admin', 'admin@cgs.com', 'Password1234!', '$2y$10$WfnnQXmXf5MubBk0HL1AP.QG3y/AulDozmtWmHYK95wx1mDlhx2h.', '1');
#password = testTEST1234!
INSERT INTO staff(first_name, last_name, email, username, hashed_password, secretary) VALUES ('david', 'temple', 'david@test.com', 'testvolunteer', '$2y$10$7KyHnntmEfAI2v0/9tl6QOVDq.rUQ.2hFklDBywQhMqnixc4EQ6k2', '');

#access credentials
GRANT ALL PRIVILEGES ON CGS.* TO 'webuser'@'localhost' IDENTIFIED BY 'Heliotrope';