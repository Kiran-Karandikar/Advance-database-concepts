-- remaining
-- problem 8 -- array_to_json , b??
-- problem 9

-- Problem 1. a
-- working query
with rp as (
select array_agg(ps.pid) as pids from personHasSkills ps  where is_in('AI', ps.skills) and is_in('Programming', ps.skills))
select c.* from company c where c.cname in (select ce.cname from companyHasEmployees ce, rp  where  cardinality (setintersection(ce.employees, rp.pids))>=2) order by c.cname;

-- test query
-- person with AI and the Programming job skills.
with rp as (
select array_agg(ps.pid) as pids from personHasSkills ps  where is_in('AI', ps.skills) and is_in('Programming', ps.skills))
select c.* from company c where c.cname in (select ce.cname from companyHasEmployees ce, rp  where  cardinality (setintersection(ce.employees, rp.pids))>=2) order by c.cname;

-- Problem 1. b
-- working query

with rc as (
select ce.employees as pids from companyHasEmployees ce where ce.cname in ('Yahoo', 'Netflix')),
all_employee as (
select array_agg(employees) as pids from rc, unnest(rc.pids) employees),
skill_records as (
select distinct unnest(ps.skills) from personHasSkills ps, all_employee where is_in(ps.pid, all_employee.pids))
select * from skill except select * from skill_records



-- test query
with rc as (
select ce.employees as pids from companyHasEmployees ce where ce.cname in ('Yahoo', 'Netflix')),
all_employee as (
select array_agg(employees) as pids from rc, unnest(rc.pids) employees),
skill_records as (
select distinct unnest(ps.skills) from personHasSkills ps, all_employee where is_in(ps.pid, all_employee.pids))
select * from skill except select * from skill_records

-- problem 1.c
--working query

with all_people as (
select array_agg(kp.pid) as pids from knowsPersons kp where cardinality(kp.persons)>=5)
select bag_to_set(array_agg(ce.cname)) as companies from companyHasEmployees ce, all_people ap where cardinality(setintersection(ce.employees, ap.pids))>=3;

-- test query




with all_people as (
select array_agg(kp.pid) as pids from knowsPersons kp where cardinality(kp.persons)>=5)
select bag_to_set(array_agg(ce.cname)) as companies from companyHasEmployees ce, all_people ap where cardinality(setintersection(ce.employees, ap.pids))>=3

-- problem 1.d
-- working query

with known_by as (
select p.pid, p.pname, ikbp.persons as persons from person p, isKnownByPersons ikbp where  ikbp.pid=p.pid),
rp as (
select array_agg(ps.pid) as pids from personHasSkills ps where is_in('AI', ps.skills) and  not is_in('Programming', ps.skills))
select kb.pid, kb.pname, setintersection(kb.persons, rp.pids) from known_by kb, rp;

-- test query
with known_by as (
select p.pid, p.pname, ikbp.persons as persons from person p, isKnownByPersons ikbp where  ikbp.pid=p.pid),
rp as (
select array_agg(ps.pid) as pids from personHasSkills ps where is_in('AI', ps.skills) and  not is_in('Programming', ps.skills))
select kb.pid, kb.pname, setintersection(kb.persons, rp.pids) from known_by kb, rp;


-- problem 1.e
-- working query
with mores as (
select array_agg(w.pid) as pids from worksfor w where w.salary> 55000),
pair_1 as (
select sp.skill, cardinality(set_intersection(sp.persons, mp.pids)) as count from skillOfPersons sp, mores mp),
less as (select array_agg(w.pid) as pids from worksfor w where w.salary<= 55000),
pair_2 as (
	select sp.skill, cardinality(set_intersection(sp.persons, lp.pids)) as count from skillOfPersons sp, less lp)	
select p1.skill, p2.skill from pair_1 p1, pair_2 p2 where p1.count < p2.count and p1.skill <> p2.skill



-- test query
with mores as (
select array_agg(w.pid) as pids from worksfor w where w.salary> 55000),
pair_1 as (
select sp.skill, cardinality(set_intersection(sp.persons, mp.pids)) as count from skillOfPersons sp, mores mp),
less as (select array_agg(w.pid) as pids from worksfor w where w.salary<= 55000),
pair_2 as (
	select sp.skill, cardinality(set_intersection(sp.persons, lp.pids)) as count from skillOfPersons sp, less lp)	
select p1.skill, p2.skill from pair_1 p1, pair_2 p2 where p1.count < p2.count and p1.skill <> p2.skill


-- Problem 2

-- working query
with base as (
select 
make_singleton(s1.skill) as sskill, 
remove_element(s1.skill, make_singleton(s1.skill)) as eskill,
(select distinct set_union(make_singleton(s1.skill), make_singleton(s2.skill))) as twoskill
from skill s1, skill s2 where s1.skill<>s2.skill)
select sskill from base
union
select eskill from base
union
select distinct twoskill from base
union
select distinct set_union(b1.twoskill,b2.twoskill) from base b1, base b2 where cardinality(b1.twoskill)=2 and cardinality(b2.twoskill)=2 and overlap(b1.twoskill,b2.twoskill) and not equal(b1.twoskill,b2.twoskill);

-- test query
with base as (
select 
make_singleton(s1.skill) as sskill, 
remove_element(s1.skill, make_singleton(s1.skill)) as eskill,
(select distinct set_union(make_singleton(s1.skill), make_singleton(s2.skill))) as twoskill
from skill s1, skill s2 where s1.skill<>s2.skill)
select sskill from base
union
select eskill from base
union
select distinct twoskill from base
union
select distinct set_union(b1.twoskill,b2.twoskill) from base b1, base b2 where cardinality(b1.twoskill)=2 and cardinality(b2.twoskill)=2 and overlap(b1.twoskill,b2.twoskill) and not equal(b1.twoskill,b2.twoskill);




select * from skillOfPersons;
select * from companyHasEmployees;
select * from cityHasCompanies;
select * from companyHasLocations;
select * from knowsPersons;
select * from isKnownByPersons;
select * from personHasSkills;


-- problem 4

-- working query
drop function if exists coOccur(t integer);
create or replace function coOccur(t integer) 
returns table(pair integer[]) as
$$
select distinct set_union(make_singleton(ps1.pid),make_singleton(ps2.pid)) from personHasSkills ps1, personHasSkills ps2 where ps1.pid<>ps2.pid and
cardinality(set_intersection(ps1.skills, ps2.skills)) >= t
$$ language sql;

select * from coOccur(0);
select * from coOccur(1);
select * from coOccur(2);
select * from coOccur(3);

-- test query

drop function if exists coOccur(t integer);
create or replace function coOccur(t integer) 
returns table(pair integer[]) as
$$
select distinct set_union(make_singleton(ps1.pid),make_singleton(ps2.pid)) from personHasSkills ps1, personHasSkills ps2 where ps1.pid<>ps2.pid and
cardinality(set_intersection(ps1.skills, ps2.skills)) >= t
$$ language sql;

select * from coOccur(0);
select * from coOccur(1);
select * from coOccur(2);
select * from coOccur(3);






-- problem 5

-- working query
drop function if exists JaccardSimilar(t float);
drop view if exists jarrod_values;
create temp view jarrod_values as (
select s1.skill as skill1, s2.skill as skill2,
(cast(cardinality(setintersection(s1.persons, s2.persons)) as float)/cast (cardinality(setunion(s1.persons, s2.persons)) as float)) as j_index
from skillOfPersons s1, skillOfPersons s2 where s1.skill <> s2.skill);
create or replace function JaccardSimilar(t float) 
returns table(pair text[]) as
$$
	select distinct  set_union(make_singleton(jv.skill1),make_singleton(jv.skill2)) as pair from jarrod_values jv where cast (jv.j_index as float) >= t
	
$$ language sql;

select * from JaccardSimilar(0.0);
select * from JaccardSimilar(0.25);
select * from JaccardSimilar(0.5);
select * from JaccardSimilar(0.75);
select * from JaccardSimilar(1);

-- test query
drop function if exists JaccardSimilar(t float);
drop view if exists jarrod_values;
create temp view jarrod_values as (
select s1.skill as skill1, s2.skill as skill2,
(cast(cardinality(setintersection(s1.persons, s2.persons)) as float)/cast (cardinality(setunion(s1.persons, s2.persons)) as float)) as j_index
from skillOfPersons s1, skillOfPersons s2 where s1.skill <> s2.skill);
create or replace function JaccardSimilar(t float) 
returns table(pair text[]) as
$$
	select distinct  set_union(make_singleton(jv.skill1),make_singleton(jv.skill2)) as pair from jarrod_values jv where cast (jv.j_index as float) >= t;
	
$$ language sql;

select * from JaccardSimilar(0.0);
select * from JaccardSimilar(0.25);
select * from JaccardSimilar(0.5);
select * from JaccardSimilar(0.75);
select * from JaccardSimilar(1);

-- probelm 6
-- working query

create type stduentsType as (sid text);
create type gradeInfoType as (grade text, sid stduentsType[])
create or replace view courseGrades as (
	with all_sids as (
select cno, grade, array_agg(row(sid)::stduentsType) as sids from enroll group by cno, grade
)
select cno, array_agg(row(grade,sids)::gradeInfoType) as gradeInfo from all_sids group by cno order by 1	
);
select * from courseGrades;


-- test query
select * from student;
select * from enroll;
select * from course;
select cno, array_agg(sid)from enroll group by(cno);
select cno, array_agg(grade)from enroll group by(cno);
select cno, array_agg(row(grade, sid)) from enroll group by(cno);
CREATE TYPE courseType AS (cno text);  
CREATE TYPE gradeCoursesType AS (grade text, courses courseType[]);
with e as (
SELECT cno, array_agg((grade, sid::stduentsType [])::gradeInfoType) AS gradeInfo  FROM enroll
GROUP BY(cno))
select * from e;
create type stduentsType as (sid text);
drop type if exists gradeInfoType;
create type gradeInfoType as (grade text, sid stduentsType[])
drop view if exists courseGrades;
create or replace view courseGrades as (
	with all_sids as (
select cno, grade, array_agg(row(sid)::stduentsType) as sids from enroll group by cno, grade
)
select cno, array_agg(row(grade,sids)::gradeInfoType) as gradeInfo from all_sids group by cno order by 1	
);
select * from courseGrades;

select e.cno,   from enroll e,(select array_agg(row(grade,sid)::)
							   
with all_sids as (
select cno, grade, array_agg(row(sid)::stduentsType) as sids from enroll group by cno, grade
)
select cno, array_agg(row(grade,sids)::gradeInfoType) as gradeInfo from all_sids group by cno order by 1	


-- Problem 7.a
-- working query
with base_q as (
select cg.cno, unnest(gi.sid) as sids from courseGrades cg, unnest(gradeinfo) gi where gi.grade in ('A', 'B'))
select bq.cno, array_agg(bq.sids order by bq.sids) from base_q as bq group by cno order by 1


-- test query

							   
-- Problem 7.b
-- working query
create type courseInfoType as (course_n text);
with base_q as (
select cg.cno, sids.sid from courseGrades cg, unnest(gradeinfo) gi, unnest(gi.sid) sids where gi.grade='A')
select bq.sid as sid, array_agg(row(bq.cno)::courseInfoType order by bq.cno) as courses from base_q as bq group by sid order by 1


-- test query
							   
select cg.cno, unnest(gi.sid).sid as sids from courseGrades cg, unnest(gradeinfo) gi where gi.grade='A'
							   
							   
-- Problem 8
-- working query
with base_q as (
	select cno, grade, array_to_json(array_agg(jsonb_build_object('sid', sid) order by sid)) as js from enroll group by cno, grade )							   
select jsonb_build_object('cno', cno, 'gradeInfo', array_to_json(array_agg(jsonb_build_object('grade', grade, 'students', bq.js))))   as courseinfo from base_q bq group by cno order by cno
	

							   
							   
-- or 
							   drop view if exists jcourseGrades;
create view jcourseGrades as (
with base_q as (
	select cno, grade, jsonb_agg(jsonb_build_object('sid', sid) order by sid) as js from enroll group by cno, grade )				   
select jsonb_build_object('cno', cno, 'gradeInfo', jsonb_agg(jsonb_build_object('grade', grade, 'students', bq.js)))   as courseinfo from base_q bq group by cno order by cno);
select * from jcourseGrades;
							   
-- test query
select jsonb_build_object('cno', cno, 'gradeInfo', grade) from enroll;
							   
select jsonb_build_object('cno', cno, 'gradeInfo', jsonb_build_object('grade', grade, 'students', jsonb_build_object('sid', array_agg(sid)))) from enroll group by cno, grade;
							   
select jsonb_build_object('cno', cno, 'gradeInfo', jsonb_build_object('grade', grade, 'students', jsonb_build_object('sid', array_to_json(array_agg(sid))))) as json_obj from enroll group by cno, grade;
							   

							   
with base_q as (
	select cno, grade, jsonb_build_object('sid', array_to_json(array_agg(sid order by sid))) as js from enroll group by cno, grade )							   
select jsonb_build_object('cno', cno, 'gradeInfo', array_to_json(array_agg(jsonb_build_object('grade', grade, 'students', bq.js))))   as courseinfo from base_q bq group by cno order by cno
	
							   
with base_q as (
	select cno, grade, array_to_json(array_agg(jsonb_build_object('sid', sid) order by sid)) as js from enroll group by cno, grade )							   
select jsonb_build_object('cno', cno, 'gradeInfo', array_to_json(array_agg(jsonb_build_object('grade', grade, 'students', bq.js))))   as courseinfo from base_q bq group by cno order by cno
							   
with base_q as (
	select cno, grade, jsonb_agg(jsonb_build_object('sid', sid) order by sid) as js from enroll group by cno, grade )							   
select jsonb_build_object('cno', cno, 'gradeInfo', jsonb_agg(jsonb_build_object('grade', grade, 'students', bq.js)))   as courseinfo from base_q bq group by cno order by cno

-- problem 9
							   
-- 9.a
							   
-- working query							   
select courseinfo->> 'cno' as cno, students->>'sid' as sids  from jcourseGrades jG, jsonb_array_elements(jG.courseinfo-> 'gradeInfo') gradeinfo, jsonb_array_elements(gradeinfo->'students') students  where gradeinfo ->'grade'<>'"A"';						   

-- test query
							   
select courseinfo->> 'cno' as cno, students->>'sid' as sids  from jcourseGrades jG, jsonb_array_elements(jG.courseinfo-> 'gradeInfo') gradeinfo, jsonb_array_elements(gradeinfo->'students') students  where gradeinfo ->'grade'<>'"A"';								   
							   

select * from jcourseGrades;							   
select jsonb(courseinfo-> 'cno') as cno  from jcourseGrades jG, jsonb_array_elements;
							   
select jsonb_each_text(g) as cno  from jcourseGrades jG, jsonb_array_elements(courseinfo-> 'cno') g

							   
select jsonb(courseinfo) as cno  from jcourseGrades jG;
							   
-- Problem 9.b

-- working query
							   
with rp as (							   
with base_q as (
	select distinct row(jg1.courseinfo->>'cno')::CourseInfoType as cs, sids1->>'sid' as  s
from jcourseGrades jg1, jcourseGrades jg2, jsonb_array_elements(jg1.courseinfo-> 'gradeInfo') gradeInfo1, jsonb_array_elements(jg2.courseinfo-> 'gradeInfo') gradeInfo2, jsonb_array_elements(gradeInfo1->'students') sids1, jsonb_array_elements(gradeInfo2->'students') sids2 where jg1.courseinfo->> 'cno' <> jg2.courseinfo->> 'cno' and gradeInfo1 -> 'grade'= gradeInfo2->'grade' and gradeInfo1->>'grade'='A' and sids1->>'sid'=sids2->>'sid'
)							   
select distinct set_union(make_singleton(b1.cs), make_singleton(b2.cs)) as cp, array_agg(distinct row(b1.s)::studentsInfoType) as s from base_q b1, base_q b2	where cardinality(set_union(make_singleton(b1.cs), make_singleton(b2.cs)))=2 and b1.s=b2.s and b1.cs<>b2.cs group by set_union(make_singleton(b1.cs), make_singleton(b2.cs))),
add_on as (							   
select distinct set_union(make_singleton(row(jg1.courseinfo->>'cno')::CourseInfoType), make_singleton(row(jg2.courseinfo->>'cno')::CourseInfoType)) as cp from jcourseGrades jg1, jcourseGrades jg2 except select bq.cp from rp bq)
select ad.cp as coursePair, array[]::studentsInfoType[] from add_on ad where cardinality(ad.cp)=2 
union 
select * from rp							   
							   
							   
-- test query
							   
select jsonb_pretty(jg.courseinfo) from jcourseGrades jg;
							   
select jg.courseinfo from jcourseGrades jg;							   
							   
with base_q as (			
	
select distinct jg1.courseinfo->>'cno' as coursePair, sids1->>'sid' as  Students
from jcourseGrades jg1, jcourseGrades jg2, jsonb_array_elements(jg1.courseinfo-> 'gradeInfo') gradeInfo1, jsonb_array_elements(jg2.courseinfo-> 'gradeInfo') gradeInfo2, jsonb_array_elements(gradeInfo1->'students') sids1, jsonb_array_elements(gradeInfo2->'students') sids2 where jg1.courseinfo->> 'cno' <> jg2.courseinfo->> 'cno' and gradeInfo1 -> 'grade'= gradeInfo2->'grade' and gradeInfo1->>'grade'='A' and sids1->>'sid'=sids2->>'sid'

)
select distinct set_union(make_singleton(jg1.courseinfo->>'cno'), make_singleton(jg2.courseinfo ->> 'cno')) as coursePair from jcourseGrades jg1, jcourseGrades jg2 except select bq.coursePair from base_q bq

create type studentsInfoType as (sid text);
create type CourseInfoType as (cno text);
create type multiplecourse as (c1 CourseInfoType,c2 CourseInfoType);						   
with base_q as (							   
with b as (							   
select distinct jg1.courseinfo->>'cno' as cs, sids1->>'sid' as  s
from jcourseGrades jg1, jcourseGrades jg2, jsonb_array_elements(jg1.courseinfo-> 'gradeInfo') gradeInfo1, jsonb_array_elements(jg2.courseinfo-> 'gradeInfo') gradeInfo2, jsonb_array_elements(gradeInfo1->'students') sids1, jsonb_array_elements(gradeInfo2->'students') sids2 where jg1.courseinfo->> 'cno' <> jg2.courseinfo->> 'cno' and gradeInfo1 -> 'grade'= gradeInfo2->'grade' and gradeInfo1->>'grade'='A' and sids1->>'sid'=sids2->>'sid')
select bag_to_set(set_union(make_singleton(b1.cs), make_singleton(b2.cs))) as coursePair,  array_agg(distinct row(b1.s)::studentsInfoType) from b b1, b b2 where b1.s=b2.s and b1.cs<>b2.cs group by set_union(make_singleton(b1.cs), make_singleton(b2.cs))
),
add_on as (
select distinct set_union(make_singleton(jg1.courseinfo->>'cno'), make_singleton(jg2.courseinfo ->> 'cno')) as coursePair from jcourseGrades jg1, jcourseGrades jg2 except select bq.coursePair from base_q bq)
select ad.*, array[]::studentsInfoType[] from add_on ad where cardinality(ad.coursePair)=2 
union 
select * from base_q
							   
							   
							   
							   
create temp view b as (							   
select distinct row(jg1.courseinfo->>'cno')::CourseInfoType as cs, sids1->>'sid' as  s
from jcourseGrades jg1, jcourseGrades jg2, jsonb_array_elements(jg1.courseinfo-> 'gradeInfo') gradeInfo1, jsonb_array_elements(jg2.courseinfo-> 'gradeInfo') gradeInfo2, jsonb_array_elements(gradeInfo1->'students') sids1, jsonb_array_elements(gradeInfo2->'students') sids2 where jg1.courseinfo->> 'cno' <> jg2.courseinfo->> 'cno' and gradeInfo1 -> 'grade'= gradeInfo2->'grade' and gradeInfo1->>'grade'='A' and sids1->>'sid'=sids2->>'sid');
							   
select array_agg( distinct row(b1.cs, b2.cs)) as coursePair,  array_agg(distinct row(b1.s)::studentsInfoType) from b b1, b b2 where b1.s=b2.s and b1.cs<>b2.cs group by row(b1.cs, b2.cs) 
		
							   
with rp as (							   
with base_q as (
	select distinct row(jg1.courseinfo->>'cno')::CourseInfoType as cs, sids1->>'sid' as  s
from jcourseGrades jg1, jcourseGrades jg2, jsonb_array_elements(jg1.courseinfo-> 'gradeInfo') gradeInfo1, jsonb_array_elements(jg2.courseinfo-> 'gradeInfo') gradeInfo2, jsonb_array_elements(gradeInfo1->'students') sids1, jsonb_array_elements(gradeInfo2->'students') sids2 where jg1.courseinfo->> 'cno' <> jg2.courseinfo->> 'cno' and gradeInfo1 -> 'grade'= gradeInfo2->'grade' and gradeInfo1->>'grade'='A' and sids1->>'sid'=sids2->>'sid'
)							   
select distinct set_union(make_singleton(b1.cs), make_singleton(b2.cs)) as cp, array_agg(distinct row(b1.s)::studentsInfoType) as s from base_q b1, base_q b2	where cardinality(set_union(make_singleton(b1.cs), make_singleton(b2.cs)))=2 and b1.s=b2.s and b1.cs<>b2.cs group by set_union(make_singleton(b1.cs), make_singleton(b2.cs))),
add_on as (							   
select distinct set_union(make_singleton(row(jg1.courseinfo->>'cno')::CourseInfoType), make_singleton(row(jg2.courseinfo->>'cno')::CourseInfoType)) as cp from jcourseGrades jg1, jcourseGrades jg2 except select bq.cp from rp bq)
select ad.cp as coursePair, array[]::studentsInfoType[] from add_on ad where cardinality(ad.cp)=2 
union 
select * from rp
						  
							   
select * from rp;