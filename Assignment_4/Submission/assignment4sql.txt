-- Script for Assignment 4

-- Creating database with full name

CREATE DATABASE kiran_karandikar;

-- Connecting to database 
\c kiran_karandikar

-- Relation schemas and instances for assignment 2

CREATE TABLE Person(pid integer,
                    pname text,
                    city text,
                    primary key (pid));

CREATE TABLE Company(cname text,
                     headquarter text,
                     primary key (cname));

CREATE TABLE Skill(skill text,
                   primary key (skill));


CREATE TABLE worksFor(pid integer,
                      cname text,
                      salary integer,
                      primary key (pid),
                      foreign key (pid) references Person (pid),
                      foreign key (cname) references Company(cname));


CREATE TABLE companyLocation(cname text,
                             city text,
                             primary key (cname, city),
                             foreign key (cname) references Company (cname));


CREATE TABLE personSkill(pid integer,
                         skill text,
                         primary key (pid, skill),
                         foreign key (pid) references Person (pid) on delete cascade,
                         foreign key (skill) references Skill (skill) on delete cascade);


CREATE TABLE hasManager(eid integer,
                        mid integer,
                        primary key (eid, mid),
                        foreign key (eid) references Person (pid),
                        foreign key (mid) references Person (pid));

CREATE TABLE Knows(pid1 integer,
                   pid2 integer,
                   primary key(pid1, pid2),
                   foreign key (pid1) references Person (pid),
                   foreign key (pid2) references Person (pid));



INSERT INTO Person VALUES
     (1001,'Jean','Cupertino'),
     (1002,'Vidya', 'Cupertino'),
     (1003,'Anna', 'Seattle'),
     (1004,'Qin', 'Seattle'),
     (1005,'Megan', 'MountainView'),
     (1006,'Ryan', 'Chicago'),
     (1007,'Danielle','LosGatos'),
     (1008,'Emma', 'Bloomington'),
     (1009,'Hasan', 'Bloomington'),
     (1010,'Linda', 'Chicago'),
     (1011,'Nick', 'MountainView'),
     (1012,'Eric', 'Cupertino'),
     (1013,'Lisa', 'Indianapolis'), 
     (1014,'Deepa', 'Bloomington'), 
     (1015,'Chris', 'Denver'),
     (1016,'YinYue', 'Chicago'),
     (1017,'Latha', 'LosGatos'),
     (1018,'Arif', 'Bloomington'),
     (1019,'John', 'NewYork');

INSERT INTO Company VALUES
     ('Apple', 'Cupertino'),
     ('Amazon', 'Seattle'),
     ('Google', 'MountainView'),
     ('Netflix', 'LosGatos'),
     ('Microsoft', 'Redmond'),
     ('IBM', 'NewYork'),
     ('ACM', 'NewYork'),
     ('Yahoo', 'Sunnyvale');


INSERT INTO worksFor VALUES
     (1001,'Apple', 65000),
     (1002,'Apple', 45000),
     (1003,'Amazon', 55000),
     (1004,'Amazon', 55000),
     (1005,'Google', 60000),
     (1006,'Amazon', 55000),
     (1007,'Netflix', 50000),
     (1008,'Amazon', 50000),
     (1009,'Apple',60000),
     (1010,'Amazon', 55000),
     (1011,'Google', 70000), 
     (1012,'Apple', 50000),
     (1013,'Yahoo', 55000),
     (1014,'Apple', 50000), 
     (1015,'Amazon', 60000),
     (1016,'Amazon', 55000),
     (1017,'Netflix', 60000),
     (1018,'Apple', 50000),
     (1019,'Microsoft', 50000);

INSERT INTO companyLocation VALUES
   ('Apple', 'Bloomington'),
   ('Amazon', 'Chicago'),
   ('Amazon', 'Denver'),
   ('Amazon', 'Columbus'),
   ('Google', 'NewYork'),
   ('Netflix', 'Indianapolis'),
   ('Netflix', 'Chicago'),
   ('Microsoft', 'Bloomington'),
   ('Apple', 'Cupertino'),
   ('Amazon', 'Seattle'),
   ('Google', 'MountainView'),
   ('Netflix', 'LosGatos'),
   ('Microsoft', 'Redmond'),
   ('IBM', 'NewYork'),
   ('Yahoo', 'Sunnyvale');

INSERT INTO Skill VALUES
   ('Programming'),
   ('AI'),
   ('Networks'),
   ('OperatingSystems'),
   ('Databases');

INSERT INTO personSkill VALUES
 (1001,'Programming'),
 (1001,'AI'),
 (1002,'Programming'),
 (1002,'AI'),
 (1004,'AI'),
 (1004,'Programming'),
 (1005,'AI'),
 (1005,'Programming'),
 (1005,'Networks'),
 (1006,'Programming'),
 (1006,'OperatingSystems'),
 (1007,'OperatingSystems'),
 (1007,'Programming'),
 (1009,'OperatingSystems'),
 (1009,'Networks'),
 (1010,'Networks'),
 (1011,'Networks'),
 (1011,'OperatingSystems'),
 (1011,'AI'),
 (1011,'Programming'),
 (1012,'AI'),
 (1012,'OperatingSystems'),
 (1012,'Programming'),
 (1013,'Programming'),
 (1013,'OperatingSystems'),
 (1013,'Networks'),
 (1014,'OperatingSystems'),
 (1014,'AI'),
 (1014,'Networks'),
 (1015,'Programming'),
 (1015,'AI'),
 (1016,'OperatingSystems'),
 (1016,'AI'),
 (1017,'Networks'),
 (1017,'Programming'),
 (1018,'AI'),
 (1019,'Networks'),
 (1010,'Databases'),
 (1011,'Databases'),
 (1013,'Databases'),
 (1014,'Databases'),
 (1017,'Databases'),
 (1019,'Databases'),
 (1005,'Databases'),
 (1006,'AI'),
 (1009,'Databases');
 

INSERT INTO hasManager VALUES
 (1004, 1003),
 (1006, 1003),
 (1015, 1003),
 (1016, 1004),
 (1016, 1006),
 (1008, 1015),
 (1010, 1008),
 (1013, 1007),
 (1017, 1013),
 (1002, 1001),
 (1009, 1001),
 (1014, 1012),
 (1011, 1005);


INSERT INTO Knows VALUES
 (1011,1009),
 (1007,1016),
 (1011,1010),
 (1003,1004),
 (1006,1004),
 (1002,1014),
 (1009,1005),
 (1018,1009),
 (1007,1017),
 (1017,1019),
 (1019,1013),
 (1016,1015),
 (1001,1012),
 (1015,1011),
 (1019,1006),
 (1013,1002),
 (1018,1004),
 (1013,1007),
 (1014,1006),
 (1004,1014),
 (1001,1014),
 (1010,1013),
 (1010,1014),
 (1004,1019),
 (1018,1007),
 (1014,1005),
 (1015,1018),
 (1014,1017),
 (1013,1018),
 (1007,1008),
 (1005,1015),
 (1017,1014),
 (1015,1002),
 (1018,1013),
 (1018,1010),
 (1001,1008),
 (1012,1011),
 (1002,1015),
 (1007,1013),
 (1008,1007),
 (1004,1002),
 (1015,1005),
 (1009,1013),
 (1004,1012),
 (1002,1011),
 (1004,1013),
 (1008,1001),
 (1008,1019),
 (1019,1008),
 (1001,1019),
 (1019,1001),
 (1004,1003),
 (1006,1003),
 (1015,1003),
 (1016,1004),
 (1016,1006),
 (1008,1015),
 (1010,1008),
 (1017,1013),
 (1002,1001),
 (1009,1001),
 (1011,1005),
 (1014,1012),
 (1010,1002),
 (1010,1012),
 (1010,1018);

\qecho 'Problem 1'
-- Find each pair $(c,n)$ where $c$ is the cnameof a company that pays
-- an average salary between 50000 and 55000 and where $n$ is the number
-- of employees who work for company $c$.

select w.cname, count(w.pid)  from worksfor w group by (w.cname) having (50000 <= avg(w.salary)) and (avg(w.salary) <=55000) order by w.cname;

\qecho 'Problem 2'
-- Find the pid and name of each person who lacks at least 4 job skils
-- and who knows at least 4 persons.

with knows_at_least_4_persons as (select kn.pid1 from knows kn group by (kn.pid1) having count(kn.pid2)>=4),
lack_at_least_4_skills as (select ps.pid from personskill ps group by (ps.pid)  having ((select count(*) as total_skills from skill)- count(ps.skill)) >=4) select p.pid, p.pname from person p where p.pid in (select * from knows_at_least_4_persons) and p.pid in (select * from lack_at_least_4_skills) union select p.pid, p.pname from person p where p.pid not in (select ps.pid from personskill ps) and p.pid in (select * from knows_at_least_4_persons);

\qecho 'Problem 3'
-- Find the pid and name of each person who has fewer than 2 of the
-- combined set of job skills of persons who work for Google.
with r_skills as ( with wgoogle as (select w.pid from worksfor w where w.cname='Google') select  distinct ps.skill from personskill ps where ps.pid in (select * from wgoogle)), fewerthan_two as ( select ps.pid from personskill ps where ps.skill in (select * from r_skills) group by ps.pid having count(ps.skill) <2),
no_skills as (select p.pid, p.pname from person p where p.pid not in (select ps.pid from personskill ps))
(select p.pid, p.pname from person p where p.pid in (select * from fewerthan_two)) union (select * from no_skills);

\qecho 'Problem 4'
-- Find the cname of each company that employs at least 3 persons and
-- that pays the lowest average salary among such companies.
with required_companies as (select w.cname, count(w.pid), avg(w.salary) as avg_sal from worksfor w group by (w.cname) having count(w.pid)>=3) select rc.cname from required_companies rc where rc.avg_sal in (select min(rc1.avg_sal) from required_companies rc1);


\qecho 'Problem 5'
-- Find each pair $(c_1,c_2)$ of different company cnames such that,
-- among all companies, company $c_2$ pays the closest average salary
--- compared to the average salary paid by company $c_1$.
create temp view required_companies as (select w.cname, avg(w.salary) as avg_sal from worksfor w group by (w.cname));
create or replace function abs_avg_salary(company_name text, comp_avg_sal float) 
returns table(cname text) as 
$$
with other_companies as (select rc1.cname ,abs(rc1.avg_sal - comp_avg_sal) as distance from required_companies rc1 where rc1.cname<>company_name and abs(rc1.avg_sal - comp_avg_sal) >=0)
select oc1.cname from other_companies oc1 where oc1.distance in (select min(distance) from other_companies oc)
$$ language sql;
select rc1.cname as c1,rc2 as c2  from required_companies rc1, abs_avg_salary(rc1.cname, rc1.avg_sal) as rc2 order by c1;

\qecho 'Problem 6'
--Without using set predicates, find each pid of a person who does not
--know each person who (1) works for Apple and
-- (2) who makes less than 55000.
with rc as (select w.pid from worksfor w where w.cname='Apple' and w.salary<55000), fquery as (select rc.pid, kn.pid1 as person_id from rc cross join knows kn except select kn1.pid2, kn.pid1 from knows kn1 join knows kn on (kn1.pid1=kn.pid1)) select distinct fq.person_id from fquery fq order by fq.person_id;


\qecho 'Problem 7'
-- Without using set predicates, find each pairs $(s_1,s_2)$ of skills
-- such that the set of persons with skill $s_1$ is the same as the set
-- of persons with skill $s_2$.
with skill_count as (select ps.skill, count(ps.skill) from personskill ps group by ps.skill),
same_skills_count as (select s1.skill as skill1, s2.skill as skill2 from skill_count s1 join skill_count s2 on (s1.count=s2.count)), not_required_pair as (	select ps.pid, sc.* from personskill ps join same_skills_count sc on(ps.skill=sc.skill1) except select ps.pid, sc.* from personskill ps join same_skills_count sc on(ps.skill=sc.skill2)
) select skill1, skill2 from same_skills_count except select skill1, skill2 from not_required_pair;

\qecho 'Problem 8'
-- Find each pairs $(s_1,s_2,n)$ of different skills $s_1$ an $s_2$ and
-- such that (1) the number of persons with skill $s_1$ is the same as
-- the number of persons with skill $s_2$ and (2) where $n$ is the number
-- of such persons associated with $c_1$ and $c_2$.
with skill_count as (select ps.skill, count(ps.pid) from personskill ps group by ps.skill)
select s1.skill, s2.skill, s1.count from skill_count s1 join skill_count s2 on ( s1.skill<>s2.skill and s1.count=s2.count) order by s1.count;

\qecho 'Problem 9'

\qecho 'Problem 9a'
create or replace function numberOfSkills(c text)
returns table (pid integer, salary int, numberOfSkills bigint) as
$$
with p_details as (select w.pid, w.salary from worksfor w where w.cname=c),person_skill as (select ps.pid, count(ps.skill) from personskill ps group by ps.pid)
(select pd.pid, pd.salary, ps.count from p_details pd join person_skill ps on (pd.pid=ps.pid))union(select pd.pid, pd.salary, 0 from p_details pd where pd.pid not in (select ps.pid from person_skill ps))
$$ language sql;

\qecho 'Problem 9b'
select * from numberOfSkills('Apple') order by numberOfSkills;
select * from numberOfSkills('Amazon') order by numberOfSkills;
select * from numberOfSkills('ACM') order by numberOfSkills;

\qecho 'Problem 9c'

create or replace function numberOfSkills(c text)
returns table (pid integer, salary int, numberOfSkills bigint) as
$$
with p_details as (select w.pid, w.salary from worksfor w where w.cname=c),person_skill as (select distinct ps.pid, (select count(ps1.skill) from personskill ps1 where ps1.pid=ps.pid) from personskill ps )
(select pd.pid, pd.salary, ps.count from p_details pd join person_skill ps on (pd.pid=ps.pid))union(select pd.pid, pd.salary, 0 from p_details pd where pd.pid not in (select ps.pid from person_skill ps))
$$ language sql;

\qecho 'Problem 9d'

select * from numberOfSkills('Apple') order by numberOfSkills;
select * from numberOfSkills('Amazon') order by numberOfSkills;
select * from numberOfSkills('ACM') order by numberOfSkills;

\qecho 'Problem 9e'
-- Using the function {\tt numberOfSkills} but without using set
-- predicates, write the following query: ``{\it Find each pair $(c,p)$
-- where $c$ is the name of a company and where $p$ is the pid of a
-- person who (1) works for company $c$, (2) makes more than 50000 and
-- (3) has the most job skills among all the employees who work for
-- company $c$}."

with details as(
select c.cname, ns.pid, ns.numberOfSkills as scount, ns.salary from company c, numberOfSkills(c.cname) as ns),
max_skills as (select cname, max(d.scount) as max_count from details d group by cname)
select d.cname, d.pid from details d join max_skills ms on(d.cname=ms.cname and d.scount=ms.max_count) and d.salary> 50000;



\qecho 'Problem 10'

create table p (coefficient int, degree int);
create table q (coefficient int, degree int);
insert into p values (2,2), (-5,1), (5,0);
insert into q values (4,4), (3,3), (1,2), (-1,1);

\qecho 'Polynomial P = 2x^2 - 5x + 5'
\qecho 'Polynomial Q = 4x^4 + 3x^3 + x^2 -x'
\qecho 'P'
select * from p;
\qecho 'Q'
select * from q;

\qecho 'Problem 10a'
create or replace function multiplyPolynomials(polynomial1 text, polynomial2 text) returns table(coefficient integer, degree integer) as
$$
begin 
return query
execute 'with mul as (select p1.coefficient*p2.coefficient as c, p1.degree+p2.degree as d from ' || polynomial1 || ' as p1,' || polynomial2 ||' as p2)
select cast(sum(mul.c) as INTEGER), cast(mul.d as INTEGER) from mul group by mul.d order by mul.d desc';

end;
$$ language plpgsql;

\qecho 'Problem 10b.i'
select * from multiplyPolynomials('p','q');

\qecho 'Problem 10b.ii'
select * from multiplyPolynomials('p','p');

\qecho 'Problem 10b.iii'
select * from multiplyPolynomials('p', $$multiplyPolynomials('q','p')$$);

-- Connect to default database
\c postgres

-- Drop database created for this assignment
DROP DATABASE kiran_karandikar;