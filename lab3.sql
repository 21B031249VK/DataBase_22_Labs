drop table customers;

create table customers
(
  	id              serial primary key,
   	full_name       varchar(100),
   	timestamp       timestamp,
    delivery_addres text
);

delete from customers
where full_name = 'John';

alter table customers
    add column age integer;

insert into customers (full_name, age, timestamp, delivery_addres)
VALUES ('John', 44, current_timestamp , 'jbjs street, 55');

select *
from customers;

Create table products
(
	id              varchar primary key,
	name            varchar(100),
    description     text,
    price           double precision
);

create table orders
(
  	code            serial primary key,
   	customer_id     integer references customers (id),
   	total_sum       double precision,
    is_paid         boolean

);

create table order_items
(
  	order_code      integer references orders (code),
   	product_id      varchar references products (id),
   	quantity        integer
);



create table student
(
    full_name           varchar(100) primary key,
    age                 integer,
    birthdate           date,
    gender              varchar(100),
    av_grade            double precision,
    need_of_dormitory   boolean,
    info_about_ys       text,
    additional_info     text
);

create table instructor
(
    full_name           varchar(100) primary key,
    languages           varchar(100),
    work_experience     text,
    online_lessons      boolean
);

create table lesson_participants
(
    lesson_title        varchar(100),
    room_number         integer,
    lesson_student      varchar references student (full_name),
    lesson_instructor   varchar references instructor (full_name)
);




