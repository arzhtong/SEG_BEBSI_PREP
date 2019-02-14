create database if not exists Bebsi;
use Bebsi;

create table if not exists departments (
    name        VARCHAR(255) NOT NULL UNIQUE,
    
    PRIMARY KEY (name) 
);

create table if not exists staff (
    staff_id 			INT NOT NULL AUTO_INCREMENT,
    email               VARCHAR(255) NOT NULL UNIQUE,
    username            VARCHAR(30) NOT NULL UNIQUE,
    hashed_password     VARCHAR(255) NOT NULL,
    department			VARCHAR(30) NOT NULL UNIQUE,
    admin           	BOOLEAN DEFAULT '0',
    
    PRIMARY KEY     (staff_id),
    CONSTRAINT
        FOREIGN KEY (department) REFERENCES departments(name) ON DELETE CASCADE
);

create table if not exists patients (
    patient_id          INT(7) unsigned NOT NULL AUTO_INCREMENT,
    
    PRIMARY KEY (patient_id)
);

create table if not exists tests (
    test_id       		INT(7) unsigned NOT NULL AUTO_INCREMENT,
    test_name       	VARCHAR(255) NOT NULL UNIQUE,
    description     	BLOB NOT NULL,
    department			VARCHAR(30) NOT NULL UNIQUE,    
    
    PRIMARY KEY (test_id) ,
    CONSTRAINT
        FOREIGN KEY (department) REFERENCES departments(name) ON DELETE CASCADE
    
);


create table if not exists test_instances (
    test_instance_id    INT(7) unsigned NOT NULL AUTO_INCREMENT,
    test_id         	INT(7) unsigned NOT NULL,
    details				BLOB,

    PRIMARY KEY (test_instance_id),

    CONSTRAINT
        FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE
);

create table if not exists appointments (
    app_id       	 	INT(9) unsigned NOT NULL AUTO_INCREMENT,
    patient_id          INT(7) unsigned NOT NULL,
    app_date           	date NOT NULL,
    app_time		    time NOT NULL,
    app_location       	VARCHAR(255) NOT NULL,
    test_instance_id    INT(7) unsigned NOT NULL,
    
    
    PRIMARY KEY     (app_id),
    CONSTRAINT
        FOREIGN KEY (test_instance_id) REFERENCES test_instances(test_instance_id) ON DELETE CASCADE,
        FOREIGN KEY (patient_id) REFERENCES patients(patient_id) ON DELETE CASCADE    
);
