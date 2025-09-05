USE Assignment_1;

WITH stage_progression AS (
    SELECT 
        StudentID,
        Stage,
        ExamDateTime,
        Status,
        CASE Stage
            WHEN 'Technical Entrance Test' THEN 1
            WHEN 'IQ Test' THEN 2  
            WHEN 'Descriptive Exam' THEN 3
            WHEN 'Face-to-Face Interview' THEN 4
        END as stage_order
    FROM masters_exam
),
stage_stats AS (
    SELECT 
        Stage,
        stage_order,
        COUNT(*) as total_students,
        SUM(CASE WHEN Status = 'Pass' THEN 1 ELSE 0 END) as passed_students,
        SUM(CASE WHEN Status = 'Fail' THEN 1 ELSE 0 END) as failed_students,
        ROUND((SUM(CASE WHEN Status = 'Pass' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as pass_rate
    FROM stage_progression
    GROUP BY Stage, stage_order
),
turnaround_times AS (
    SELECT 
        curr.Stage as current_stage,
        curr.stage_order,
        AVG(TIMESTAMPDIFF(DAY, prev.ExamDateTime, curr.ExamDateTime)) as avg_days_from_previous_stage
    FROM stage_progression curr
    JOIN stage_progression prev ON curr.StudentID = prev.StudentID 
        AND curr.stage_order = prev.stage_order + 1
    GROUP BY curr.Stage, curr.stage_order
)
SELECT 
    ss.stage_order as 'Stage Number',
    ss.Stage as 'Admission Stage',
    ss.total_students as 'Total Students',
    ss.passed_students as 'Students Passed',
    ss.failed_students as 'Students Failed',
    CONCAT(ss.pass_rate, '%') as 'Pass Rate',
    CASE 
        WHEN ss.stage_order = 1 THEN 'N/A (First Stage)'
        ELSE CONCAT(ROUND(tt.avg_days_from_previous_stage, 1), ' days')
    END as 'Avg Turnaround from Previous Stage'
FROM stage_stats ss
LEFT JOIN turnaround_times tt ON ss.Stage = tt.current_stage
ORDER BY ss.stage_order;