SELECT product_name, suppliers.company_name, units_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id;


SELECT order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id;


-- из левой таблицы все записи берет вместе с null
SELECT company_name, order_id
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE order_id IS NULL;


-- псевдоним AS. не работает в строке WHERE,FROM,HAVING
SELECT category_id, SUM(unit_price * units_in_stock) AS total_price
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY total_price DESC;


SELECT c.company_name, CONCAT(e.first_name, ' ', e.last_name)
FROM orders AS O
JOIN customers AS c USING(customer_id)
JOIN employees AS e USING(employee_id)
JOIN shippers AS s ON o.ship_via = s.shipper_id
WHERE c.city = 'London' AND e.city = 'London' AND s.company_name = 'Speedy Express';






