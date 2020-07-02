-- 1. Добавить внешние ключи
alter table booking
	add constraint booking_client_id_client_fk
		foreign key (id_client) references client;

alter table room_in_booking
	add constraint room_in_booking_booking_id_booking_fk
		foreign key (id_booking) references booking;

alter table room_in_booking
	add constraint room_in_booking_room_id_room_fk
		foreign key (id_room) references room;

alter table room
	add constraint room_hotel_id_hotel_fk
		foreign key (id_hotel) references hotel;

alter table room
	add constraint room_room_category_id_room_category_fk
		foreign key (id_room_category) references room_category;

-- 2. Выдать информацию о клиентах гостиницы “Космос”, проживающих в номерах категории “Люкс” на 1 апреля 2019г.
select client.id_client, client.name, client.phone
from booking
    left join client on client.id_client = booking.id_client
    left join room_in_booking on room_in_booking.id_booking = booking.id_booking
    left join room on room_in_booking.id_room = room.id_room
    left join hotel on room.id_hotel = hotel.id_hotel
    left join room_category on room.id_room_category = room_category.id_room_category
where hotel.name = 'Космос'
    and room_category.name = 'Люкс'
    and room_in_booking.checkin_date <= '2019-04-01'
    and room_in_booking.checkout_date >= '2019-04-01';

-- 3. Дать список свободных номеров всех гостиниц на 22 апреля
select room.id_room, room.id_hotel, room.id_room_category, room.number, room.price from room
where room.id_room not in (select room_in_booking.id_room from room_in_booking
     where checkin_date <= '2019-04-22'
        and checkout_date >= '2019-04-22');

-- 4. Дать количество проживающих в гостинице "Космос" на 23 марта по каждой категории номеров
select rc.name, count(rc.name) from room
left join room_in_booking rib on room.id_room = rib.id_room
left join room_category rc on room.id_room_category = rc.id_room_category
left join hotel h on room.id_hotel = h.id_hotel
where h.name = 'Космос'
    and checkin_date <= '2019-03-23'
    and checkout_date > '2019-03-23'
group by rc.name;


--5. Дать список последних проживавших клиентов по всем комнатам гостиницы “Космос”, выехавшим в апреле с указанием даты выезда
select client.name, room.id_room, checkout_max FROM room
    left join (SELECT id_room, MAX(checkout_date) AS checkout_max FROM room_in_booking
        where checkout_date >= '2019-04-01' and checkout_date <= '2019-04-30'
        group by id_room) AS max_checkout ON room.id_room = max_checkout.id_room
    left join room_in_booking ON room_in_booking.id_room = room.id_room
    left join booking ON booking.id_booking = room_in_booking.id_booking
    left join client ON client.id_client = booking.id_client
    left join hotel on room.id_hotel = hotel.id_hotel
where hotel.name = 'Космос' and checkout_date = checkout_max;

--6  Продлить на 2 дня дату проживания в гостинице “Космос” всем клиентам комнат категории “Бизнес”, которые заселились 10 мая
update room_in_booking
set checkout_date = checkout_date + interval '2 days'
where id_room in (select room_in_booking.id_room from room
    left join room_in_booking ON room_in_booking.id_room = room.id_room
where id_hotel = 1 and id_room_category = 3 and checkin_date = '2019-05-10');

select checkout_date, checkin_date from room
    left join room_in_booking ON room_in_booking.id_room = room.id_room
where id_hotel = 1 and id_room_category = 3 and checkin_date = '2019-05-10';

--7. Найти все "пересекающиеся" варианты проживания. Правильное состояние:не может быть забронирован один номер на одну
--  дату несколько раз, т.к. нельзя заселиться нескольким клиентам в один номер.
--  Записи в таблице room_in_booking с id_room_in_booking = 5 и 2154 являются примером неправильного с остояния,
--  которые необходимо найти. Результирующий кортеж выборки должен содержать информацию о двух конфликтующих номерах.
select rib1.id_room,
       rib2.id_room,
       rib1.checkin_date,
       rib1.checkout_date,
       rib2.checkin_date,
       rib2.checkout_date
       from room_in_booking rib1
left join room_in_booking as rib2 on rib1.id_room = rib2.id_room
where rib1.id_room = rib2.id_room
    and (rib1.checkin_date < rib2.checkin_date and rib2.checkin_date < rib1.checkout_date);

--8. Создать бронирование в транзакции.
-- select setval('booking_id_booking_seq1'::regclass,2501,false);

begin transaction;
	insert into booking
	values (DEFAULT, 7, now());
commit;

--9
create index room_category_name_id_room_category_index
	on room_category (name);

create index hotel_name_index
	on hotel (name);



