--a.Find all courses worth more than 3 credits;
select * from course
where credits > 3;

--b.Find all classrooms situated either in ‘Watson’ or ‘Packard’ buildings;
select * from classroom
where building = 'Packard' or building  = 'Watson';

--c.Find all courses offered by the Computer Science department;
select * from course
where dept_name = 'Comp. Sci.';

--d.Find all courses offered during fall;
select * from section
where semester  = 'Fall';

--e.Find all students who have more than 45 credits but less than 90;
select * from student
where tot_cred > 45 and tot_cred < 90;

--f.Find all students whose names end with vowels;
select * from student
where name like '%a'
    or name like '%e'
    or name like '%i'
    or name like '%o'
    or name like '%u';
--where right (name, 1) in ('a', 'e', 'i', 'o', 'u');

--g.Find all courses which have course ‘CS-101’ as their prerequisite;
select * from prereq
where prereq_id = 'CS-101';


--a.For each department, find the average salary of instructors in that department and list them in ascending order.
-- Assume that every department has at least one instructor;
select dept_name, avg(salary)
from instructor
group by dept_name
order by avg(salary);

--b.Find the building where the biggest number of courses takes place;
select building, count(building)
from section
group by building
order by count(building) desc limit 1;

--c.Find the department with the lowest number of courses offered;
select dept_name, count(dept_name)
from course
group by dept_name
having count(dept_name)<= all(select count(dept_name) from course)
and
    count(dept_name) = (select min(number_of_crss)
                        from
                            (select count(dept_name) as number_of_crss
                             from course
                             group by dept_name) as min);
--order by count(dept_name) asc;

--d.Find the ID and name of each student who has taken more than 3 courses from the Computer Science department;
select id, count(course_id)
from takes
where course_id = any(select course_id
        from course
        where dept_name = 'Comp. Sci.')
group by id
having count(course_id) > 3;

--e.Find all instructors who work either in Biology, Philosophy, or Music departments;
select *
from instructor
where dept_name = 'Music'
   or dept_name = 'Biology'
   or dept_name = 'Philosophy';

--f.Find all instructors who taught in the 2018 year but not in the 2017 year;
select id, name
from instructor
where id = any(select id
            from teaches
            where year = 2018
              except
            select id
            from teaches
            where year = 2017)
group by id;


--a.Find all students who have taken Comp. Sci. course and got an excellent grade (i.e., A, or A-) and sort them alphabetically;
select id, name
from student
where id = any(select distinct id from takes where course_id like 'CS%'
                                 and (grade = 'A' or grade = 'A-'))
order by name;

--b.Find all advisors of students who got grades lower than B on any class;
select id, name
from instructor
where id = any(select distinct i_id
from advisor
where s_id = any(select id
                 from takes
                 where grade > 'B+'));


--c.Find all departments whose students have never gotten an F or C grade;
select distinct dept_name
from course
except
select dept_name
from course
where course_id  = any(select course_id
                        from takes
                        where grade >= 'C');

--d.Find all instructors who have never given an A grade in any of the courses they taught;
select id, name
from instructor
where id = any(select distinct id from teaches
where course_id = any(select course_id
       from takes
       group by course_id
       except
       select course_id
       from takes
       group by course_id
       having min(grade) = 'A'
       or min(grade) = 'A-'));

--e.Find all courses offered in the morning hours (i.e., courses ending before 13:00);
select *
from course
where course_id = any(select course_id
                      from section
                      where time_slot_id <= 'C');
