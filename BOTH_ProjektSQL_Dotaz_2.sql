/*
Dotaz č.2. 
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
*/ 

WITH
a AS (
	SELECT 	name_category, 
			`year` ,
			round(avg(average_wages)*12/average_price) AS 'pcs/year', 
			price_unit  
		FROM t_Pavel_Both_project_SQL_primary_final t 
			WHERE  name_category = 'Chléb konzumní kmínový' 
				AND  (`year` = (SELECT MIN(`year`) FROM t_Pavel_Both_project_SQL_primary_final t  WHERE name_category IS NOT NULL) 
				OR  `year` = (SELECT MAX(`year`) FROM t_Pavel_Both_project_SQL_primary_final t  WHERE name_category IS NOT NULL) )		
		GROUP BY  `year`
	),
b AS (
	SELECT name_category, 
			`year`,
			round(avg(average_wages)*12/average_price) AS 'pcs/year', 
			price_unit 
		FROM t_Pavel_Both_project_SQL_primary_final t  
		WHERE  name_category = 'Mléko polotučné pasterované' 
			AND  (`year` = (SELECT MIN(`year`) FROM t_Pavel_Both_project_SQL_primary_final t  WHERE name_category IS NOT NULL) 
			OR  `year` = (SELECT MAX(`year`) FROM t_Pavel_Both_project_SQL_primary_final t  WHERE name_category IS NOT NULL) )
		GROUP BY  `year` 
	 )
SELECT * FROM a
	UNION
SELECT * FROM b
; 
