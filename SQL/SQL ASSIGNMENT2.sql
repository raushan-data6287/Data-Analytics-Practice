-- SQL COMMANDS
Use school;
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(50),
    active TINYINT,       
    rental_id INT,        
    create_date DATE
);


INSERT INTO customer (customer_id, first_name, last_name, email, address, city, active, rental_id, create_date) 
VALUES
(1, 'Amit',      'Kumar',    'amit@gmail.com',     'Sector 10', 'Agra',       1, 10, '2022-01-01'),
(2, 'Arun',      'Singh',    'arun@gmail.com',     'Sector 11', 'Delhi',      1, 11, '2022-01-02'),
(3, 'Nikhil',    'Roy',      'nroy@gmail.com',     'Sector 12', 'Nagpur',     0, 12, '2022-01-03'),
(4, 'Mohit',     'Verma',    'mohit@gmail.com',    'Street 21', 'Mumbai',     1, 13, '2022-01-04'),
(5, 'Anita',     'Sharma',   'anita@gmail.com',    'Street 33', 'Agra',       1, 14, '2022-01-05'),
(6, 'Akash',     'Mehta',    'akash@gmail.com',    'Road 99',   'Ahmedabad',  0, 15, '2022-01-06'),
(7, 'Riya',      'Gupta',    'riya@gmail.com',     'Road 22',   'Raipur',     1, 16, '2022-01-07'),
(8, 'Anmol',     'Bose',     'anmol@gmail.com',    'Colony 8',  'Agra',       1, 17, '2022-01-08'),
(9, 'Aman',      'Das',      'aman@gmail.com',     'Town 44',   'Delhi',      0, 18, '2022-01-09'),
(10,'Aarav',     'Shah',     'aarav@gmail.com',    'Lane 50',   'Agra',       1, 19, '2022-01-10');
SELECT * FROM CUSTOMER;
INSERT INTO customer (customer_id, first_name, last_name, email, address, city, active, rental_id, create_date)
VALUES
(11, 'Bharat', 'Sharma', 'bharat.sharma@example.com', '12 Gandhi Road', 'Patna', 1, 201, '2024-05-01'),

(12, 'Barkha', 'Devi', 'barkha.devi@example.com', '22 Station Road', 'Gaya', 1, 202, '2024-05-05'),

(13, 'Bhuvan', 'Rai', 'bhuvan.rai@example.com', '33 Mall Street', 'Darbhanga', 0, 203, '2024-05-10'),

(14, 'Bobby', 'Khan', 'bobby.khan@example.com', '44 College Chowk', 'Muzaffarpur', 1, 204, '2024-05-12');


CREATE TABLE film (
    film_id INT PRIMARY KEY,
    title VARCHAR(100),
    rating VARCHAR(10),
    rental_duration INT,
    replacement_cost DECIMAL(5,2),
    length INT
);
INSERT INTO film (film_id, title, rating, rental_duration, replacement_cost, length) VALUES
(1, 'Avatar',           'PG',    6, 18.00, 120),
(2, 'Inception',        'PG-13', 7, 25.00, 95),
(3, 'Toy Story',        'G',     3, 12.00, 80),
(4, 'The Lion King',    'G',     4, 17.00, 60),
(5, 'Titanic',          'PG-13', 6, 19.50, 150),
(6, 'Joker',            'R',     5, 20.00, 110),
(7, 'Dangal',           'PG',    8, 14.00, 132),
(8, 'Coco',             'G',     9, 16.50, 90),
(9, 'Interstellar',     'PG-13', 10, 30.00, 170),
(10,'Up',               'G',     2, 11.50, 96);
select * from film;
SELECT 
    film_id,
    title,
    rating,
    rental_duration,
    CONCAT('$', replacement_cost) AS replacement_cost,
    length
FROM film;


CREATE TABLE actor (
    actor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

INSERT INTO actor (actor_id, first_name, last_name) VALUES
(1, 'Amit', 'Khan'),
(2, 'Aamir', 'Khan'),
(3, 'Akshay', 'Kumar'),
(4, 'Salman', 'Khan'),
(5, 'Shahrukh', 'Khan'),
(6, 'Hrithik', 'Roshan'),
(7, 'Ranbir', 'Kapoor'),
(8, 'Ranveer', 'Singh'),
(9, 'Ayush', 'Sharma'),
(10,'Ajay', 'Devgn');


CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY,
    film_id INT
);

INSERT INTO inventory (inventory_id, film_id) VALUES
(1, 1),
(2, 3),
(3, 5),
(4, 1),
(5, 2),
(6, 3),
(7, 8),
(8, 9),
(9, 10),
(10, 4);

-- SQL COMMANDS
USE SCHOOL;

-- QUES-1: IDENTIFY THE PRIMARY KEYS AND FOREIGN KEYS IN MAVEN DB . DISCUSS THE DIFFERENCES.



-- QUES-2: LIST ALL DETAILS OF ACTORS. 
SELECT * FROM ACTOR;

-- QUES-3: LIST ALL CUSTOMER INFORMATION FROM DB. 
SELECT * FROM CUSTOMER;

-- QUES-4: LIST DIFFERENT COUNTRIES: 
USE WORLD;
SELECT distinct NAME FROM COUNTRY;

-- QUES-5: DISPLAY ALL ACTIVE CUSTOMER. 
use school;
SELECT * FROM customer
WHERE ACTIVE = 1;

-- QUES-6: LIST ALL RENTAL IDS FOR CUSTOMER WITH ID 1. 
SELECT rental_id from customer
where customer_id = 1;

-- QUES-7: DISPLAY ALL THE FILMS WHOSE RENTAL DURATION IS GREATER THAN 5. 
SELECT * FROM FILM
WHERE rental_duration > 5;

-- QUES-8: LIST THE TOTAL NUMBER OF FILMS WHOSE REPLACEMENT COST IS GREATER THAN $15 AND LESS THAN $20. 
SELECT COUNT(*) FROM FILM
WHERE replacement_cost > 15
AND replacement_cost < 20;


-- QUES-9: DISPLAY THE COUNT OF UNIQUE FIRST NAME OF ACTORS. 
SELECT count(distinct first_name) as unique_fir_name from actor;

-- QUES-10: DISPLAY THE FIRST 10 RECORDS FROM THE CUSTOMER TABLE. 
SELECT * FROM CUSTOMER 
LIMIT 11; 

-- QUES-11: DISPLAY THE FIRST 3 RECORDS FROM THE CUSTOMER TABLE WHOSE FIRST NAME START WITH 'B'. 
SELECT * FROM CUSTOMER 
WHERE first_name like 'B%' 
LIMIT 4;

-- QUES-12: DISPLAY THE NAMES OF FIRST 5 MOVIES WHICH ARE RATED AS 'G'. 
SELECT * FROM FILM 
WHERE RATING = 'G'
LIMIT 5;

-- QUES-13: FIND ALL CUSTOMERS WHOSE FIRST NAME START WITH 'a'. 
SELECT * FROM CUSTOMER
WHERE first_name like 'a%';

-- QUES-14: FIND ALL CUSTOMERS WHOSE FIRST NAME ENDS WITH 'a'. 
SELECT * FROM CUSTOMER 
WHERE first_name like '%a';

-- QUES-15: DISPLAY THE LIST OF FIRST 4 CITIES WHICH START AND END WITH 'a'. 
USE WORLD;
SELECT * FROM CITY
WHERE CITY_NAME LIKE 'A%' 
AND CITY_NAME LIKE '%A';

-- QUES-16: FIND ALL CUSTOMERS WHOSE FIRST NAME HAVE "NI" IN ANY POSITION. 
USE SCHOOL;
SELECT * FROM CUSTOMER
WHERE first_name LIKE '%NI%';

-- QUES-17: FIND ALL CUSTOMERS WHOSE FIRST NAME HAVE 'R' IN THE SECOND POSITION 
SELECT * FROM CUSTOMER
WHERE first_name LIKE '_r%';

-- QUES-18: FIND ALL CUSTOMERS WHOSE FIRST NAME START WITH 'a' AND ARE AT LEAST 5 CHARACTER IN LENGTH. 
SELECT * FROM CUSTOMER 
WHERE FIRST_NAME LIKE 'a%'
AND length(FIRST_NAME) >= 5;

-- QUES-19: FIND ALL CUSTOMERS WHOSE FIRST NAME STARTS WITH 'a' AND ENDS WITH 'o'. 
SELECT * FROM CUSTOMER 
WHERE FIRST_NAME LIKE 'a%' 
AND FIRST_NAME LIKE '%o';

-- QUES-20: GET THE FILMS WITH PG AND PG-13 RATING USING IN OPERATOR. 
SELECT * FROM FILM 
WHERE RATING IN ('PG', 'PG-13');

-- QUES-21: GET THE FILM WITH LENGTH BETWEEN 50 TO 100 USING BETWEEN OPERATOR. 
SELECT * FROM FILM 
WHERE LENGTH BETWEEN 50 AND 100;

-- QUES-22: GET THE TOP 50 ACTORS USING LIMIT OPERATOR. 
USE SAKILA;
SELECT * FROM ACTOR
LIMIT 50;

-- QUES-23: GET THE DISTINCT FILM IDS FROM INVENTORY TABLE. 
USE SCHOOL;
SELECT distinct FILM_ID  FROM INVENTORY; 







