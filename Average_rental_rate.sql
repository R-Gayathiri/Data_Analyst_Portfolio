SELECT ca.name AS genre ,ROUND(AVG(f.rental_rate),2) AS Average_rental_rate
FROM category ca
JOIN film_category 
USING (category_id)
JOIN film f
USING (film_id)
GROUP BY 1
ORDER BY 2 DESC;
