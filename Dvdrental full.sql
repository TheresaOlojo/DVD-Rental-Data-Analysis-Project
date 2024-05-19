--Display the customer names that share the same address (e.g. husband and wife)--
SELECT c.first_name, c.last_name, c1.first_name, c1.last_name
FROM customer AS c
JOIN customer AS c1 ON c.customer_id<>c1.customer_id 
WHERE c.address_id=c1.address_id

--What is the name of the customer who made the highest total payments--
SELECT c.first_name, c.last_name, SUM(p.amount) highest_payment
FROM customer AS c
JOIN payment AS p ON c.customer_id=p.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY highest_payment DESC
LIMIT 1

--What is the movie(s) that was rented the most--
SELECT DISTINCT f.film_id, f.title, COUNT(r.rental_id) number_rented
FROM film AS f
JOIN inventory AS i ON f.film_id=i.film_id
JOIN rental AS r ON i.inventory_id=r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY number_rented DESC
LIMIT 1

--Which movies have been rented so far
SELECT DISTINCT f.title AS movies_rented, COUNT(r.rental_id)
FROM film AS f
JOIN inventory AS i ON f.film_id=i.film_id
JOIN rental AS r ON r.inventory_id=i.inventory_id
GROUP BY f.title

--Which movies have not been rented so far.
SELECT f.title
FROM film AS f
LEFT JOIN 
   (SELECT DISTINCT i.film_id
    FROM rental AS r
    JOIN inventory AS i ON r.inventory_id = i.inventory_id) AS rented_movies
ON f.film_id = rented_movies.film_id
WHERE rented_movies.film_id IS NULL

--Which customers have not rented any movies so far.
SELECT c.first_name, c.last_name
FROM customer AS c
WHERE c.customer_id NOT IN
	(SELECT DISTINCT r.customer_id
	FROM rental AS r)
	
--Display each movie and the number of times it got rented. 
SELECT f.title, COUNT (r.rental_id) AS rental_count
FROM film AS f
LEFT JOIN inventory AS i
ON f.film_id = i.film_id
LEFT JOIN rental AS r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY f.title

--Show the first name and last name and the number of films each actor acted in.
SELECT a.first_name, a.last_name, COUNT(fa.film_id)
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id=fa.actor_id
GROUP BY 1,2
HAVING COUNT(fa.film_id)>0

--Display the names of the actors that acted in more than 20 movies. 
SELECT a.first_name, a.last_name, COUNT(fa.film_id)
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id=fa.actor_id
GROUP BY 1,2
HAVING COUNT(fa.film_id)>20

--For all the movies rated "PG" show me the movie and the number of times it got rented. 
SELECT f.title, f.rating, COUNT(r.rental_id)
FROM film AS f
JOIN inventory AS i ON f.film_id=i.film_id
JOIN rental AS r ON i.inventory_id=r.inventory_id
WHERE f.rating = 'PG' 
GROUP BY 1,2

--Display the movies offered for rent in store_id 1 and not offered in store_id 2--
SELECT DISTINCT f.title, i.store_id
FROM film AS f
JOIN inventory AS i ON f.film_id=i.film_id
WHERE store_id=1 AND f.film_id NOT IN 
	(SELECT DISTINCT film_id FROM inventory
	WHERE store_id=2)
GROUP BY 1,2
ORDER BY 1

--Display the movies offered for rent in any of the two stores 1 and 2.
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
WHERE i.store_id IN (1,2)
ORDER BY 1

--Display the movie titles of those movies offered in both stores at the same time. 
SELECT DISTINCT f.title
FROM film AS f
JOIN inventory AS i1 ON f.film_id = i1.film_id
JOIN inventory AS i2 ON f.film_id = i2.film_id
WHERE i1.store_id = 1
AND i2.store_id = 2

--Display the movie title for the most rented movie in the store with store_id 1.
SELECT f.title AS s1_most_rented_movie, COUNT(r.rental_id)
FROM film AS f
JOIN inventory AS i ON f.film_id=i.film_id
JOIN rental AS r ON i.inventory_id=r.inventory_id
WHERE i.store_id = 1
GROUP BY 1
ORDER BY COUNT (*) DESC
LIMIT 1

--How many movies are not offered for rent in the stores yet. There are two stores only 1 and 2
SELECT COUNT(*) AS count_movies_not_rented
FROM film AS f
WHERE f.film_id NOT IN 
	(SELECT DISTINCT i.film_id
    FROM inventory AS i)
	
--Show the number of rented movies under each rating. 
SELECT f.rating, count(r.rental_id) Rent_count
FROM film AS f
JOIN inventory i ON i.film_id = f.film_id 
JOIN rental AS r ON r.inventory_id = i.inventory_id
GROUP BY f.rating
ORDER BY COUNT(r.rental_id) DESC

--Show the profit of each of the stores 1 and 2.
SELECT i.store_id, SUM(p.amount) AS profit
FROM payment AS p
JOIN rental AS r ON p.rental_id = r.rental_id
JOIN inventory AS i ON r.inventory_id = i.inventory_id
GROUP BY i.store_id