/*
Monkeypox Data Exploration 
Skills used: Joins, Conditional Expressions, Aggregate Functions, Converting Data Types
*/

--Where / when were first cases reported:
SELECT date_confirmation date, country FROM mp_case_detection
GROUP BY date,country
ORDER BY date

--Top 5 countries with the highest number of reported cases:
SELECT COUNT(*), country FROM mp_case_detection
GROUP BY country
ORDER BY 1 DESC LIMIT 5;

--Percentage of confirmed cases hospitalized:
SELECT DISTINCT country, gd.confirmed_cases,gd.hospitalized, 
ROUND(CAST(gd.hospitalized AS numeric)/CAST(gd.confirmed_cases AS numeric) *100,2) AS percentage
FROM mp_case_detection cd
JOIN mp_global_data gd USING(country)
ORDER BY gd.confirmed_cases DESC

--Show sum of confirmed cases and daily totals:
SELECT date_confirmation, COUNT(date_confirmation) AS total_cases
FROM mp_case_detection
GROUP BY date_confirmation
UNION ALL 
SELECT 'Total' date_confirmation, COUNT(date_confirmation) 
FROM mp_case_detection
ORDER BY date_confirmation DESC

--Percentage of confirmed cases per day
SELECT country,date_confirmation,COUNT(date_confirmation) AS cases_reported,confirmed_cases, 
ROUND(CAST(COUNT(date_confirmation) AS numeric)/CAST(confirmed_cases AS numeric) *100,2) AS percentage
FROM mp_case_detection
JOIN mp_global_data USING(country)
GROUP BY country,date_confirmation,confirmed_cases
ORDER BY cases_reported DESC

--Countries having highest travel history with confirmed cases
SELECT country, MAX(travel_history_yes) AS cases_that_traveled
FROM mp_global_data
WHERE travel_history_yes IS NOT NULL
GROUP BY country,travel_history_yes
ORDER BY travel_history_yes DESC

--Show sum of confirmed cases for all recorded months:
SELECT DISTINCT CASE
	WHEN date_confirmation LIKE '01/%%/22' THEN 'January'
	WHEN date_confirmation LIKE '02/%%/22' THEN 'February'
	WHEN date_confirmation LIKE '03/%%/22' THEN 'March'
	WHEN date_confirmation LIKE '04/%%/22' THEN 'April'
	WHEN date_confirmation LIKE '05/%%/22' THEN 'May'
	WHEN date_confirmation LIKE '06/%%/22' THEN 'June'
	WHEN date_confirmation LIKE '07/%%/22' THEN 'July'
	WHEN date_confirmation LIKE '08/%%/22' THEN 'August'
	WHEN date_confirmation LIKE '09/%%/22' THEN 'September'
	WHEN date_confirmation LIKE '10/%%/22' THEN 'October'
	WHEN date_confirmation LIKE '11/%%/22' THEN 'November'
	WHEN date_confirmation LIKE '12/%%/22' THEN 'December'
	END month_total,COUNT(date_confirmation)
FROM mp_case_detection
GROUP BY month_total
HAVING COUNT(date_confirmation) > 0
ORDER BY COUNT(date_confirmation)
