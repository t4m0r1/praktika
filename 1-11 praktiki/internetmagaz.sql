
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    recommended_by INT,
    FOREIGN KEY (recommended_by) REFERENCES Customers(customer_id)
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers (customer_id, full_name, email, registration_date, recommended_by) VALUES
(1, 'Иван Иванов', 'ivan.ivanov@example.com', '2023-01-15', NULL),
(2, 'Мария Петрова', 'maria.petrova@example.com', '2023-02-20', 1),
(3, 'Алексей Смирнов', 'alex.smirnov@example.com', '2023-03-10', 1),
(4, 'Елена Васильева', 'elena.v@example.com', '2023-04-01', 2),
(5, 'Андрей Николаев', 'andrey.n@example.com', '2023-05-01', NULL);

INSERT INTO Products (product_name, category, price) VALUES
('Смартфон', 'Электроника', 70000.00),
('Ноутбук', 'Электроника', 120000.00),
('Кофемашина', 'Бытовая техника', 25000.00),
('Книга "Основы SQL"', 'Книги', 1500.00),
('Фен', 'Бытовая техника', 4500.00),
('Пылесос', 'Бытовая техника', 15000.00);

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-05-10', 'Доставлен'),
(2, '2024-05-12', 'В обработке'),
(1, '2024-05-15', 'Отправлен'),
(3, '2024-05-16', 'Доставлен');

INSERT INTO Order_Items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 70000.00),  -- Иван купил Смартфон
(1, 4, 2, 1400.00),   -- и 2 книги
(2, 2, 1, 120000.00), -- Мария купила Ноутбук
(3, 3, 1, 25000.00),  -- Иван купил Кофемашину
(4, 1, 1, 70000.00),  -- Алексей купил Смартфон
(4, 5, 1, 4500.00);   -- и Фен

-- Задание 1: Заказы и их владельцы (INNER JOIN)
-- Напишите запрос, который выводит список всех заказов. В результате должны быть две колонки: имя покупателя (`full_name`) и дата заказа (`order_date`).
SELECT
    c.full_name,
    o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

-- Задание 2: Покупатели без заказов (LEFT JOIN)
-- Используя `LEFT JOIN`, найдите всех покупателей, которые еще не сделали ни одного заказа. В результате должно быть только имя покупателя.
SELECT
    c.full_name,
    o.order_id,
    o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- Задание 3: Состав конкретного заказа (Multi-JOIN)
-- Напишите запрос для вывода всех позиций заказа с `order_id = 1`. Результат должен включать название товара (`product_name`), количество (`quantity`) и цену за единицу (`price_per_unit`).
SELECT
    p.product_name,
    oi.quantity,
    oi.price_per_unit
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_id = 1;

-- Задание 4: Покупатели определенного товара (Подзапрос с IN)
-- С помощью подзапроса найдите имена всех покупателей, которые заказывали 'Смартфон'.

SELECT full_name
FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE p.product_name = 'Смартфон'
);

-- Задание 5: Дорогие товары (Скалярный подзапрос)
-- Напишите запрос, который находит все товары, цена которых выше средней цены всех товаров в магазине.
SELECT product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- Задание 6: Заказы с дорогими товарами (Коррелирующий подзапрос c EXISTS)
-- Используя коррелирующий подзапрос с оператором `EXISTS`, найдите все заказы (`order_id`, `order_date`), которые содержат хотя бы один товар дороже 100 000.
SELECT
    order_id,
    order_date
FROM Orders o
WHERE EXISTS (
    SELECT 1
    FROM Order_Items oi
    WHERE oi.order_id = o.order_id 
    AND oi.price_per_unit > 100000
);

-- Задание 7 (со звездочкой): Сравнение подходов
-- Найдите всех покупателей, которые НЕ заказывали 'Ноутбук'. Решите эту задачу двумя способами:

-- Используя `LEFT JOIN`.
SELECT c.full_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id AND p.product_name = 'Ноутбук'
WHERE p.product_id IS NULL;

-- Используя подзапрос с `NOT IN`.
SELECT c.full_name
FROM Customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE p.product_name = 'Ноутбук'
);

-- Задание 8: Товары, которые еще никто не заказывал (RIGHT JOIN или LEFT JOIN с IS NULL)
-- Найдите все товары, которые еще ни разу не были заказаны. Выведите их названия. Решите задачу, используя `RIGHT JOIN` (или `LEFT JOIN` с соответствующим условием).
SELECT p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Задание 9: Полный список активности (FULL OUTER JOIN)
-- Выведите полный список всех покупателей, всех товаров и все их заказы. Включите покупателей, которые не делали заказов, и товары, которые не были заказаны. 
-- Для записей без совпадений должны быть `NULL` значения. Выведите имя покупателя, название товара и количество.
-- Способ 1: Используя UNION для эмуляции FULL OUTER JOIN
SELECT 
    c.full_name AS full_name,
    p.product_name AS product_name,
    oi.quantity AS quantity
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id

UNION

SELECT 
    c.full_name AS full_name,
    p.product_name AS product_name,
    oi.quantity AS quantity
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id
RIGHT JOIN Order_Items oi ON o.order_id = oi.order_id
RIGHT JOIN Products p ON oi.product_id = p.product_id;

-- Задание 10: Покупатели, купившие самый дорогой товар (JOIN vs Подзапрос)
-- Найдите имена покупателей, которые купили самый дорогой товар. Решите задачу двумя способами:
-- Используя `JOIN` с подзапросом.
SELECT DISTINCT c.full_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE oi.price_per_unit = (
    SELECT MAX(price_per_unit) 
    FROM Order_Items
);

-- Используя только подзапросы (без явного `JOIN` в основном запросе, если возможно).
SELECT full_name
FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    WHERE o.order_id IN (
        SELECT order_id
        FROM Order_Items
        WHERE price_per_unit = (
            SELECT MAX(price_per_unit)
            FROM Order_Items
        )
    )
);

-- Задание 11: Все возможные пары "покупатель-категория" (CROSS JOIN)
-- Напишите запрос, который выведет все возможные комбинации имен покупателей 
-- и категорий товаров. Это может быть полезно для создания отчета, где нужно показать все возможные варианты, даже если покупок в данной категории не было.
SELECT 
    c.full_name AS full_name,
    p.category AS category
FROM Customers c
CROSS JOIN (
    SELECT DISTINCT category 
    FROM Products
) p
ORDER BY c.full_name, p.category;

-- Задание 12: Кто кого порекомендовал (SELF JOIN)
-- Используя `SELF JOIN` на таблице `Customers`, выведите список покупателей и тех, кто их порекомендовал. 
-- Результат должен содержать два столбца: `new_customer` (имя нового покупателя) и `recommended_by` (имя того, кто его порекомендовал).
-- Задание 12: Кто кого порекомендовал (SELF JOIN)
SELECT 
    new_cust.full_name AS new_customer,
    rec_by.full_name AS recommended_by
FROM Customers new_cust
LEFT JOIN Customers rec_by ON new_cust.recommended_by = rec_by.customer_id
ORDER BY new_cust.full_name;