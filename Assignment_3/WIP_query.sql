-- Script for Assignment 3

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

\qecho 'Problem 6'

-- Consider the query ``Find the cname and headquarter of
-- each company that employs persons who earns less than 55000 and who do
-- not live in Bloomington.''

-- A possible way to write this query in Pure SQL is 

select c.cname, c.headquarter
from   company c
where  c.cname in (select w.cname
                   from   worksfor w
                   where  w.salary < 55000 and 
                          w.pid = SOME (select p.pid
                                        from   person p
                                        where  p.city <> 'Bloomington'));

-- Using the Pure SQL to RA SQL translation algorithm, translate this
-- Pure SQL query to an equivalent RA SQL query.  Show the translation
-- steps you used to obtain your solution.

-- step 1
select c.cname, c.headquarter
from   company c where  c.cname in (select q.cname from (select w.cname from worksfor w where  w.salary < 55000 intersect select w.cname from worksfor w, person p where  w.salary < 55000 and w.pid=p.pid and p.city <>'Bloomington')q);
-- step 2
with required_person as (select p.pid from person p where p.city<>'Bloomington') 
select c.cname, c.headquarter from company c where  c.cname in (select q.cname from (select w.cname from worksfor w where  w.salary < 55000 intersect select w.cname from worksfor w, required_person rp where  w.salary < 55000 and w.pid=rp.pid ) q);


-- step 3
with required_person as (select p.pid from person p where p.city<>'Bloomington'),
salry_details as (select w.pid, w.cname from worksfor w where  w.salary < 55000)
select c.cname, c.headquarter from company c where  c.cname in (select q.cname from  (select sd.cname from salry_details sd intersect select sd.cname from salry_details sd, required_person rp where  sd.pid=rp.pid) q);
-- step 4
with required_person as (select p.pid from person p where p.city<>'Bloomington'),
salry_details as (select w.pid, w.cname from worksfor w where  w.salary < 55000)
select c.cname, c.headquarter from company c where  c.cname in (select q.cname from  (select sd.cname from salry_details sd intersect select sd.cname from salry_details sd join required_person rp on  (sd.pid=rp.pid))q);
-- step 5
with required_person as (select p.pid from person p where p.city<>'Bloomington'),
salry_details as (select w.pid, w.cname from worksfor w where  w.salary < 55000),
required_company as (select sd.cname from salry_details sd intersect select sd.cname from salry_details sd join required_person rp on  (sd.pid=rp.pid))
select c.cname, c.headquarter from company c where  c.cname in (select rd.cname from required_company rd);
-- step 6
with required_person as (select p.pid from person p where p.city<>'Bloomington'),
salry_details as (select w.pid, w.cname from worksfor w where  w.salary < 55000),
required_company as (select sd.cname from salry_details sd intersect select sd.cname from salry_details sd join required_person rp on  (sd.pid=rp.pid))
select q.* from (select c.cname, c.headquarter from company c intersect   select c.cname, c.headquarter from company c, required_company rd where rd.cname=c.cname) q;
-- step 7
with required_person as (select p.pid from person p where p.city<>'Bloomington'),
salry_details as (select w.pid, w.cname from worksfor w where  w.salary < 55000),
required_company as (select sd.cname from salry_details sd intersect select sd.cname from salry_details sd join required_person rp on  (sd.pid=rp.pid))
select q.* from  (select c.cname, c.headquarter from company c intersect   select c.cname, c.headquarter from company c join required_company rd on (rd.cname=c.cname))q;

\qecho 'Problem 7'

-- Consider the query ``Find the pid of each person who has
-- all-but-one job skill."

-- A possible way to write this query in Pure SQL is


select p.pid
from   person p
where  exists (select 1
               from   skill s
               where  (p.pid, s.skill) not in (select ps.pid, ps.skill 
                                               from   personSkill ps)) and
        not exists (select 1
                    from   skill s1, skill s2
                    where  s1.skill <> s2.skill and
                           (p.pid, s1.skill) not in (select ps.pid, ps.skill 
                                                     from   personSkill ps) and
                           (p.pid, s2.skill) not in (select ps.pid, ps.skill 
                                                     from   personSkill ps));

-- Using the Pure SQL to RA SQL translation algorithm, translate this
-- Pure SQL query to an equivalent RA SQL query.  Show the translation
-- steps you used to obtain your solution.

-- step 1
select p.pid from   person p where  exists (select 1 from   skill s where  (p.pid, s.skill) not in (select ps.pid, ps.skill from   personSkill ps)) and not exists (select 1 from   skill s1, skill s2 where  s1.skill <> s2.skill and (p.pid, s1.skill) not in (select ps.pid, ps.skill from   personSkill ps) and (p.pid, s2.skill) not in (select ps.pid, ps.skill from   personSkill ps));

-- step 2
select p.pid from   person p where  exists (select 1 from   skill s where  (p.pid, s.skill) not in (select ps.pid, ps.skill from   personSkill ps)) and not exists (select 1 from   skill s1, skill s2 where  s1.skill <> s2.skill and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s1.skill=ps.skill) and (p.pid, s2.skill) not in (select ps.pid, ps.skill from   personSkill ps));

-- step 3
select p.pid from   person p where  exists (select 1 from   skill s where  (p.pid, s.skill) not in (select ps.pid, ps.skill from   personSkill ps)) and not exists (select 1 from   skill s1, skill s2 where  s1.skill <> s2.skill and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s1.skill=ps.skill) and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s2.skill=ps.skill));


--step 4:
select p.pid from   person p where  exists (select * from  skill s except select s.* from skill s,personSkill ps where ps.pid=p.pid and ps.skill=s.skill) 
and not exists (select 1 from   skill s1, skill s2 where  s1.skill <> s2.skill and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s1.skill=ps.skill) and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s2.skill=ps.skill));

-- step 5
select p.pid from   (select * from  skill s, person p except select s.*, p.* from skill s,personSkill ps, person p where ps.pid=p.pid and ps.skill=s.skill) p where not exists (select 1 from   skill s1, skill s2 where  s1.skill <> s2.skill and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s1.skill=ps.skill) and not exists (select 1 from   personSkill ps where p.pid=ps.pid and s2.skill=ps.skill));


-- step 6: 
with required_person as (select * from  skill s, person p except select s.*, p.* from skill s,personSkill ps, person p where ps.pid=p.pid and ps.skill=s.skill)
select p.pid from required_person   p where not exists (
select q.* from (select * from   skill s1, skill s2 where  s1.skill <> s2.skill except
select s1.*, s2.* from   skill s1, skill s2, personSkill ps where  s1.skill <> s2.skill and p.pid=ps.pid and s1.skill=ps.skill) q intersect select q1.* from (select * from   skill s1, skill s2 where  s1.skill <> s2.skill except
select s1.*, s2.* from   skill s1, skill s2, personSkill ps where  s1.skill <> s2.skill and p.pid=ps.pid and s2.skill=ps.skill) q1);
-- step 7:
with required_person as (select * from  skill s cross join person p except select s.*, p.* from skill s cross join personSkill ps cross join person p where ps.pid=p.pid and ps.skill=s.skill)
select p.pid from required_person p except select p.pid from  (select q1.* from (select * from   skill s1 cross join skill s2 cross join required_person p where  s1.skill <> s2.skill except
select s1.*, s2.*, p.* from   skill s1 cross join skill s2 cross join personSkill ps cross join required_person p where  s1.skill <> s2.skill and p.pid=ps.pid and s1.skill=ps.skill) q1 intersect select q2.* from (select * from   skill s1 cross join skill s2 cross join required_person p where  s1.skill <> s2.skill except
select s1.*, s2.*, p.* from   skill s1 cross join skill s2 cross join personSkill ps cross join required_person p where  s1.skill <> s2.skill and p.pid=ps.pid and s2.skill=ps.skill) q2) p;



\qecho 'Problem 8'

-- Consider the query ``Find the pid and name of each person who
-- works for a company located in Bloomington but who does not knows any
-- person who lives in Chicago.''

 
-- A possible way to write this query in Pure SQL is

select p.pid, p.pname
from   person p
where  exists (select 1
               from   worksFor w, companyLocation c
               where  p.pid = w.pid and w.cname = c.cname and c.city = 'Bloomington') and
       p.pid not in (select k.pid1
                     from   knows k
                     where  exists (select 1
                                    from   person p
                                    where  k.pid2 = p.pid and  p.city = 'Chicago'));

-- Using the Pure SQL to RA SQL translation algorithm, translate this
-- Pure SQL query to an equivalent RA SQL query.  Show the translation
-- steps you used to obtain your solution.


-- step 2:
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington') 
select p.pid, p.pname from   person p where  exists (select 1 from worksdetail wd where p.pid=wd.pid) and p.pid not in (select k.pid1 from   knows k where  exists (select 1 from   person p where  k.pid2 = p.pid and  p.city ='Chicago')) order by p.pid;

-- step 3:
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago')
select p.pid, p.pname from   person p where  exists (select 1 from worksdetail wd where p.pid=wd.pid) and p.pid not in (select k.pid1 from   knows k where  exists (select 1 from persondetail pd where  k.pid2 = pd.pid)) order by p.pid;

-- step 4
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago')
select p.pid, p.pname from   person p where  exists (select 1 from worksdetail wd where p.pid=wd.pid) and p.pid not in (select k.pid1 from   knows k, persondetail pd where  k.pid2 = pd.pid) order by p.pid;
-- step 5
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago')
select p.pid, p.pname from   person p where  exists (select 1 from worksdetail wd where p.pid=wd.pid) and p.pid not in (select k.pid1 from   knows k join persondetail pd on (k.pid2 = pd.pid)) order by p.pid;
-- step 6:
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago')
select p.pid, p.pname from   person p, worksdetail wd where p.pid=wd.pid and p.pid not in (select k.pid1 from   knows k join persondetail pd on (k.pid2 = pd.pid)) order by p.pid;
-- step 7:
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago')
select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) and p.pid not in (select k.pid1 from   knows k join persondetail pd on (k.pid2 = pd.pid)) order by p.pid;
-- step 8:
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago'), 
knowdetails as (select k.pid1 from knows k join persondetail pd on (k.pid2 = pd.pid))
select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) and p.pid not in (select kd.pid1 from knowdetails kd) order by p.pid;
-- step 9:
with worksdetail as (select w.pid, w.cname from worksFor w, companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago'), 
knowdetails as (select k.pid1 from knows k join persondetail pd on (k.pid2 = pd.pid))
select q.* from (select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) except select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) and p.pid in (select kd.pid1 from knowdetails kd)) q;
-- step 10:
with worksdetail as (select w.pid, w.cname from worksFor w cross join companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago'), 
knowdetails as (select k.pid1 from knows k join persondetail pd on (k.pid2 = pd.pid))
select q.* from (select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) except select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) join knowdetails kd on (p.pid=kd.pid1)) q;

\qecho 'Problem 9'

-- Consider the query ''Find the cname and headquarter of each company
-- that (1) employs at least one person and (2) whose workers who make
-- at most 70000 have both the programming and AI skills.”

select c.cname, c.headquarter
from   company c
where  exists (select 1 from worksfor w where w.cname = c.cname) and
       not exists (select 1
                   from   worksfor w
                   where  w.cname = c.cname and w.salary <= 70000 and
                          (w.pid not in (select ps.pid from personskill ps where skill = 'Programming') or
                           w.pid not in (select ps.pid from personskill ps where skill = 'AI')));


-- step 1
select c.cname, c.headquarter
from   company c where  exists (select 1 from worksfor w where w.cname = c.cname) and not exists (select 1 from   worksfor w where  w.cname = c.cname and w.salary <= 70000 and (w.pid not in (select ps.pid from personskill ps where skill = 'Programming') or w.pid not in (select ps.pid from personskill ps where skill = 'AI')));
						   
-- step 2
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000)
select c.cname, c.headquarter
from   company c where  exists (select 1 from worksfor w where w.cname = c.cname) and not exists (select 1 from   wsalrydetails w where  w.cname = c.cname and (w.pid not in (select ps.pid from personskill ps where skill = 'Programming') or w.pid not in (select ps.pid from personskill ps where skill = 'AI')));

-- step 3
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000)
select distinct c.cname, c.headquarter
from   company c, worksfor w where w.cname = c.cname and not exists (select 1 from   wsalrydetails w where  w.cname = c.cname and (w.pid not in (select ps.pid from personskill ps where skill = 'Programming') or w.pid not in (select ps.pid from personskill ps where skill = 'AI')));
-- step 4 
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI')
select distinct c.cname, c.headquarter
from   company c join worksfor w on (w.cname = c.cname) and not exists (select 1 from   wsalrydetails w where  w.cname = c.cname and (w.pid not in (select ps.pid from prog ps) or w.pid not in (select * from ai)));

-- step 5 
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI')
select distinct c.cname, c.headquarter from company c join worksfor w on (w.cname = c.cname) and not exists (select 1 from   wsalrydetails w where  w.cname = c.cname and w.pid not in (select ps.pid from prog ps) union
select 1 from   wsalrydetails w where  w.cname = c.cname and w.pid not in (select * from ai));

-- step 6 
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI')
select distinct c.cname, c.headquarter from company c join worksfor w on (w.cname = c.cname) and not exists (select q2.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w where  w.cname = c.cname and w.pid in (select ps.pid from prog ps)) q2 union
select q1.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w where  w.cname = c.cname and w.pid in (select * from ai)) q1);

-- step 7
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI')
select distinct c.cname, c.headquarter from company c join worksfor w on (w.cname = c.cname) and not exists (select q2.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w, prog ps where  w.cname = c.cname and w.pid=ps.pid) q2 union
select q1.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w, ai where  w.cname = c.cname and ai.pid=w.pid) q1);

-- step 8 
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI')
select distinct c.cname, c.headquarter from company c join worksfor w on (w.cname = c.cname) and not exists (select q2.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w join prog ps on(w.cname = c.cname and w.pid=ps.pid)) q2 union
select q1.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w join ai on(w.cname = c.cname and ai.pid=w.pid)) q1);

-- step 9 
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI'),
c_details as (select distinct c.cname, c.headquarter from company c join worksfor w on (w.cname = c.cname))
select c.* from  c_details c where not exists (select q2.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w join prog ps on(w.cname = c.cname and w.pid=ps.pid)) q2 union
select q1.* from (select w.* from   wsalrydetails w where  w.cname = c.cname except select w.* from   wsalrydetails w join ai on(w.cname = c.cname and ai.pid=w.pid)) q1);

-- step 10 
with wsalrydetails as (select w.pid, w.cname from  worksfor w where w.salary <= 70000),
prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI'),
c_details as (select distinct c.cname, c.headquarter from company c join worksfor w on (w.cname = c.cname))select q.* from (select c.* from  c_details c except select subq.cc, subq.hq from (	
select q2.cc, q2.hq from (select w.*, c.cname as cc, c.headquarter as hq from wsalrydetails w join c_details c on (w.cname = c.cname) except select w.*, c.cname as cc, c.headquarter as hq from   wsalrydetails w join c_details c on (w.cname = c.cname) join prog ps on (w.pid=ps.pid)) q2 union select q1.cc, q1.hq from (select w.*, c.cname as cc, c.headquarter as hq from wsalrydetails w join c_details c on(w.cname = c.cname) except select w.*,  c.cname as cc, c.headquarter as hq from   wsalrydetails w join c_details c on (w.cname = c.cname) join ai on(ai.pid=w.pid)) q1
)subq)q;

\qecho 'Problem 10'

-- Consider the following Pure SQL query.

select p.pid, exists (select 1
                      from   hasManager hm1, hasManager hm2
                      where  hm1.mid = p.pid and hm2.mid = p.pid and
                             hm1.eid <> hm2.eid)
from   Person p;

-- This query returns a pair (p,t) if p is the pid of a person who
-- manages at least two persons and returns the pair (p,f) otherwise.

-- Using the insights gained from Problem 2, translate
-- this Pure SQL query to an equivalent RA SQL query.

-- step 1
select p.pid, exists (select 1
                      from   hasManager hm1, hasManager hm2
                      where  hm1.mid = p.pid and hm2.mid = p.pid and
                             hm1.eid <> hm2.eid)
from   Person p;

-- step 2
select p.pid, exists (select 1
                      from   hasManager hm1 join hasManager hm2
                      on  (hm1.mid = p.pid and hm2.mid = p.pid and
                             hm1.eid <> hm2.eid))
from   Person p;

-- step 3:
with true_d as (select distinct p.pid, True from   hasManager hm1 join hasManager hm2 on (hm1.eid <> hm2.eid) join person p on  (hm1.mid = p.pid and hm2.mid = p.pid))
select q.pid, False from (select p.pid from person p 
except
select true_d.pid from true_d) q
union
select true_d.* from true_d;



-- Connect to default database
\c postgres

-- Drop database created for this assignment
-- DROP DATABASE kiran_karandikar;





