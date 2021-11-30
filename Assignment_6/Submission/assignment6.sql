-- Script for Assignment 6

-- Creating database with full name

CREATE DATABASE kiran_karandikar;

-- Connecting to database 
\c kiran_karandikar


\qecho 'Problem 1'

create table P
(
    outcome     int,
    probability float
);

\qecho 'Test case 1 - uniform mass function'
insert into P
values (1, 0.2),
       (2, 0.2),
       (3, 0.2),
       (4, 0.2),
       (5, 0.2);
	   
create or replace temp view sum_p as (
with ranked_p as (select rank() over (order by outcome), * from p),
no_first_record as (select * from ranked_p offset(1)),
q as (select sum(rp.probability) as lt,fp.rank from no_first_record fp, ranked_p rp where rp.rank<fp.rank group by fp.rank),
sq as (select sum(rp.probability) as leq,fp.rank from no_first_record fp, ranked_p rp where rp.rank<=fp.rank group by fp.rank)
select  q.lt, sq.leq, ranked_p.outcome from sq join q on (sq.rank=q.rank) join ranked_p on (ranked_p.rank=q.rank) order by q.rank
);

create or replace function check_for_probability(x double precision, l1 int, u2 int) returns double precision as 
$$
	with all_values as (
		select * from sum_p union (select 0::double precision as lt, probability as leq, outcome  from p limit(1) offset(0))
	) select sp.outcome from all_values sp where sp.lt < x and x <=sp.leq and sp.outcome >=l1 and sp.outcome<=u2;
$$ language sql;

create or replace function RelationOverProbabilityFunction(n int, l_1 int, u_1 int, l_2 int, u_2 int)
returns table (x int, y int) as
$$
select floor(random() * (u_1-l_1+1) + l_1)::int as x, check_for_probability(random(), l_2, u_2)::int as y  from generate_series(1,n);
$$ language sql;

select * from RelationOverProbabilityFunction(100, 1, 150, 1, 5);

\qecho 'Problem 5'

-- Data
-- Relation schemas and instances for assignment 6

create table Student
(
    sid   text,
    sname text,
    major text,
    byear int,
    primary key (sid)
);

-- We don't specify any constraints on enroll
create table Enroll
(
    sid   text,
    cno   text,
    grade text
);

insert into Student
values ('s100', 'Eric', 'CS', 1988),
       ('s101', 'Nick', 'Math', 1991),
       ('s102', 'Chris', 'Biology', 1977),
       ('s103', 'Dinska', 'CS', 1978),
       ('s104', 'Zanna', 'Math', 2001),
       ('s105', 'Vince', 'CS', 2001);


insert into Enroll
values ('s100', 'c200', 'A'),
       ('s100', 'c201', 'B'),
       ('s100', 'c202', 'A'),
       ('s101', 'c200', 'B'),
       ('s101', 'c201', 'A'),
       ('s102', 'c200', 'B'),
       ('s103', 'c201', 'A'),
       ('s101', 'c202', 'A'),
       ('s101', 'c301', 'C'),
       ('s101', 'c302', 'A'),
       ('s102', 'c202', 'A'),
       ('s102', 'c301', 'B'),
       ('s102', 'c302', 'A'),
       ('s104', 'c201', 'D');
	   
	   
create temp view grade_index as  (
select rank() over (order by grade) as on_grade , grade, sid from Enroll group by sid, grade order by sid);

create temp view grade_pointer as (
select distinct(on_grade), grade from grade_index group by (grade, on_grade) order by grade);

create temp view cno_index as  (
select rank() over (order by cno) as on_cno , cno, sid from Enroll group by sid, cno order by sid);

create temp view cno_pointer as (
select distinct(on_cno), cno from cno_index group by (cno, on_cno) order by cno);

create temp view all_pointers as (
select ci.on_cno, gi.on_grade, gi.grade, ci.sid, ci.cno from cno_index ci join grade_index gi on (ci.sid=gi.sid));
create or replace function FindStudents(op text, cno text, grade text) returns table(ssid   text, ssname text, smajor text, sbyear int) as
$$
begin 
return query
execute 'with cp as (
select on_cno from cno_pointer where cno=' || cno || '),
gp as (select on_grade from grade_pointer where grade='||grade ||')
select * from student where sid in( select sid from all_pointers ap , cp, gp where ap.on_cno=cp.on_cno ' ||op || ' ap.on_grade=gp.on_grade);';
end;
$$ language plpgsql;


\qecho 'Problem 5.a'
select * from FindStudents('and', $$'c202'$$, $$ 'A' $$);

\qecho 'Problem 5.b'
select * from FindStudents('or', $$'c202'$$, $$ 'A' $$);

\qecho 'Problem 5.c'
select * from FindStudents('and not', $$'c202'$$, $$ 'A' $$);

\c postgres

drop database kiran_karandikar;

