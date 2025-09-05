-- Q1c: Stored Procedure for Student Performance Analysis
-- Compares individual student performance with peers by gender, city, and age

USE Assignment_1;

DROP PROCEDURE IF EXISTS GetStudentPerformanceAnalysis;

DELIMITER //

CREATE PROCEDURE GetStudentPerformanceAnalysis(IN input_student_id VARCHAR(20))
BEGIN
    DECLARE student_gender VARCHAR(10);
    DECLARE student_city VARCHAR(100);
    DECLARE student_age INT;
    DECLARE student_age_band VARCHAR(10);
    DECLARE student_count INT DEFAULT 0;

    -- Check student exists
    SELECT COUNT(*) INTO student_count
    FROM masters_exam
    WHERE StudentID = input_student_id;

    IF student_count = 0 THEN
        SELECT 'Student not found' as message;
    ELSE
        -- Get student basic information
        SELECT Gender, City, Age,
               CASE 
                   WHEN Age BETWEEN 18 AND 20 THEN '18-20'
                   WHEN Age BETWEEN 21 AND 23 THEN '21-23'
                   WHEN Age BETWEEN 24 AND 25 THEN '24-25'
                   ELSE 'Other'
               END
        INTO student_gender, student_city, student_age, student_age_band
        FROM masters_exam
        WHERE StudentID = input_student_id 
        LIMIT 1;

        -- Create temporary table for analysis
        DROP TEMPORARY TABLE IF EXISTS temp_student_analysis;
        CREATE TEMPORARY TABLE temp_student_analysis (
            stage_order INT,
            stage_name VARCHAR(100),
            student_result VARCHAR(10),
            exam_datetime DATETIME,
            same_gender_pass_rate DECIMAL(6,2),
            same_gender_peers INT,
            same_city_pass_rate DECIMAL(6,2),
            same_city_peers INT,
            same_age_pass_rate DECIMAL(6,2),
            same_age_peers INT,
            gender_analysis VARCHAR(100),
            city_analysis VARCHAR(100),
            age_analysis VARCHAR(100)
        );

        -- Populate analysis data
        INSERT INTO temp_student_analysis
        SELECT 
            CASE sp.Stage
                WHEN 'Stage 1' THEN 1
                WHEN 'Stage 2' THEN 2  
                WHEN 'Stage 3' THEN 3
                WHEN 'Stage 4' THEN 4
            END as stage_order,
            sp.Stage as stage_name,
            sp.Status as student_result,
            sp.ExamDateTime as exam_datetime,
            
            -- Same gender pass rate
            ROUND(COALESCE((
                SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END) * 100
                FROM masters_exam 
                WHERE Gender = student_gender 
                  AND Stage = sp.Stage
                  AND StudentID <> input_student_id
            ), 0), 2) as same_gender_pass_rate,
            
            -- Same gender peer count
            COALESCE((
                SELECT COUNT(*)
                FROM masters_exam 
                WHERE Gender = student_gender 
                  AND Stage = sp.Stage
                  AND StudentID <> input_student_id
            ), 0) as same_gender_peers,
            
            -- Same city pass rate
            ROUND(COALESCE((
                SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END) * 100
                FROM masters_exam 
                WHERE City = student_city 
                  AND Stage = sp.Stage
                  AND StudentID <> input_student_id
            ), 0), 2) as same_city_pass_rate,
            
            -- Same city peer count
            COALESCE((
                SELECT COUNT(*)
                FROM masters_exam 
                WHERE City = student_city 
                  AND Stage = sp.Stage
                  AND StudentID <> input_student_id
            ), 0) as same_city_peers,
            
            -- Same age band pass rate
            ROUND(COALESCE((
                SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END) * 100
                FROM masters_exam 
                WHERE Age BETWEEN 
                    CASE student_age_band
                        WHEN '18-20' THEN 18
                        WHEN '21-23' THEN 21
                        WHEN '24-25' THEN 24
                        ELSE student_age
                    END 
                    AND 
                    CASE student_age_band
                        WHEN '18-20' THEN 20
                        WHEN '21-23' THEN 23
                        WHEN '24-25' THEN 25
                        ELSE student_age
                    END
                  AND Stage = sp.Stage
                  AND StudentID <> input_student_id
            ), 0), 2) as same_age_pass_rate,
            
            -- Same age band peer count
            COALESCE((
                SELECT COUNT(*)
                FROM masters_exam 
                WHERE Age BETWEEN 
                    CASE student_age_band
                        WHEN '18-20' THEN 18
                        WHEN '21-23' THEN 21
                        WHEN '24-25' THEN 24
                        ELSE student_age
                    END 
                    AND 
                    CASE student_age_band
                        WHEN '18-20' THEN 20
                        WHEN '21-23' THEN 23
                        WHEN '24-25' THEN 25
                        ELSE student_age
                    END
                  AND Stage = sp.Stage
                  AND StudentID <> input_student_id
            ), 0) as same_age_peers,
            
            -- Gender performance analysis
            CASE 
                WHEN sp.Status = 'Pass' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE Gender = student_gender AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) < 0.5 THEN 'Above Gender Average'
                WHEN sp.Status = 'Pass' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE Gender = student_gender AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) >= 0.5 THEN 'Meets Gender Average'
                WHEN sp.Status = 'Fail' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE Gender = student_gender AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) >= 0.5 THEN 'Below Gender Average'
                ELSE 'Aligns with Gender Average'
            END as gender_analysis,
            
            -- City performance analysis
            CASE 
                WHEN sp.Status = 'Pass' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE City = student_city AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) < 0.5 THEN 'Above City Average'
                WHEN sp.Status = 'Pass' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE City = student_city AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) >= 0.5 THEN 'Meets City Average'
                WHEN sp.Status = 'Fail' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE City = student_city AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) >= 0.5 THEN 'Below City Average'
                ELSE 'Aligns with City Average'
            END as city_analysis,
            
            -- Age group performance analysis
            CASE 
                WHEN sp.Status = 'Pass' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE Age BETWEEN 
                        CASE student_age_band
                            WHEN '18-20' THEN 18
                            WHEN '21-23' THEN 21
                            WHEN '24-25' THEN 24
                            ELSE student_age
                        END 
                        AND 
                        CASE student_age_band
                            WHEN '18-20' THEN 20
                            WHEN '21-23' THEN 23
                            WHEN '24-25' THEN 25
                            ELSE student_age
                        END
                      AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) < 0.5 THEN 'Above Age Group Average'
                WHEN sp.Status = 'Pass' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE Age BETWEEN 
                        CASE student_age_band
                            WHEN '18-20' THEN 18
                            WHEN '21-23' THEN 21
                            WHEN '24-25' THEN 24
                            ELSE student_age
                        END 
                        AND 
                        CASE student_age_band
                            WHEN '18-20' THEN 20
                            WHEN '21-23' THEN 23
                            WHEN '24-25' THEN 25
                            ELSE student_age
                        END
                      AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) >= 0.5 THEN 'Meets Age Group Average'
                WHEN sp.Status = 'Fail' AND COALESCE((
                    SELECT AVG(CASE WHEN Status = 'Pass' THEN 1.0 ELSE 0.0 END)
                    FROM masters_exam 
                    WHERE Age BETWEEN 
                        CASE student_age_band
                            WHEN '18-20' THEN 18
                            WHEN '21-23' THEN 21
                            WHEN '24-25' THEN 24
                            ELSE student_age
                        END 
                        AND 
                        CASE student_age_band
                            WHEN '18-20' THEN 20
                            WHEN '21-23' THEN 23
                            WHEN '24-25' THEN 25
                            ELSE student_age
                        END
                      AND Stage = sp.Stage AND StudentID <> input_student_id
                ), 0) >= 0.5 THEN 'Below Age Group Average'
                ELSE 'Aligns with Age Group Average'
            END as age_analysis
            
        FROM masters_exam sp
        WHERE sp.StudentID = input_student_id
        ORDER BY stage_order;
        
        -- Display student information header
        SELECT 
            CONCAT('Student ID: ', input_student_id) as 'Student Information',
            CONCAT('Demographics: ', student_gender, ', ', student_city, ', Age ', student_age, ' (', student_age_band, ')') as 'Demographics'
        UNION ALL
        SELECT '', '';
        
        -- Display detailed performance analysis
        SELECT 
            stage_order as 'Stage Number',
            stage_name as 'Stage Name',
            student_result as 'Student Result',
            exam_datetime as 'Exam Date/Time',
            CONCAT(same_gender_pass_rate, '%') as 'Same Gender Pass Rate',
            same_gender_peers as 'Same Gender Peers',
            CONCAT(same_city_pass_rate, '%') as 'Same City Pass Rate',
            same_city_peers as 'Same City Peers',
            CONCAT(same_age_pass_rate, '%') as 'Same Age Band Pass Rate',
            same_age_peers as 'Same Age Band Peers',
            gender_analysis as 'Gender Performance Analysis',
            city_analysis as 'City Performance Analysis',
            age_analysis as 'Age Group Performance Analysis'
        FROM temp_student_analysis
        ORDER BY stage_order;
        
        DROP TEMPORARY TABLE IF EXISTS temp_student_analysis;
        
    END IF;
    
END //

DELIMITER ;

-- Example usage:
-- CALL GetStudentPerformanceAnalysis('S202500001');
