/*Data Cleaning in SQL Queries*/

-- Standardize sale_date Format:
ALTER TABLE nyc_housing_data
ADD sale_date_converted DATE;

UPDATE  nyc_housing_data
SET sale_date_converted = CAST(sale_date AS date);

---------------------------------------------------------------------------------------------------------------------

-- Find Row Label variants and consolidate them:
SELECT DISTINCT land_use
FROM nyc_housing_data 
ORDER BY land_use;

SELECT land_use, CASE WHEN land_use like 'VACANT R%' THEN 'VACANT RESIDENTIAL LAND'
	   WHEN land_use = 'CONDOMINIUM' THEN 'CONDO'
	   ELSE land_use
	   END
FROM nyc_housing_data;

UPDATE nyc_housing_data
SET land_use = CASE WHEN land_use like 'VACANT R%' THEN 'VACANT RESIDENTIAL LAND'
	   WHEN land_use = 'CONDOMINIUM' THEN 'CONDO'
	   ELSE land_use
	   END;

---------------------------------------------------------------------------------------------------------------------

-- Seperate property_address into individual columns (Address, City,State, Zipcode):
SELECT property_address
FROM nyc_housing_data


SELECT
SPLIT_PART(property_address, ',' , 1 ) AS street_address,
SPLIT_PART(property_address, ',' , 2 )AS  city,
SUBSTRING(property_address FROM '[A-Z][A-Z]') AS State,
SUBSTRING(property_address FROM '\ (\d{5})') AS zipcode
FROM nyc_housing_data;
	
ALTER TABLE nyc_housing_data
ADD street_address VARCHAR(255),
ADD city VARCHAR(255),
ADD state VARCHAR(2),
ADD zipcode VARCHAR(10);

UPDATE nyc_housing_data
SET street_address = SPLIT_PART(property_address, ',' , 1 );

UPDATE nyc_housing_data
SET city = SPLIT_PART(property_address, ',' , 2 );

UPDATE nyc_housing_data
SET state = SUBSTRING(property_address FROM '[A-Z][A-Z]');

UPDATE nyc_housing_data
SET zipcode = SUBSTRING(property_address FROM '\ (\d{5})');

---------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns:
SELECT *
FROM  nyc_housing_data
ORDER BY parcel_id;

ALTER TABLE nyc_housing_data
DROP COLUMN property_address;




