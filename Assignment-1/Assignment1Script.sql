-- Creating database with full name
 
CREATE DATABASE kiran_karandikar;

-- Connecting to database 
\c kiran_karandikar;

-- Defining Schemas



CREATE Person (
pid INTEGER PRIMARY KEY,
pname TEXT,
city TEXT
);

-- Data for B561 Fall 2021 Assignment 1

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


-- Provide 4 conceptually different examples that illustrate how the
-- presence or absence of primary and foreign keys affect insert and
-- deletes in these relations.  To solve this problem, you will need to
-- experiment with the relation schemas and instances for this
-- assignment.  For example, you should consider altering primary keys
-- and foreign key constraints and then consider various sequences of
-- insert and delete operations.  You may need to change some of the
-- relation instances to observe the desired effects.  Certain inserts
-- and deletes should succeed but other should generate error
-- conditions.  (Consider the lecture notes about keys, foreign keys,
-- and inserts and deletes as a guide to solve this problem.)



\qecho 'Problem 1 conceptual example 1'

\qecho 'Problem 1 conceptual example 2'

\qecho 'Problem 1 conceptual example 3'

\qecho 'Problem 1 conceptual example 4'

-- Before starting with the rest of the assignment, make sure to
-- use the originally given data set in data.sql

\qecho 'Problem 2'
-- Find the pid, pname of each person who (a) lives in Bloomington, (b)
-- works for a company where he or she earn a salary that is higher than
-- 30000, and (c) has at least one manager.



\qecho 'Problem 3'
-- Find the pairs $(c_1, c_2)$ of different company names who
-- headquarters are located in the same city.  



\qecho 'Problem 4'
-- Find the pid and pname of each person who lives in a city that is
-- different than each city in which his or her managers live.
-- (Persons who have no manager should not be included in the answer.)



\qecho 'Problem 5'
-- Find each skill that is the skill of at most 2 persons.



\qecho 'Problem 6'
-- Find the pid, pname, and salary of each employee who has at least two
-- managers such that these managers have a common job skill but provided
-- that it is not the `Networks' skill.



\qecho 'Problem 7'
-- Find the cname of each company that not only employs persons
-- who live in MountainView.



\qecho 'Problem 8'
-- For each company, list its name along with the highest salary made by
-- employees who work for it.



\qecho 'Problem 9'
-- Find the pid and pname of each employee who has a salary that is
-- higher than the salary of each of his or her managers.  (Employees who
-- have no manager should not be included.)


\qecho 'Problem 10'



\qecho 'Problem 11'



\qecho 'Problem 12'



\qecho 'Problem 13'



\qecho 'Problem 18'
-- Each person works for a company and has at least two job skills.



\qecho 'Problem 19'
-- Some person has a salary that is strictly higher than the salary of
-- each of his or her managers.



\qecho 'Problem 20'
-- Each employee and his or her managers work for the same company.



-- Connect to default database
\c postgres;

-- Drop database created for this assignment
DROP DATABASE yourname;
