------------------------------------------------------------------------
------------------------------------------------------------------------
-- Problem 1

-- working query
delete from p;
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
drop function if exists check_for_probability(x double precision);
create or replace function check_for_probability(x double precision, l1 int, u2 int) returns double precision as 
$$	
	with all_values as (
		select * from sum_p union (select 0::double precision as lt, probability as leq, outcome  from p limit(1) offset(0))
	) select sp.outcome from all_values sp where sp.lt < x and x <=sp.leq and sp.outcome >=l1 and sp.outcome<=u2;
$$ language sql;
drop function if exists RelationOverProbabilityFunction(n int, l_1 int, u_1 int, l_2 int, u_2 int);
create or replace function RelationOverProbabilityFunction(n int, l_1 int, u_1 int, l_2 int, u_2 int)
returns table (x int, y int) as
$$
select floor(random() * (u_1-l_1+1) + l_1)::int as x, check_for_probability(random(), l_2, u_2)::int as y  from generate_series(1,n);
$$ language sql;
select * from RelationOverProbabilityFunction(100, 1, 150, 1, 5);

-- test query
drop function if exists RelationOverProbabilityFunction(n int, l_1 int, u_1 int, l_2 int, u_2 int);
drop function if exists check_for_probability(x double precision);
		   
	   
create or replace temp view sum_p as (
with ranked_p as (select rank() over (order by outcome), * from p),
no_first_record as (select * from ranked_p offset(1)),
q as (select sum(rp.probability) as lt,fp.rank from no_first_record fp, ranked_p rp where rp.rank<fp.rank group by fp.rank),
sq as (select sum(rp.probability) as leq,fp.rank from no_first_record fp, ranked_p rp where rp.rank<=fp.rank group by fp.rank)
select  q.lt, sq.leq, ranked_p.outcome from sq join q on (sq.rank=q.rank) join ranked_p on (ranked_p.rank=q.rank) order by q.rank
);
drop function if exists check_for_probability(x double precision);
create or replace function check_for_probability(x double precision, l1 int, u2 int) returns double precision as 
$$	
	with all_values as (
		select * from sum_p union (select 0::double precision as lt, probability as leq, outcome  from p limit(1) offset(0))
	) select sp.outcome from all_values sp where sp.lt < x and x <=sp.leq and sp.outcome >=l1 and sp.outcome<=u2;
$$ language sql;


create or replace function RelationOverProbabilityFunction(n int, l_1 int, u_1 int, l_2 int, u_2 int)
returns table (x int, y int) as
$$
select floor(random() * (u_1-l_1+1) + l_1)::int as x, check_for_probability(random(), 1,5)::int as y  from generate_series(1,n);
$$ language sql;
select * from RelationOverProbabilityFunction(100, 1, 150, 1, 5);



------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------
-- from performingexperiments.sql
-- The function queryPlan returns the query plan for the given sqlStatement

create or replace function queryPlan (sqlStatement text) 
returns table (queryPlanRow text) as
$$
begin
 return  query execute 'explain analyze ' || sqlStatement;
end;
$$ language plpgsql;

-- The function extractExecutionTime extracts the execution time of
-- the query plan for the given sqlStatement

create or replace function extractExecutionTime(sqlStatement text)
returns       float as
$$
   select substring(q.queryPlan,'([0-9.]+)')::float
   from   (select queryPlan from queryPlan(sqlStatement)) q
   where  q.queryPlan like '%Exec%';
$$ language sql;

-- The function runExperiment runs 'n' experiment for the
-- given queryStatement and returns their average execution time

create or replace function runExperiment(n int, queryStatement text) 
returns float as
$$
    select avg((select * from extractExecutionTime(queryStatement)))
    from   generate_series(1,n);
$$ language sql;

-- The 'experiment' function creates m relation S, with |S| = 10^k for k
-- in [k_1,k_2] and runs the (scan) query `SELECT x FROM S' n times.
-- Then the function returns the average execution times of these n
-- runs.

create or replace function experiment(m int, k_1 int, k_2 int, n int, sqlstatement text)
returns table(s int, e numeric) as
$$
begin
   drop table if exists executionTimeTable;
   create table executionTimeTable (size int, executionTime    float);   
   
   for i in 1..m loop
     for k in k_1..k_2 loop
      perform makeS(floor(power(10,k))::int);
      insert into executionTimeTable values(floor(power(10,k))::int, (select runexperiment(n,sqlstatement)));
    end loop;
   end loop;   
   return query select size::int, round(avg(executiontime)::numeric,3)
                from   executionTimeTable 
                group by(size) order by 1;
end;
$$ language plpgsql;


-- Example:  SCANNING
-- Average execution times to analyze scanning a set S of increasing size
-- using the SQL statement  'SELECT x FROM S' statement.

select s as "size of relation S", e as "Average execution time for SELECT x FROM S"
from   experiment(5,1,7,5,'SELECT x FROM S');
------------------------------------------------------------------------



-- Problem 3;
-- working query


-- test query

create or replace function SetOfIntegers(n int, l int, u int)
returns table (x int) as
$$
select floor(random() * (u-l+1) + l)::int from generate_series(1,n);
$$ language sql;
create or replace function makeS (n integer)
returns void as
$$
begin
drop table if exists S;
create table S (x int);
insert into S select * from SetOfIntegers(n,1,n);
end;
$$ language plpgsql;

VACUUM FULL;
select makeS(cast(power(10,1) as int));
-- avg execution time to scan S (in ms)
explain analyze select x from S;
-- avg execution time to sort S (in ms)
explain analyze select x from S order by 1;


-- using the function given in file
delete from s;
VACUUM FULL;
set work_mem='1GB'
show work_mem;
select s as "size of relation S", e as "Avg execution time to scan S (in ms): SELECT x FROM S" from   experiment(5,1,8,5,'SELECT x FROM S');


delete from s;
VACUUM FULL;
set work_mem='1GB'
show work_mem;
select s as "size of relation S", e as "Avg execution time to sort S (in ms): SELECT x FROM S order by 1" from experiment(5,1,8,5,'select x from S order by 1');


--- Memory Setting and repeat above	
-- set work_mem = '16MB';
-- show work_mem;
set work_mem = '64kB';
show work_mem;

set work_mem = '1GB';
show work_mem;

VACUUM FULL;
select s as "size of relation S", e as "Avg execution time to scan S (in ms): SELECT x FROM S"
from   experiment(5,1,8,5,'SELECT x FROM S');

VACUUM FULL;
select s as "size of relation S", e as "Avg execution time to sort S (in ms): SELECT x FROM S order by 1"
from   experiment(5,1,8,5,'select x from S order by 1');

-- index creation

create or replace function SetOfIntegers(n int, l int, u int)
returns table (x int) as
$$
select floor(random() * (u-l+1) + l)::int from generate_series(1,n);
$$ language sql;




create or replace function
BinaryRelationOverIntegers(n int, l_1 int, u_1 int, l_2 int, u_2 int)
   returns table (x int, y int) as
$$
   select floor(random() * (u_1-l_1+1) + l_1)::int as x,
          floor(random() * (u_2-l_2+1) + l_2)::int as y
   from   generate_series(1,n);
$$ language sql;


create or replace function
FunctionOverIntegers(n int, l_1 int, u_1 int, l_2 int, u_2 int)
   returns table (x int, y int) as
$$
   select x, floor(random() * (u_2-l_2+1) + l_2)::int as y
   from   generate_series(l_1,u_1) x order by random() limit(n);
$$ language sql;

create table indexedS (x integer);
create index on indexedS using btree (x);

drop index if exists indexedS;
delete from indexedS;
VACUUM FULL;


create or replace function experiment(m int, k_1 int, k_2 int, n int, sqlstatement text)
returns table(s int, e numeric) as
$$
begin
   drop table if exists executionTimeTable;
   create table executionTimeTable (size int, executionTime    float);   
   
   for i in 1..m loop
     for k in k_1..k_2 loop
      perform makeS(floor(power(10,k))::int);
      insert into executionTimeTable values(floor(power(10,k))::int, (select runexperiment(n,sqlstatement)));
    end loop;
   end loop;   
   return query select size::int, round(avg(executiontime)::numeric,3)
                from   executionTimeTable 
                group by(size) order by 1;
end;
$$ language plpgsql;

set work_mem='1.5GB'
set max_parallel_workers = default;
set max_parallel_workers_per_gather= default;
select s as "size n of relation S", e as "avg execution time to create index indexedS"
from   experiment(5,1,7,5,'insert into indexedS select x from S order by 1;');


select s as "size n of relation S", e as "avg execution time to create index indexedS"
from   experiment(5,1,7,5,'select x from indexedS where x between 1 and 100000;');
-- Problem 5

-- test query

-- working query

select * from Student;
-- secondary index
create temp view index_on_grade as (select rank() over (order by grade) as on_grade, * from Enroll order by on_grade);
select * from index_on_grade;
--- first index
select distinct(on_grade), grade from index_on_grade group by (grade, on_grade) order by grade;


select rank() over (order by grade) as on_grade, * from Enroll order by on_grade
--------

select * from grade_pointer;
select * from cno_pointer;

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
drop function if exists FindStudents(op text, cno text, grade text); 
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

select * from FindStudents('and', $$'c202'$$, $$ 'A' $$);
select * from FindStudents('or', $$'c202'$$, $$ 'A' $$);
select * from FindStudents('and not', $$'c202'$$, $$ 'A' $$);




select rank() over (order by (cno, grade)) as on_cno, * from Enroll

select rank() over (order by cno) as on_cno, * from Enroll order by on_cno;


select rank() over (order by cno) as on_cno, * from Enroll order by on_cno;



select row_number() over (partition by cno, grade) as on_cno, * from index_on_grade order by grade;

select sum() over (partition by grade, cno) as on_cno, * from index_on_grade order by grade;

select count(cno), cno from enroll group by cno;


create or replace temp view index_on_cno as (
select rank() over (order by cno) by_cno,*, rank() over (order by grade) from enroll order by grade);

select * from index_on_cno order by by_cno;
select distinct(by_cno), cno from index_on_cno group by (cno, by_cno) order by cno;



-- Problem 10

-- data insertion
CREATE TABLE Company(cname text, headquarter text, primary key (cname));
CREATE TABLE Person(pid integer,pname text, city text,primary key (pid));
CREATE TABLE worksFor(pid integer, cname text, salary integer, primary key (pid),foreign key (pid) references Person (pid), foreign key (cname) references Company(cname));	

create or replace function generate_data(total_records int)
returns void as 
$$	
	delete from worksfor;
	delete from person;
	delete from company;

INSERT INTO Company VALUES
 ('Apple', 'Cupertino'),
 ('Amazon', 'Seattle'),
 ('Google', 'MountainView'),
 ('Netflix', 'LosGatos'),
 ('Microsoft', 'Redmond'),
 ('IBM', 'NewYork'),
 ('ACM', 'NewYork'),
 ('Yahoo', 'Sunnyvale');
INSERT INTO Person (pid,pname, city) 
		SELECT pid,
(ARRAY['greg','pablo','Luke','james','Iain','Chris','Ryan','jay', 'Ronnie', 'Dexter', 'Branch'])[floor(random() * (11) + 1) :: int],
(ARRAY['vegas','new york','tampa','miami','long beach','california','Oregaon','North Dakota', 'South Dakota', 'Texas', 'Mexico'])[floor(random() * (11) + 1) :: int] FROM generate_series(1, total_records) pid;
INSERT INTO worksFor
		select p.pid,(array(select cname from company))[floor(random() * (7) + 1) :: int], floor(random()*(1300000 - 45000) + 12000) :: int
		from person p;
$$ language sql;

create or replace function index_experiment(m int, k_1 int, k_2 int, n int, sqlstatement text)
returns table(s int, e numeric) as
$$
begin
   drop table if exists executionTimeTable;
   create table executionTimeTable (size int, executionTime    float);   
   for i in 1..m loop
     for k in k_1..k_2 loop
      perform generate_data(floor(power(10,k))::int);
      insert into executionTimeTable values(floor(power(10,k))::int, (select runexperiment(n,sqlstatement)));
    end loop;
   end loop;
   return query select size::int, round(avg(executiontime)::numeric,3)
                from   executionTimeTable 
                group by(size) order by 1;
end;
$$ language plpgsql;


-- data insertion
vacuum full;
set work_mem = '1.5GB';
show work_mem;
-- using B+ Tree 
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_btree;
create index worksFor_btree on worksfor(cname);

-- \qecho "select pid from worksFor where cname = 'Google'"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid from worksFor where cname = 'Google'$$);

-- using hash table
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_hash;
create index worksFor_hash on worksfor using hash(cname);
-- \qecho "select pid from worksFor where cname = 'Google'"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid from worksFor where cname = 'Google'$$);


-- Problem 11
-- data insertion
vacuum full;
set work_mem = '1.5GB';
show work_mem;
-- using B+ Tree 
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_salary_btree;
create index worksFor_salary_btree on worksfor(salary);

-- \qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid, cname from worksFor where 10000 <= salary and salary <= 100000$$);


-- using hash table
vacuum full;
set work_mem = '1.5GB';
show work_mem;
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_salary_hash;
create index worksFor_salary_hash on worksfor using hash(salary);
-- \qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid, cname from worksFor where 10000 <= salary and salary <= 100000$$);


-- Problem 12
-- data insertion
vacuum full;
set work_mem = '1.5GB';
show work_mem;
-- using B+ Tree 
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_btree;
drop index if exists worksFor_salary_btree;
create index worksFor_btree on worksfor(cname);
create index worksFor_salary_btree on worksfor(salary);

-- \qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid from worksFor where salary = 100000 and cname = 'Google'$$);

-- using hash table
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_hash;
drop index if exists worksFor_salary_hash;
create index worksFor_hash on worksfor using hash(cname);
create index worksFor_salary_hash on worksfor using hash(salary);
-- \qecho "select pid from worksFor where salary = s and cname = c;"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid from worksFor where salary = 100000 and cname = 'Google'$$);



-- problem 13
-- data insertion
vacuum full;
set work_mem = '1.5GB';
show work_mem;
-- using B+ Tree 
delete from worksfor;
delete from person;
delete from company;
drop index if exists worksFor_btree;
drop index if exists worksFor_pid_btree;
create index worksFor_btree on worksfor(cname);
create index worksFor_pid_btree on worksfor(pid);

-- \qecho "select pid, pname from Person where pid in (select pid from worksFor where cname = 'Google');"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid, pname from Person where pid in (select pid from worksFor where cname = 'Google');$$);

-- using hash table
vacuum full;
set work_mem = '1.5GB';
show work_mem;

delete from worksfor;
delete from person;
delete from company;

drop index if exists worksFor_hash;
drop index if exists worksFor_pid_hash;
create index worksFor_hash on worksfor using hash(cname);
create index worksFor_pid_hash on worksfor using hash(pid);

-- \qecho "select pid from worksFor where salary = s and cname = c;"
select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)"
from   index_experiment(4,3,6,4,$$select pid from worksFor where salary = 100000 and cname = 'Google'$$);

