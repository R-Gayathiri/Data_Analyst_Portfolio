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
