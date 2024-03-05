/*
Dotaz č. 3. 
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
*/ 

WITH 
a AS (
	SELECT 
		DISTINCT name_category, 
		average_price, 
		`year`, 
		price_value, 
		price_unit
		FROM t_pavel_both_project_sql_primary_final t
		WHERE `year` = 2006
	),
b AS (
	SELECT 
		DISTINCT name_category, 
		average_price, 
		`year`
		FROM t_pavel_both_project_sql_primary_final t
		WHERE `year` = 2018
		)	
SELECT a.name_category,
	   round(((b.average_price/a.average_price)-1)*100,2) AS total_price_increase,
	   round((((b.average_price/a.average_price)-1)*100)/13,2) AS avg_price_increace, 
	   a.price_value, 
	   a.price_unit,
		CASE 
			WHEN round(((b.average_price/a.average_price)-1)*100,2) > 0 THEN 'price is rising'
			ELSE 'price is decreasing'
		END AS overall_price_trends
FROM a
JOIN b
ON a.name_category = b.name_category
ORDER BY avg_price_increace
