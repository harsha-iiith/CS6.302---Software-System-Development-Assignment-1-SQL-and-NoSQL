CREATE DATABASE IF NOT EXISTS Assignment_1;

USE Assignment_1;

DROP TABLE IF EXISTS masters_exam;

CREATE TABLE masters_exam (
    StudentID VARCHAR(20) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Stage ENUM('Stage 1', 'Stage 2', 'Stage 3', 'Stage 4') NOT NULL,
    ExamDateTime DATETIME NOT NULL,
    Status ENUM('Pass', 'Fail') NOT NULL,
    INDEX idx_student_id (StudentID),
    INDEX idx_stage (Stage),
    INDEX idx_status (Status),
    INDEX idx_exam_date (ExamDateTime),
    INDEX idx_gender (Gender),
    INDEX idx_city (City),
    INDEX idx_age (Age)
);
