-- ORDER BY

SELECT
 name,
 provider_type
FROM healthcare_provider hp
ORDER BY name ASC;


SELECT
 trim(name),
 provider_type
FROM healthcare_provider hp
ORDER BY trim(name) ASC;

SELECT *
FROM healthcare_provider hp;

SELECT
	provider_id,
	name,
	provider_type,
	region_code,
	district_code
FROM healthcare_provider hp 
ORDER BY region_code ASC, district_code ASC;

SELECT *
FROM czechia_district cd 
ORDER BY code DESC;

SELECT *
FROM czechia_region cr 
ORDER BY name DESC 
LIMIT 5;

SELECT name, provider_type
FROM healthcare_provider hp 
ORDER BY provider_type ASC, name DESC;

SELECT
	name, region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END	AS is_from_prague
FROM healthcare_provider hp
ORDER BY is_from_prague DESC;


SELECT
	name, region_code,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END	AS is_from_prague
FROM healthcare_provider hp
WHERE region_code = 'CZ010';

SELECT * FROM (
SELECT
	name, region_code, municipality,
	CASE
		WHEN region_code = 'CZ010' THEN 1
		ELSE 0
	END	AS is_from_prague
FROM healthcare_provider hp
)
WHERE is_from_prague = 1 AND municipality = 'Praha 12'
ORDER BY name;

SELECT
 name, municipality, longitude,
 CASE
  WHEN longitude < 14 THEN 'nejvíce na západě'
  WHEN longitude < 16 THEN 'méně na západě'
  WHEN longitude < 18 THEN 'více na východě'
  ELSE 'nejvíce na východě'
 END AS czechia_position
FROM healthcare_provider
-- WHERE municipality = 'Praha'
ORDER BY municipality DESC, longitude DESC;


SELECT 
	name, provider_type,
	CASE 
		WHEN provider_type = 'Lékárna' OR provider_type = 'Výdejna zdravotnických prostředků' THEN 1
		ELSE 0
	END AS is_desired_type
FROM healthcare_provider hp
ORDER BY is_desired_type DESC;

SELECT 
	name, provider_type,
	CASE 
		WHEN provider_type IN ('Lékárna', 'Výdejna zdravotnických prostředků') THEN 1
		ELSE 0
	END AS is_desired_type
FROM healthcare_provider hp
ORDER BY is_desired_type DESC;


SELECT * FROM (
 SELECT 
	name, provider_type,
	CASE 
		WHEN provider_type IN ('Lékárna', 'Výdejna zdravotnických prostředků') THEN 1
		ELSE 0
	END AS is_desired_type
 FROM healthcare_provider hp)
WHERE is_desired_type = 1;


SELECT name
FROM healthcare_provider hp
WHERE name LIKE '%nemocnice%'
ORDER BY name;

SELECT
    name AS Jmeno,
    CASE
        WHEN name LIKE 'Lékárna%' THEN 1
        ELSE 0
    END AS starts_with_searched_name
FROM healthcare_provider hp
WHERE lower(name) LIKE '%lékárna%';


SELECT
    name,
    municipality
FROM healthcare_provider
WHERE municipality LIKE '____'; -- vysledky o delce 4 znaku - 4x podtrzitko


SELECT *
FROM czechia_district;

SELECT
    name,
    municipality,
    district_code
FROM healthcare_provider hp
WHERE 
    municipality IN ('Brno', 'Praha', 'Ostrava')
    OR district_code IN ('CZ0425', 'CZ0421')
ORDER BY municipality;

SELECT *
FROM czechia_region cr
WHERE name IN ('Jihomoravský kraj','Středočeský kraj');


SELECT
    provider_id,
    name,
    region_code
FROM healthcare_provider
WHERE region_code IN (
    SELECT code
    FROM czechia_region cr
    WHERE name IN ('Jihomoravský kraj', 'Středočeský kraj')
);


SELECT district_code, municipality
    FROM healthcare_provider
    WHERE municipality LIKE '____'
	ORDER BY municipality;

SELECT
    *
FROM czechia_district
WHERE code IN (
    SELECT
        district_code
    FROM healthcare_provider
    WHERE municipality LIKE '____'
)
ORDER BY name;


-- POHLEDY - VIEW

CREATE OR REPLACE VIEW YAN75_healthcare_provider_subset AS
 SELECT
 provider_id, name AS provider_name, municipality, district_code
 FROM healthcare_provider
 WHERE 
 municipality IN ('Brno', 'Praha', 'Ostrava');

SELECT *
FROM YAN75_healthcare_provider_subset
ORDER BY provider_id;


SELECT *
FROM healthcare_provider
WHERE provider_id NOT IN (
 SELECT provider_id
 FROM YAN75_healthcare_provider_subset
)
ORDER BY provider_id;

DROP VIEW IF EXISTS YAN75_healthcare_provider_subset;





