/*
ORDER BY
*/


/*

Úkol 1: Vypište od všech poskytovatelů zdravotních služeb jméno a typ. 
Záznamy seřaďte podle jména vzestupně.

*/

SELECT 
	name,
	trim(name),
	provider_type
FROM healthcare_provider hp 
ORDER BY trim(name) ASC;

/*
Úkol 2: Vypište od všech poskytovatelů zdravotních služeb ID, jméno a typ. 
Záznamy seřaďte primárně podle kódu kraje a sekundárně podle kódu okresu.
*/


SELECT 
	provider_id,
	name,
	provider_type,
	region_code,
	district_code 
FROM healthcare_provider hp
ORDER BY region_code ASC, district_code ASC;

-- je ekvivaletni
SELECT 
	provider_id,
	name,
	provider_type,
	region_code,
	district_code 
FROM healthcare_provider hp
ORDER BY region_code, district_code;

/*
 * Úkol 3: Seřaďte na výpisu data z tabulky czechia_district sestupně podle kódu okresu.
 */

SELECT *
FROM czechia_district cd 
ORDER BY code DESC;

/*
 * Úkol 4: Vypište abecedně pět posledních krajů v ČR.
 */

SELECT *
FROM czechia_region cr 
ORDER BY name DESC 
LIMIT 5;

/*
 * Úkol 5: Data z tabulky healthcare_provider vypište seřazena vzestupně 
 * dle typu poskytovatele a sestupně dle jména.
 */

SELECT 
	name,
	provider_type 
FROM healthcare_provider hp
ORDER BY 
	provider_type ASC,
	name DESC;



/*
 * CASE 
 */

/*
CASE
	WHEN podminka_1 THEN vysledek_1
	WHEN podminka_2 THEN vysledek_2
	...
	[ELSE vychozi_podminka]
END
*/

/*
 * 
 * Úkol 1: Přidejte na výpisu k tabulce healthcare_provider nový sloupec is_from_prague, 
 * který bude obsahovat 1 pro poskytovate z Prahy a 0 pro ty mimo pražské.
 */

SELECT 
	name,
	region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END	AS is_from_prague
FROM healthcare_provider hp;

/*
Úkol 2: Upravte dotaz z předchozího příkladu tak, aby obsahoval záznamy, 
které spadají jenom do Prahy.
 */

SELECT 
	name,
	region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END	AS is_from_prague
FROM healthcare_provider hp
WHERE region_code = 'CZ010';



SELECT 
	name,
	region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END	AS is_from_prague
FROM healthcare_provider hp
WHERE is_from_prague = 1;			-- tohle nefunguje


-- tohle je verze se subselectem, tady to funguje
SELECT *
FROM (
	SELECT 
		name,
		region_code,
		CASE
			WHEN region_code = 'CZ010' THEN 1
			ELSE 0
		END	AS is_from_prague
	FROM healthcare_provider hp
)
WHERE is_from_prague = 1;


-- pokracovani 19:07


-- https://www.postgresql.org/docs/current/datatype.html


/*
Úkol 3: Sestavte dotaz, který na výstupu ukáže název poskytovatele, 
město poskytování služeb, zeměpisnou délku a v dynamicky vypočítaném 
sloupci slovní informaci, jak moc na západě se poskytovatel nachází – 
určete takto čtyři kategorie rozdělení.
 */


SELECT 
	longitude 
FROM healthcare_provider hp
WHERE longitude IS NOT NULL
ORDER BY longitude DESC;


/*
 * longitude
 * 12.16672350342
 * obsahuj i NULL
 * 18.771133634002
 */

/*
 * longitude < 14 nejvice na zapade
 * longitude < 16 mene na zapade
 * longitude < 18 vice na vychode
 * ostatni nejvice na vychode
 */

SELECT 
	name,
	municipality,
	longitude,
	CASE 
		WHEN longitude IS NULL THEN 'unknown'
		WHEN longitude < 14 THEN 'nejvice na zapade'
		WHEN longitude < 16 THEN 'mene na zapade'
		WHEN longitude < 18 THEN 'vice na vychode'
		ELSE 'nejvice na vychode'		-- alternativne WHEN longitude >= 18 THEN 'nejvice na vychode'
	END	AS cz_position
FROM healthcare_provider hp; 


/*
 * Úkol 4: Vypište název a typ poskytovatele a v novém sloupci odlište, 
 * zda jeho typ je Lékárna nebo Výdejna zdravotnických prostředků.
*/


SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type = 'Lékárna' THEN 1
		WHEN provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END	AS is_desired_type
FROM healthcare_provider hp;


SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type = 'Lékárna' OR provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END	AS is_desired_type
FROM healthcare_provider hp;


SELECT 
	name,
	provider_type,
	CASE 
		WHEN provider_type IN ('Lékárna', 'Výdejna zdravotnických prostředků') THEN 1
		ELSE 0
	END	AS is_desired_type
FROM healthcare_provider hp;


/*
 * Cvičení: WHERE, IN a LIKE
 */


-- pokracovani 20:05


/*
 * Úkol 1: Vyberte z tabulky healthcare_provider záznamy o poskytovatelích, 
 * kteří mají ve jméně slovo nemocnice.
 */

SELECT 
	name
FROM healthcare_provider hp
WHERE lower(name) LIKE '%nemocnice%';			-- name LIKE 'nemocnice' => name = 'nemocnice'


-- tohle je ekvivaletni zapis
SELECT 
	name
FROM healthcare_provider hp
WHERE name ILIKE '%nemocnice%';				-- '%nemocnice%kraje%'

/*
Úkol 2: Vyberte z tabulky healthcare_provider jméno poskytovatelů, 
kteří v něm mají slovo lékárna. 
Vytvořte další dynamicky vypsaný sloupec, který bude obsahovat 1, 
pokud slovem Lékárna název začíná. V opačném případě bude ve sloupci 0.
 */

SELECT  
	name,
	CASE
		WHEN name LIKE 'Lékárna%' THEN 1
		ELSE 0
	END	AS healthcare_provider 
FROM healthcare_provider hp
WHERE name ILIKE '%lékárna%';

/*
Úkol 3: Vypište jméno a město poskytovatelů, jejichž název města poskytování má délku čtyři písmena (znaky).
*/

SELECT 
	name,
	municipality 
FROM healthcare_provider hp
WHERE municipality LIKE '____'; -- 4x podtrzitko -> _ _ _ _ 

-- '%l_k_rna%' -> lakerna najde i tohle

/*
Úkol 4: Vypište jméno, město a okres místa poskytování u těch poskytovatelů, 
kteří jsou z Brna, Prahy nebo Ostravy nebo z okresů Most nebo Děčín.
*/

SELECT *
FROM czechia_district cd;

/*
 * CZ0425	Most
 * CZ0421	Děčín
 */

SELECT 
	name,
	municipality,
	district_code 
FROM healthcare_provider hp
WHERE 
	municipality IN ('Brno', 'Praha', 'Ostrava')
	OR district_code IN ('CZ0425', 'CZ0421');


/*
Úkol 5: Pomocí vnořeného SELECT vypište kódy krajů pro Jihomoravský a Středočeský kraj 
z tabulky czechia_region. Ty použijte pro vypsání ID, jména a kraje jen těch 
vyhovujících poskytovatelů z tabulky healthcare_provider.
*/



SELECT *
FROM czechia_region cr
WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj')


SELECT 
	provider_id,
	name,
	region_code 
FROM healthcare_provider hp 
WHERE region_code IN (
	SELECT code
	FROM czechia_region cr
	WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj')
);

-- tohle je stejne, jen bez subquery
SELECT 
	provider_id,
	name,
	region_code 
FROM healthcare_provider hp 
WHERE region_code IN ('CZ020', 'CZ064');


/*
 * Úkol 6: Z tabulky czechia_district vypište jenom ty okresy, 
 * ve kterých se vyskytuje název města, které má délku čtyři písmena (znaky).
 */

-- tento si muzete zkusit doma


/*
 * Cvičení: Pohledy (VIEW)
 */


/*
Úkol 1: Vytvořte pohled (VIEW) s ID, jménem, městem a okresem místa poskytování u těch poskytovatelů, 
kteří jsou z Brna, Prahy nebo Ostravy. Pohled pojmenujte v_healthcare_provider_subset .
 */

CREATE OR REPLACE VIEW v_healthcare_provider_subset AS
	SELECT 
		provider_id,
		name AS provider_name,
		municipality,
		district_code 
	FROM healthcare_provider hp 
	WHERE 
		municipality IN ('Brno', 'Praha', 'Ostrava');


SELECT *
FROM v_healthcare_provider_subset;


DROP VIEW IF EXISTS v_healthcare_provider_subset;


-- Stahnout Postgres v17 nebo v18
-- https://www.postgresql.org/download/
-- https://engeto.com/files/data_academy_2024_11_04.pgdump.sql




