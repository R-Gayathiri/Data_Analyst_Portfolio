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