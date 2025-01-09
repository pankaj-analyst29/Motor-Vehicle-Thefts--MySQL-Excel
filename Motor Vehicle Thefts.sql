USE stolen_vehicles_db;

select * from stolen_vehicles;

select * from locations;

select * from make_details;


--                 Objective 1
-- Identify when vehicles are likely to be stolen

-- Questions
-- Find the number of vehicles stolen each year

SELECT 
    YEAR(date_stolen) AS year, COUNT(*) AS num_vehicles
FROM
    stolen_vehicles
GROUP BY YEAR(date_stolen);

-- Find the number of vehicles stolen each month

SELECT 
    YEAR(date_stolen) AS year,
    MONTH(date_stolen) AS month,
    COUNT(*) AS num_vehicles
FROM
    stolen_vehicles
GROUP BY MONTH(date_stolen) , YEAR(date_stolen)
ORDER BY year , month;

-- Find the number of vehicles stolen each day of the week

SELECT 
    DAYOFWEEK(date_stolen) AS DOW, COUNT(*) AS num_vehicles
FROM
    stolen_vehicles
GROUP BY DAYOFWEEK(date_stolen)
ORDER BY DOW;

-- Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)

SELECT 
    DAYOFWEEK(date_stolen) AS DOW, 
    CASE WHEN DAYOFWEEK(date_stolen) = 1 THEN 'Sunday'
		 WHEN DAYOFWEEK(date_stolen) = 2 THEN 'Monday'
         WHEN DAYOFWEEK(date_stolen) = 3 THEN 'Tuesday'
         WHEN DAYOFWEEK(date_stolen) = 4 THEN 'Wednesday'
         WHEN DAYOFWEEK(date_stolen) = 5 THEN 'Thursday'
         WHEN DAYOFWEEK(date_stolen) = 6 THEN 'Friday'
         ELSE 'Saturday' END AS Day_Of_Week,
    COUNT(*) AS num_vehicles
FROM
    stolen_vehicles
GROUP BY DAYOFWEEK(date_stolen), Day_Of_Week
ORDER BY DOW;

-- Create a bar chart that shows the number of vehicles stolen on each day of the week


--               Objective 2
-- Identify which vehicles are likely to be stolen

-- Find the vehicle types that are most often and least often stolen

SELECT 
    vehicle_type, COUNT(*) AS num_vehicles
FROM
    stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5;

SELECT 
    vehicle_type, COUNT(*) AS num_vehicles
FROM
    stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles
LIMIT 5;

-- For each vehicle type, find the average age of the cars that are stolen

SELECT 
    vehicle_type, AVG(YEAR(date_stolen) - model_year) AS avg_age
FROM
    stolen_vehicles
GROUP BY vehicle_type
ORDER BY avg_age DESC;

-- For each vehicle type, find the percent of vehicles stolen that are luxury versus standard

WITH lux_std AS(
SELECT 
    vehicle_type,
    CASE
        WHEN make_type = 'Luxury' THEN 1
        ELSE 0
    END luxury,
    1 AS all_cars
FROM
    stolen_vehicles sv
        LEFT JOIN
    make_details md ON sv.make_id = md.make_id)

SELECT 
    vehicle_type, SUM(luxury) / SUM(all_cars) * 100 AS pct_lux
FROM
    lux_std
GROUP BY vehicle_type
ORDER BY pc_lux DESC;


-- Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen

SELECT * FROM stolen_vehicles;

SELECT color, COUNT(*)
FROM stolen_vehicles
GROUP BY color
ORDER BY COUNT(*) DESC;

-- Top 7 colors
-- Silver	1272
-- White	934
-- Black	589
-- Blue	512
-- Red	390
-- Grey	378
-- Green	224

SELECT vehicle_type, count(vehicle_id) AS num_vehicles,
SUM(CASE WHEN color = 'Silver' THEN 1 ELSE 0 END) AS silver,
SUM(CASE WHEN color = 'White' THEN 1 ELSE 0 END) AS white,
SUM(CASE WHEN color = 'Black' THEN 1 ELSE 0 END) AS black,
SUM(CASE WHEN color = 'Blue' THEN 1 ELSE 0 END) AS blue,
SUM(CASE WHEN color = 'Red' THEN 1 ELSE 0 END) AS red,
SUM(CASE WHEN color = 'Grey' THEN 1 ELSE 0 END) AS grey,
SUM(CASE WHEN color = 'Green' THEN 1 ELSE 0 END) AS green,
SUM(CASE WHEN color IN ('Gold','Brown','Yellow','Orange','Purple','Cream','Pink') THEN 1 ELSE 0 END) AS other
FROM stolen_vehicles
GROUP BY vehicle_type
ORDER BY num_vehicles DESC
LIMIT 10;


-- Create a heat map of the table comparing the vehicle types and colors


--                        Objective 3
-- Identify where vehicles are likely to be stolen

-- Find the number of vehicles that were stolen in each region

SELECT 
    region, COUNT(vehicle_id) AS num_vehicles
FROM
    stolen_vehicles sv
        JOIN
    locations l ON sv.location_id = l.location_id
GROUP BY region
ORDER BY num_vehicles DESC;

-- Combine the previous output with the population and density statistics for each region

SELECT 
    l.region,
    COUNT(sv.vehicle_id) AS num_vehicles,
    l.population,
    l.density
FROM
    stolen_vehicles sv
        JOIN
    locations l ON sv.location_id = l.location_id
GROUP BY l.region , l.population , l.density
ORDER BY num_vehicles DESC;

-- Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?

SELECT
    l.region,
    COUNT(sv.vehicle_id) AS num_vehicles,
    l.population,
    l.density
FROM
    stolen_vehicles sv
        JOIN
    locations l ON sv.location_id = l.location_id
GROUP BY l.region , l.population , l.density
ORDER BY l.density DESC;

-- Auckland	1638	1695200	343.09
-- Nelson	92	54500	129.15
-- Wellington	420	543500	67.52

-- Otago	139	246000	7.89
-- Gisborne	176	52100	6.21
-- Southland	26	102400	3.28

(SELECT
    'High Density' AS Density,
    sv.vehicle_type,
    COUNT(sv.vehicle_id) AS num_vehicles
FROM
    stolen_vehicles sv
        JOIN
    locations l ON sv.location_id = l.location_id
WHERE l.region IN ('Auckland', 'Nelson', 'Wellington')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5)

UNION

(SELECT
    'Low Density' AS Density,
    sv.vehicle_type,
    COUNT(sv.vehicle_id) AS num_vehicles
FROM
    stolen_vehicles sv
        JOIN
    locations l ON sv.location_id = l.location_id
WHERE l.region IN ('Otago', 'Gisborne', 'Southland')
GROUP BY sv.vehicle_type
ORDER BY num_vehicles DESC
LIMIT 5);

-- Create a scatter plot of population versus density, and change the size of the points based on the number of vehicles stolen in each region



-- Create a map of the regions and color the regions based on the number of stolen vehicles