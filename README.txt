# Q1

1. Getting the dataset into the database (mysql)

CREATE DATABASE IF NOT EXISTS Assignment_1_Q1;
USE Assignment_1_Q1;

# Adding dataset from the dataset folder to the database

 LOADAD DATA LOCAL INFILE 'file.csv' INTO TABLE table
 FIELDS TERMINATED BY ','
 ENCLOSURE BY '"'
 LINES TERMINATED BY '\n'
 (column1, column2, column3,...)