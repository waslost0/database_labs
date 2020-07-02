-- 1. INSERT
INSERT INTO rent_sell_inventory.customer VALUES (DEFAULT, 'Drey', 'Joh', 'Ven, 54 st A', '462548974', 'gjqw@mao.com');

INSERT INTO rent_sell_inventory.inventory (name, in_stock, item_description) VALUES ('shoes', true, 'Shoes Fxr pro');

INSERT INTO rent_sell_inventory.item_rental (id_inventory)  SELECT id_inventory FROM rent_sell_inventory.inventory;

-- 2. DELETE
    -- 1. Всех записей
    DELETE FROM rent_sell_inventory.customer;

    -- 2. По условию
    --DELETE FROM table_name WHERE condition;
    DELETE FROM rent_sell_inventory.customer WHERE passport_number='126126';

    -- 3. Очистить таблицу
    --TRUNCATE
    TRUNCATE rent_sell_inventory.payment;

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
SELECT id_customer, id_item_rental, amount, date_out, date_returned FROM rent_sell_inventory.item_rental WHERE date_returned='2001-10-05 14:06:00';
    --  2. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
    SELECT date_part('year',TIMESTAMP '2001-01-01') FROM rent_sell_inventory.item_rental WHERE id_customer=1;
    SELECT EXTRACT(YEAR FROM TIMESTAMP '2002-01-01') FROM rent_sell_inventory.item_rental WHERE id_customer=1;

-- 7. SELECT GROUP BY с функциями агрегации
    -- 1. MIN
    SELECT name,  MIN(rental_daily_rate)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 2. MAX
    SELECT name,  MAX(rental_daily_rate)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 3. AVG
    SELECT name,  AVG(rental_daily_rate::numeric)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 4. SUM
    SELECT name,  SUM(rental_daily_rate)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;
    -- 5. COUNT
    SELECT name,  COUNT(rental_daily_rate)
    FROM  rent_sell_inventory.inventory
    GROUP BY name;


-- 8. SELECT GROUP BY + HAVING
    SELECT id_customer,  min(amount)
    FROM  rent_sell_inventory.payment
    GROUP BY id_customer
    HAVING min(amount::numeric) > 100;


    SELECT id_customer,  sum(amount)
    FROM  rent_sell_inventory.payment
    GROUP BY id_customer
    HAVING sum(amount::numeric) > 1000;


    SELECT payment.id_staff, first_name, last_name , sum(amount)
    FROM  rent_sell_inventory.payment
    LEFT JOIN rent_sell_inventory.staff ON rent_sell_inventory.staff.id_staff = rent_sell_inventory.payment.id_staff
    GROUP BY payment.id_staff, first_name, last_name
    HAVING  AVG(amount::numeric) > 500;

-- 9. SELECT JOIN
    -- 1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
    SELECT first_name, last_name, amount, payment_date
    FROM rent_sell_inventory.staff
    LEFT JOIN rent_sell_inventory.payment ON rent_sell_inventory.payment.id_staff = rent_sell_inventory.staff.id_staff
    WHERE amount::numeric IS NOT NULL;

    -- 2. RIGHT JOIN. Получить такую же выборку, как и в 9.1
    SELECT first_name, last_name, amount, payment_date
    FROM rent_sell_inventory.staff
    RIGHT JOIN rent_sell_inventory.payment ON rent_sell_inventory.payment.id_staff = rent_sell_inventory.staff.id_staff
    WHERE amount::numeric IS NOT NULL;

    --3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
    SELECT staff.id_staff,
           staff.id_staff,
           staff.first_name,
           staff.last_name,
           payment.amount,
           payment_date
    FROM rent_sell_inventory.staff
    LEFT JOIN rent_sell_inventory.payment ON staff.id_staff = payment.id_staff
    LEFT JOIN rent_sell_inventory.item_rental ON payment.id_payment = item_rental.id_payment
    WHERE staff.id_staff = 5 AND date(payment_date) > date('2020-01-01') AND payment.amount::numeric > 400;

    SELECT * FROM rent_sell_inventory.inventory FULL OUTER JOIN rent_sell_inventory.item_rental ON inventory.id_inventory = item_rental.id_inventory;

-- 10. Подзапросы
     -- 1. Написать запрос с WHERE IN (подзапрос)
    SELECT * FROM rent_sell_inventory.item_rental WHERE date(date_out) IN (date('1999-10-05'), date('2001-11-05'));
    SELECT name, item_description, rental_daily_rate FROM rent_sell_inventory.inventory WHERE id_inventory IN (SELECT item_rental.id_inventory FROM rent_sell_inventory.item_rental);



