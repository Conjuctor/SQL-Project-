
/*
 Dotaz č. 4. 
 Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*/ 

/* -----------------------------------------------------------------------------------------------------------------------------
 Varianta č.1
porovnání mezoročního navýšení průměrných ročních platů všech odvětví s mezoročním navýšením průměrné roční ceny všech kategorií
 -----------------------------------------------------------------------------------------------------------------------------*/

WITH 
a AS (
	SELECT 	a.`year` , 
			round (avg(a.wage_increase),2) AS wage_increase
	FROM (
			SELECT	 branch_type, 
		   			 `year`, 
		   			 average_wages
		   			 ,ROUND(((average_wages - LAG(average_wages) OVER (PARTITION BY branch_type ORDER BY `year`)) 
		    		 / LAG(average_wages) OVER (PARTITION BY branch_type ORDER BY `year`)) * 100, 2) AS wage_increase
		 	FROM
		  		t_Pavel_Both_project_SQL_primary_final t
			GROUP BY branch_type, `year`
			) a
	GROUP BY  a.`year`
	),
b AS (
	SELECT 	b.`year`, 
			round (avg(b.price_increase),2) AS price_increase
	FROM (
			SELECT	name_category , 
					`year` , 
					average_price,
					ROUND(((average_price - LAG(average_price) OVER (PARTITION BY name_category ORDER BY `year`)) 
				    	 / LAG(average_price) OVER (PARTITION BY name_category ORDER BY `year`)) * 100, 2) AS price_increase
			FROM 	t_Pavel_Both_project_SQL_primary_final t
			GROUP BY name_category , `year` 
			) b
	GROUP BY  b.`year`
	)
SELECT	a.`year`,
		b.price_increase - a.wage_increase AS price_wage_differences, 
		CASE 
			WHEN b.price_increase - a.wage_increase > 10 THEN 'prices increased over 10%'
			ELSE 'little differences'
		END AS differences
FROM a 
	LEFT JOIN b
	ON a.`year`  = b.`year`  
WHERE b.price_increase IS NOT NULL
ORDER BY price_wage_differences DESC
;


/* -----------------------------------------------------------------------------------------------------------------------------
 Varianta č.2
 Porovnání mezoročního navýšení průměrných ročních platů ze všech odvětví s meziročním navýšením průměrné roční ceny každé kategorie surovin 
 -----------------------------------------------------------------------------------------------------------------------------*/

WITH 
a AS (
	SELECT t.name_category , t.`year`, aw.avg_year_wages,  t.average_price
	FROM t_Pavel_Both_project_SQL_primary_final t
	LEFT JOIN (
		SELECT `year` , round(avg(average_wages)) AS avg_year_wages
		FROM t_Pavel_Both_project_SQL_primary_final t
		GROUP BY `year` 
			  ) aw
		ON t.`year` = aw.`year`
	WHERE t.name_category  IS NOT NULL
	GROUP BY t.name_category, t.`year` 
	),
b AS (	
SELECT *
		, round((a.avg_year_wages - LAG(a.avg_year_wages) OVER (PARTITION BY a.name_category ORDER BY a.`year`)) 
				/ (LAG(a.avg_year_wages) OVER (PARTITION BY a.name_category ORDER BY a.`year`))*100,2) AS wage_increase
		, round((a.average_price - LAG(a.average_price) OVER (PARTITION BY a.name_category ORDER BY a.`year`)) 
				/ (LAG(a.average_price) OVER (PARTITION BY a.name_category ORDER BY a.`year`))*100,2) AS price_increase
FROM a
	)
SELECT  b.`year`, 
		b.name_category,  
		round(price_increase - wage_increase,2) AS price_wage_differences,
		CASE
			WHEN price_increase - wage_increase > 10 THEN 'prices increased over 10%'
			ELSE 'little differences'
		END AS differences
FROM b
WHERE price_increase - wage_increase > 10
ORDER BY price_wage_differences DESC 
;





