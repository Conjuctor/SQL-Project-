/*
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států 
ve stejném období, jako primární přehled pro ČR.
*/

CREATE OR REPLACE TABLE t_Pavel_Both_project_SQL_secondary_final AS
SELECT country, `year`, population, gini , GDP 
	FROM economies e 
	WHERE `year` BETWEEN 2006 AND 2018
	;