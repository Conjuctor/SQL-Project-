
/* tabulka pro porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období. */

CREATE OR REPLACE TABLE t_Pavel_Both_project_SQL_primary_final AS		
WITH 
cp AS (
		SELECT industry_branch_code , payroll_year,  unit_code, 
			avg(value) AS Average_wages
		FROM czechia_payroll cp 
		WHERE cp.value_type_code = 5958
			AND cp.calculation_code = 100 
			AND industry_branch_code IS NOT NULL 
		GROUP BY payroll_year, industry_branch_code  
		),
cpr AS (
		SELECT name AS Name_category,  
			year(date_from) AS price_year ,  
			round(avg(value),2) AS Average_price , 
			cpc.price_value, 
			cpc.price_unit
		FROM czechia_price cp 
			LEFT JOIN czechia_price_category cpc 
				ON cp.category_code = cpc.code 
				WHERE region_code  IS  NULL
				GROUP BY code, price_year
		)
SELECT 
		cpib.name AS branch_type,  
		cp.payroll_year AS `year`,
		cp.Average_wages AS average_wages, 
		cpu.name AS CZK_,
		cpr.Name_category AS name_category, 
		cpr.Average_price AS average_price, 
		cpu.name AS CZK, 
		cpr.price_value, 
		cpr.price_unit
FROM cp
		LEFT JOIN czechia_payroll_industry_branch cpib
			ON cp.industry_branch_code = cpib.code 
		LEFT JOIN czechia_payroll_unit cpu 
			ON cp.unit_code = cpu.code 
		LEFT JOIN cpr
			ON cpr.price_year = cp.payroll_year
WHERE cpr.Name_category IS NOT NULL
	;







	

