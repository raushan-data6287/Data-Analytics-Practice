USE AIRPORT_DB;
-- PROBLEM STATEMENT - 11 
-- THE OBJECTIVE  IS  TO DETERMINE  THE MOST AND LEAST  BUSY MONTHS BY FLIGHTS COUNT ACROSS  MULTIPLE YEARS. 

WITH MONTHLY_FLIGHTS AS (SELECT 
    month(FLY_DATE) AS MONTH,
    COUNT(flights) as total_flights
FROM 
    airport_occupancy
group by 
    month(FLY_DATE)
)

SELECT 
    MONTH,
	total_flights,
    CASE
      WHEN total_flights = (select max(total_flights) from MONTHLY_FLIGHTS) THEN 'MOST BUSY' 
      WHEN total_flights = (SELECT MIN(total_flights) from MONTHLY_FLIGHTS) THEN 'LEAST BUSY' 
      ELSE null
      END AS MONTH_STATUS
FROM 
    MONTHLY_FLIGHTS
WHERE 
   TOTAL_FLIGHTS = (SELECT MAX(TOTAL_FLIGHTS) FROM MONTHLY_FLIGHTS)
   OR TOTAL_FLIGHTS = (SELECT MIN(TOTAL_FLIGHTS) FROM MONTHLY_FLIGHTS);
   
-- This analysis will provide insights into seasonal trends in air travel,
-- helping airlines and stakeholders understand peak and off-peak periods for better operational planning and resource allocation.

-- PROBLEM STATEMENT 12 
-- The aim is to calculate the year-over-year percentage growth in the total number of passengers for each origin and destination airport pair.

WITH PASSENGER_SUMMARY AS (SELECT 
    ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    year(FLY_DATE) AS YEAR,
    SUM(PASSENGERS) AS TOTAL_PASSENGERS
FROM 
    airport_occupancy
group by 
   ORIGIN_AIRPORT,
    DESTINATION_AIRPORT,
    year(FLY_DATE)
),
PASSENGER_GROWTH AS (SELECT 
     ORIGIN_AIRPORT,
     DESTINATION_AIRPORT,
     YEAR,
     TOTAL_PASSENGERS,
     LAG(TOTAL_PASSENGERS) OVER(partition by ORIGIN_AIRPORT,DESTINATION_AIRPORT ORDER BY YEAR) AS PREV_YEAR_PASSENGERS
FROM 
   PASSENGER_SUMMARY
)

SELECT 
     ORIGIN_AIRPORT,
     DESTINATION_AIRPORT,
     YEAR,
     TOTAL_PASSENGERS, 
     CASE 
         WHEN PREV_YEAR_PASSENGERS IS NOT NULL THEN 
          ((TOTAL_PASSENGERS - PREV_YEAR_PASSENGERS)/ nullif(PREV_YEAR_PASSENGERS, 0) * 100.0)
          ELSE NULL
          END AS GROWTH_PERCENTAGE
FROM 
    PASSENGER_GROWTH
ORDER BY 
    ORIGIN_AIRPORT,
     DESTINATION_AIRPORT,
     YEAR;
	
-- This analysis will help identify trends in passenger traffic over time,
-- providing valuable insights for airlines to make informed decisions about route development 
-- and capacity management based on demand fluctuations.

-- PROBLEM STATEMENTS 13
-- The objective is to identify routes (from origin to destination) that have demonstrated consistent year-over-year growth in the number of flights

WITH Flight_Summary AS (
    SELECT 
        Origin_airport, 
        Destination_airport, 
        YEAR(Fly_date) AS Year, 
        COUNT(Flights) AS Total_Flights
    FROM 
        airport_occupancy
    GROUP BY 
        Origin_airport, 
        Destination_airport, 
        YEAR(Fly_date)
),

Flight_Growth AS (
    SELECT 
        Origin_airport, 
        Destination_airport, 
        Year, 
        Total_Flights,
        LAG(Total_Flights) OVER (PARTITION BY Origin_airport, Destination_airport ORDER BY Year) AS Previous_Year_Flights
    FROM 
        Flight_Summary
),

Growth_Rates AS (
    SELECT 
        Origin_airport, 
        Destination_airport, 
        Year, 
        Total_Flights,
        CASE 
            WHEN Previous_Year_Flights IS NOT NULL AND Previous_Year_Flights > 0 THEN 
                ((Total_Flights - Previous_Year_Flights) * 100.0 / Previous_Year_Flights)
            ELSE NULL 
        END AS Growth_Rate,
        CASE 
            WHEN Previous_Year_Flights IS NOT NULL AND Total_Flights > Previous_Year_Flights THEN 1
            ELSE 0 
        END AS Growth_Indicator
    FROM 
        Flight_Growth
)

-- Final query to identify routes with consistent growth and their growth rate
SELECT 
    Origin_airport, 
    Destination_airport,
    MIN(Growth_Rate) AS Minimum_Growth_Rate,
    MAX(Growth_Rate) AS Maximum_Growth_Rate
FROM 
    Growth_Rates
WHERE 
    Growth_Indicator = 1
GROUP BY 
    Origin_airport, 
    Destination_airport
HAVING 
    MIN(Growth_Indicator) = 1
ORDER BY 
    Origin_airport, 
    Destination_airport;

-- This analysis helps airlines find routes that are growing continuously. 
-- It also shows how much growth has happened in percentage.
 -- This information helps airlines understand demand and plan better routes in the future.

-- PROBLEM STATEMENT - 14
-- The aim is to determine the top 3 origin airports with the highest weighted passenger-to-seats utilization ratio, 
-- considering the total number of flights for weighting.

WITH UTILIZATION_RATIO AS (
-- Step 1: Calculate the passenger-to-seats ratio for each flight
SELECT 
    ORIGIN_AIRPORT, 
    SUM(PASSENGERS) AS TOTAL_PASSENGERS,
    SUM(SEATS) AS TOTAL_SEATS, 
     COUNT(FLIGHTS) AS TOTAL_FLIGHTS,
     SUM(PASSENGERS) * 1.0 / SUM(SEATS) AS PASSENGER_SEAT_RATIO
FROM 
    airport_occupancy
group by 
    ORIGIN_AIRPORT
),

 WEIGHTED_UTILIZATION AS (
 
 SELECT 
     ORIGIN_AIRPORT, 
     TOTAL_PASSENGERS,
     TOTAL_SEATS, 
     TOTAL_FLIGHTS,
    PASSENGER_SEAT_RATIO,
    (PASSENGER_SEAT_RATIO * TOTAL_FLIGHTS) / SUM(TOTAL_FLIGHTS) OVER() AS WEIGHTED_UTILIZATION
FROM 
    UTILIZATION_RATIO
)
SELECT 
    Origin_airport, 
    Total_Passengers, 
    Total_Seats, 
    Total_Flights, 
    Weighted_Utilization
FROM 
    Weighted_Utilization
ORDER BY 
    Weighted_Utilization DESC
LIMIT 3;

-- This analysis shows the top three origin airports with good passenger-to-seat ratios and a high number of flights.
 -- It helps in understanding airport performance by looking at both passenger efficiency and flight count. 
 
-- PROBLEM STATEMENT 15 
-- The objective is to identify the peak traffic month for each origin city based on the highest number of passengers, 
-- including any ties where multiple months have the same passenger count.

WITH Monthly_Passenger_Count AS (
    SELECT 
        Origin_city,
        YEAR(Fly_date) AS Year,
        MONTH(Fly_date) AS Month,
        SUM(Passengers) AS Total_Passengers  -- Handling NULLs and non-integer values
    FROM 
        airport_occupancy
    GROUP BY 
        Origin_city, 
        YEAR(Fly_date), 
        MONTH(Fly_date)
),

Max_Passengers_Per_City AS (
    SELECT 
        Origin_city, 
        MAX(Total_Passengers) AS Peak_Passengers
    FROM 
        Monthly_Passenger_Count
    GROUP BY 
        Origin_city
)

SELECT 
    mpc.Origin_city, 
    mpc.Year, 
    mpc.Month, 
    mpc.Total_Passengers
FROM 
    Monthly_Passenger_Count mpc
JOIN 
    Max_Passengers_Per_City mp ON mpc.Origin_city = mp.Origin_city 
                               AND mpc.Total_Passengers = mp.Peak_Passengers
ORDER BY 
    mpc.Origin_city, 
    mpc.Year, 
    mpc.Month;
    
-- This analysis will help reveal seasonal travel patterns specific to each city,
-- enabling airlines to tailor their services and marketing strategies to meet demand effectively.

-- PROBLEM STATEMENT 16
-- The aim is to identify the routes (origin-destination pairs) that have experienced the largest decline in passenger numbers year-over-year. 

WITH Yearly_Passenger_Count AS (
    SELECT 
        Origin_airport,
        Destination_airport,
        YEAR(Fly_date) AS Year,
        SUM(Passengers) AS Total_Passengers
    FROM 
        airport_occupancy
    GROUP BY 
        Origin_airport, 
        Destination_airport, 
        YEAR(Fly_date)
),

Yearly_Decline AS (
    SELECT 
        y1.Origin_airport,
        y1.Destination_airport,
        y1.Year AS Year1,
        y1.Total_Passengers AS Passengers_Year1,
        y2.Year AS Year2,
        y2.Total_Passengers AS Passengers_Year2,
        -- Calculate percentage decline: (New - Old) / Old * 100
        ((y2.Total_Passengers - y1.Total_Passengers) / NULLIF(y1.Total_Passengers, 0)) * 100 AS Percentage_Change
    FROM 
        Yearly_Passenger_Count y1
    JOIN 
        Yearly_Passenger_Count y2
        ON y1.Origin_airport = y2.Origin_airport
        AND y1.Destination_airport = y2.Destination_airport
        AND y2.Year = y1.Year + 1 -- Join consecutive years
)

SELECT 
    Origin_airport,
    Destination_airport,
    Year1,
    Year2,
    Passengers_Year1,
    Passengers_Year2,
    Percentage_Change
FROM 
    Yearly_Decline
WHERE 
    Percentage_Change < 0 -- Only declining routes
ORDER BY 
    Percentage_Change ASC -- Largest decline first
LIMIT 5;
   
-- This analysis will help airlines pinpoint routes facing reduced demand,
-- allowing for strategic adjustments in operations, marketing, and service offerings to address the decline effectively.
    
## Problem Statement 17 : 

-- The objective is to list all origin and destination airports that had at least 10 flights
-- but maintained an average seat utilization (passengers/seats) of less than 50%.
    
WITH Flight_Stats AS (
    SELECT 
        Origin_airport,
        Destination_airport,
        COUNT(Flights) AS Total_Flights,
        SUM(Passengers) AS Total_Passengers,
        SUM(Seats) AS Total_Seats,
        -- Calculate average seat utilization as (Total Passengers / Total Seats)
        (SUM(Passengers) / NULLIF(SUM(Seats), 0)) AS Avg_Seat_Utilization
    FROM 
        airport_occupancy
    GROUP BY 
        Origin_airport, Destination_airport
)

SELECT 
    Origin_airport,
    Destination_airport,
    Total_Flights,
    Total_Passengers,
    Total_Seats,
    ROUND(Avg_Seat_Utilization * 100, 2) AS Avg_Seat_Utilization_Percentage
FROM 
    Flight_Stats
WHERE 
    Total_Flights >= 10 -- At least 10 flights
    AND Avg_Seat_Utilization < 0.5 -- Less than 50% seat utilization
ORDER BY 
    Avg_Seat_Utilization_Percentage ASC;
 
-- This analysis will highlight underperforming routes, allowing airlines to reassess their capacity management strategies
-- and make informed decisions regarding potential service adjustments to optimize seat utilization and improve profitability 

    
## Problem Statement 18 : 

-- The aim is to calculate the average flight distance for each unique city-to-city pair (origin and destination) 
-- and identify the routes with the longest average distance. 

WITH Distance_Stats AS (
    SELECT 
        Origin_city,
        Destination_city,
        AVG(Distance) AS Avg_Flight_Distance
    FROM 
        airport_occupancy
    GROUP BY 
        Origin_city, 
        Destination_city
)

SELECT 
    Origin_city,
    Destination_city,
    ROUND(Avg_Flight_Distance, 2) AS Avg_Flight_Distance
FROM 
    Distance_Stats
ORDER BY 
    Avg_Flight_Distance DESC;  -- Sort by average distance in descending order

-- This analysis will provide insights into long-haul travel patterns,
-- helping airlines assess operational considerations
-- and potential market opportunities for extended routes.


## Problem Statement 19 : 

-- The objective is to calculate the total number of flights and passengers for each year, 
-- along with the percentage growth in both flights and passengers compared to the previous year. 

WITH Yearly_Summary AS (
    SELECT 
        SUBSTR(Fly_date, 7, 4) AS Year,  -- Extracting year from the Fly_date string
        COUNT(Flights) AS Total_Flights,
        SUM(Passengers) AS Total_Passengers
    FROM 
        airport_occupancy
    GROUP BY 
        SUBSTR(Fly_date, 7, 4)
),

Yearly_Growth AS (
    SELECT 
        Year,
        Total_Flights,
        Total_Passengers,
        LAG(Total_Flights) OVER (ORDER BY Year) AS Prev_Flights,
        LAG(Total_Passengers) OVER (ORDER BY Year) AS Prev_Passengers
    FROM 
        Yearly_Summary
)

SELECT 
    Year,
    Total_Flights,
    Total_Passengers,
    ROUND(((Total_Flights - Prev_Flights) / NULLIF(Prev_Flights, 0) * 100), 2) AS Flight_Growth_Percentage,
    ROUND(((Total_Passengers - Prev_Passengers) / NULLIF(Prev_Passengers, 0) * 100), 2) AS Passenger_Growth_Percentage
FROM 
    Yearly_Growth
ORDER BY 
    Year;

    
-- This analysis will provide a comprehensive overview of annual trends in air travel,
-- enabling airlines and stakeholders to assess growth patterns and 
-- make informed strategic decisions for future operations.

## Problem Statement 20 : 

-- The aim is to identify the top 3 busiest routes (origin-destination pairs) based on the total distance flown,
--  weighted by the number of flights. 

WITH Route_Distance AS (
    SELECT 
        Origin_airport,
        Destination_airport,
        SUM(Distance) AS Total_Distance,
        SUM(Flights) AS Total_Flights
    FROM 
        airport_occupancy
    GROUP BY 
        Origin_airport, 
        Destination_airport
),

Weighted_Routes AS (
    SELECT 
        Origin_airport,
        Destination_airport,
        Total_Distance,
        Total_Flights,
        Total_Distance * Total_Flights AS Weighted_Distance
    FROM 
        Route_Distance
)

SELECT 
    Origin_airport,
    Destination_airport,
    Total_Distance,
    Total_Flights,
    Weighted_Distance
FROM 
    Weighted_Routes
ORDER BY 
    Weighted_Distance DESC
LIMIT 3;  -- To get the top 3 busiest routes

-- This analysis will highlight the most significant routes in terms of distance and operational activity, 
-- providing valuable insights for airlines to optimize their scheduling and resource allocation strategies.









 

