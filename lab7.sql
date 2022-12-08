--1. Create a function that:

--a. Increments given values by 1 and returns it.
create or replace function increment(val integer)
    returns integer
as
$$
begin
    return val+1;
end;
$$
    language plpgsql;

select increment(2);

--b. Returns sum of 2 numbers.
create function summa (a integer, b integer)
    returns integer
as
$$
begin
    return a+b;
end;
$$
    language plpgsql;

select summa(2, 9);

--c. Returns true or false if numbers are divisible by 2.
create function divisible(val integer)
    returns bool
as
$$
begin
    if(val % 2 = 0) then
        return true;
    else
        return false;
    end if;
end;
$$
    language plpgsql;

select divisible(4);

--d. Checks some password for validity.
create function checker(password text)
returns bool
as
$$
begin
    if(length(password) < 6) then
        return false;
    else
        return true;
    end if;
end;
$$
    language plpgsql;

select checker('bbbb');

--e. Returns two outputs, but has one input.
create function twooutputs(inp integer, out plus integer, out minus integer)
as
$$
begin
    plus := inp + 1;
    minus := inp - 1;
end;
$$
    language plpgsql;

select * from twooutputs(3);

--2. Create a trigger that:

--a. Return timestamp of the occured action within the database.
create table t(id int, txt text);
create table out( id int generated always as identity , time timestamp(6));
create function tmstamp()
    returns trigger
    as
    $$
    begin
        insert into out(time) values (now());
        return new;
    end;
    $$
    language  plpgsql;
    create trigger change
        before insert
        on t
        for each statement
        execute procedure tmstamp();

insert into t(txt) VALUES ('bjsabjdsjb');
select * from out;

--b. Computes the age of a person when persons’ date of birth is inserted.
create table t2 (id int generated always as identity , birthdate timestamp);
create table out2( id int generated always as identity,  years int);
create function getage()
    returns trigger
    as $$
    begin
        insert into out2(years) values (extract(year from now())-extract(year from new.birthdate));
        return new;
    end;
    $$
    language plpgsql;

    create trigger yearst
        before insert
        on t2
        for each row
        execute procedure getage();

insert into t2(birthdate) values (now());
select * from out2;

--c. Adds 12% tax on the price of the inserted item.
create table t3 (id int generated always as identity , price int);
create table out3( id int generated always as identity,  price int);
create function increase()
    returns trigger
    as
    $$
    begin
        new.price:=new.price*1.12;
        return new;
    end;
    $$
    language plpgsql;

create trigger incprice
    before insert
    on t3
    for each row
    execute procedure increase();

insert into t3(price) values (300);
select * from t3;

--d. Prevents deletion of any row from only one table.
create function dont()
    returns trigger
    as
    $$
    begin
        raise exception using message = 'S 167', detail = 'D 167', hint = 'H 167', errcode = 'P3333';
    end;
    $$
    language plpgsql;

create trigger dontdel
    before delete
    on t3
    for each row
    execute procedure dont();

insert into t3(price) values (120);
select * from t3;

--e. Launches functions 1.d and 1.e.
create function pass(s text)
    returns bool
    as
    $$
    begin
        return (char_length(s)>=8) and ((strpos(s,'!')>0) or (strpos(s,'@')>0) or (strpos(s,'#')>0) or (strpos(s,'$')>0) or (strpos(s,'%')>0));
    end;
    $$
    language plpgsql;

create function L_S(s text, out len int, out symb boolean)
    as
    $$
    begin
        len:=char_length(s);
        symb=(strpos(s,'!')>0) or (strpos(s,'@')>0) or (strpos(s,'#')>0) or (strpos(s,'$')>0) or (strpos(s,'%')>0);
    end;
    $$
    language plpgsql;
--3.Create procedures that:

--a) Increases salary by 10% for every 2 years of work experience and provides
--10% discount and after 5 years adds 1% to the discount.
--b) After reaching 40 years, increase salary by 15%. If work experience is more
--than 8 years, increase salary for 15% of the already increased value for work
--experience and provide a constant 20% discount

create table t16 (id int primary key ,name varchar(20), date_of_birth date, age int, salary int,workexperience int , discount int );
insert into t16 values (1,'jagdja','2000-11-23',14,4000, 20, 1000);
insert into t16 values (4,'jjjg','2000-11-23',10,500000, 1, 2000);
insert into t16 values (5,'pixoa','2000-11-23',1,6000, 10, 3000);
insert into t16 values (2,'ppsij','2000-11-23',2,50, 5, 4000);
insert into t16 values (3,'AAAD','2000-11-23',122,3000, 2, 5000);
insert into t16 values (6,'ugcu','2000-11-23',136,1000, 36, 6000);

select * from t16;
begin;
    update t16 set salary=salary*1.1*(workexperience/2);
    update t16 set discount=discount*1.01 where workexperience>5;
end;

begin;
    update t16 set salary=salary*1.15 where age>=40;
    update t16 set salary=salary*1.15 where workexperience>=8;
    update t16 set discount=discount*1.2 where workexperience>=8;
end;

select * from t16;