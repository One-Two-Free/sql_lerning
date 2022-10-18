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




-- UNION (сложение)

SELECT  Country, City
FROM    Customers
  UNION ALL
SELECT  Country, City
FROM    Employees
ORDER BY Country, City
------------------------------
SELECT  Country, City
FROM    Customers
  UNION  -- без совпадающих строк
SELECT  Country, City
FROM    Employees
ORDER BY Country, City

-----------------------------
SELECT  Country, City, 'Клиент' AS [Тип]
FROM    Customers
  UNION ALL
SELECT  Country, City, 'Сотрудник'
FROM    Employees
ORDER BY Country, City



-- EXCEPT (вычитание строк)

-- список регионов клиентов, где нет сотрудников
SELECT  Country, City
FROM    Customers
  EXCEPT
SELECT  Country, City
FROM    Employees

-- список регионов сотрудников, где нет клиентов
SELECT  Country, City
FROM    Employees
  EXCEPT
SELECT  Country, City
FROM    Customers



-- INTERSECT (пересечение наборов)

-- список регионов клиентов, где есть сотрудники
SELECT  Country, City
FROM    Customers
  INTERSECT
SELECT  Country, City
FROM    Employees



-- подзапрос

-- Сколько заказов оформил каждый продавец (ФИО)?

--1 Список продавцов (из ФИО)
SELECT FirstName + ' '+LastName AS ФИО
FROM   Employees

-- промеж рез-т
-- Сколько заказов оформил продавец №1 (EmployeeID = 1)
-- 2 вложенный запрос
SELECT COUNT(*)
FROM   Orders
WHERE  EmployeeID = 1

-- Итого
SELECT FirstName + ' '+LastName AS ФИО,
       (
		SELECT COUNT(*)
		FROM   Orders AS O
		WHERE  O.EmployeeID = E.EmployeeID  -- условие корреляции
	   ) AS Kol
FROM   Employees AS E
------------------------------------------
SELECT FirstName + ' '+LastName AS ФИО,
       (
		SELECT COUNT(*)
		FROM   Orders
		WHERE  EmployeeID = Employees.EmployeeID  -- условие корреляции
	   ) AS Kol
FROM   Employees




-- Найти макс цену товара в каждой категории (название)

--1 
SELECT CategoryName
FROM   Categories

--2
SELECT MAX(UnitPrice)
FROM   Products
WHERE  CategoryID = 1

-- Итого
SELECT CategoryName,
       (
		SELECT MAX(UnitPrice)
		FROM   Products
		WHERE  CategoryID = Categories.CategoryID
	   ) AS MaxPrice
FROM   Categories




-- Сколько штук товаров продано в каждой категории (название)?

--1
SELECT CategoryName,
       (
	   SELECT SUM(Quantity)
	   FROM   [Order Details]
	   WHERE  ProductID = (...) -- - список продуктов одной категории
	   ) AS Штук
FROM   Categories

-- (...) - список продуктов одной категории

--2
SELECT ProductID
FROM   Products
WHERE  CategoryID = 1

-- Итого
SELECT CategoryName,
       (
	   SELECT SUM(Quantity)
	   FROM   [Order Details]
	   WHERE  ProductID IN 
	          (
				SELECT ProductID
				FROM   Products
				WHERE  CategoryID = Categories.CategoryID			  
			  ) -- - список продуктов одной категории
	   ) AS Штук
FROM   Categories





-- подзапросы

-- Показать заказы клиентов из Мексики
-- 1
SELECT OrderID, OrderDate, CustomerID
FROM Orders

-- 2 определитиь клиентов из Мексики
SELECT CustomerID
FROM   Customers
WHERE  Country = 'Mexico'

-- Итого
SELECT OrderID, OrderDate, CustomerID
FROM Orders
WHERE CustomerID IN 
      (
		SELECT CustomerID
		FROM   Customers
		WHERE  Country = 'Mexico' -- не скалярный, автономный
	  )

-- табличный подзапрос
SELECT CustomerID, OrderID
FROM
	(
	SELECT OrderID, OrderDate, CustomerID
	FROM Orders
	WHERE CustomerID IN 
		  (
			SELECT CustomerID
			FROM   Customers
			WHERE  Country = 'Mexico' -- не скалярный, автономный
		  )
	) AS T1
ORDER BY CustomerID




-- Сколько штук товаров продано в каждую страну?

--1 
SELECT ShipCountry
FROM   Orders
GROUP BY ShipCountry

--2
SELECT  SUM(Quantity)
FROM    [Order Details]
WHERE   OrderID IN (...) -- заказы в одну страну

--2.1
SELECT OrderID
FROM   Orders
WHERE  ShipCountry = 'USA'

-- Итого
SELECT ShipCountry,
       (
		SELECT  SUM(Quantity)
		FROM    [Order Details]
		WHERE   OrderID IN 
		        (
				SELECT OrderID
				FROM   Orders O
				WHERE  O.ShipCountry = CO.ShipCountry
				)
	   ) AS Штук
FROM   Orders CO
GROUP BY ShipCountry
ORDER BY ShipCountry

-- 2 способ -- сколько штук продано в каждом заказе и вывести страну
-- этот вариант эффективнее примерно в 4 раза
SELECT ShipCountry,OrderID,
       (
		SELECT SUM(Quantity)
		FROM [Order Details]
		WHERE OrderID = Orders.OrderID
	   ) AS OrderTotal
FROM   Orders

-- содаем табличный подзапрос
SELECT ShipCountry, SUM(OrderTotal) AS Total
FROM
(
SELECT ShipCountry,OrderID,
       (
		SELECT SUM(Quantity)
		FROM [Order Details]
		WHERE OrderID = Orders.OrderID
	   ) AS OrderTotal
FROM   Orders
) AS T1
GROUP BY ShipCountry
ORDER BY ShipCountry

-- сравнение с 1 вариантом
-- Итого
SELECT ShipCountry,
       (
		SELECT  SUM(Quantity)
		FROM    [Order Details]
		WHERE   OrderID IN 
		        (
				SELECT OrderID
				FROM   Orders
				WHERE  ShipCountry = CO.ShipCountry
				)
	   ) AS Штук
FROM   Orders CO
GROUP BY ShipCountry
ORDER BY ShipCountry


SELECT SUM(Quantity)
FROM [Order Details]
WHERE OrderID = 10248




-- Для каждой категории показать макс цену товара
SELECT CategoryName,
       (
	   SELECT MAX(UnitPrice)
	   FROM  Products
	   WHERE CategoryID = Categories.CategoryID
	   ) AS MaxPrice
FROM   Categories

-- теперь JOIN
SELECT C.CategoryName, MAX(UnitPrice) AS MaxPrice
FROM   Categories AS C JOIN Products AS P
ON     C.CategoryID = P.CategoryID
GROUP BY C.CategoryName

-- теперь JOIN
SELECT C.CategoryName, MAX(UnitPrice) AS MaxPrice
FROM   Categories AS C LEFT JOIN Products AS P
ON     C.CategoryID = P.CategoryID
GROUP BY C.CategoryName




-- Сколько заказов оформил каждый продавец в Лондон
SELECT FirstName + ' '+Lastname AS Name
FROM   Employees 

SELECT COUNT(*)
FROM   Orders
WHERE  EmployeeID = 2
------------------- Подзапросом
SELECT FirstName + ' '+Lastname AS Name,
       (
		SELECT COUNT(*)
		FROM   Orders
		WHERE  EmployeeID = Employees.EmployeeID
		       AND
			   ShipCity = 'London'
	   ) AS Kol
FROM   Employees 
ORDER BY Name

-- теперь через JOIN
---------------------------------------------
SELECT FirstName + ' '+Lastname AS Name,
       (
		SELECT COUNT(*)
		FROM   Orders
		WHERE  EmployeeID = Employees.EmployeeID
		       AND
			   ShipCity = 'London'
	   ) AS Kol
FROM   Employees 
ORDER BY Name


SELECT FirstName + ' '+Lastname AS Name, COUNT(*) AS Kol
FROM   Employees E JOIN Orders O
ON     E.EmployeeID = O.EmployeeID
WHERE  O.ShipCity = 'London'
GROUP BY FirstName + ' '+Lastname
ORDER BY Name
-------------------------------------------
SELECT FirstName + ' '+Lastname AS Name, COUNT(*) AS Kol
FROM   Employees E JOIN Orders O
ON     E.EmployeeID = O.EmployeeID
WHERE  O.ShipCity = 'Paris'
GROUP BY FirstName + ' '+Lastname
ORDER BY Name
--------------------------------------
SELECT FirstName + ' '+Lastname AS Name, COUNT(*) AS Kol
FROM   Employees E LEFT JOIN Orders O
ON     E.EmployeeID = O.EmployeeID
       AND
	   O.ShipCity = 'Paris'
--WHERE  O.ShipCity = 'Paris'
GROUP BY FirstName + ' '+Lastname
ORDER BY Name

-- 1 правильный JOIN + доп условие (в поле ON)

SELECT FirstName + ' '+Lastname AS Name, COUNT(OrderID) AS Kol
FROM   Employees E LEFT JOIN Orders O
ON     E.EmployeeID = O.EmployeeID
       AND
	   O.ShipCity = 'Paris'
GROUP BY FirstName + ' '+Lastname
ORDER BY Name

--2 Считаем правильно кол-во для колонок, кот могут содержать NULL
--   COUNT(любая колонка правой таблицы)






