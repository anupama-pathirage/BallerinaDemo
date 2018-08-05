DROP DATABASE IF EXISTS BallerinaDemo;
CREATE DATABASE BallerinaDemo;
GRANT all on BallerinaDemo.* to 'demouser'@'localhost' identified by 'password@123';
USE BallerinaDemo;
CREATE TABLE Accommodation (id INT NOT NULL AUTO_INCREMENT, hotel VARCHAR(1024), taxi VARCHAR(1024), PRIMARY KEY (ID));
CREATE TABLE Flight (id INT , flight1 VARCHAR(1024), flight2 VARCHAR(1024));

