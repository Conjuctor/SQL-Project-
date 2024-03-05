/* 
Dotaz č.1. 
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají? 
*/

SELECT branch_type ,  `year`,
		CASE
			WHEN lag(average_wages) OVER (PARTITION BY branch_type   ORDER BY `year`) > average_wages THEN 'wage decreasing'
			ELSE 'wage increasing'
		END	AS wage_change
FROM  t_pavel_both_project_sql_primary_final t
GROUP BY branch_type , `year` 
ORDER BY wage_change 