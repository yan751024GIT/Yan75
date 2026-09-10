/*
 * CTE
 */

-- Úkol 2: Zjistěte, ve kterých okresech mají všichni praktičtí lékaři vyplněný telefon, fax, nebo e-mail.
-- Pro tyto účely si připravte dočasnou tabulku
--s výčtem okresů, ve kterých tato podmínka naopak splněna není, pod názvem not_completed_provider_info_district.

SELECT * FROM healthcare_provider hp;


WITH not_completed_provider_info_district AS (
	SELECT hp.district_code
	FROM healthcare_provider hp
	WHERE
		hp.phone IS NULL
		AND hp.email IS NULL
		AND hp.fax IS NULL
		AND hp.provider_type LIKE '%Samost. ordinace všeob. prakt. lékaře%'
)
SELECT *
FROM czechia_district cd
WHERE cd.code NOT IN (
	SELECT district_code
	FROM not_completed_provider_info_district
);

-- Úkol 3: Vypište z tabulky economies průměr světových daní, při HDP vyšším než 70 miliard.
WITH large_gdp_area AS (
	SELECT *
	FROM economies e
	WHERE gdp > 70_000_000_000
), even_larger_gdp_area AS (
	SELECT *
	FROM economies e
	WHERE gdp > 700_000_000_000
)
SELECT
	'large area' ,round(avg(taxes)::numeric, 2) AS taxes_average
FROM large_gdp_area
UNION
SELECT
	'larger area', round(avg(taxes)::numeric, 2) AS taxes_average
FROM even_larger_gdp_area


/*
 * HAVING
 */

-- Úkol 1: Vypište z tabulky covid19_basic_differences země s více než 5 000 000 potvrzenými
-- případy COVID-19 (data jsou za rok 2020 a část roku 2021).

-- nevalidni dotaz
SELECT
	country,
	sum(confirmed) AS total_confirmed
FROM covid19_basic_differences cb
WHERE sum(confirmed) > 5_000_000
GROUP BY country
ORDER BY total_confirmed DESC;

SELECT
	country,
	sum(confirmed) AS total_confirmed
FROM covid19_basic_differences cb
GROUP BY country
HAVING sum(confirmed) > 5_000_000
ORDER BY total_confirmed DESC;


-- Úkol 2: Vyberte z tabulky economies roky a oblasti s populací nad 4 miliardy.
SELECT
    year,
    country,
    SUM(population) AS total_population
FROM economies
GROUP BY year, country
HAVING SUM(population) > 4_000_000_000
ORDER BY year;


-- Vypište 20 nejbližších poskytovatelů zdravotních služeb
-- v okruhu 10 km od místa na souřadnicích 49°0'0"N 15°0'0"E.
-- https://en.wikipedia.org/wiki/Haversine_formula
/*
 * 6371 = km, 3959 = miles
 */
SELECT 
    name,
    (6371 * ACOS( COS( RADIANS(49)) * COS( RADIANS( latitude )) 
    * COS( RADIANS( longitude ) - RADIANS(15)) 
    + SIN( RADIANS(49)) * SIN( RADIANS(latitude)))) AS distance 
FROM healthcare_provider
GROUP BY name, latitude, longitude
HAVING (6371 * ACOS( COS( RADIANS(49)) * COS( RADIANS( latitude )) 
    * COS( RADIANS( longitude ) - RADIANS(15)) 
    + SIN( RADIANS(49)) * SIN( RADIANS(latitude)))) < 10
ORDER BY distance 
LIMIT 20;


/*
 * AI Smart Completion
 */

-- Vrať mi všechny kategorie potravin seřazené podle názvu alfabeticky
SELECT name
FROM czechia_price_category
ORDER BY name;

-- Vrať mi všechny kategorie potravin seřazené podle názvu alfabeticky. Vrať mi sloupce s názvem a kódem.
SELECT name, code
FROM czechia_price_category
ORDER BY name;

-- Najdi země, ve kterých se platí dolarem a seřaď je podle naděje na dožití.
SELECT country
FROM countries
WHERE currency_code = 'USD'
ORDER BY life_expectancy DESC;

-- Vyber pocitovou teplotu a vlhkost za dostupné období pro každou zemi na základě údajů o počasí.
-- Použij join na země, kde najdeš hlavní města zemí. přidej ještě join s délkou dožití a join na náboženství.
-- Potřebuju skupiny podle náboženství, u každé uveď průměrnou pocitovou teplotu a vlhkost pro každou skupinu.
-- Výsledek seřadˇ sestupně podle délky dožití.

-- vygeneroval nevalidni vysledky
SELECT r.religion,
       AVG(w.feels) AS avg_feels_temperature,
       AVG(w.humidity) AS avg_humidity,
       AVG(d.life_expectancy) AS avg_life_expectancy
FROM weather w
JOIN countries c ON w.city = c.capital_city
JOIN life_expectancy d ON c.country = d.country
JOIN religions r ON c.country = r.country
GROUP BY r.religion
ORDER BY avg_life_expectancy DESC;

SELECT *
FROM weather w;

/*
 * Temp Tables
 */

-- Úkol 1: Vytvořte dočasnou tabulku temp_{jmeno}_{prijemni}_orders. V tabulce budou sloupce order_id (s primárním klíčem),
-- customer_id (int), amount (numeric) a order_date (date).

CREATE TEMP TABLE temp_engeto_lektor_orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INT,
	amount NUMERIC(10, 2),
	order_date DATE
);

SELECT *
FROM temp_engeto_lektor_orders;

-- Úkol 2: Přidejte do tabulky temp_{jmeno}_{prijemni}_orders dva řádky s hodnotami.
-- Zákazník č. 1 utratil 250 Kč dne 1.1.2024 a zákazník č. 5 utratil 300,50 Kč dne 2.1.2024.
INSERT INTO temp_engeto_lektor_orders(customer_id, amount, order_date) VALUES (1, 250, '2024-01-01');
INSERT INTO temp_engeto_lektor_orders(customer_id, amount, order_date) VALUES (5, 300.50, '2024-01-02');

-- Úkol 3: Hodnoty ve sloupci amount v tabulce temp_{jmeno}_{prijemni}_orders nyní přenásobte koeficientem 1.1 = hodnoty zvýšíme o 10%.
UPDATE temp_engeto_lektor_orders
SET amount = amount * 1.1;

-- Úkol 4: Smažte tabulku temp_engeto_lektor_orders.
DROP TABLE temp_engeto_lektor_orders;
-- nebo se odhlasit z DB



/*
 * Materialized VIEWs
 */

-- Úkol 1: Vytvořte materializovaný pohled s názvem mv_healthcare_provider_subset pro tabulku healthcare_provider.
-- Do pohledu zahrňte sloupce provider_id, name, region_code, district_code.
-- U sloupce name použijte funkci pro odstranění prázdných znaků.

CREATE MATERIALIZED VIEW mv_healthcare_provider_subset AS
	SELECT provider_id, trim(name), region_code, district_code
	FROM healthcare_provider;
	
-- Úkol 2: Vytvořte SELECT se zobrazením materializovaného pohledu.
SELECT * FROM mv_healthcare_provider_subset;

CREATE VIEW v_healthcare_provider_subset AS
	SELECT provider_id, trim(name), region_code, district_code
	FROM healthcare_provider;
	
SELECT * FROM v_healthcare_provider_subset;

-- Úkol 3: Aktualizujte data v pohledu.
REFRESH MATERIALIZED VIEW mv_healthcare_provider_subset;

-- Úkol 4: Smažte pohled z databáze.
DROP MATERIALIZED VIEW mv_healthcare_provider_subset;


/* 
 * Self JOIN
 */

SELECT
	e.country,
	e."year",
	e2."year",
	e2.population - e.population 
FROM economies e
JOIN economies e2
	ON e.country = e2.country 
		AND e.YEAR = e2.year - 1; 

/*
 * LAG
 */

SELECT
	e.country,
	e.year,
	LAG(e.year) OVER (PARTITION BY country ORDER BY year) previous_year,
	e.population - LAG(e.population) OVER (PARTITION BY country ORDER BY year) population_change
FROM economies e; 

