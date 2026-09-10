

-- Všechna data z tabulky healthcare_provider hp

SELECT *
FROM healthcare_provider hp;

-- Ze dvou tabulek

SELECT 
	name, 
	provider_type
FROM healthcare_provider hp
WHERE municipality = 'Ostrava';

-- Limit

SELECT 
	*
FROM healthcare_provider hp
WHERE residence_municipality = 'Praha' 
LIMIT 20;

-- ORDER BY

SELECT *
FROM healthcare_provider hp
ORDER BY region_code ASC;

/* Vypište ze stejné tabulky jako v předchozím příkladě sloupce se jménem poskytovatele, kódem kraje a kódem okresu. 
 Data seřaďte podle kódu okresu sestupně. Nakonec vyberte pouze prvních 500 záznamů.
*/

-- AS - Alias (vlastni nazev)

SELECT
 name AS Jmeno,
 region_code AS Oblast,
 district_code AS Kod
FROM healthcare_provider hp
ORDER BY district_code DESC
LIMIT 500;

/*
 Vyberte z tabulky healthcare_provider všechny záznamy poskytovatelů zdravotních služeb, kteří poskytují služby v Praze (kraj Praha).
 */

SELECT *
FROM healthcare_provider hp
WHERE region_code = 'CZ010';

/*
 Vyberte ze stejné tabulky název a kotaktní informace poskytovatelů, kteří nemají místo poskytování v Praze (kraj Praha).
 */

-- Najdeme kod pro Prahu v tabulce czechia_region
SELECT * 
FROM czechia_region cr;

SELECT
 name,
 phone,
 website,
 fax
FROM healthcare_provider hp
WHERE region_code != 'CZ010';

/*
 Vypište názvy poskytovatelů, kódy krajů místa poskytování a místa sídla u takových poskytovatelů, u kterých se tyto hodnoty rovnají.
 */

SELECT
 name,
 region_code,
 residence_region_code
FROM healthcare_provider hp
WHERE region_code = residence_region_code;

/*
 Vypište název a telefon takových poskytovatelů, kteří svůj telefon vyplnili (nevyplnili) do registru.
 */

SELECT
 name,
 phone
FROM healthcare_provider hp
WHERE phone IS NOT NULL;

SELECT
 name,
 phone
FROM healthcare_provider hp
WHERE phone IS NULL;

/*
 Vypište název poskytovatele a kód okresu u poskytovatelů, 
 kteří mají místo poskytování služeb v okresech Benešov a Beroun. Záznamy seřaďte vzestupně podle kódu okresu.
 */

SELECT *
FROM czechia_district;

SELECT
 name,
 district_code
FROM healthcare_provider hp
WHERE district_code = 'CZ0201' 
 OR district_code = 'CZ0202'
ORDER BY district_code DESC;	

--Tvorba, úprava & vkládání do tabulek

/*
 Vytvořte tabulku t_{jméno}_{příjmení}_providers_south_moravia z tabulky healthcare_provider vyberte pouze Jihomoravský kraj.
 */

CREATE TABLE t_engeto_jan75_providers_south_moravia AS
	SELECT * 
	FROM healthcare_provider hp
	WHERE region_code = 'CZ064';


SELECT *
FROM t_engeto_jan75_providers_south_moravia;

-- Vytvoreni nove tabulky

CREATE TABLE t_jan75_engeto_resume (
 date_start date,
 date_end date,
 education varchar(255),
 job varchar(255)
);

-- vlozeni dat do tabulky

INSERT INTO t_jan75_engeto_resume
VALUES ('2026-08-12', NULL, 'Datova akademie', 'Student v Engeto Academy');

INSERT INTO t_jan75_engeto_resume
VALUES ('2026-08-13', NULL, 'Datova akademie', 'Student v Engeto Academy');

INSERT INTO t_jan75_engeto_resume
VALUES ('2026-08-14', NULL, 'Datova akademie', 'Student v Engeto Academy');

INSERT INTO t_jan75_engeto_resume
VALUES ('2026-08-15', NULL, 'Datova akademie', 'Student v Engeto Academy');

SELECT *
FROM t_jan75_engeto_resume hp;


ALTER TABLE t_jan75_engeto_resume ADD COLUMN institution VARCHAR(255);

UPDATE t_jan75_engeto_resume
SET institution = 'AACC'
WHERE date_start = '2026-08-15';

ALTER TABLE t_jan75_engeto_resume ADD COLUMN role VARCHAR(255);

UPDATE t_jan75_engeto_resume
SET role = 'MSc student, OR with Data Science'
WHERE date_start = '2026-08-14';



ALTER TABLE t_jan75_engeto_resume DROP COLUMN institution;

ALTER TABLE t_jan75_engeto_resume DROP COLUMN role;



