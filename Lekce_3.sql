-- Agregační funkce

SELECT * FROM healthcare_provider hp;
SELECT * FROM czechia_price_category cpc;
SELECT * FROM czechia_price cp;

--Spočítejte počet řádků v tabulce czechia_price

SELECT count(*) AS počet, value, category_code
FROM czechia_price cp
GROUP BY category_code, value
ORDER BY počet DESC;

SELECT count(*)AS počet, value
FROM czechia_price cp
GROUP BY value
ORDER BY počet DESC;

SELECT count(*)AS počet, value, category_code
FROM czechia_price cp
GROUP BY value, category_code
ORDER BY počet DESC;

SELECT count(*), region_code, value
FROM czechia_price cp
GROUP BY region_code, value
ORDER BY value ASC;


--Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce count().

SELECT * FROM czechia_payroll cp;


SELECT count(*), value
FROM czechia_payroll cp
GROUP BY value;


SELECT count(id) AS rows_count
FROM czechia_payroll;


SELECT count(value) AS rows_count
FROM czechia_payroll;

--Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?


SELECT count(1) AS rows_count_code_316
FROM czechia_payroll cp 
WHERE value_type_code = 316
	AND value IS NOT NULL;


SELECT
    count(id) AS rows_of_known_employees
FROM czechia_payroll
WHERE	
    value_type_code = 316 
    AND value IS NOT NULL;

--Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.

SELECT * FROM czechia_price cp;


SELECT category_code, count(id) AS rows_of_category
FROM czechia_price cp 
GROUP BY category_code;


SELECT category_code, id
FROM czechia_price cp 
GROUP BY id;


--Rozšiřte předchozí dotaz o dodatečné rozdělení dle let měření.

SELECT
    category_code, 
    date_part('year', date_from) AS year_of_entry,
    count(id) AS rows_in_category
FROM czechia_price
GROUP BY 
    category_code, 
    year_of_entry
ORDER BY 
    year_of_entry, 
    category_code;

--Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.

SELECT sum(value) AS value_sum
FROM czechia_payroll
WHERE value_type_code = 316;

--Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.

SELECT *
FROM czechia_region;

SELECT 
    category_code, value, region_code,
    sum(value) AS sum_of_average_prices
FROM czechia_price
WHERE region_code = 'CZ064'
GROUP BY category_code, value, region_code;


SELECT 
    category_code, 
    sum(value) AS sum_of_average_prices
FROM czechia_price
WHERE region_code = 'CZ064'
GROUP BY category_code
ORDER BY category_code;

--Sečtěte průměrné ceny potravin za všechny kategorie, u kterých měření probíhalo od (date_from) 15. 1. 2018.

SELECT
    sum(value) AS sum_of_average_prices
FROM czechia_price
WHERE date_from::date >= '2018-01-15';


/*Vypište tři sloupce z tabulky czechia_price: kód kategorie, 
počet řádků pro ni a sumu hodnot průměrných cen. To vše pouze pro data v roce 2018.*/

SELECT
    category_code,
    count(1) AS row_count,
    sum(value) AS sum_of_average_prices
FROM czechia_price
WHERE date_part('year', date_from) = 2018
GROUP BY category_code;


--Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.

SELECT *
FROM czechia_payroll_value_type;

SELECT max(value)
FROM czechia_payroll
WHERE value_type_code = 5958;

--Na základě údajů v tabulce czechia_price vyberte pro každou kategorii potravin její minimum v letech 2015 až 2017.

SELECT
    category_code,
    min(value) AS minimum
FROM czechia_price
WHERE date_part('year', date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;


--Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.

SELECT * FROM czechia_payroll cp;

SELECT
        max(value)
    FROM czechia_payroll
    WHERE value_type_code = 5958;

SELECT
    industry_branch_code
FROM czechia_payroll
WHERE value IN (
    SELECT
        max(value)
    FROM czechia_payroll
    WHERE value_type_code = 5958
);

SELECT
 *
FROM czechia_payroll_industry_branch;


SELECT
 *
FROM czechia_payroll_industry_branch
WHERE code IN (
 SELECT
  industry_branch_code
 FROM czechia_payroll
 WHERE value IN (
  SELECT
   max(value)
  FROM czechia_payroll
  WHERE value_type_code = 5958
 )
);


/*
Pro každou kategorii potravin určete její minimum, maximum a vytvořte nový sloupec s názvem difference, 
ve kterém budou hodnoty "rozdíl do 10 Kč", 
"rozdíl do 40 Kč" a "rozdíl nad 40 Kč" na základě rozdílu minima a maxima. Podle tohoto rozdílu data seřaďte.
*/

SELECT
    category_code,
    round(min(value)::numeric, 2) AS min,
    max(value),
    CASE
        WHEN max(value) - min(value) < 10 THEN 'rozdíl do 10 Kč'
        WHEN max(value) - min(value) < 40 THEN 'rozdíl do 40 Kč'
         ELSE 'rozdíl nad 40 Kč'
    END AS difference
FROM czechia_price
GROUP BY category_code
ORDER BY difference;

--Korektnější řazení:

SELECT 
 category_code,
 min(value),
 max(value),
 CASE
  WHEN max(value) - min(value) < 10 THEN 'rozdíl do 10 Kč'
  WHEN max(value) - min(value) < 40 THEN 'rozdíl do 40 Kč'
  ELSE 'rozdíl nad 40 Kč' 
 END AS difference
FROM czechia_price
GROUP BY category_code
ORDER BY max(value) - min(value);

/* 
 Vyberte pro každou kategorii potravin minimum, maximum a aritmetický průměr (v našem případě průměr z průměrů)
 zaokrouhlený na dvě desetinná místa.
 */
SELECT
    category_code,
    min(value) AS historical_minimum,
    max(value) AS historical_maximum,
    round(avg(value)::numeric, 2) AS average
FROM czechia_price
GROUP BY category_code
ORDER BY average;

/*
 Rozšiřte předchozí dotaz tak, 
 že data budou rozdělena i podle kódu kraje a seřazena sestupně podle aritmetického průměru.
 */

SELECT
    category_code,
    region_code,
    min(value) AS historical_minimum,
    max(value) AS historical_maximum,
    round(avg(value)::numeric, 2) AS average --přetypování na numeric ::numeric
FROM czechia_price
GROUP BY category_code, region_code
ORDER BY average DESC;

/* Další operace v SELECT */

SELECT SQRT(-16); --error
SELECT 10/0; --error

SELECT FLOOR(1.56); -- 1
SELECT FLOOR(-1.56); -- -2

SELECT CEIL(1.56); -- 2
SELECT CEIL(-1.56); -- -1

SELECT ROUND(1.56); -- 2
SELECT ROUND(-1.56); -- -2

-- Vypočítejte průměrné ceny kategorií potravin bez použití funkce AVG() s přesností na dvě desetinná místa.

SELECT * FROM czechia_price cp;

SELECT
    category_code,
    ROUND((SUM(value) / COUNT(value))::numeric, 2) AS average_price
FROM czechia_price
GROUP BY category_code
ORDER BY category_code;

--Jaké datové typy budou mít hodnoty v následujících dotazech?

SELECT 1;--INT
SELECT 1.0; --DECIMAL
SELECT 1 + 1; --INT
SELECT 1 + 1.0; --DECIMAL
SELECT 1 + '1'; --DECIMAL :/
SELECT 1 + 'a'; --error
SELECT 1 + '12tatata'; --error

--Spojování řetězců

SELECT CONCAT('Hi, ', 'Engeto lektor here!');

SELECT CONCAT('We have ', COUNT(DISTINCT category_code), ' price categories.') AS info
FROM czechia_price;

--Další řetězcové operace:

SELECT name,
    substring(name FOR 2) AS prefix,
    substring(name FROM '..$') AS sufix,
    length(name)
FROM czechia_price_category;

--modulo - zbytek po dělení

SELECT 5 % 2;
SELECT 14 % 5;
SELECT 15 % 5;

SELECT 123456789874 % 11; -- zjistí, zda se jedná o bankovní účet, pokud je výsledek 0
SELECT 123456759875 % 11;

--Populace - zbytek po dělení dvěma:

SELECT
    country, year, population, population::bigint % 2 AS division_rest
FROM economies e
WHERE population IS NOT NULL;

--Populace - flag zda je sudá:

SELECT 
    country, year, population, population::bigint % 2 AS is_even
FROM economies e 
WHERE population IS NOT NULL;

--Populace - flag zda je sudá se selekcí:

SELECT 
    country, year, population, population::bigint % 2 AS is_even 
FROM economies e
WHERE population IS NOT NULL AND population::bigint % 2 = 0;
