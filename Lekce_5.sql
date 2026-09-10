WITH roky AS (
SELECT count(*), cp.payroll_year FROM czechia_payroll cp
GROUP BY cp.payroll_year)
SELECT * FROM roky
ORDER BY payroll_year;


--------------------------

/*Zjistěte, ve kterých okresech mají všichni praktičtí lékaři vyplněný telefon, fax, nebo e-mail. 
Pro tyto účely si připravte dočasnou tabulku s výčtem okresů, ve kterých tato podmínka naopak splněna není, 
pod názvem not_completed_provider_info_district.*/

SELECT * FROM healthcare_provider hp;
SELECT * FROM czechia_district cd;


WITH not_completed_provider_info_district AS (
    SELECT DISTINCT district_code, name
    FROM healthcare_provider
    WHERE 
        phone IS NULL 
        AND email IS NULL 
        AND fax IS NULL 
        AND provider_type = 'Samost. ordinace všeob. prakt. lékaře'
)
SELECT *
FROM czechia_district
WHERE code NOT IN (
    SELECT district_code
    FROM not_completed_provider_info_district
);

SELECT name, hp.provider_type, hp.municipality, hp.residence_municipality FROM healthcare_provider hp
WHERE hp.residence_municipality = 'Rakovník';

--Vypište z tabulky economies průměr světových daní, při HDP vyšším než 70 miliard.

WITH large_gdp_area AS (
    SELECT *
    FROM economies
    WHERE GDP > 70000000000
)
SELECT
    round(avg(taxes)::numeric, 2) AS taxes_average
FROM large_gdp_area;



--Klauzule HAVING

/*Vypište z tabulky covid19_basic_differences země s více než 5 000 000 potvrzenými případy COVID-19 (data jsou za rok 2020 a část roku 2021).*/


SELECT * FROM covid19_basic_differences
WHERE confirmed IS NOT NULL AND confirmed <> 0
ORDER BY confirmed DESC;

SELECT
	country, 
	sum(confirmed) AS total_confirmed
FROM covid19_basic_differences
GROUP BY country
ORDER BY country;


SELECT
	country, 
	sum(confirmed) AS total_confirmed
FROM covid19_basic_differences
WHERE sum(confirmed) > 5000000
GROUP BY country; --Tento dotaz NEFUNGUJE - je nutna klauzule HAVING

SELECT
	country, 
	sum(confirmed) AS total_confirmed
FROM covid19_basic_differences
GROUP BY country
HAVING sum(confirmed) > 1000000
ORDER BY country;

--Vyberte z tabulky economies roky a oblasti s populací nad 4 miliardy.

SELECT * FROM economies e;

SELECT
	country, 
	year, 
	sum(population) AS overall_population
FROM economies e
GROUP BY 
	country, 
	year
ORDER BY country;


SELECT
	country, 
	year, 
	sum(population) AS overall_population
FROM economies e
GROUP BY 
	country, 
	year
HAVING sum(population) > 4_000_000_000
ORDER BY overall_population DESC;

SELECT
	country,
	sum(population) AS overall_population
FROM economies e
GROUP BY 
	country
HAVING sum(population) > 4_000_000_000
ORDER BY overall_population DESC;


--Využití umělé inteligence v DBeaveru

/*Tipy k napsání dobrého promptu
Kvalitní prompt je základním nástrojem pro to, aby výsledek odpovídal tvým očekáváním a byl skutečně užitečný. Správně sestavený prompt pomáhá nasměrovat odpověď, zajišťuje její relevanci a přizpůsobení konkrétnímu účelu. Proto je důležité nejen jasně definovat cíl, ale také poskytnout kontext, určit roli a tón, doplnit detailní instrukce a případná omezení. Čím přesněji tyto prvky vymezíš, tím lépe se výstup přiblíží tomu, co potřebuješ.

﻿
🧭 1. Cíl / účel
Co přesně chceš získat – zda jde o vysvětlení, seznam, analýzu, kreativní text, obrázek nebo kód.
Proč to potřebuješ – účel pomáhá nasměrovat odpověď (např. vzdělávání, inspirace, pracovní použití).
Čím jasněji definuješ výsledek, tím méně prostoru zůstává pro nejednoznačnost.
﻿
📚 2. Kontext
Pozadí nebo situace, ve které se výstup použije (např. školní projekt, firemní prezentace, osobní poznámky).
Kontext pomáhá přizpůsobit hloubku detailu, jazyk i formát.
Pokud chybí, odpověď může být příliš obecná nebo nepřesná.
﻿
🎭 3. Role
Určení role, kterou má AI zaujmout – např. učitel, expert, poradce, kreativní spisovatel.
Role nastavuje perspektivu a způsob, jakým se informace podávají.
Díky tomu se odpověď přizpůsobí očekávání (jinak vysvětluje profesor než copywriter).
﻿
🎙️ 4. Tón
Styl komunikace – formální, neformální, přátelský, odborný, motivační.
Tón ovlivňuje, jak se text čte a působí na cílové publikum.
Pokud není uveden, AI zvolí neutrální tón, který nemusí být ideální.
﻿
📝 5. Detailní instrukce
Formát – zda má být výstup v bodech, odstavcích, tabulce, kódu.
Rozsah – délka textu, počet bodů, úroveň detailu.
Specifické požadavky – např. „stručně“, „max. 200 slov“, „použij jednoduchý jazyk“.
﻿
📌 6. Omezení
Co se má vynechat – odborný žargon, přílišná složitost, cizí jazyk, nevhodné příklady.
Omezení pomáhají udržet výstup relevantní a použitelný.
﻿
🔍 7. Příklady nebo vzory
Pokud máš jasnou představu, můžeš přidat ukázku struktury nebo stylu.
Není nutné, ale výrazně to zvyšuje přesnost výsledku.*/


-------------------------------

--Dočasné tabulky - TEMP TABLES

/*Vytvořte dočasnou tabulku temp_{jmeno}_{prijemni}_orders. V tabulce budou sloupce order_id (s primárním klíčem), customer_id (int), amount (numeric) a order_date (date).*/

CREATE TEMP TABLE temp_engeto_lektor_orders_Jan_S (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    amount NUMERIC(10, 2),
    order_date DATE
);

SELECT * FROM temp_engeto_lektor_orders_Jan_S;


INSERT INTO temp_engeto_lektor_orders_Jan_S (customer_id, amount, order_date) 
VALUES (1, 250.00, '2024-01-01'),
    (5, 300.50, '2024-01-02');


UPDATE temp_engeto_lektor_orders_Jan_S
SET amount = amount * 1.1
WHERE order_date = '2024-01-01';

/*Jsou dva způsoby jak tabulku smazat. Stačí se odpojit od databáze (protože takhle temp tabulky fungují) a nebo pomocí dotazu DROP:*/


DROP TABLE IF EXISTS temp_engeto_lektor_orders_Jan_S;

/*Vytvořte materializovaný pohled s názvem mv_healthcare_provider_subset pro tabulku healthcare_provider. 
 Do pohledu zahrňte sloupce provider_id, name, region_code, district_code. U sloupce name použijte funkci pro odstranění prázdných znaků.*/

CREATE MATERIALIZED VIEW mv_healthcare_provider_subset AS 
    SELECT
	    hp.provider_id,
	    trim(hp.name) AS name,
        hp.region_code,
	    hp.district_code
	FROM healthcare_provider hp 
	
	
SELECT * FROM mv_healthcare_provider_subset;

REFRESH MATERIALIZED VIEW mv_healthcare_provider_subset

DROP MATERIALIZED VIEW IF EXISTS mv_healthcare_provider_subset;


--WINDOW FUNCTIONS

/*Někdy potřebujeme zodpovědět otázky jako: „Kdo jsou dva nejlépe placení zaměstnanci v každém oddělení?" nebo „Jaké je pořadí produktu v rámci kategorie?"
Tyto otázky mají jedno společné – potřebujeme porovnávat řádky navzájem, ale zároveň každý řádek zachovat ve výsledku.
Proč je to důležité? Window functions a CTE se vyskytují ve velké většině pohovorových SQL úloh. Pokud se budete ucházet o jakoukoli pozici analytika, datového inženýra nebo junior vývojáře, 
window functions budete pravděpodobně potřebovat.*/

SELECT
    sloupec1,
    sloupec2,
    ROW_NUMBER() OVER (PARTITION BY skupina ORDER BY serazeni DESC) AS poradi
FROM nazev_tabulky;

ROW_NUMBER() – očíslují řádky v okně podle pořadí
SUM() – agregace přímo v rámci okna, bez slučování řádků
LAG() – podívají se na hodnotu z předchozího nebo následujícího řádku

---

ROW_NUMBER() – přiřadí každému řádku číslo (pořadí)
OVER (...) – říká, že pracujeme s oknem (skupinou řádků)
PARTITION BY – definuje, podle čeho okno vytvoříme (naše skupiny)
ORDER BY uvnitř OVER – určuje, jak se řádky v okně seřadí před číslováním



WITH sales_data AS (
    SELECT '2023-03-01' AS date, 'product 1' AS product, 40 AS sales
    UNION ALL
    SELECT '2023-03-02', 'product 1', 66
    UNION ALL
    SELECT '2023-03-03', 'product 1', 50
    UNION ALL
    SELECT '2023-03-03', 'product 1', 50
    UNION ALL
    SELECT '2023-03-05', 'product 1', 9
    UNION ALL
    SELECT '2023-03-05', 'product 2', 15
)
SELECT 
    *,  
    SUM(sales) OVER (PARTITION BY product ORDER BY date) AS value_cumulative_sum_default,  
    SUM(sales) OVER (PARTITION BY product ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS value_cumulative_sum,  
    SUM(sales) OVER (PARTITION BY product ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS value_cumulative_sum_last_2,  
    SUM(sales) OVER (PARTITION BY product ORDER BY date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS value_cumulative_sum_last_1_next_1
FROM sales_data;


WITH sales_data AS (
    SELECT '2023-03-01' AS date, 'product 1' AS product, 40 AS sales
    UNION ALL
    SELECT '2023-03-02', 'product 1', 66
    UNION ALL
    SELECT '2023-03-03', 'product 1', 50
    UNION ALL
    SELECT '2023-03-03', 'product 1', 50
    UNION ALL
    SELECT '2023-03-05', 'product 1', 9
    UNION ALL
    SELECT '2023-03-05', 'product 2', 15
)
SELECT 
    *,
    RANK() OVER (PARTITION BY product ORDER BY date) AS value_rank,
    DENSE_RANK() OVER (PARTITION BY product ORDER BY date) AS value_dense_rank,
    ROW_NUMBER() OVER (PARTITION BY product ORDER BY date) AS value_row_number,
    LAG(sales) OVER (PARTITION BY product ORDER BY date) AS value_lag,
    LEAD(sales) OVER (PARTITION BY product ORDER BY date) AS value_lead,	
    LAST_VALUE(sales) OVER (PARTITION BY product ORDER BY product) AS value_last,
    FIRST_VALUE(sales) OVER (PARTITION BY product ORDER BY product) AS value_first
FROM sales_data;


SELECT
	e.country,
	e."year",
	e2."year",
	e2.population - e.population AS rozdíl
FROM economies e
JOIN economies e2
	ON e.country = e2.country 
		AND e.YEAR = e2.year - 1;

--Jiný zápis pomocí LAG() a PARTITION BY()

SELECT
	e.country,
	e.year,
	LAG(e.year) OVER (PARTITION BY country ORDER BY year) previous_year,
	e.population - LAG(e.population) OVER (PARTITION BY country ORDER BY year) population_change
FROM economies e; 





