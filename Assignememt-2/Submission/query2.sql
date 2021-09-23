-- Script for Assignment 2

-- Creating database with full name

CREATE DATABASE kiran_karandikar;

-- Connecting to database 
\c kiran_karandikar;

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
 (1019,'Networks');

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
 (1014,1012);



create table tree(parent integer,
                  child integer);

insert into tree values
 (1,2),
 (1,3),
 (1,4),
 (2,5),
 (2,6),
 (3,7),
 (5,8),
 (8,9),
 (8,10),
 (8,11),
 (7,12),
 (7,13),
 (12,14),
 (14,15);
 
 \qecho 'Problem 1'

-- Consider the query “Find the pid and name of each person who works
-- for Google and who has a higher salary than some other person who he
-- or she knows and who also works for Google.”

-- (a) Formulate this query in SQL by only using the EXISTS or NOT EXISTS set predicates.
select distinct p.pid , p.pname from person p, worksfor w where exists (select 1 from worksfor wf1 where wf1.cname='Google' and wf1.pid=p.pid) and exists (SELECT 1 FROM knows kn where kn.pid1=p.pid and exists(select 1 from worksfor wf where wf.cname='Google' and wf.pid=kn.pid2 and wf.salary < w.salary));

-- (b) Formulate this query in SQL by only using the IN, NOT IN, SOME,
-- or ALL set membership predicates.

select distinct p.pid , p.pname from person p, worksfor w where p.pid in (select w.pid from worksfor w where w.cname='Google') and p.pid in (SELECT kn.pid1 FROM knows kn where kn.pid2 in (select wf.pid from worksfor wf where wf.cname='Google' and wf.salary < w.salary));


-- (c) Formulate this query in SQL without using set predicates.
select q.* from (select distinct p.pid , p.pname from person p, worksfor w where w.cname='Google' and w.pid=p.pid Intersect select distinct p1.pid , p1.pname from person p1, person p2, worksfor wf1, worksfor wf2, knows kn  where wf1.cname='Google' and wf1.pid=p1.pid and kn.pid1=p1.pid and kn.pid2=p2.pid and wf1.salary > wf2.salary and wf2.cname='Google') q;

\qecho 'Problem 2'

-- Consider the query “Find the cname of each company with headquarter in
-- Cupertino, but that is not located in Indianapolis, along with the
-- pid, name, and salary of each person who works for that company and
-- who has the next-to-lowest salary at that company.

-- (a) Formulate this query in SQL by only using the EXISTS or NOT EXISTS
-- set predicates. You can not use the set operations INTERSECT, UNION,
-- and EXCEPT.
with loweset_removed as(SELECT distinct c.cname, p.pid, p.pname, w.salary FROM company c, person p, worksfor w where c.headquarter='Cupertino' and not exists(select 1 from companylocation cl where cl.cname=c.cname and cl.city='Indianapolis') and p.pid=w.pid and w.cname=c.cname and exists (select 1 from worksfor wf where wf.cname=c.cname and wf.salary < w.salary)) select lr.* from loweset_removed lr where  not exists (select 1 from loweset_removed lr1 where lr1.cname=lr.cname and lr1.salary < lr.salary);


-- (b) Formulate this query in SQL by only using the IN, NOT IN, SOME, or
-- ALL set membership predicates. You can not use the set oper- ations
-- INTERSECT, UNION, and EXCEPT.
with emp_details as (SELECT distinct c.cname, p.pid, p.pname, w.salary FROM company c, person p, worksfor w where c.headquarter='Cupertino' and c.cname not in(select cl.cname from companylocation cl where cl.city='Indianapolis') and p.pid=w.pid and w.cname=c.cname),lowest_removed as (select lr.* from emp_details lr where lr.pid not in (select ed.pid from emp_details ed where ed.salary<=all(select salary from emp_details))) select ntl.* from lowest_removed ntl where ntl.pid in (
	select lr.pid from lowest_removed lr where lr.salary<=all(select salary from lowest_removed));

-- (c) Formulate this query in SQL without using set predicates.
with emp_details as (SELECT distinct c.cname, p.pid, p.pname, w.salary FROM company c, person p, worksfor w, companylocation cl where c.headquarter='Cupertino' and cl.city<>'Indianapolis' and cl.cname=c.cname and p.pid=w.pid and w.cname=c.cname),lowest_removed as (select distinct ed1.* from emp_details ed1, emp_details ed2 where ed1.pid<>ed2.pid and (ed1.salary-ed2.salary) > 0)select ntl.* from (select distinct ntl1.* from lowest_removed ntl1 intersect select  ntl1.* from  lowest_removed ntl1 , lowest_removed ntl2 where ntl1.pid <>ntl2.pid and (ntl1.salary -ntl2.salary)=0) ntl;

\qecho 'Problem 3'

-- Consider the query “Find each (c, p) pair where c is the cname of a 
-- company and p is the pid of a person who works for that company and 
-- who is known by all other persons who work for that company.

-- (a) Formulate this query in SQL by only using the EXISTS or NOT EXISTS set predicates. 
-- You can not use the set operations INTERSECT, UNION, and EXCEPT.
select wf.cname, wf.pid from worksfor wf where exists(select 1 from worksfor wf1, knows kn1 where wf1.cname=wf.cname and wf1.pid<>wf.pid and kn1.pid1=wf1.pid and kn1.pid2=wf.pid and not exists(select 1 from worksfor wf2, knows kn2 where wf2.cname=wf.cname and wf2.pid<>wf1.pid and wf2.pid<>wf.pid and kn2.pid1=wf2.pid and kn2.pid2<>wf.pid)) or not exists( select 1 from worksfor wf3 where wf3.cname=wf.cname and wf3.pid<>wf.pid);


-- (b) Formulate this query in SQL by only using the IN, NOT IN, SOME, or ALL set membership predicates. 
-- You can not use the set oper- ations INTERSECT, UNION, and EXCEPT.
select wf.cname, wf.pid from worksfor wf where wf.pid in (select kn1.pid2 from worksfor wf1, knows kn1 where wf1.cname=wf.cname and wf1.pid<>wf.pid and kn1.pid1=wf1.pid and kn1.pid2=wf.pid and wf.pid = All(select kn2.pid2 from worksfor wf2, knows kn2 where wf2.cname=wf.cname and wf2.pid<>wf1.pid and wf2.pid<>wf.pid and kn2.pid1=wf2.pid)) or wf.pid= all( select wf3.pid from worksfor wf3 where wf3.cname=wf.cname);

-- (c) Formulate this query in SQL without using set predicates.
with same_company as (select distinct kn.pid1, kn.pid2, wf1.cname from knows kn, worksfor wf1, worksfor wf2 where wf1.cname=wf2.cname and wf1.pid=kn.pid1 and wf2.pid=kn.pid2), known_persons as (select distinct pid2, cname from same_company), single_person_in_company as (select distinct wf1.cname, wf1.pid from worksfor wf1 except select distinct wf1.cname, wf1.pid from worksfor wf1, worksfor wf2 where wf1.cname=wf2.cname and wf1.pid<>wf2.pid) select q.* from ((select ks.cname, ks.pid2  from known_persons ks except select distinct ks.cname, ks.pid2 from same_company sc1, known_persons ks where sc1.cname=ks.cname and sc1.pid2<>ks.pid2) union select * from single_person_in_company) q;


\qecho 'Problem 4'

-- Consider the query “Find each skill that is not a jobskill of any person
-- who works for Yahoo or for Netflix.

-- (a) Formulate this query in SQL using subqueries and set predicates. 
-- You can not use the set operations INTERSECT, UNION, and EXCEPT.
with people_skill as (select distinct ps.skill from personskill ps where exists(
select 1 from worksfor wf where (wf.cname='Yahoo' or wf.cname='Netflix') and wf.pid=ps.pid)
) select s.skill from skill s where not exists ( select 1 from people_skill ps where ps.skill=s.skill) ;

-- (b) Formulate this query in SQL without using predicates.
with people_skill as (select distinct ps.skill from personskill ps, worksfor wf where (wf.cname='Yahoo' or wf.cname='Netflix') and wf.pid=ps.pid) select s.* from (select s.skill from skill s except (select s.skill from skill s, people_skill ps where ps.skill=s.skill)) s;


\qecho 'Problem 5'

--  Consider the query “Find the pid and name of each person who
--  manages all but 1 person who work for Google.


-- (a) Formulate this query in SQL using subqueries and set predicates. 
-- You can not use the set operations INTERSECT, UNION, and EXCEPT.
with worksfor_google as (select distinct hm.eid , hm.mid from hasmanager hm, worksfor wf where wf.cname='Google' and wf.pid=hm.eid and hm.mid in (select wfm.pid from worksfor wfm where wfm.cname='Google' and wfm.pid<>hm.eid)) select distinct per.pid, per.pname from person per, worksfor_google wfg where per.pid=wfg.mid and not exists(	select 1 from worksfor_google wfg2 where wfg2.eid<>wfg.eid and wfg2.mid<>wfg.mid);

-- (b) Formulate this query in SQL without using set predicates.
-- Needs work
with worksfor_google as (select distinct hm.eid , hm.mid from hasmanager hm, worksfor wf, worksfor wfm where wf.cname='Google' and wf.pid=hm.eid and wfm.cname='Google' and wfm.pid=hm.mid)
select q.* from (select distinct wf.mid as pid, pers.pname from person pers, worksfor_google wf where wf.mid=pers.pid  except select distinct wfg.mid, p.pname from  worksfor_google wfg, worksfor_google wfg2, person p where wfg2.eid<>wfg.eid and wfg2.mid<>wfg.mid and p.pid=wfg.mid) q;


\qecho 'Problem 6'
-- Problem 1 in RA SQL2
with works_for_google as (select p.pid, p.pname, wf.cname, wf.salary from worksfor wf join person p on (p.pid =wf.pid ) where wf.cname='Google'), people_details as (select wg.*, kn.pid2 from works_for_google wg join knows kn on (kn.pid1=wg.pid)) select distinct pd.pid, pd.pname from people_details pd join works_for_google wg on (pd.pid2=wg.pid) and pd.salary > wg.salary;

\qecho 'Problem 7'
-- Problem 2 in RA SQL
with required_company as (select distinct c.cname from company c join companylocation cl on (cl.cname=c.cname) where c.headquarter='Cupertino' and cl.city<>'Indianapolis'), company_details as (
select w.pid, w.salary, w.cname from worksfor w join required_company rc on (w.cname=rc.cname) 
),personal_details as  (select cd.cname, p.pid, p.pname, cd.salary from person p join company_details cd on (cd.pid=p.pid)),lowest_removed as (select distinct pd1.* from personal_details pd1 join personal_details pd2 on  (pd1.pid<>pd2.pid) and (pd1.salary-pd2.salary) > 0) select distinct ntl1.* from lowest_removed ntl1 join lowest_removed ntl2 on(ntl1.pid <>ntl2.pid) and (ntl1.salary -ntl2.salary)=0 ;

\qecho 'Problem 8'
-- Problem 3 in RA SQL
with same_company as (select distinct kn.pid1, kn.pid2, wf1.cname from worksfor wf1 join worksfor wf2 on (wf1.cname=wf2.cname) join knows kn on (wf1.pid=kn.pid1 and wf2.pid=kn.pid2)),
known_persons as (select distinct pid2, cname from same_company),single_person_in_company as 
(select distinct wf1.cname, wf1.pid from worksfor wf1 except select distinct wf1.cname, wf1.pid from worksfor wf1 join  worksfor wf2 on(wf1.cname=wf2.cname and wf1.pid<>wf2.pid))
select ks.cname, ks.pid2  from known_persons ks except
(select distinct ks.cname, ks.pid2 from same_company sc1 join known_persons ks on(sc1.cname=ks.cname and sc1.pid2<>ks.pid2) ) union select * from single_person_in_company;


\qecho 'Problem 9'
-- Problem 4 in RA SQL
with people_skill as (select distinct ps.skill from personskill ps join worksfor wf on (wf.pid=ps.pid)  where (wf.cname='Yahoo' or wf.cname='Netflix'))select s.skill from skill s except (select s.skill from skill s join people_skill ps on (ps.skill=s.skill));

\qecho 'Problem 10'
-- Problem 5 in RA SQL
with worksfor_google as (select distinct hm.eid , hm.mid from hasmanager hm join worksfor wf on (wf.pid=hm.eid) join worksfor wfm on (wfm.pid=hm.mid) where wf.cname='Google' and wfm.cname='Google'
)select distinct wf.mid as pid, pers.pname from person pers join worksfor_google wf on(wf.mid=pers.pid)   except select distinct wfg.mid, p.pname from  worksfor_google wfg join worksfor_google wfg2 on (wfg2.eid<>wfg.eid and wfg2.mid<>wfg.mid) join person p on(p.pid=wfg.mid);


\qecho 'Problem 16'

-- Create a view {\tt Triangle} that contains each triple of pids of different persons $(p_1,p_2,p_3)$
-- that mutually know each other.   

-- Then test your view.

create view triangle as(with two_p as(select distinct p1.pid1, p1.pid2 from knows p1, knows p2 where p2.pid1=p1.pid2 and p2.pid2=p1.pid1), three_p as (select distinct tp.pid1,tp.pid2, p3.pid2 as pid3 from two_p tp, knows p3 where tp.pid2=p3.pid1 and tp.pid1<>p3.pid2 and exists (select 1 from knows ktest where ktest.pid1=p3.pid2 and ktest.pid2=tp.pid1)) select distinct * from three_p tp where exists (select 1 from knows kn where kn.pid1=tp.pid1 and kn.pid2=tp.pid3) and exists(select 1 from knows kn where kn.pid1=tp.pid3 and kn.pid2=tp.pid2));

select pid1, pid2, pid3 from triangle;


\qecho 'Problem 17'


-- Define a parameterized view SalaryBelow(cname text, salary integer) that returns, 
-- for a given company identified by cname and a given salary value, 
-- the subrelation of Person of persons who work for company cname and whose salary is strictly below salary.

-- Test your view for the parameter values (’IBM’,60000), (’IBM’,50000), and (’Apple’,65000).
create function SalaryBelow(compname text, emp_salary integer)
returns TABLE(pid integer, pname text, city text) as
$$
select per.* from person per, worksfor wf where wf.cname=compname and wf.salary < emp_salary and per.pid=wf.pid order by per.pid;
$$ language sql;

select * from SalaryBelow('IBM',60000);
select * from SalaryBelow('IBM',50000);
select * from SalaryBelow('Apple', 65000);

\qecho 'Problem 18'

-- Define a parameterized view KnowsPersonAtCompany(p integer, c text) that returns
-- for a person with pid p the subrelation of Person of persons who p knows and 
-- who work for the company with cname c.

-- Test you view for the parameters (1001, ‘Amazon’), (1001,‘Apple’), and (1015,‘Netflix’).

create function KnowsPersonAtCompany(p integer, c text)
returns TABLE(pid integer, pname text, city text) as
$$
	select per.* from person per where per.pid in (select kn.pid2 from knows kn where kn.pid1=p and exists(select 1 from worksfor wf where wf.pid=kn.pid2 and wf.cname=c))
$$ language sql;
select * from KnowsPersonAtCompany(1001, 'Amazon');
select * from KnowsPersonAtCompany(1001,'Apple');
select * from KnowsPersonAtCompany(1015,'Netflix');


\qecho 'Problem 19'

-- Define a parameterized view KnownByPersonAtCompany(p integer, c text)
-- that returns the subrelation of Person of persons who know the person
-- with pid p and who work for the company with cname c.  

-- Test your view for the parameters (1001, ‘Amazon’), (1001,‘Apple’),
-- and (1015,‘Netflix’).

create function KnownByPersonAtCompany(p integer, c text)
returns TABLE(pid integer, pname text, city text) as
$$
	select per.* from person per where per.pid in (select kn.pid1 from knows kn where kn.pid2=p) and exists (select 1 from worksfor wf1 where wf1.pid=per.pid and wf1.cname=c)
$$ language sql;
select * from KnownByPersonAtCompany(1001, 'Amazon');
select * from KnownByPersonAtCompany(1001,'Apple');
select * from KnownByPersonAtCompany(1015,'Netflix');

\qecho 'Problem 20'

-- Let Tree(parent : integer, child : integer) be a rooted parent-child tree. 
-- So a pair (n,m) in Tree indicates that node n is a parent of node m. 

-- The sameGeneration(n1, n2) binary relation is inductively defined using the following two rules:
--  If n is a node in T , then the pair (n, n) is in the sameGeneration relation. (Base rule)

--   If $n_1$ is the parent of $m_1$ in $Tree$ and $n_2$ is the parent of
--   $m_2$ in $Tree$ and $(n_1,n_2)$ is a pair in the {\tt sameGeneration}
--   relation then $(m_1,m_2)$ is a pair in the {\tt sameGeneration}
--   relation. ({\bf Inductive Rule})

-- Write a \blue{recursive view} for the {\tt sameGeneration} relation.
-- 
-- Test your view.
CREATE RECURSIVE VIEW sameGeneration(n1, n2) as
(
	select t.parent, t.parent from tree as t
	union
	select t.child, t.child from tree as t
	union
	select t1.child, t2.child from tree t1, tree t2, sameGeneration sg where sg.n1=t1.parent and sg.n2=t2.parent
);
select * from sameGeneration order by n1;

\qecho 'Connect to default database'

\c postgres;

\qecho 'Drop database created for this assignment'

DROP DATABASE kiran_karandikar;
