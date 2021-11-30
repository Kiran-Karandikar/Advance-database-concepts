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


\qecho 'Problem 3'


create or replace function makeS (n integer)
returns void as
$$
begin
drop table if exists S;
create table S (x int);
insert into S select * from SetOfIntegers(n,1,n);
end;
$$ language plpgsql;


set work_mem='1GB';
show work_mem;
select s as "size of relation S", e as "Avg execution time to scan S (in ms): SELECT x FROM S" from   experiment(5,1,8,5,'SELECT x FROM S');


VACUUM FULL;
select s as "size of relation S", e as "Avg execution time to sort S (in ms): SELECT x FROM S order by 1" from experiment(5,1,8,5,'select x from S order by 1');


set work_mem = '64kB';
show work_mem;

VACUUM FULL;
select s as "size of relation S", e as "Avg execution time to scan S (in ms): SELECT x FROM S" from   experiment(5,1,8,5,'SELECT x FROM S');


VACUUM FULL;
select s as "size of relation S", e as "Avg execution time to sort S (in ms): SELECT x FROM S order by 1" from experiment(5,1,8,5,'select x from S order by 1');


\qecho 'INDEX Creation ---'

VACUUM FULL;
create table indexedS (x integer);
create index on indexedS using btree (x);
select s as "size n of relation S", e as "avg execution time to create index indexedS"
from   experiment(5,1,7,5,'insert into indexedS select x from S order by 1;');

select s as "size n of relation S", e as "avg execution time to create index indexedS"
from   experiment(5,1,7,5,'select x from indexedS where x between 1 and 20000;');


\qecho 'Random data generation..............'

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


\qecho 'Probelm 10'
vacuum full;
set work_mem = '1.5GB';
show work_mem;

delete from worksfor;
delete from person;
delete from company;

drop index if exists worksFor_btree;
-- Create indexes.
\qecho 'using B+ Tree'
create index worksFor_btree on worksfor USING btree(cname);

-- Analyze the query given in the problem.
\qecho "select pid from worksFor where cname = 'Google';"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from  index_experiment(4,3,6,4,$$select pid from worksFor where cname = 'Google'$$);

delete from worksfor;
delete from person;
delete from company;
vacuum full;

drop index if exists worksFor_btree;
drop index if exists worksFor_hash;
-- Create indexes.
\qecho 'using hash table'
create index worksFor_hash on worksfor using hash(cname);
\qecho "select pid from worksFor where cname = 'Google';"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from index_experiment(4,3,6,4,$$select pid from worksFor where cname = 'Google'$$);




\qecho 'Probelm 11'
vacuum full;
set work_mem = '1.5GB';
show work_mem;

delete from worksfor;
delete from person;
delete from company;


drop index if exists worksFor_salary_btree;
-- Create indexes.
\qecho 'using B+ Tree'
create index worksFor_salary_btree on worksfor USING btree(salary);


-- Analyze the query given in the problem.
\qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from index_experiment(4,3,6,4,$$select pid, cname from worksFor where 10000 <= salary and salary <= 100000$$);



delete from worksfor;
delete from person;
delete from company;
vacuum full;

drop index if exists worksFor_salary_btree;
drop index if exists worksFor_salary_hash;
drop index if exists worksFor_hash;

-- Create indexes.
\qecho 'using hash table'
create index worksFor_salary_hash on worksfor using hash(salary);

\qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from index_experiment(4,3,6,4,$$select pid, cname from worksFor where 10000 <= salary and salary <= 100000$$);
  
\qecho 'Probelm 12'
vacuum full;
set work_mem = '1.5GB';
show work_mem;

delete from worksfor;
delete from person;
delete from company;


drop index if exists worksFor_salary_btree;
drop index if exists worksFor_salary_hash;
drop index if exists worksFor_hash;
drop index if exists worksFor_btree;

-- Create indexes.
\qecho 'using B+ Tree'
create index worksFor_btree on worksfor using btree(cname);
create index worksFor_salary_btree on worksfor using btree(salary);


-- Analyze the query given in the problem.
\qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from index_experiment(4,3,6,4,$$select pid from worksFor where salary = 100000 and cname = 'Google'$$);



delete from worksfor;
delete from person;
delete from company;
vacuum full;

drop index if exists worksFor_salary_btree;
drop index if exists worksFor_salary_hash;
drop index if exists worksFor_hash;
drop index if exists worksFor_btree;


-- Create indexes.
\qecho 'using hash table'
create index worksFor_hash on worksfor using hash(cname);
create index worksFor_salary_hash on worksfor using hash(salary);


\qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from index_experiment(4,3,6,4,$$select pid, cname from worksFor where 10000 <= salary and salary <= 100000$$);

\qecho 'Probelm 13'
vacuum full;
set work_mem = '1.5GB';
show work_mem;

delete from worksfor;
delete from person;
delete from company;


drop index if exists worksFor_salary_btree;
drop index if exists worksFor_salary_hash;
drop index if exists worksFor_hash;
drop index if exists worksFor_btree;
drop index if exists worksFor_pid_btree;

-- Create indexes.
\qecho 'using B+ Tree'
create index worksFor_btree on worksfor using btree(cname);
create index worksFor_pid_btree on worksfor using btree(pid);


-- Analyze the query given in the problem.
\qecho "select pid, pname from Person where pid in (select pid from worksFor where cname = 'Google');"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from index_experiment(4,3,6,4,$$select pid, pname from Person where pid in (select pid from worksFor where cname = 'Google');$$);



delete from worksfor;
delete from person;
delete from company;
vacuum full;

drop index if exists worksFor_salary_btree;
drop index if exists worksFor_salary_hash;
drop index if exists worksFor_hash;
drop index if exists worksFor_btree;
drop index if exists worksFor_pid_btree;
drop index if exists worksFor_pid_hash;

-- Create indexes.
\qecho 'using hash table'
create index worksFor_hash on worksfor using hash(cname);
create index worksFor_pid_hash on worksfor using hash(pid);


\qecho "select pid, cname from worksFor where 10000 <= salary and salary <= 100000;"

select s as "size of relation worksFor", e as "Avg execution time to scan(in ms)" from   index_experiment(4,3,6,4,$$select pid, cname from worksFor where 10000 <= salary and salary <= 100000$$);