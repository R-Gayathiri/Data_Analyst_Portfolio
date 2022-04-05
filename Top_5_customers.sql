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
