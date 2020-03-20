create table customer
(
    id_customer     serial not null
        constraint customer_pk
            primary key,
    first_name      varchar(50),
    last_name       varchar(50),
    address         varchar(100),
    phone           varchar(50),
    email           varchar(50),
    passport_number varchar(50)
);

alter table customer
    owner to xrksscovddfxbv;

create table item_rental
(
    id_item_rental serial not null
        constraint item_rental_pk
            primary key,
    id_customer    integer
        constraint item_rental_customer_id_customer_fk
            references customer,
    date_out       timestamp,
    date_returned  timestamp,
    amount_due     money,
    other_detail   varchar(50)
);

alter table item_rental
    owner to xrksscovddfxbv;

create table inventory
(
    id_inventory      serial not null
        constraint inventory_pk
            primary key,
    name              varchar(50),
    sale_price        money,
    in_stock          boolean,
    item_description  varchar(50),
    rental_daily_rate money,
    rental            boolean
);

alter table inventory
    owner to xrksscovddfxbv;

create table "order"
(
    id_order       serial not null
        constraint order_pk
            primary key,
    id_item_rental integer
        constraint order_item_rental_id_item_rental_fk
            references item_rental,
    id_inventory   integer
        constraint order_inventory_id_inventory_fk
            references inventory
);

alter table "order"
    owner to xrksscovddfxbv;

create table account
(
    id_account      serial not null
        constraint account_pk
            primary key,
    id_customer     integer
        constraint account_customer_id_customer_fk
            references customer,
    payment_method  varchar(50),
    account_name    varchar(50),
    account_details varchar(50)
);

alter table account
    owner to xrksscovddfxbv;

create table financial_transaction
(
    id_account     serial
        constraint financial_transaction_account_id_account_fk
            references account,
    id_item_rental integer
        constraint financial_transaction_item_rental_id_item_rental_fk
            references item_rental,
    date           date,
    amount         money,
    comment        varchar(50),
    id_transaction serial not null
        constraint financial_transaction_pk
            primary key
);

alter table financial_transaction
    owner to xrksscovddfxbv;

create unique index financial_transaction_id_transaction_uindex
    on financial_transaction (id_transaction);


