/*  
Dotaz č.5. 
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na
cenách potravin či mzdách ve stejném nebo násdujícím roce výraznějším růstem?
 */


WITH 
-- výpočet meziroční změny HDP
a AS ( 
	SELECT  `year`,
	  		 round(((GDP - lag(GDP) OVER (ORDER BY `year`) ) / lag(GDP) OVER (ORDER BY `year`) ) * 100,2 ) AS GDP_changes
	FROM t_Pavel_Both_project_SQL_secondary_final t
	WHERE country = 'Czech Republic'
	 ),
-- výpočet meziroční změny platů
b AS (     
	SELECT `year`,
			round (avg(a.wage_changes),2) AS wage_changes
	FROM (
			SELECT
		 	   branch_type, `year`, average_wages
		 	   ,round(((average_wages - lag(average_wages) OVER (PARTITION BY branch_type ORDER BY year)) 
		    	 / lag(average_wages) OVER (PARTITION BY branch_type ORDER BY year)) * 100, 2) AS wage_changes
			 FROM  t_Pavel_Both_project_SQL_primary_final t
				GROUP BY branch_type, `year` 
			) a
	GROUP BY  `year`
	 ),
-- výpočet meziroční změny cen potravin
c AS (
	SELECT `year`, 
		   round (avg(b.price_changes),2) AS price_changes
	FROM (
			SELECT name_category , `year` , average_price,
					round(((average_price - lag(average_price) OVER (PARTITION BY name_category ORDER BY year)) 
				    	 / lag(average_price) OVER (PARTITION BY name_category ORDER BY year)) * 100, 2) AS price_changes
			FROM t_Pavel_Both_project_SQL_primary_final t
			GROUP BY name_category , `year` 
			) b
	GROUP BY  `year`
	)
SELECT a.`year`,
		 CASE 
			WHEN a.GDP_changes > lag(a.GDP_changes) OVER (ORDER BY a.`year`) THEN 'GDP is increasing'
			ELSE 'decrease'
		  END GDP_changes ,
		  CASE 
			WHEN b.wage_changes > lag(b.wage_changes) OVER (ORDER BY b.`year`) THEN 'wage is increasing '
			ELSE 'decrease'
		  END wage_changes ,
		  CASE 
			WHEN c.price_changes > lag(c.price_changes) OVER (ORDER BY c.`year`) THEN 'price is increasing'
			ELSE 'decrease'
		  END price_changes
FROM b
	JOIN a	
		ON a.`year` = b.`year`
	JOIN c
		ON a.`year` = c.`year`
	 WHERE a.GDP_changes IS NOT NULL
ORDER BY a.`year`
;
	
	