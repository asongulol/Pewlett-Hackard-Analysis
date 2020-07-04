# Pewlett-Hackard-Analysis
## Technical Report

There were two main questions that we wanted to answer in our analysis: 1) identify the number of retiring employees and their current titles, 2) identify the current employees and their titles who are eligible to become mentors to the new generation of Pewelett-Hackard team members.

For the first goal of the analysis, we produced a table entitled retirement_list and added the required fields of emp_no, first_name, last_name, title, title_from and salary filtering using the retirable birth dates. The problem we encountered here is that since these employees have been with the company for many decades, many of them have gone through more than one position in the company and certain employees can be repeated resulting in a bigger list than necessary. Also, some of the retirable employees also have left the company. To solve the first problem, partitioning was done to delete identify and delete duplicate entries. Also, current employees were filtered using the to_date column.

For the second goal of the analysis, the required data the employee number, first and last name, title and from_date to to_date for that title. We filtered the data to only choose employes born in 1965 to limit the number of employees who are eligible for mentoring.

The results of the analysis are presented in two tables (in csv format) entitled retirement_list and mentor_list. Notes are in the queries file and the schema is in the schema file found in the queries directory. 
