-- примеры встроенных символьных функций
SELECT title,
       LEN(title) AS [Длина названия],
	   LEFT(title,10),
	   REVERSE(Title)
FROM   titles
--WHERE  LEN(title) < 20



-- функции работы с датой и временем
-- показать текущую дату и время
SELECT GETDATE(), SYSDATETIME()

-- показать часть даты
SELECT YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE())
SELECT DATEPART(YEAR,GETDATE()),DATEPART(MONTH,GETDATE()),DATEPART(DAY,GETDATE()),
       DATEPART(HOUR,GETDATE()),DATEPART(MINUTE,GETDATE())




-- 1 установить параметры сессии 
SET DATEFORMAT dmy

-- 2 способ - использовать универсальный формат даты

SELECT *
FROM sales
WHERE ord_date = '19940913'  -- работает!

SELECT *
FROM sales
WHERE ord_date = '1994-09-13'  -- не работает

--3 использование функции DATEFROMPARTS()
SELECT *
FROM sales
WHERE ord_date = DATEFROMPARTS(1994,9,13)





-- работа с NULL
SELECT * FROM titles
WHERE  price IS NULL

SELECT * FROM titles
WHERE  price IS NOT NULL

SELECT * FROM titles
ORDER BY price  -- NULL - самое маленькое значение

-- microsoft
SELECT title, notes, Title + '**** ' + ISNULL(Notes,' Нет примечания')
FROM titles
-- for all sql
SELECT title, notes, Title + '**** ' + COALESCE(Notes,' Нет примечания')
FROM titles

SELECT title, notes,CONCAT (Title,'**** ',Notes)
FROM titles





-- примеры сортировок
SELECT CustomerID, ContactName,City
FROM  Customers
WHERE City IN ('London','Rio de Janeiro','Sao Paulo')
ORDER BY City DESC,ContactName




-- пример на порядок выполнения
-- в каком ключевом поле можно использовать заголоки колонок
SELECT CONCAT(FirstName,' ',LastName) AS Фио
FROM Employees
--WHERE Фио LIKE 'Andrew%'
WHERE CONCAT(FirstName,' ',LastName) LIKE 'Andrew%'
ORDER BY Фио


SELECT FirstName +' ' +LastName AS Фио
FROM Employees
WHERE FirstName +' ' +LastName LIKE 'Andrew%'
ORDER BY Фио




-- команды модификации данных
SELECT *
FROM authors

-- INSERT (добавление строк в таблицу)
INSERT INTO authors ([contract],[phone],[au_fname],[au_lname],[au_id],[city])
VALUES (0,'499 123-4567','Федор','Достоевский','111-22-7777','Москва');

-- UPDATE (изменение существующих строк)
UPDATE authors
SET [City] = 'Петербург',[contract] = 1
WHERE au_id = '111-22-7777'

-- DELETE (удаление строк)
DELETE FROM authors
WHERE au_id = '111-22-7777'





-- применение агрегирования к вычисленной колонке 
SELECT OrderID, ProductID, UnitPrice, Quantity, Discount,UnitPrice*Quantity*(1-Discount) AS Total
FROM   [Order Details]
WHERE ProductID = 1

-- показать выручку от товара №1
SELECT SUM(UnitPrice*Quantity*(1-Discount)) AS GrandTotal
FROM   [Order Details]
WHERE ProductID = 1




SELECT price
FROM titles

SELECT AVG(price),MIN(price), MAX(price), SUM(price)
FROM  titles

SELECT AVG(price),MIN(price), MAX(price), SUM(price)
FROM  titles
WHERE [type] = 'business'

-- группирование
SELECT [type], AVG(price) AS [Средняя],MIN(price) AS [Минимальная], MAX(price)  AS [Максимальная]
FROM  titles
GROUP BY type





-- В какой категории больше всего товаров
USE Northwind

SELECT *
FROM Products

SELECT ProductID, ProductName, CategoryID
FROM   Products
ORDER BY CategoryID

-- группирование по CategoryID
SELECT CategoryID, COUNT(*)
FROM   Products
GROUP BY CategoryID
ORDER BY COUNT(*) DESC

SELECT CategoryID  --, COUNT(*)
FROM   Products
GROUP BY CategoryID
ORDER BY COUNT(*) DESC OFFSET 0 ROWS FETCH FIRST 1 ROW ONLY;





SELECT TOP (3) WITH TIES ShipCity, COUNT(*)
FROM Orders
GROUP BY ShipCity
ORDER BY COUNT(*) DESC




-- группирование по вычисленной колонке

-- сколько заказов было сделано в каждом году
SELECT OrderID, OrderDate, YEAR(OrderDate) AS Год 
FROM Orders

SELECT YEAR(OrderDate) AS Год,COUNT(*) AS Kol
FROM Orders
GROUP BY YEAR(OrderDate)
ORDER BY Год




-- Группировка по нескольким колонкам

-- Сколько заказов было продано в каждую страну
SELECT ShipCountry,COUNT(*)
FROM Orders
GROUP BY ShipCountry
ORDER BY ShipCountry

-- Сколько заказов было продано в каждую страну в каждый год
SELECT ShipCountry,YEAR(OrderDate) AS Год, COUNT(*) As Kol
FROM Orders
GROUP BY ShipCountry, YEAR(OrderDate)
ORDER BY ShipCountry, Год

SELECT ship_country, date_part('year', order_date) AS Год, COUNT(*) AS kol
FROM orders
GROUP BY ship_country, date_part('year', order_date)
ORDER BY ship_country, date_part('year', order_date);





-- какие товары принесли выручку больше 10000

-- показать выручку от товара №1
SELECT SUM(UnitPrice*Quantity*(1-Discount)) AS GrandTotal
FROM   [Order Details]
WHERE ProductID = 1

-- какие выручку принес каждый товар
SELECT ProductID, SUM(UnitPrice*Quantity*(1-Discount)) AS GrandTotal
FROM   [Order Details]
GROUP BY ProductID

-- какие товары принесли выручку больше 10000
SELECT ProductID, SUM(UnitPrice*Quantity*(1-Discount)) AS GrandTotal
FROM   [Order Details]
GROUP BY ProductID
HAVING SUM(UnitPrice*Quantity*(1-Discount)) > 10000

-- какие товары принесли выручку больше 10000 (для товаров 1-20)
SELECT ProductID, SUM(UnitPrice*Quantity*(1-Discount)) AS GrandTotal
FROM   [Order Details]
WHERE  ProductID BETWEEN 1 AND 20
GROUP BY ProductID
HAVING SUM(UnitPrice*Quantity*(1-Discount)) > 10000




