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
