-- Lab | SQL Subqueries 3.03
-- In this lab, you will be using the Sakila database of movie rentals. Create appropriate joins wherever necessary.

USE sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.title AS 'Title', COUNT(i.inventory_id) As 'No. of copies' From sakila.film As f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT f.title, a.first_name, a.last_name, a.actor_id FROM sakila.film AS f
JOIN sakila.film_actor AS fa
ON f.film_id = fa.film_id
JOIN sakila.actor AS a
ON fa.actor_id = a.actor_id
WHERE f.title = ('Alone Trip')
GROUP BY f.title, a. first_name, a.last_name, a.actor_id;

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT f.title AS 'Title', f.rating AS 'Rating' FROM sakila.film AS f
WHERE f.rating = ('PG');

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the 
-- relevant information.

SELECT CONCAT(first_name,' ', last_name) AS 'Name', email AS 'Email' FROM sakila.customer
WHERE address_id IN (
	SELECT address_id FROM sakila.address
    WHERE city_id IN (
		SELECT city_id FROM sakila.city
        WHERE country_id IN (
			SELECT country_id FROM sakila.country
            WHERE country = 'Canada')));
            

SELECT CONCAT(c.first_name,' ', c.last_name) AS 'Name', c.email AS'Email', co.country AS 'Country' FROM sakila.customer AS c
JOIN sakila.address AS a
ON c.address_id = a.address_id
JOIN sakila.city AS ci
ON a.city_id = ci.city_id
JOIN sakila.country AS co
ON ci.country_id = co.country_id
WHERE co.country = ('Canada');

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the 
-- most number of films. First you will have to find the most prolific actor and then use that actor_id to find the 
-- different films that he/she starred.

SELECT title FROM sakila.film 
WHERE film_id IN (
	SELECT film_id FROM sakila.film_actor 
    WHERE actor_id IN (
		SELECT actor_id from (
			SELECT actor_id, count(film_id) AS 'Amount films', row_number() OVER (
            ORDER BY count(film_id) DESC) AS position FROM sakila.film_actor
group by 1) AS sub1 
WHERE position = 1));

-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments



SELECT customer_id, SUM(amount) FROM sakila.payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;


SELECT f.title AS "Title" FROM sakila.film AS f
JOIN sakila.inventory AS i
ON f.film_id = i.film_id
JOIN sakila.rental AS r
ON i.inventory.id = r.inventory_id
JOIN sakila.payment AS p
ON r.customer_id = p.customer_id
WHERE p.customer_id = '526'
GROUP BY "Title";

-- Customers who spent more than the average payments.

SELECT AVG(amount) FROM sakila.payment;

SELECT CONCAT(c.first_name,' ',c.last_name) AS "Name" FROM sakila.customer AS c
JOIN sakila.payment AS p
ON c.customer_id = p.customer_id
WHERE p.amount > '4.201356'
GROUP BY CONCAT(c.first_name,' ',c.last_name);