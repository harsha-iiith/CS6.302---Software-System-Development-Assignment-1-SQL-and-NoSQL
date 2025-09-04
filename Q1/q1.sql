CREATE DATABASE IF NOT EXISTS Assignment_1_Q1;
USE Assignment_1_Q1;

CREATE TABLE IF NOT EXISTS masters_exam (
    StudentID INT,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Age INT,
    Gender VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Email VARCHAR(255),
    PhoneNumber VARCHAR(255),
    Stage VARCHAR(255),
    ExamDateTime DATETIME,
    Status VARCHAR(255)
    );

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/media/leo/leostore/leostore/leo-ext/college/ssd/assignments/CS6.302---Software-System-Development-Assignment-1-SQL-and-NoSQL/Q1/resources/masters_exam_time_travel_Jan-Jun2025_part1.csv' INTO TABLE masters_exam FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE '/media/leo/leostore/leostore/leo-ext/college/ssd/assignments/CS6.302---Software-System-Development-Assignment-1-SQL-and-NoSQL/Q1/resources/masters_exam_time_travel_Jan-Jun2025_part2.csv' INTO TABLE masters_exam FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';
LOAD DATA LOCAL INFILE '/media/leo/leostore/leostore/leo-ext/college/ssd/assignments/CS6.302---Software-System-Development-Assignment-1-SQL-and-NoSQL/Q1/resources/masters_exam_time_travel_Jan-Jun2025_part3.csv' INTO TABLE masters_exam FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

