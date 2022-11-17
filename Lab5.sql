create database lab5;

create table if not exists Warehouses(
    code integer primary key,
    location varchar(255),
    capacity integer
);

create table if not exists Boxes(
    code char(4),
    contents varchar(255),
    value real,
    warehouses integer references Warehouses(code)
);

--Select all warehouses with all columns.
select * from Warehouses;

--Select all boxes with a value larger than $150.
select * from Boxes
where value > 150;

--Select all the boxes distinct by contents.
select distinct on (contents) * from Boxes;

--Select the warehouse code and the number of the boxes in each warehouse.
select warehouses as warehouse_code, count(warehouses) as number_of_boxes from Boxes
group by warehouses;

--Same as previous exercise, but select only those warehouses where the number of the boxes is greater than 2.
select warehouses as warehouse_code, count(warehouses) as number_of_boxes from Boxes
group by warehouses
having count(warehouses) > 2;

--Create a new warehouse in New York with a capacity for 3 boxes.
insert into Warehouses(code, location, capacity)
values (6, 'New York', 3);
select * from Warehouses;

--Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
insert into Boxes(code, contents, value, warehouses)
values ('H5RT', 'Papers', 200, 2);
select * from Boxes;

--Reduce the value of the third largest box by 15%.
update Boxes
set value = value * 0.85
where value = (select distinct value from Boxes
                            order by value desc limit 1 offset 2);
select * from Boxes order by value desc;

--Remove all boxes with a value lower than $150.
delete from Boxes
where value < 150;
select * from Boxes;

--Remove all boxes which is located in New York. Statement should return all deleted data.
delete from Boxes
where warehouses = any(select code from Warehouses
                                   where location = 'New York')
returning *;
select * from Boxes;
