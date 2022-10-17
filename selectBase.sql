SELECT *
FROM products;


SELECT product_id, product_name, unit_price
FROM products;


SELECT product_id, product_name, unit_price * units_in_stock
FROM products;


-- уникальные строки
SELECT DISTINCT city, country
FROM employees;


-- подсчет строк
SELECT COUNT(DISTINCT country)
FROM employees;


-- условие where
SELECT company_name, contact_name, phone
FROM customers
WHERE country = 'USA';


SELECT *
FROM products
WHERE unit_price > 20;


SELECT COUNT(*)
FROM products
WHERE unit_price > 20;


SELECT *
FROM products
WHERE discontinued = 1;


SELECT *
FROM customers
-- WHERE city <> 'Berlin';
-- WHERE country IN ('Mexico', 'Germany', 'USA', 'Canada');
WHERE country NOT IN ('Mexico', 'Germany', 'USA', 'Canada');



SELECT *
FROM orders
-- WHERE order_date > '1998-03-01';
-- WHERE shipped_date > '1998-04-30' AND (freight < 75 OR freight > 150);
WHERE freight BETWEEN 20 AND 40;


SELECT *
FROM products
-- WHERE unit_price > 25 AND units_in_stock > 40;
WHERE city = 'Berlin' OR city = 'London' OR city = 'San Francisco';



-- ORDER BY   sort
SELECT DISTINCT country
FROM customers
-- ORDER BY country ASC;
ORDER BY country DESC;


SELECT DISTINCT country, city
FROM customers
ORDER BY country DESC, city ASC



-- scalar
SELECT MIN(order_date)
FROM orders
WHERE ship_city = 'London';


SELECT MAX(order_date)
FROM orders
WHERE ship_city = 'London';


SELECT AVG(unit_price)
FROM products
WHERE discontinued <> 1;


SELECT SUM(units_in_stock)
FROM products
WHERE discontinued <> 1;




-- поиск с шаблоном
SELECT last_name, first_name
FROM employees
WHERE last_name LIKE '_uch%'


SELECT product_name, unit_price
FROM products
LIMIT 10


SELECT product_name, unit_price
FROM products
WHERE discontinued <> 1
ORDER BY unit_price DESC
LIMIT 10


SELECT ship_city, ship_region, ship_country
FROM orders
WHERE ship_region IS NULL;


SELECT ship_city, ship_region, ship_country
FROM orders
WHERE ship_region IS NOT NULL;


-- группировку
SELECT ship_country, COUNT(*)
FROM orders
WHERE freight > 50
GROUP BY ship_country
ORDER BY COUNT(*) DESC;

SELECT ship_country, COUNT(*)
FROM orders
WHERE freight > 50
GROUP BY ship_country
ORDER BY COUNT(*) DESC;

SELECT category_id, SUM(units_in_stock)
FROM products
GROUP BY category_id
ORDER BY SUM(units_in_stock) DESC
LIMIT 5;


-- второй фильтр
SELECT category_id, SUM(unit_price * units_in_stock)
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC;


-- объединение двух запросов, нет дубликатов, чтобы были дубликаты применить  UNION ALL
SELECT country
FROM customers
UNION
SELECT country
FROM employees

-- пересечение
SELECT country
FROM customers
INTERSECT
SELECT country
FROM suppliers

-- вычетание
SELECT country
FROM customers
EXCEPT
SELECT country
FROM suppliers;













