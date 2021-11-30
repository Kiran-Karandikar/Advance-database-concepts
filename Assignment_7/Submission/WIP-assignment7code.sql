------------------------------------------------------------------------
-- Schema
------------------------------------------------------------------------
create table P(a int);
create table R(a int, b int);
create table S(b int);
select * from P;
select * from R;
select * from S;

----------------------------------------------------------------------------
-- All functions
----------------------------------------------------------------------------

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

create or replace function make_data (n integer)
returns void as
$$
begin
drop table if exists P;
create table P(a int);
insert into P select * from SetOfIntegers(n,1,n);

drop table if exists R;
create table R(a int, b int);
insert into R select * from BinaryRelationOverIntegers(n,1,n, 1,n);

drop table if exists S;
create table S(b int);
insert into S select * from SetOfIntegers(n,1,n);
end;
$$ language plpgsql;

-----------------------------------------------------------------------------
-- Fucntions related to performing experiments.
-----------------------------------------------------------------------------

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
      perform make_data(floor(power(10,k))::int);
      insert into executionTimeTable values(floor(power(10,k))::int, (select runexperiment(n,sqlstatement)));
    end loop;
   end loop;
   return query select size::int, round(avg(executiontime)::numeric,3)
                from   executionTimeTable 
                group by(size) order by 1;
end;
$$ language plpgsql;


-----------------------------------------------------------------------------
-- Query Executions
-----------------------------------------------------------------------------
set work_mem='1GB';
show work_mem;

-- Problem 2 << Pending the execution times >>
--- Part a: Q3
VACUUM FULL;
select s as "Size of relation", e as "Avg execution time (in ms)" from   experiment(5,1,8,5,'select distinct p.a from P p, R r1, R r2, R r3, S s where p.a = r1.a and r1.b = r2.a and r2.b = r3.a and r3.b = S.b');


-- part b: optimized Q4
select distinct p.a from P p join R r1 on (p.a = r1.a) join R r2 on(r1.b = r2.a) join R r3 on (r2.b = r3.a) join S s on(r3.b = S.b);

select s as "Size of relation", e as "Avg execution time (in ms)" from   experiment(5,1,7,5,'select distinct p.a from P p join R r1 on (p.a = r1.a) join R r2 on(r1.b = r2.a) join R r3 on (r2.b = r3.a) join S s on(r3.b = S.b);');

-- Problem 3 << Pending the execution times >>
--- Part a: Q5
VACUUM FULL;
select s as "Size of relation", e as "Avg execution time (in ms)" from   experiment(5,1,2,5,'select p.a from P p where exists (select 1 from R r where r.a = p.a and not exists (select 1 from S s where r.b = s.b));');

-- part b: optimized Q6 
-- step 1
select p.a from P p where exists (select 1 from R r where r.a = p.a and not exists (select 1 from S s where r.b = s.b));

-- step 2

select p.a from P p where exists ((select r.a, r.b from R r where r.a = p.a) except (select r.a,r.b from R r, S s where r.a = p.a and r.b = s.b))
--  step 3 : translation is wrong



select s as "Size of relation", e as "Avg execution time (in ms)" from   experiment(5,1,7,5,'select distinct p.a from P p join R r1 on (p.a = r1.a) join R r2 on(r1.b = r2.a) join R r3 on (r2.b = r3.a) join S s on(r3.b = S.b);');

-- part c: Q7

select s as "Size of relation", e as "Avg execution time (in ms)" from   experiment(5,1,2,5,'with nestedR as (select P.a, array_agg(R.b) as bs from P natural join R group by (P.a)), Ss as (select array(select b from S) as bs) select a from nestedR where not (bs <@ (select bs from Ss));');


-- Problem 4 << Pending the execution times >>
--- Part a: Q8
VACUUM FULL;

select s as "Size of relation", e as "Avg execution time (in ms)" from   experiment(5,1,1,5,'select p.a from P p where exists (select 1 from S s where not exists (select 1 from R where p.a = r.a and r.b = s.b));');

-- part b: optimized Q9
-- step 1
select p.a from P p where exists (select 1 from S s where not exists (select 1 from R where p.a = r.a and r.b = s.b));

-- step 2
select p.a from P p where exists (select p.a, s.b from S s except select r.a, r.b from S s, R r where p.a = r.a and r.b = s.b);


-- step 3 -- translation going wrong
select p.a from P p where exists (select p.a, s.b from S s except select r.a, r.b from S s, R r where p.a = r.a and r.b = s.b);

-- part c: Q10

select s as "Size of relation", e as "Avg execution time (in ms)" from experiment(5,1,5,5,$$with nestedR as (select P.a, array_agg(R.b) as bs from P natural join R group by (P.a)), Ss as (select array(select b from S) as bs) select a from P where a not in (select a from nestedR) and not((select bs from Ss) <@ '{}') union select a from nestedR where not((select bs from Ss) <@ bs);$$);