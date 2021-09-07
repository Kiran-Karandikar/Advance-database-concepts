CREATE DATABASE kiran_karandikar;

\c kiran_karandikar;

CREATE TABLE Person (
pid INTEGER PRIMARY KEY,
pname TEXT,
city TEXT
);

CREATE TABLE Company (
cname TEXT PRIMARY KEY,
headquarter TEXT
);
 
CREATE TABLE Skill (
skill TEXT PRIMARY KEY
);



CREATE TABLE worksFor (
pid INTEGER references Person(pid),
cname TEXT references Company(cname),
salary INTEGER,
PRIMARY KEY (pid)
);

CREATE TABLE companyLocation
(
cname TEXT references Company(cname), 
city TEXT,
PRIMARY KEY (cname, city)
);

CREATE TABLE personSkill
(
pid INTEGER references Person(pid), 
skill TEXT references Skill(skill),
PRIMARY KEY (pid, skill)
);

CREATE TABLE hasManager
(
eid INTEGER references Person(pid), 
mid INTEGER references Person(pid),
PRIMARY KEY (eid, mid)
);



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
     ('ACM', 'NewYork');
	 
INSERT INTO Skill VALUES
   ('Programming'),
   ('AI'),
   ('Networks'),
   ('OperatingSystems'),
   ('Databases');
   
   
   
   

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
     (1013,'Netflix', 55000),
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
   ('IBM', 'NewYork');



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
 (1013,'AI'),
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
 (1014, 1012);


\qecho 'Problem 1'
\qecho 'Problem 1 conceptual example 1'
\qecho 'Deletion of primary key not allowed.'

	-- select * from skill;
	-- select * from personskill;
	-- 
	-- select * from skill s where s.skill='Networks';
	-- select * from personskill ps where ps.skill='Networks';
	
	-- Example 1:
	-- Deletion of primary key not allowed.
	-- ERROR:  update or delete on table "skill" violates foreign key constraint "personskill_skill_fkey" on table "personskill"
	-- DETAIL:  Key (skill)=(Networks) is still referenced from table "personskill".
	
	delete from skill s where s.skill='Networks';
	 -- select * from personskill ps where ps.skill='Networks';
	
	
\qecho 'Problem 1 conceptual example 2'
\qecho 'Insert not allowed in realtion since primary key is not present.'

	-- ERROR:  insert or update on table "personskill" violates foreign key constraint "personskill_pid_fkey"
	-- DETAIL:  Key (pid)=(1050) is not present in table "person".

insert into personskill values (1050, 'Visualization');
	
\qecho 'Problem 1 conceptual example 3'
\qecho 'Deletion of keys in relation does not affect parent data'

delete from personskill ps where ps.skill='Networks' and ps.pid=1010;
select count(*) from skill s where s.skill='Networks';

-- select * from skill s where s.skill='Networks';
-- select * from personskill ps where ps.skill='Networks';
-- delete from personskill ps where ps.skill='Networks' and ps.pid=1010;
-- select * from skill s where s.skill='Networks';

\qecho 'Problem 1 conceptual example 4'
\qecho 'Altering primary key in parent table'
\qecho 'Adding constarint on delte cascade'

ALTER TABLE personskill DROP CONSTRAINT "personskill_skill_fkey";
ALTER TABLE personskill ADD CONSTRAINT "personskill_skill_fkey" foreign key (skill) references skill(skill) ON DELETE CASCADE;
select count(*) from personskill ps where ps.skill='Networks';
select count(*)  from skill s where s.skill='Networks';
delete from skill s where s.skill='Networks';
select count(*) from personskill ps where ps.skill='Networks';
	

\qecho  'Reverting back the tables'

ALTER TABLE personskill DROP CONSTRAINT "personskill_skill_fkey";
ALTER TABLE personskill ADD CONSTRAINT "personskill_skill_fkey" foreign key (skill) references skill(skill);


INSERT INTO Skill VALUES ('Networks') Except (select * from skill s where s.skill='Networks');
INSERT INTO personskill values 
(1005,'Networks'),
(1009,'Networks'),
(1010,'Networks'),
(1011,'Networks'),
(1013,'Networks'),
(1014,'Networks'),
(1017,'Networks'),
(1019,'Networks');


\qecho 'Problem 2'

select distinct p.pid, p.pname from person p, worksFor w, hasManager hm where p.city='Bloomington' and p.pid=w.pid and w.salary > 30000 and hm.eid=p.pid;

\qecho 'Problem 3'

select distinct c1.cname, c2.cname from Company c1, Company c2 where c1.headquarter=c2.headquarter and c1.cname!=c2.cname;


\qecho 'Problem 4'

select p.pid, p.pname from person p, hasmanager hm where hm.eid=p.pid and not exists (select 1 from person m, hasmanager hm1 where hm1.mid=m.pid and m.city=p.city and hm1.eid=p.pid) order by p.pid;


\qecho 'Problem 5'

select s.skill from skill s Except
(
select distinct ps1.skill From Personskill ps1, Personskill ps2 where ps1.pid<>ps2.pid and ps1.skill=ps2.skill and Exists(
	select * from Personskill ps where ps.skill in (ps1.skill, ps2.skill) and ps.pid NOT in (ps1.pid, ps2.pid)
)
);

\qecho 'Problem 6'
select p.pid, p.pname, wf.salary from worksFor wf, person p where wf.pid=p.pid and Exists (
select 1 from hasmanager hm1, hasmanager hm2 where hm1.eid=hm2.eid and hm1.eid=p.pid and 
hm1.mid<>hm2.mid and Exists (select 1 from personskill ps1, personskill ps2 where ps1.skill<>'Networks' and ps1.pid=hm1.mid and ps2.pid=hm2.mid and ps1.skill=ps2.skill));


\qecho 'Problem 7'

SELECT distinct cname FROM worksfor where pid not in (SELECT pid FROM person where city='MountainView') order by cname;

\qecho 'Problem 8'

SELECT w.cname, w.salary FROM worksfor w where exists (select 1 from worksfor wf where wf.cname = w.cname and w.salary>= wf.salary and not exists (select 1 from worksfor w2 where wf.cname = w2.cname and w2.salary> wf.salary )) order by w.cname;


\qecho 'Problem 9'

with personal_Details as(select p.pid, p.pname, salary from person p, worksfor wf where p.pid=wf.pid  and Exists(select * from hasmanager hm where hm.eid=p.pid))
select pd.pid, pd.pname from personal_Details pd where pd.salary > all (select distinct wf.salary from worksfor wf where wf.pid in (select hm.mid from hasmanager hm where hm.eid=pd.pid)) order by pd.pid;


\qecho 'Problem 10'

select p.pid, p.pname, w.cname, w.salary from person p, worksfor w where p.pid=w.pid and p.city='Bloomington' and w.cname<>'Apple' and w.salary >= 40000;

\qecho 'Problem 11'

select p.pid, p.pname From person p where Exists(select 1 from company c, worksfor w where p.pid=w.pid and c.cname=w.cname and c.headquarter='LosGatos' and Exists (select 1 from hasmanager hm,person m where hm.eid=p.pid and hm.mid=m.pid and m.city<>'LosGatos'));

\qecho 'Problem 12'

select s.skill from skill s where Not Exists(select 1 from Personskill ps, person p where ps.pid=p.pid and ps.skill=s.skill and p.city='Bloomington');


\qecho 'Problem 13'
select m.pid, m.pname from Person m where Not Exists(select 1 from hasmanager hm where hm.mid=m.pid and Not Exists(select 1 from Person e where hm.eid=e.pid and e.city=m.city)) order by m.pid;


\qecho 'Problem 18'

select not exists(select 1 from worksfor wf where Not Exists(select 1 from personskill ps1, personskill ps2 where ps1.pid=ps2.pid and ps1.skill<>ps2.skill and ps1.pid=wf.pid)) as constraintSatisfied;

\qecho 'Problem 19'
select exists(select  1 from hasmanager hm where Exists (select 1 from worksfor w1, worksfor w2 where w1.pid=hm.eid and w2.pid=hm.mid and w1.salary>w2.salary)
) as constraintSatisfied;

\qecho 'Problem 20'
select not exists(select 1 from hasmanager hm where not Exists (select 1 from worksfor w1, worksfor w2 where w1.pid=hm.eid and w2.pid=hm.mid and w1.cname=w2.cname)) as constraintSatisfied;


\qecho 'Connect to default database'

\c postgres;

\qecho 'Drop database created for this assignment'

DROP DATABASE kiran_karandikar;
