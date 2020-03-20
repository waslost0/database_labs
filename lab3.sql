-- 1. INSERT
INSERT INTO rent_sell_inventory.customer VALUES (DEFAULT, 'Drey', 'Joh', 'Ven, 54 st A', '462548974', 'gjqw@mao.com');

INSERT INTO rent_sell_inventory.inventory (name, sale_price, in_stock, item_description) VALUES ('shoes', 250, true, 'Shoes Fxr pro');

INSERT INTO rent_sell_inventory.order (id_inventory)  SELECT id_inventory FROM rent_sell_inventory.inventory;

-- 2. DELETE
    -- noinspection SqlWithoutWhere
    -- 1. Всех записей
    DELETE FROM rent_sell_inventory."order";

    -- 2. По условию
    --DELETE FROM table_name WHERE condition;
    DELETE FROM rent_sell_inventory."order" WHERE id_item_rental=1;

    -- 3. Очистить таблицу
    --TRUNCATE
    TRUNCATE rent_sell_inventory."order";

-- 3. UPDATE
    -- 1. Всех записей
    UPDATE rent_sell_inventory.customer SET first_name='Alex',  last_name='Brown', address='New addres', phone='546843654', email='asfqw@,ad.com';
    -- 2. По условию обновляя один атрибут
    UPDATE rent_sell_inventory.customer SET phone='41561654' WHERE first_name='Alex' AND last_name='Drown' AND email='asfqw@,ad.com';
	--3. По условию обновляя несколько атрибутов
    UPDATE rent_sell_inventory.customer SET first_name='John', last_name='Cena' WHERE passport_number='786753415378';

-- 4. SELECT
    -- 1. С определенным набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
    SELECT first_name, last_name, phone, email FROM rent_sell_inventory.customer;
    -- 2. Со всеми атрибутами (SELECT * FROM...)
    SELECT * FROM rent_sell_inventory.customer;
    -- 3. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = "")
    SELECT * FROM rent_sell_inventory.customer WHERE passport_number='45686756756';

-- 5. SELECT ORDER BY + TOP (LIMIT)
    --  1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
    SELECT * FROM rent_sell_inventory.customer
    ORDER BY last_name
    LIMIT 5;
    -- 2. С сортировкой по убыванию DESC
    SELECT * FROM rent_sell_inventory.customer
    ORDER BY id_customer DESC;
    -- 3. С сортировкой по двум атрибутам + ограничение вывода количества записей
    SELECT * FROM rent_sell_inventory.customer
    ORDER BY last_name, passport_number
    LIMIT 5;
    -- 4. С сортировкой по первому атрибуту, из списка извлекаемых
    SELECT first_name, last_name, passport_number FROM rent_sell_inventory.customer
    ORDER BY first_name;

-- 6. Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
    -- 1. WHERE по дате
    SELECT id_customer, id_item_rental, amount_due, date_out, date_returned FROM rent_sell_inventory.item_rental WHERE date_returned='2001-10-05 14:06:00';
    --  2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
    SELECT date_part('year',TIMESTAMP '2001-01-01') FROM rent_sell_inventory.item_rental WHERE id_customer=1;
    SELECT EXTRACT(YEAR FROM TIMESTAMP '2002-01-01') FROM rent_sell_inventory.item_rental WHERE id_customer=1;

-- 7. SELECT GROUP BY с функциями агрегации
    -- 1. MIN
    SELECT name,  MIN(sale_price)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 2. MAX
    SELECT name,  MAX(sale_price)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 3. AVG
    SELECT name,  AVG(sale_price::numeric)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 4. SUM
    SELECT name,  SUM(sale_price)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 5. COUNT
    SELECT name,  COUNT(sale_price)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;


-- 8. SELECT GROUP BY + HAVING
    SELECT name,  SUM(sale_price)
    FROM  rent_sell_inventory.inventory
    GROUP BY name
    HAVING SUM(sale_price::numeric) > 560;


    SELECT id_account,  MAX(amount)
    FROM  rent_sell_inventory.financial_transaction
    GROUP BY id_account
    HAVING MAX(amount::numeric) > 400;


    SELECT id_account, AVG(amount::numeric)
    FROM  rent_sell_inventory.financial_transaction
    GROUP BY id_account
    HAVING  AVG(amount::numeric) < 300;

-- 9. SELECT JOIN
    -- 1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
    SELECT
        inventory.name,
        inventory.sale_price,
        rent_sell_inventory.order.id_order
    FROM
        rent_sell_inventory.order
    LEFT JOIN rent_sell_inventory.inventory ON rent_sell_inventory.inventory.id_inventory = rent_sell_inventory.order.id_inventory
    WHERE inventory.sale_price::numeric > 260;

    -- 2. RIGHT JOIN. Получить такую же выборку, как и в 5.1
    SELECT * FROM rent_sell_inventory.customer
    ORDER BY last_name
    LIMIT 5;

    SELECT *
    FROM  rent_sell_inventory.customer
    RIGHT JOIN rent_sell_inventory.account
    ON customer.id_customer = account.id_account
    ORDER BY last_name
    LIMIT 5;

    SELECT
        customer.first_name,
        customer.last_name,
        customer.passport_number,
        account.payment_method,
        item_rental.date_out,
        item_rental.date_returned,
        item_rental.amount_due
    FROM rent_sell_inventory.customer as customer
    LEFT JOIN rent_sell_inventory.account as account ON customer.id_customer = account.id_customer
    LEFT JOIN rent_sell_inventory.item_rental  ON customer.id_customer = item_rental.id_customer
    WHERE payment_method='card' AND amount_due::numeric > 40 OR date_returned='2010-10-05 14:06:00';

    SELECT * FROM rent_sell_inventory.inventory FULL OUTER JOIN rent_sell_inventory.order ON inventory.id_inventory = "order".id_inventory;

-- 10. Подзапросы
     -- 1. Написать запрос с WHERE IN (подзапрос)
    SELECT item_rental.id_customer, item_rental.amount_due FROM rent_sell_inventory.item_rental WHERE date(date_out) IN (date('1999-10-05'), date('2001-11-05'));
    SELECT name, item_description, sale_price FROM rent_sell_inventory.inventory WHERE id_inventory IN (SELECT "order".id_inventory FROM rent_sell_inventory."order");



