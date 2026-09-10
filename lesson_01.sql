
-- Úkol 1: Vypište všechna data z tabulky healthcare_provider.


SELECT *
FROM healthcare_provider hp; 

-- Úkol 2: Vypište pouze sloupce se jménem a typem poskytovatele ze stejné tabulky jako v předchozím příkladu.

SELECT
	name,
	provider_type
FROM healthcare_provider hp;


-- Úkol 3: Předchozí dotaz upravte tak, že vypíše pouze prvních 20 záznamů v tabulce.

SELECT
	name,
	provider_type
FROM healthcare_provider hp
LIMIT 20;

-- pokracovani 19:12


-- Úkol 4: Vypište z tabulky healthcare_provider záznamy seřazené podle kódu kraje vzestupně.

SELECT *
FROM healthcare_provider hp
ORDER BY region_code ASC;


/*
 * Úkol 5: Vypište ze stejné tabulky jako v předchozím příkladě sloupce se jménem poskytovatele,
 *  kódem kraje a kódem okresu. Data seřaďte podle kódu okresu sestupně. 
 * Nakonec vyberte pouze prvních 500 záznamů.
 */

SELECT
	name,
	region_code,
	district_code 
FROM healthcare_provider hp -- hp = alias
ORDER BY district_code DESC
LIMIT 500;


/*
 * ASC - vzestupne - od nejmensiho
 * DESC - sestupne - od nejvetsiho
 */


-- jednoradkovy komentar

/*
 * vice
 * radkovy
 * komentar
 */


/*
	WHERE
	
*/

/* Úkol 1: Vyberte z tabulky healthcare_provider všechny záznamy poskytovatelů 
 * zdravotních služeb, kteří poskytují služby v Praze (kraj Praha).
*/

SELECT * 
FROM czechia_region cr; 

-- CZ010	Hlavní město Praha


SELECT *
FROM healthcare_provider hp
WHERE region_code = 'CZ010'; 

SELECT *
FROM healthcare_provider hp
WHERE region_code = 'cz010'; -- tohle taky nejde, v DB jsou velka pismena

SELECT *
FROM healthcare_provider hp
WHERE region_code = CZ010;  --- tohle nejde!!!

/*
 * Úkol 2: Vyberte ze stejné tabulky název a kotaktní informace poskytovatelů, 
 * kteří nemají místo poskytování v Praze (kraj Praha).
 */

SELECT
	name,
	phone,
	fax,
	email,
	website,
	region_code 
FROM healthcare_provider hp
WHERE region_code != 'CZ010';  -- WHERE region_code <> 'CZ010'; -- alternativni zapis ale moc nepouzivat

/*
 * Úkol 3: Vypište názvy poskytovatelů, kódy krajů místa poskytování a 
 * místa sídla u takových poskytovatelů, u kterých se tyto hodnoty rovnají.
 */

SELECT 
	name,
	region_code,
	residence_region_code 
FROM healthcare_provider hp 
WHERE region_code = residence_region_code;

/*
 * Úkol 4: Vypište název a telefon takových poskytovatelů, kteří svůj telefon vyplnili do registru.
 */

SELECT 
	name,
	phone 
FROM healthcare_provider hp 
WHERE phone IS NOT NULL;					-- WHERE phone = '' tohle nefunguje


SELECT 
	name,
	phone 
FROM healthcare_provider hp 
WHERE phone IS NULL; -- vypsat ty co nemaji vyplneny telefon


-- pokracovani 20:07


/*
 * Úkol 5: Vypište název poskytovatele a kód okresu u poskytovatelů, 
 * kteří mají místo poskytování služeb v okresech Benešov a Beroun. 
 * Záznamy seřaďte vzestupně podle kódu okresu.
 */
	
SELECT *
FROM czechia_district cd;

/*
CZ0201	Benešov
CZ0202	Beroun
 */

SELECT 
	name,
	district_code 
FROM healthcare_provider hp 
WHERE district_code = 'CZ0201' 
	OR district_code = 'CZ0202'
ORDER BY district_code ASC;



SELECT 
	name,
	district_code 
FROM healthcare_provider hp 
WHERE district_code = 'CZ0201' 
	OR district_code = 'CZ0202'
	OR district_code = 'CZ0203'
	OR district_code = 'CZ0204'
	OR district_code = 'CZ0205'
	OR district_code = 'CZ0206'
ORDER BY district_code ASC;


/*
 * Cvičení: Tvorba, úprava & vkládání do tabulek
 */

/*
 * Úkol 1: Vytvořte tabulku t_{jméno}_{příjmení}_providers_south_moravia z 
 * tabulky healthcare_provider vyberte pouze Jihomoravský kraj.
 */
-- CZ064	Jihomoravský kraj


CREATE TABLE t_engeto_lector_providers_south_moravia AS
	SELECT *
	FROM healthcare_provider hp
	WHERE region_code = 'CZ064';

SELECT *
FROM t_engeto_lector_providers_south_moravia;


/*
 * Úkol 2: Vytvořte tabulku t_{jméno}_{příjmení}_resume, 
 * kde budou sloupce date_start, date_end, job, education. 
 * Sloupcům definujte vhodné datové typy.
 */

CREATE TABLE t_lektor_engeto_resume_2 (
	date_start date, -- YYYY-mm-dd => 2026-08-12 
	date_end date,
	job varchar(255),
	education varchar(255)
);

-- porada_2026_08_12.docx - nazev souboru - tohle se hezky radi, tohle chceme pouzivat !!!
-- porada_12_08_2026.docx, porada_12_08_2025.docx -- tohle neni pekne, nepouzivat, nejde pekne radit

SELECT *
FROM t_lektor_engeto_resume_2;


INSERT INTO t_lektor_engeto_resume_2
VALUES ('2026-08-12', NULL, 'Engeto lektor', 'VUT Brno');


INSERT INTO t_lektor_engeto_resume_2
VALUES ('2026-08-15', NULL, 'Engeto lektor', 'VUT Brno');


ALTER TABLE t_lektor_engeto_resume_2 ADD COLUMN institution varchar(255);

UPDATE t_lektor_engeto_resume_2
SET institution = 'AABB'
WHERE date_start = '2026-08-15';


SELECT *
FROM t_lektor_engeto_resume_2;

ALTER TABLE t_lektor_engeto_resume_2 DROP COLUMN institution;

DROP TABLE t_lektor_engeto_resume_2; -- smazani tabulky

