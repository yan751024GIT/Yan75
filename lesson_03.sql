/*
Funkce COUNT()
*/

-- Úkol 1: Spočítejte počet řádků v tabulce czechia_price.
SELECT count(*)
FROM czechia_price cp;

SELECT count(1)
FROM czechia_price cp;

-- Úkol 2: Spočítejte počet řádků v tabulce czechia_payroll s konkrétním sloupcem jako argumentem funkce count().
SELECT count(id)
FROM czechia_payroll cp;
-- 6880

SELECT count(value)
FROM czechia_payroll cp;
-- 3784

SELECT *
FROM czechia_payroll cp;

SELECT count(cp.value_type_code)
FROM czechia_payroll cp;

-- Úkol 3: Z kolika záznamů v tabulce czechia_payroll jsme schopni vyvodit průměrné počty zaměstnanců?
SELECT count(1)
FROM czechia_payroll cp
WHERE
	cp.value_type_code = 316
	AND cp.value IS NOT NULL;

-- Úkol 4: Vypište všechny cenové kategorie a počet řádků každé z nich v tabulce czechia_price.
SELECT
	cp.category_code,
	count(id)
FROM czechia_price cp
GROUP BY category_code;

-- Úkol 5: Rozšiřte předchozí dotaz o dodatečné rozdělení dle let měření.
SELECT *
FROM czechia_price cp;

SELECT
	cp.category_code,
	date_part('year', cp.date_from) AS year_of_entry,
	count(id) AS rows_of_category
FROM czechia_price cp
GROUP BY
	category_code,
	date_part('year', cp.date_from)
ORDER BY
	category_code,
	date_part('year', cp.date_from);


/*
Funkce SUM()
*/

-- Úkol 1: Sečtěte všechny průměrné počty zaměstnanců v datové sadě průměrných platů v České republice.
SELECT
	sum(value)
FROM czechia_payroll cp
WHERE cp.value_type_code = 316;

-- Úkol 2: Sečtěte průměrné ceny pro jednotlivé kategorie pouze v Jihomoravském kraji.
SELECT *
FROM czechia_region cr;

SELECT
	cp.category_code,
	sum(value) AS sum_of_avg_values
FROM czechia_price cp
WHERE
	cp.region_code = 'CZ064'
GROUP BY category_code;

-- Úkol 3: Sečtěte průměrné ceny potravin za všechny kategorie,
-- u kterých měření probíhalo od (date_from) 15. 1. 2018.
SELECT
	sum(cp.value)
FROM czechia_price cp
WHERE cp.date_from::date >= '2018-01-15'::date;

-- Úkol 4: Vypište tři sloupce z tabulky czechia_price: kód kategorie,
-- počet řádků pro ni a sumu hodnot průměrných cen. To vše pouze pro data v roce 2018.
SELECT
	cp.category_code,
	count(1),
	sum(value)
FROM czechia_price cp
WHERE date_part('year', cp.date_from) = 2018
GROUP BY category_code;

/*
Dalsi agregacni funkce
*/

-- Úkol 1: Vypište maximální hodnotu průměrné mzdy z tabulky czechia_payroll.
SELECT
	max(value) AS maximum
FROM czechia_payroll cp
WHERE cp.value_type_code = 5958;


-- Úkol 2: Na základě údajů v tabulce czechia_price vyberte pro každou
-- kategorii potravin její minimum v letech 2015 až 2017.
SELECT
	cp.category_code,
	min(value)
FROM czechia_price cp
WHERE
	date_part('year', cp.date_from) = 2015
	OR date_part('year', cp.date_from) = 2016
	OR date_part('year', cp.date_from) = 2017
GROUP BY category_code;

/*ekvivalentni*/
SELECT
	cp.category_code,
	min(value)
FROM czechia_price cp
WHERE
	date_part('year', cp.date_from) IN (2015, 2016, 2017)
GROUP BY category_code;

/*ekvivalentni*/
SELECT
	cp.category_code,
	min(value)
FROM czechia_price cp
WHERE
	date_part('year', cp.date_from) BETWEEN 2015 AND 2017
GROUP BY category_code;

-- Úkol 3: Vypište kód (případně i název) odvětví s historicky nejvyšší průměrnou mzdou.
SELECT *
FROM czechia_payroll_industry_branch cpib
WHERE code = (
	SELECT
		cp.industry_branch_code
	FROM czechia_payroll cp
	WHERE value = (
		SELECT max(value)
		FROM czechia_payroll cp
		WHERE cp.value_type_code = 5958
	)
);

-- Úkol 4: Pro každou kategorii potravin určete její minimum, maximum a vytvořte nový sloupec s názvem difference,
-- ve kterém budou hodnoty "rozdíl do 10 Kč", "rozdíl do 40 Kč" a "rozdíl nad 40 Kč" na základě rozdílu minima a maxima.
-- Podle tohoto rozdílu data seřaďte.

SELECT
	cp.category_code,
	round(min(cp.value)::numeric, 2),
	max(cp.value),
	max(cp.value) - min(cp.value) AS diff,
	CASE
		WHEN max(cp.value) - min(cp.value) < 10 THEN 'rozdíl do 10 Kč'
		WHEN max(cp.value) - min(cp.value) < 40 THEN 'rozdíl do 40 Kč'
		ELSE 'rozdíl nad 40 Kč'
	END AS difference
FROM czechia_price cp
GROUP BY category_code
ORDER BY diff;


-- Úkol 5: Vyberte pro každou kategorii potravin minimum, maximum a aritmetický průměr
-- (v našem případě průměr z průměrů) zaokrouhlený na dvě desetinná místa.
SELECT
	cp.category_code,
	min(value),
	max(value),
	avg(value),
	round(avg(value)::numeric, 2) AS rounded_average
FROM czechia_price cp
GROUP BY category_code;

-- Úkol 6: Rozšiřte předchozí dotaz tak, že data budou rozdělena i podle kódu kraje a seřazena sestupně podle aritmetického průměru.
SELECT
	cp.category_code,
	cp.region_code ,
	MIN(value),
	MAX(value),
	AVG(value),
	round(AVG(value)::NUMERIC, 2) AS roundedaverage
FROM czechia_price cp
GROUP BY cp.category_code, cp.region_code
ORDER BY roundedaverage DESC ;

/*
 Dalsi operace v SELECT
*/

-- Úkol 1: Vyzkoušejte si následující dotazy. Co vypisují a proč?

SELECT SQRT(-16);
SELECT 10/0;

SELECT FLOOR(1.56);
SELECT FLOOR(-1.56);

SELECT CEIL(1.56);
SELECT CEIL(-1.56);

SELECT ROUND(1.56);
SELECT ROUND(-1.56);

-- Úkol 2: Vypočítejte průměrné ceny kategorií potravin bez použití funkce AVG() s přesností na dvě desetinná místa.
SELECT
	category_code,
	round((sum(value) / count(value))::NUMERIC, 2)
FROM czechia_price
GROUP BY category_code;

-- Úkol 3: Jaké datové typy budou mít hodnoty v následujících dotazech?
SELECT 1;
SELECT 1.0;
SELECT 1 + 1;
SELECT 1 + 1.0;
SELECT 1 + '1';
SELECT 1 + 'a';
SELECT 1 + '12tatata';

-- Úkol 4: Vyzkoušejte si spustit dotazy, jež operují s textovými řetězci.
SELECT CONCAT('Hi, ', 'Engeto lektor here!');

SELECT CONCAT('We have ', COUNT(DISTINCT category_code), ' price categories.') AS info
FROM czechia_price;

SELECT name,
    substring(name FOR 2) AS prefix,
    substring(name FROM '...$') AS sufix,
    length(name)
FROM czechia_price_category;


-- Úkol 5: Vyzkoušejte si operátor modulo (zbytek po celočíselném dělení).
SELECT 5 % 2;
SELECT 14 % 5;
SELECT 15 % 5;

SELECT 123456789874 % 11;
SELECT 123456759874 % 11;