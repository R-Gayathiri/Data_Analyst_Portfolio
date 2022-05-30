----1----
----Average Movie Rental Rate 

SELECT ca.name AS genre ,ROUND(AVG(f.rental_rate),2) AS Average_rental_rate
FROM category ca
JOIN film_category 
USING (category_id)
JOIN film f
USING (film_id)
GROUP BY 1
ORDER BY 2 DESC;


----2----
----Find the Distinct user

SELECT ca.name AS genre , count(DISTINCT customer) AS total_rental_demand
FROM category ca
JOIN film_category 
USING (category_id)
JOIN film
USING (film_id)
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
JOIN customer 
USING (customer_id)
GROUP BY 1
ORDER BY 2 DESC;

----3----
-- Returned Status of the movie

WITH table1 AS (SELECT *, DATE_PART('day',return_date-rental_date)
			 AS date_difference
			 FROM rental),
	 table2 AS (SELECT rental_duration, date_difference,
				CASE
					WHEN rental_duration>date_difference THEN 'Returned early'
					WHEN rental_duration=date_difference THEN 'Returned on time'
					ELSE 'Returned late'
					END AS return_status
				FROM film
				JOIN inventory
				USING (film_id)
				JOIN table1
				USING (inventory_id))
			SELECT return_status,count(*) AS total_no_of_films
			FROM table2
			GROUP BY 1
			ORDER BY 2 DESC;

----4----

-- Top 5 customer

WITH t1 AS (SELECT *, first_name || ' ' || last_name AS full_name
	FROM customer)
SELECT full_name, email, address, phone,city,country , sum(amount) AS total_purchase
FROM t1
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id)
JOIN payment
USING (customer_id)
GROUP BY 1,2,3,4,5,6
ORDER BY 7 DESC
LIMIT 5;

----5----
-- Total demand for the movie

WITH table1 AS (SELECT ca.name AS genre , count(customer) AS total_demand
			FROM category ca
			JOIN film_category 
			USING (category_id)
			JOIN film
			USING (film_id)
			JOIN inventory
			USING (film_id)
			JOIN rental
			USING (inventory_id)
			JOIN customer 
			USING (customer_id)
			GROUP BY 1
			ORDER BY 2 DESC),
	table2 AS (SELECT ca.name AS genre, SUM(payment.amount) AS Sales
			FROM category ca
			JOIN film_category 
			USING (category_id)
			JOIN film
			USING (film_id)
			JOIN inventory
			USING (film_id)
			JOIN rental
			USING (inventory_id)		
			JOIN payment 
			USING (rental_id)				
			GROUP BY 1
			ORDER BY 2 DESC)
SELECT table1.genre, table1.total_demand, table2.Sales
FROM table1
JOIN table2
ON table1.genre=table2.genre;

----6----
-- Customer based on a country

SELECT country, COUNT(DISTINCT customer_id) AS customer_base, SUM(amount)
	   AS total_sales
	   FROM country
	   JOIN city
	   USING(country_id)
	   JOIN address
	   USING (city_id)
	   JOIN customer
	   USING (address_id)
	   JOIN payment
	   USING(customer_id)
	   GROUP BY 1
	   ORDER BY 2 DESC;