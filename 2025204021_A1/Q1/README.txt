# Question 1

Q1: Load the supplied dataset into a relational database and answer the following using SQL. (30 Marks)

a. Admission Funnel - An admission funnel is a stage-by-stage representation of how applicants
progress through the selection process, showing the number who start, advance, or drop out at each
stage until final admission. Write a single SQL query to present admission funnel of students in each
stage of Admission and provide the average turn-around time between each stage for all students.

b. Pass and Fail Rate – Write a single SQL query provide pass rate by gender (Female/Male) in each stage,
pass rate by age band (18-20, 21-23, 24-25) in each stage, pass rate by City in each stage.

c. Write a Stored Procedure that reads StudentID as input and summarizes the student performance by
each stage of the test with other students from the same stage with dimensions gender, city, age. For
example, if StudentID 20162153 is provided as input, the output should return his performance in each
stage and also illustrate what is the mean pass/fail rate of other students by gender, city, age. You are
open choose any other measure apart from mean.

Dataset can be accessed from here. Details about the dataset are available here

q1a.sql
