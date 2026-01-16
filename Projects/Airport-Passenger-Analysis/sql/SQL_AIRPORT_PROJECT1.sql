USE AIRPORT_DB;
SELECT * FROM AIRPORT_OCCUPANCY;

## Problem Statement 1 : 

-- The objective is to calculate the total number of passengers for each pair of origin and destination airports.
SELECT 
   origin_airport,
   Destination_airport,
   Sum(passengers) as total_passengers
from airport_occupancy
Group by 
    origin_airport,
   Destination_airport
order by 
    origin_airport,
   Destination_airport;
   
-- This analysis will provide insights into travel patterns between specific airport pairs,
-- helping to identify the most frequented routes and enhance strategic planning for airline operations.

## Problem Statement 2 : 

-- Here the goal is to calculate the average seat utilization for each flight by dividing the  number of passengers by the  total number of seats available. 
SELECT
    origin_airport,
    Destination_airport,
    AVG(CAST(PASSENGERS AS FLOAT)/ NULLIF(SEATS,0)) * 100 AS AVERAGE_SEAT_UTILISATION
FROM airport_occupancy
group by origin_airport,
    Destination_airport
order by 
   AVERAGE_SEAT_UTILISATION DESC;
-- The results will be sorted in descending order based on utilization percentage.
-- This analysis will help identify flights with the highest and lowest seat occupancy, 
-- providing valuable insights for optimizing flight capacity and enhancing operational efficiency.
   
   
   
## Problem Statement 3 :
 
-- The aim is to determine the top 5 origin and destination airport pairs that have the highest total passenger volume. 
SELECT
    origin_airport,
    destination_airport,
    SUM(passengers) as total_passengers
from airport_occupancy
group by 
    origin_airport,
    destination_airport
order by 
    total_passengers desc
LIMIT 5;
--  This analysis will reveal the most frequented travel routes, allowing airlines to optimize resource allocation 
-- and enhance service offerings based on passenger demand trends



## Problem Statement 4 :

-- The objective is to calculate the total number of flights and passengers departing from each origin city.

SELECT 
    origin_city,
    count(flights) as total_flights,
    Sum(Passengers) as total_passengers
from airport_occupancy
Group by 
    origin_city
order by
    total_flights DESC , total_passengers desc;

-- This analysis will provide insights into the activity levels at various origin cities, 
-- helping to identify key hubs and inform strategic decisions regarding flight operations and capacity management.




## Problem Statement 5 : 

-- The aim is to calculate the total distance flown by flights originating from each airport.
SELECT
    origin_airport,
    sum(distance) as total_distance
from airport_occupancy
group by
    origin_airport
order by 
    origin_airport;
    
-- This analysis will offer insights into the overall travel patterns and operational reach of each airport, 
-- helping to evaluate their significance in the network and inform future route planning decisions.



## Problem Statement 6 :

-- The objective is to group flights by month and year using the Fly_date column to calculate the number of flights,
-- total passengers, and average distance traveled per month. 

SELECT
    year(Fly_date) as YEAR,
    month(Fly_date) as Month,
    count(flights) as total_flights,
    sum(passengers) as total_passengers,
    avg(distance) as avg_distance
from airport_occupancy
group by 
    year(Fly_date),
    month(Fly_date)
order by
    YEAR,
    MONTH;

-- This analysis will provide a clearer understanding of seasonal trends and operational performance over time, 
-- enabling better strategic planning for airline operations.


## Problem Statement 7 : 

-- The goal is to calculate the passenger-to-seats ratio for each origin and destination route
-- and filter the results to display only those routes where this ratio is less than 0.5. 

SELECT
    origin_airport,
    destination_airport,
    sum(passengers) as total_passengers,
    sum(seats) as total_seats,
    (sum(passengers)*1.0 / nullif(sum(seats),0)) as passenger_to_seats_ratio
from airport_occupancy
group by
    origin_airport,
    destination_airport
having 
    (sum(passengers)*1.0 / nullif(sum(seats),0)) < 0.5
order by 
    passenger_to_seats_ratio;
   
--  This analysis will help identify underutilized routes, 
-- enabling airlines to make informed decisions about capacity management and potential route adjustments.   
   
## Problem Statement 8 : 

-- The aim is to determine the top 3 origin airports with the highest frequency of flights. 

SELECT
    origin_airport,
    count(flights) as total_flights
from airport_occupancy
group by 
    origin_airport
order by 
    total_flights desc
limit 3;

-- This analysis will highlight the most active airports in terms of flight operations, 
-- providing valuable insights for airlines and stakeholders to optimize scheduling and improve service offerings at these critical locations.

   
## Problem Statement 9 :

-- The objective is to identify the cities (excluding Bend, OR) that sends the most flights and passengers to Bend, OR.    
 SELECT 
    Origin_city, 
    COUNT(Flights) AS Total_Flights, 
    SUM(Passengers) AS Total_Passengers
FROM 
    airport_occupancy
WHERE 
    Destination_city = 'Bend, OR' AND 
    Origin_city <> 'Bend, OR'
GROUP BY 
    Origin_city
ORDER BY 
    Total_Flights DESC, 
    Total_Passengers DESC
LIMIT 3;  

-- This analysis will reveal key contributors to passenger traffic at Bend, OR, 
-- helping airlines and travel authorities understand demand patterns and enhance connectivity from popular originating cities.


## Problem Statement 10 : 
-- The aim is to identify the longest flight route in terms of distance traveled, 
-- including both the origin and destination airports. 

SELECT 
    Origin_airport, 
    Destination_airport, 
    MAX(Distance) AS Longest_Distance
FROM 
    airport_occupancy
GROUP BY 
    Origin_airport, 
    Destination_airport
ORDER BY 
    Longest_Distance DESC
LIMIT 1;

--  This analysis will provide insights into the most extensive travel connections,
-- helping airlines assess operational challenges and opportunities for long-haul service planning.







   
   
   