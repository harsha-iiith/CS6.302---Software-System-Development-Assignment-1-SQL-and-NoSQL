USE Assignment_1;


WITH base_data AS (
    SELECT 
        Stage,
        CASE Stage
            WHEN 'Technical Entrance Test' THEN 1
            WHEN 'IQ Test' THEN 2  
            WHEN 'Descriptive Exam' THEN 3
            WHEN 'Face-to-Face Interview' THEN 4
        END as stage_order,
        Gender,
        CASE 
            WHEN Age BETWEEN 18 AND 20 THEN '18-20'
            WHEN Age BETWEEN 21 AND 23 THEN '21-23'
            WHEN Age BETWEEN 24 AND 25 THEN '24-25'
            ELSE 'Other'
        END as age_band,
        City,
        Status,
        CASE WHEN Status = 'Pass' THEN 1 ELSE 0 END as is_pass
    FROM masters_exam
)
SELECT 
    'Gender' as category,
    Gender as subcategory,
    Stage,
    ROUND(AVG(is_pass) * 100, 2) as pass_rate_percent
FROM base_data
GROUP BY Gender, Stage

UNION ALL

SELECT 
    'Age Band' as category,
    age_band as subcategory,
    Stage,
    ROUND(AVG(is_pass) * 100, 2) as pass_rate_percent
FROM base_data
GROUP BY age_band, Stage

UNION ALL

SELECT 
    'City' as category,
    City as subcategory,
    Stage,
    ROUND(AVG(is_pass) * 100, 2) as pass_rate_percent
FROM base_data
GROUP BY City, Stage
ORDER BY category, Stage, subcategory;