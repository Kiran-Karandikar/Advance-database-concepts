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

select *
from RelationOverProbabilityFunction(100, 1, 150, 1, 5);

delete
from P;

\qecho 'Test case 2 - non-uniform function'
insert into P
values (1, 0.25),
       (2, 0.10),
       (3, 0.40),
       (4, 0.10),
       (5, 0.15);

select *
from RelationOverProbabilityFunction(100, 1, 150, 1, 5);

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


\qecho 'Problem 5.a'
-- select * from FindStudents('and', 'c202', 'A');

\qecho 'Problem 5.b'
-- select * from FindStudents('or', 'c202', 'A');

\qecho 'Problem 5.c'
-- select * from FindStudents('and not', 'c202', 'A');


\c postgres

-- drop database kiran_karandikar;
