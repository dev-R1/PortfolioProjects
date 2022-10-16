/*
Monkeypox Data Exploration 
Skills used: Joins, CTE's, Aggregate Functions, Converting Data Types
*/

--Where / when were first cases reported:
SELECT date_confirmation date, country FROM mp_case_detection
GROUP BY date,country
ORDER BY date

--Top 5 countries with the highest number of reported cases:
SELECT COUNT(*), country FROM mp_case_detection
GROUP BY country
ORDER BY 1 DESC LIMIT 5;

--Date which had most cases reported:
SELECT date_confirmation,COUNT(date_confirmation) FROM mp_case_detection
GROUP BY date_confirmation
ORDER BY COUNT(date_confirmation) DESC 


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

--Show sum of cases from specific month:
SELECT 'January' date_confirmation, COUNT(date_confirmation) 
FROM mp_case_detection
WHERE date_confirmation BETWEEN '01/01/22' and '01/31/22'
ORDER BY date_confirmation DESC LIMIT 1
