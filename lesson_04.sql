/*
 * JOIN
 */

-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category. Vypište všechny dostupné sloupce.
SELECT *
FROM czechia_price
JOIN czechia_price_category
	ON czechia_price.category_code = czechia_price_category.code;

-- Úkol 2: Předchozí příklad upravte tak, že vhodně přejmenujete tabulky a vypíšete ID a jméno kategorie potravin a cenu.
SELECT
	cp.id,
	cpc.name
FROM czechia_price cp
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code;

-- Úkol 3: Přidejte k tabulce cen potravin i informaci o krajích ČR a vypište informace o cenách společně s názvem kraje.
SELECT
	cp.*,
	cr.name
FROM czechia_price cp
LEFT JOIN czechia_region cr
	ON cp.region_code = cr.code;


SELECT count(1)
FROM czechia_price cp
JOIN czechia_region cr
	ON cp.region_code = cr.code;
SELECT count(1) FROM czechia_price cp;
SELECT * FROM czechia_price cp;

-- Úkol 4: Využijte v příkladě z předchozího úkolu RIGHT JOIN s výměnou pořadí tabulek. Jak se změní výsledky?
SELECT
	cp.*,
	cr.name
FROM czechia_region cr
RIGHT JOIN czechia_price cp
	ON cp.region_code = cr.code;

-- Úkol 5: K tabulce czechia_payroll připojte všechny okolní tabulky. Využijte ERD model ke zjištění, které to jsou.
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

-- Úkol 6: Přepište dotaz z předchozí lekce do varianty, ve které použijete JOIN
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
/*ekvivalentni*/
SELECT cpib.*
FROM czechia_payroll_industry_branch cpib
JOIN czechia_payroll cp
	ON cp.industry_branch_code = cpib.code
WHERE value_type_code = 5958
ORDER BY cp.value DESC
LIMIT 1;


-- Úkol 7: Spojte informace z tabulek cen a mezd (pouze informace o průměrných mzdách). Vypište z každé z nich základní informace,
-- celé názvy odvětví a kategorií potravin a datumy měření, které vhodně naformátujete.
SELECT *
FROM czechia_price cp
WHERE date_part('year', cp.date_from) != date_part('year', cp.date_to);


SELECT
	cpc.name food_category,
	cp.value food_price,
	cpib.name industry_branch,
	cpay.value avg_wage,
	cp.region_code,
	cpay.value / cp.value items_afordable,
	to_char(cp.date_from, 'DD. Month YYYY') date_from,
	to_char(cp.date_to, 'DD.MM.YY') date_to
FROM czechia_price cp
JOIN czechia_payroll cpay
	ON date_part('year', cp.date_from) = cpay.payroll_year
JOIN czechia_payroll_industry_branch cpib
	ON cpay.industry_branch_code = cpib.code
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code
WHERE cpay.value_type_code = 5958;

/*
 * Kartezsky soucin
 */
-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category pomocí kartézského součinu.
SELECT *
FROM czechia_price cp, czechia_price_category cpc;

SELECT *
FROM czechia_price cp, czechia_price_category cpc
WHERE cp.category_code = cpc.code;


-- Úkol 2: Převeďte předchozí příklad do syntaxe s CROSS JOIN.
SELECT *
FROM czechia_price cp
CROSS JOIN czechia_price_category cpc
WHERE cp.category_code = cpc.code;

-- Úkol 3: Vytvořte všechny kombinace krajů kromě těch případů, kdy by se v obou sloupcích kraje shodovaly.
SELECT *
FROM czechia_region cr, czechia_region cr2
WHERE cr.code < cr2.code;

/*vsuvka - self-join*/
SELECT
	e.country,
	e."year",
	e2."year",
	e2.gdp - e.gdp
FROM economies e
JOIN economies e2
	ON e."year" = e2."year" - 1
	AND e.country = e2.country;

/*
 * Mnozinove operace 
 */
-- Úkol 1: Přepište následující dotaz na variantu spojení dvou separátních dotazů se selekcí pro každý kraj zvlášť.
SELECT category_code, value
FROM czechia_price
WHERE region_code IN ('CZ064', 'CZ010');
/*ekvivalentni*/
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION ALL
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';

-- Úkol 2: Upravte předchozí dotaz tak, aby byly odstraněny duplicitní záznamy.
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';


-- vsuvka
CREATE TABLE doctor (
	name varchar(255),
	surname varchar(255),
	salary float
);

INSERT INTO doctor VALUES ('Petr', 'Dvorak', 70000);

CREATE TABLE patient (
	name varchar(255),
	surname varchar(255),
	age int
);

INSERT INTO patient VALUES ('Matej', 'Karolyi', 33);


SELECT
	name,
	surname
FROM doctor
UNION
SELECT
	name,
	surname
FROM patient
-- konec vsuvky

-- nevalidni dotaz
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
UNION
SELECT value, category_code
FROM czechia_price
WHERE region_code = 'CZ010';

-- Úkol 3: Sjednoťe kraje a okresy do jedné množiny. Tu následně seřaďte dle kódu vzestupně. UNION
SELECT *
FROM czechia_region cr
UNION ALL
SELECT *
FROM czechia_district cd
ORDER BY code ASC;

SELECT code, name, 'region' AS geo_type
FROM czechia_region
UNION
SELECT code, name, 'district' AS geo_type
FROM czechia_district
ORDER BY code;


-- Úkol 4: Vytvořte průnik cen z krajů Hl. město Praha a Jihomoravský kraj.
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
INTERSECT
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';

-- Úkol 5: Vypište kód a název odvětví, ID záznamu a hodnotu záznamu průměrných mezd a počtu zaměstnanců.
-- Vyberte pouze takové záznamy, které se shodují v uvedené hodnotě a spadají do odvětví s označením A nebo B.
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

-- Úkol 6: Vyberte z tabulky czechia_price takové záznamy, které jsou v Jihomoravském kraji jiné na sloupcích category_code a value než v Praze.
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
EXCEPT
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010';

-- Úkol 7: Upravte předchozí dotaz tak, abychom získali záznamy, které jsou v Praze a ne v Jihomoravském kraji.
-- Dále udělejte průnik těchto dvou disjunktních podmnožin.
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010'
EXCEPT
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064';



(SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064'
EXCEPT
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010')
INTERSECT
(SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ010'
EXCEPT
SELECT category_code, value
FROM czechia_price
WHERE region_code = 'CZ064')

/*
 * Common Table Expressions
 */
-- Úkol 1: Pomocí operátoru WITH připravte tabulku s cenami nad 150 Kč.
-- S její pomocí následně vypište jména takových kategorií potravin, které do této cenové hladiny spadají.

WITH high_value_food AS (
	SELECT DISTINCT cp.category_code
	FROM czechia_price cp
	WHERE value > 150
)
SELECT cpc."name"
FROM czechia_price_category cpc
JOIN high_value_food hvf
	ON hvf.category_code = cpc.code;



