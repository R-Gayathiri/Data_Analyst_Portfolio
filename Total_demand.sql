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
			
			
