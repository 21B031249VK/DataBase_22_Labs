create table dealer (
    id integer primary key ,
    name varchar(255),
    location varchar(255),
    charge float
);

INSERT INTO dealer (id, name, location, charge) VALUES (101, 'Ерлан', 'Алматы', 0.15);
INSERT INTO dealer (id, name, location, charge) VALUES (102, 'Жасмин', 'Караганда', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (105, 'Азамат', 'Нур-Султан', 0.11);
INSERT INTO dealer (id, name, location, charge) VALUES (106, 'Канат', 'Караганда', 0.14);
INSERT INTO dealer (id, name, location, charge) VALUES (107, 'Евгений', 'Атырау', 0.13);
INSERT INTO dealer (id, name, location, charge) VALUES (103, 'Жулдыз', 'Актобе', 0.12);

create table client (
    id integer primary key ,
    name varchar(255),
    city varchar(255),
    priority integer,
    dealer_id integer references dealer(id)
);

INSERT INTO client (id, name, city, priority, dealer_id) VALUES (802, 'Айша', 'Алматы', 100, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (807, 'Даулет', 'Алматы', 200, 101);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (805, 'Али', 'Кокшетау', 200, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (808, 'Ильяс', 'Нур-Султан', 300, 102);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (804, 'Алия', 'Караганда', 300, 106);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (809, 'Саша', 'Шымкент', 100, 103);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (803, 'Маша', 'Семей', 200, 107);
INSERT INTO client (id, name, city, priority, dealer_id) VALUES (801, 'Максат', 'Нур-Султан', null, 105);

create table sell (
    id integer primary key,
    amount float,
    date timestamp,
    client_id integer references client(id),
    dealer_id integer references dealer(id)
);

INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (201, 150.5, '2012-10-05 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (209, 270.65, '2012-09-10 00:00:00.000000', 801, 105);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (202, 65.26, '2012-10-05 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (204, 110.5, '2012-08-17 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (207, 948.5, '2012-09-10 00:00:00.000000', 805, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (205, 2400.6, '2012-07-27 00:00:00.000000', 807, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (208, 5760, '2012-09-10 00:00:00.000000', 802, 101);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (210, 1983.43, '2012-10-10 00:00:00.000000', 804, 106);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (203, 2480.4, '2012-10-10 00:00:00.000000', 809, 103);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (212, 250.45, '2012-06-27 00:00:00.000000', 808, 102);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (211, 75.29, '2012-08-17 00:00:00.000000', 803, 107);
INSERT INTO sell (id, amount, date, client_id, dealer_id) VALUES (213, 3045.6, '2012-04-25 00:00:00.000000', 802, 101);

-- drop table client;
-- drop table dealer;
-- drop table sell;

--1. Write a SQL query using Joins:
--a. combine each row of dealer table with each row of client table
select * from dealer d
full outer join client c on d.id = c.dealer_id;

--b. find all dealers along with client name, city, grade, sell number, date, and amount
select d.name, c.name, c.city, c.priority, s.date, s.amount from dealer d
left join client c on d.id = c.dealer_id
left join sell s on c.id = s.client_id;

--c. find the dealer and client who belongs to same city
select d.name, c.name, c.city from dealer d
join client c on d.location = c.city;

--d. find sell id, amount, client name, city those sells where sell amount exists between 100 and 500
select s.id, s.amount, c.name, d.location from sell s
join client c on s.client_id = c.id
join dealer d on c.dealer_id = d.id
where s.amount >= 100 and s.amount <= 500;

--e. find dealers who works either for one or more client or not yet join under any of the clients
select * from dealer d
full outer join client c on d.id = c.dealer_id;

--f. find the dealers and the clients he service, return client name, city, dealer name commission.
select c.name, c.city, d.name, d.charge from dealer d
join client c on d.id = c.dealer_id;

--g. find client name, client city, dealer, commission those dealers who received a
--commission from the sell more than 12%
select c.name, c.city, d.name, d.charge from dealer d
join client c on d.id = c.dealer_id
where d.charge > 0.12;

--h. make a report with client name, city, sell id, sell date, sell amount, dealer name
--and commission to find that either any of the existing clients haven’t made a
--purchase(sell) or made one or more purchase(sell) by their dealer or by own.
select c.name, c.city, s.id, s.date, s.amount, d.name, d.charge from client c
left join sell s on c.id = s.client_id
left join dealer d on d.id = c.dealer_id;

--i. find dealers who either work for one or more clients. The client may have made,
--either one or more purchases, or purchase amount above 2000 and must have a
--grade, or he may not have made any purchase to the associated dealer. Print
--client name, client grade, dealer name, sell id, sell amount
select c.name, c.priority, d.name, s.id, s.amount from dealer d
join client c on d.id = c.dealer_id
join sell s on c.id = s.client_id;

--2. Create following views:
--a. count the number of unique clients, compute average and total purchase amount of client orders by each date.
create or replace view a as
    select count(distinct c.id), avg(s.amount), sum(s.amount), s.date from client c
    join sell s on c.id = s.client_id
    group by s.date;
select * from a;

--b. find top 5 dates with the greatest total sell amount
create or replace view b as
    select date, sum(amount) from sell
    group by date
    order by sum(amount) desc limit 5;
select * from b;

--c. count the number of sales, compute average and total amount of all sales of each dealer
create or replace view c as
    select dealer_id, count(dealer_id), avg(amount), sum(amount) from sell
    group by dealer_id;
select * from c;

--d. compute how much all dealers earned from charge(total sell amount * charge) in each location
create or replace view d as
    select d.location, sum(amount) as total, sum(s.amount * d.charge) as earned from sell s
    join dealer d on s.dealer_id = d.id
    group by d.location;
select * from d;

--e. compute number of sales, average and total amount of all sales dealers made in each location
create or replace view e as
    select d.location, count(s.dealer_id), avg(s.amount), sum(s.amount) from sell s
    join dealer d on s.dealer_id = d.id
    group by d.location;
select * from e;

--f. compute number of sales, average and total amount of expenses in each city clients made.
create or replace view f as
    select c.city, count(s.client_id), avg(s.amount), sum(s.amount) from sell s
    join client c on s.client_id = c.id
    group by c.city;
select * from f;

--g. find cities where total expenses more than total amount of sales in locations
create or replace view g as
    select c.city, sum(s.amount) from sell s
    join client c on s.client_id = c.id
    group by c.city
    having sum(s.amount) > any(select sum(s2.amount) from sell s2
                            join dealer d on s2.dealer_id = d.id
                            group by d.location);
select * from g;