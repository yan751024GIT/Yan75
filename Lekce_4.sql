--Spojovaní tabulek a množinové operace

/*Spojte tabulky czechia_price a czechia_price_category. Vypište všechny dostupné sloupce.*/

SELECT *
FROM czechia_price;

SELECT *
FROM czechia_price_category; 

SELECT *
FROM czechia_price
INNER JOIN czechia_price_category
    ON czechia_price.category_code = czechia_price_category.code;

/*Předchozí příklad upravte tak, že vhodně přejmenujete tabulky a vypíšete ID a jméno kategorie potravin a cenu.*/

SELECT
    cp.id, 
    cpc.name, 
    cp.value
FROM czechia_price AS cp
JOIN czechia_price_category AS cpc
    ON cp.category_code = cpc.code;

/*Přidejte k tabulce cen potravin i informaci o krajích ČR a vypište informace o cenách společně s názvem kraje.*/

SELECT * FROM czechia_region cr;

SELECT
    cp.*, cr.name
FROM czechia_price AS cp
LEFT JOIN czechia_region AS cr
    ON cp.region_code = cr.code;

SELECT
    count(*)
FROM czechia_price AS cp
LEFT JOIN czechia_region AS cr
    ON cp.region_code = cr.code;

/*Rozdíl v počtech řádků levého a vnitřního spojení:*/

SELECT 
    count(1) total_number_of_rows
FROM czechia_price cp
LEFT JOIN czechia_region cr ON cp.region_code = cr.code;

SELECT 
    count(1) total_number_of_rows
FROM czechia_price cp
INNER JOIN czechia_region cr ON cp.region_code = cr.code;

/*Využijte v příkladě z předchozího úkolu RIGHT JOIN s výměnou pořadí tabulek. Jak se změní výsledky?*/

SELECT
    cp.*, 
    cr.name
FROM czechia_region AS cr
RIGHT JOIN czechia_price AS cp
    ON cp.region_code = cr.code;

/*K tabulce czechia_payroll připojte všechny okolní tabulky. Využijte ERD model ke zjištění, které to jsou.*/

SELECT *
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_calculation cpc
    ON cp.calculation_code = cpc.code
LEFT JOIN czechia_payroll_industry_branch cpib
    ON cp.industry_branch_code = cpib.code
LEFT JOIN czechia_payroll_unit cpu
    ON cp.unit_code = cpu.code
LEFT JOIN czechia_payroll_value_type cpvt
    ON cp.value_type_code = cpvt.code;

/*Přepište dotaz z předchozí lekce do varianty, ve které použijete JOIN*/

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

SELECT cpib.* 
FROM czechia_payroll_industry_branch cpib 
JOIN czechia_payroll cp
	ON cpib.code = cp.industry_branch_code
WHERE cp.value_type_code = 5958
ORDER BY cp.value DESC
LIMIT 1;

/*Spojte informace z tabulek cen a mezd (pouze informace o průměrných mzdách). 
 Vypište z každé z nich základní informace, celé názvy odvětví a kategorií potravin a datumy měření, které vhodně naformátujete.*/

SELECT cp.value, cpay.value, cp.date_from s
FROM 
czechia_payroll cpay
JOIN czechia_price cp 
ON date_part('year', cp.date_from) = cpay.payroll_year;

SELECT * 
FROM 
czechia_price cp;

SELECT
    cpc.name AS food_category,
    cp.value AS price,
    cpib.name AS industry,
    cpay.value AS average_wages,
    TO_CHAR(cp.date_from, 'DD. Month YYYY') AS price_measured_from,
    TO_CHAR(cp.date_to, 'DD.MM.YYYY') AS price_measured_to,
    cpay.payroll_year
FROM
    czechia_price AS cp
JOIN czechia_payroll AS cpay
    ON date_part('year', cp.date_from) = cpay.payroll_year
    AND cpay.value_type_code = 5958    
    AND cp.region_code IS NULL
JOIN czechia_price_category AS cpc
    ON cp.category_code = cpc.code
JOIN czechia_payroll_industry_branch AS cpib    
    ON cpay.industry_branch_code = cpib.code;

--Kartézský součin a CROSS JOIN

/*Spojte tabulky czechia_price a czechia_price_category pomocí kartézského součinu.*/

SELECT *
FROM czechia_price, czechia_price_category; --dvě tabulky oddělené čárkou - výsledek je kartézký součin


SELECT *
FROM czechia_price cp, czechia_price_category cpc 
WHERE cp.category_code = cpc.code;

--Převeďte předchozí příklad do syntaxe s CROSS JOIN.

SELECT *
FROM czechia_price cp
CROSS JOIN czechia_price_category cpc --to samé jako předchozí příklad
WHERE cp.category_code = cpc.code;


/*Vytvořte všechny kombinace krajů kromě těch případů, kdy by se v obou sloupcích kraje shodovaly.*/

SELECT * FROM czechia_region cr;

SELECT
    cr.name AS první_region, cr2.name AS druhý_region
FROM czechia_region cr
CROSS JOIN czechia_region cr2
WHERE cr.code != cr2.code;

SELECT
    *
FROM czechia_region cr
CROSS JOIN czechia_region cr2
WHERE cr.code < cr2.code;

SELECT * FROM (
SELECT e.gdp, e2.gdp, e.country AS Zeme, e."year", e2."year", e2.gdp - e.gdp AS rozdíl
FROM economies e 
JOIN economies e2
	ON e."year" = e2."year"-1
    AND e.country = e2.country) AS eco
WHERE rozdíl IS NOT NULL 
ORDER BY eco.zeme;

SELECT
	e.country,
	e."year",
	e2."year",
	e2.gdp - e.gdp AS rozdíl
FROM economies e
JOIN economies e2
	ON e."year" = e2."year" - 1
	AND e.country = e2.country;

--Množinové operace

/*Přepište následující dotaz na variantu spojení dvou separátních dotazů se selekcí pro každý kraj zvlášť.*/

SELECT category_code, value
FROM czechia_price
WHERE region_code IN ('CZ064', 'CZ010');

SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION ALL
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';

--Upravte předchozí dotaz tak, aby byly odstraněny duplicitní záznamy.

SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';

/*vsuvka

CREATE TABLE doctor_jan_s (
	name varchar(255),
	surname varchar(255),
	salary float
);

CREATE TABLE patient_jan_s (
	name varchar(255),
	surname varchar(255),
	age int
);

INSERT INTO patient_jan_s VALUES ('Jan', 'Honda', 33);

INSERT INTO doctor_jan_s VALUES ('James', 'Bond', 50);

SELECT *
FROM doctor_jan_s djs
UNION
SELECT *
FROM patient_jan_s pjs;

SELECT * FROM (
SELECT *
FROM doctor_jan_s djs
UNION 
SELECT *
FROM patient_jan_s pjs) AS Health
ORDER BY name; */

/*Sjednoťe kraje a okresy do jedné množiny. Tu následně seřaďte dle kódu vzestupně.*/

SELECT *
FROM (
    SELECT code, name, 'region' AS country_part
    FROM czechia_region
    UNION
    SELECT code, name, 'district' AS country_part
    FROM czechia_district
) AS country_parts
ORDER BY code;

/*Vytvořte průnik cen z krajů Hl. město Praha a Jihomoravský kraj.*/

SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
INTERSECT
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';

/*Vypište kód a název odvětví, ID záznamu a hodnotu záznamu průměrných mezd a počtu zaměstnanců. 
 Vyberte pouze takové záznamy, které se shodují v uvedené hodnotě a spadají do odvětví s označením A nebo B.*/

SELECT * FROM czechia_payroll cp;


SELECT 
    cpib.*, 
    cp.id, 
    cp.value
FROM czechia_payroll cp
JOIN czechia_payroll_industry_branch cpib
    ON cp.industry_branch_code = cpib.code
WHERE value IN (
    SELECT value
    FROM czechia_payroll
    WHERE industry_branch_code = 'A'
    INTERSECT
    SELECT value
    FROM czechia_payroll
    WHERE industry_branch_code = 'B'
);

/*Vyberte z tabulky czechia_price takové záznamy, které jsou v Jihomoravském kraji jiné na sloupcích category_code a value než v Praze.*/

SELECT * FROM czechia_price cp;

SELECT category_code, value, region_code 
FROM czechia_price
WHERE region_code = 'CZ064'
EXCEPT
SELECT category_code, value, region_code
FROM czechia_price
WHERE region_code = 'CZ010';

/*Upravte předchozí dotaz tak, abychom získali záznamy, které jsou v Praze a ne v Jihomoravském kraji. 
Dále udělejte průnik těchto dvou disjunktních podmnožin.*/

--Výsledek bude prázdný

(
    SELECT category_code, value
    FROM czechia_price 
    WHERE region_code = 'CZ064' 
    EXCEPT 
    SELECT category_code, value 
    FROM czechia_price 
    WHERE region_code = 'CZ010'
) 
INTERSECT
(
    SELECT category_code, value 
    FROM czechia_price 
    WHERE region_code = 'CZ010' 
    EXCEPT 
    SELECT category_code, value 
    FROM czechia_price 
    WHERE region_code = 'CZ064'
);

--COMMON TABLE EXPRESION

/*Pomocí operátoru WITH připravte tabulku s cenami nad 150 Kč. 
S její pomocí následně vypište jména takových kategorií potravin, které do této cenové hladiny spadají.*/

SELECT * FROM czechia_price_category cpc;

WITH high_price AS (
    SELECT category_code AS code
    FROM czechia_price
    WHERE value > 150
)
SELECT DISTINCT cpc.name
FROM high_price hp
JOIN czechia_price_category cpc
    ON hp.code = cpc.code;