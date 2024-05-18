--Q1: Display the customer names that share the same address (e.g. husband and wife)--
SELECT c.first_name, c.last_name, c1.first_name, c1.last_name
FROM customer AS c
JOIN customer AS c1 ON c.customer_id<>c1.customer_id 
WHERE c.address_id=c1.address_id