-- remaining
-- probelm 5: apple, micrsoft pair
-- Problem 9e:  -- pair apple, 1009
-- verify all without set predicate things

	
-- problem 1

select w.cname, count(w.pid)  from worksfor w group by (w.cname) having (50000 <= avg(w.salary)) and (avg(w.salary) <=55000) order by w.cname;

-- problem 2 

select ps.pid, count(ps.skill) from personskill ps group by (ps.pid) order by ps.pid;
select * from skill;
-- what it means by at leat 4 job skills;
select ps.pid from personskill ps except
select ps.pid from personskill ps group by (ps.pid) having count(ps.skill) >4;
select ps.pid, count(ps.skill) from personskill ps group by (ps.pid) 
-- knows at least 4 persons
select kn.pid1 from knows kn group by (kn.pid1) having count(kn.pid2)>=4

select count(*) as total_skills from skill;
-- test query
with knows_at_least_4_persons as (
select kn.pid1 from knows kn group by (kn.pid1) having count(kn.pid2)>=4),
lack_at_least_4_skills as (
select ps.pid from personskill ps group by (ps.pid)  having ((select count(*) as total_skills from skill)- count(ps.skill)) >=4
)
select p.pid, p.pname from person p where p.pid in (select * from knows_at_least_4_persons) and p.pid in (select * from lack_at_least_4_skills)
union
select p.pid, p.pname from person p where p.pid not in (select ps.pid from personskill ps) and p.pid in (select * from knows_at_least_4_persons)

-- working query
with knows_at_least_4_persons as (
select kn.pid1 from knows kn group by (kn.pid1) having count(kn.pid2)>=4),
lack_at_least_4_skills as (
select ps.pid from personskill ps group by (ps.pid)  having ((select count(*) as total_skills from skill)- count(ps.skill)) >=4
)
select p.pid, p.pname from person p where p.pid in (select * from knows_at_least_4_persons) and p.pid in (select * from lack_at_least_4_skills)
union
select p.pid, p.pname from person p where p.pid not in (select ps.pid from personskill ps) and p.pid in (select * from knows_at_least_4_persons)


-- problem 3
with all_g_skills as (
with wgoogle as (select w.pid from worksfor w where w.cname='Google')
select  count(distinct ps.skill) from personskill ps where ps.pid in (select * from wgoogle))
select  p.pid, p.pname from person p where p.pid in (select ps.pid from personskill ps) 

-- test query
-- what is fewer than 2 means???
with all_g_skills as (
with wgoogle as (select w.pid from worksfor w where w.cname='Google')
select  count(distinct ps.skill) from personskill ps where ps.pid in (select * from wgoogle))
select  p.pid, p.pname from person p where p.pid in (select ps.pid from personskill ps group by ps.pid having ((select * from all_g_skills) - count(ps.skill)) >2)

-- working query
with r_skills as (
with wgoogle as (select w.pid from worksfor w where w.cname='Google')
select  distinct ps.skill from personskill ps where ps.pid in (select * from wgoogle)),
fewerthan_two as (
select ps.pid from personskill ps where ps.skill in (select * from r_skills) group by ps.pid having count(ps.skill) <2),
no_skills as (select p.pid, p.pname from person p where p.pid not in (select ps.pid from personskill ps))
(select p.pid, p.pname from person p where p.pid in (select * from fewerthan_two))
union
(select * from no_skills);









-- problem 4 
-- test query
with required_companies as (
select w.cname, count(w.pid), avg(w.salary) as avg_sal from worksfor w group by (w.cname) having count(w.pid)>=3)
select min(rc1.avg_sal) from required_companies rc1



-- working query
with required_companies as (
select w.cname, count(w.pid), avg(w.salary) as avg_sal from worksfor w group by (w.cname) having count(w.pid)>=3)
select rc.cname from required_companies rc where rc.avg_sal in (select min(rc1.avg_sal) from required_companies rc1)

-- problem 5

-- working query
create or replace function abs_avg_salary(company_name text, comp_avg_sal float) 
returns table(cname text) as 
$$
with other_companies as (
	select rc1.cname ,abs(rc1.avg_sal - comp_avg_sal) as distance from required_companies rc1 where rc1.cname<>company_name and abs(rc1.avg_sal - comp_avg_sal) >=0
)
select oc1.cname from other_companies oc1 where oc1.distance in (select min(distance) from other_companies oc)
$$ language sql;
with required_companies as (
select w.cname, avg(w.salary) as avg_sal from worksfor w group by (w.cname))
select rc1.cname as c1,rc2 as c2  from required_companies rc1, abs_avg_salary(rc1.cname, rc1.avg_sal) as rc2 order by c1;



-- test query --- issue
drop function if exists abs_avg_salary(company_name text, comp_avg_sal float);
drop view if exists required_companies;
create or replace temp view required_companies as (
select w.cname, avg(w.salary) as avg_sal from worksfor w group by (w.cname));

select rc.* from required_companies as rc;

create or replace function abs_avg_salary(company_name text, comp_avg_sal float) 
returns table(cname text) as 
$$
with other_companies as (
	select rc1.cname ,abs(rc1.avg_sal - comp_avg_sal) as distance from required_companies rc1 where rc1.cname<>company_name and abs(rc1.avg_sal - comp_avg_sal) >=0
)
select oc1.cname from other_companies oc1 where oc1.distance in (select min(distance) from other_companies oc)
$$ language sql;
select rc1.cname as c1,rc2 as c2  from required_companies rc1, abs_avg_salary(rc1.cname, rc1.avg_sal) as rc2 order by c1;

-- problem 6
-- working query
with rc as (
	select w.pid from worksfor w where w.cname='Apple' and w.salary<55000
),
fquery as (select rc.pid, kn.pid1 as person_id from rc cross join knows kn except select kn1.pid2, kn.pid1 from knows kn1 join knows kn on (kn1.pid1=kn.pid1)
)
select distinct fq.person_id from fquery fq order by fq.person_id;


-- test query
create or replace temp view rc as (
	select w.pid from worksfor w where w.cname='Apple' and w.salary<55000
);
select * from rc;
select distinct p.pid1 from knows p where exists(select rc.pid from rc except select kn.pid2 from knows kn where kn.pid1=p.pid1)

-- probelm 7 

-- working query
with skill_count as (
select ps.skill, count(ps.skill) from personskill ps group by ps.skill),
same_skills_count as (select s1.skill as skill1, s2.skill as skill2 from skill_count s1 join skill_count s2 on (s1.count=s2.count)),
not_required_pair as (
	select ps.pid, sc.* from personskill ps join same_skills_count sc on(ps.skill=sc.skill1)
	except
	select ps.pid, sc.* from personskill ps join same_skills_count sc on(ps.skill=sc.skill2)
)
select skill1, skill2 from same_skills_count except select skill1, skill2 from not_required_pair;

-- test query
drop  view if exists skill_count;
create or replace temp view skill_count as (
select ps.skill, count(ps.skill) from personskill ps group by ps.skill);
select * from skill_count;
select sc.pid from skill_count sc group by sc.count;



select s1.skill, s2.skill from skill_count s1, skill_count s2 where  s1.count=s2.count and not exists(
	select ps.pid from personskill ps where ps.skill=s1.skill
	except
	select ps.pid from personskill ps where ps.skill=s2.skill
)


-- problem 8
-- working query
with skill_count as (
select ps.skill, count(ps.pid) from personskill ps group by ps.skill)
select s1.skill, s2.skill, s1.count from skill_count s1 join skill_count s2 on ( s1.skill<>s2.skill and s1.count=s2.count) order by s1.count;

-- test query
create or replace temp view skill_count as (
select ps.skill, count(ps.pid) from personskill ps group by ps.skill);
select * from skill_count;

select s1.skill, s2.skill, s1.count from skill_count s1, skill_count s2 where s1.skill<>s2.skill and s1.count=s2.count order by s1.count


-- problem 9 -- 
-- 9.a --create function
-- working query
drop function if exists  numberOfSkills(c text);
create or replace function numberOfSkills(c text)
returns table (pid integer, salary int, numberOfSkills bigint) as
$$
with p_details as (select w.pid, w.salary from worksfor w where w.cname=c),person_skill as (select ps.pid, count(ps.skill) from personskill ps group by ps.pid)
(select pd.pid, pd.salary, ps.count from p_details pd join person_skill ps on (pd.pid=ps.pid))union(select pd.pid, pd.salary, 0 from p_details pd where pd.pid not in (select ps.pid from person_skill ps))
	
$$ language sql;

-- 9b
-- working query
select * from numberOfSkills('Apple') order by numberOfSkills;
select * from numberOfSkills('Amazon') order by numberOfSkills;
select * from numberOfSkills('ACM') order by numberOfSkills;

-- 9c 
-- working query
drop function if exists  numberOfSkills(c text);
create or replace function numberOfSkills(c text)
returns table (pid integer, salary int, numberOfSkills bigint) as
$$
with p_details as (select w.pid, w.salary from worksfor w where w.cname=c),person_skill as (select distinct ps.pid, (select count(ps1.skill) from personskill ps1 where ps1.pid=ps.pid) from personskill ps )
(select pd.pid, pd.salary, ps.count from p_details pd join person_skill ps on (pd.pid=ps.pid))union(select pd.pid, pd.salary, 0 from p_details pd where pd.pid not in (select ps.pid from person_skill ps))
	
$$ language sql;


-- testing query

select distinct ps.pid, (select count(ps1.skill) from personskill ps1 where ps1.pid=ps.pid) from personskill ps 

drop function if exists  numberOfSkills(c text);
create or replace function numberOfSkills(c text)
returns table (pid integer, salary int, numberOfSkills bigint) as
$$
with p_details as (select w.pid, w.salary from worksfor w where w.cname=c),person_skill as (select distinct ps.pid, (select count(ps1.skill) from personskill ps1 where ps1.pid=ps.pid) from personskill ps )
(select pd.pid, pd.salary, ps.count from p_details pd join person_skill ps on (pd.pid=ps.pid))union(select pd.pid, pd.salary, 0 from p_details pd where pd.pid not in (select ps.pid from person_skill ps))
	
$$ language sql;



-- 9d
-- working query
select * from numberOfSkills('Apple') order by numberOfSkills;
select * from numberOfSkills('Amazon') order by numberOfSkills;
select * from numberOfSkills('ACM') order by numberOfSkills;


-- 9e
-- working 
with details as(
select c.cname, ns.pid, ns.numberOfSkills as scount, ns.salary from company c, numberOfSkills(c.cname) as ns),
max_skills as (select cname, max(d.scount) as max_count from details d group by cname)
select d.cname, d.pid from details d join max_skills ms on(d.cname=ms.cname and d.scount=ms.max_count) and d.salary> 50000

-- testing 9e
with details as(
select c.cname, ns.pid, ns.numberOfSkills as scount, ns.salary from company c, numberOfSkills(c.cname) as ns),
max_skills as (select cname, max(d.scount) as max_count from details d group by cname)
select d.cname, d.pid from details d join max_skills ms on(d.cname=ms.cname and d.scount=ms.max_count) and d.salary> 50000




-- Problem 10
-- working query


-- testing query
create table p (c int, d int);
create table q (c int, d int);
drop table p,q;

select * from p;
select * from q;
insert into p values (2,2), (-5,1), (5,0);
insert into q values (4,4), (3,3), (1,2), (-1,1);




-- testing query
drop function if exists multiplyPolynomials(polynomal1 text, polynomial2 text);
create or replace function multiplyPolynomials(polynomal1 text, polynomial2 text) returns table(c integer, d integer) as
$$
begin 
return query
execute 'select * from ' || polynomal1;
end;
$$ language plpgsql;

drop function if exists multiplyPolynomials(polynomal1 text, polynomial2 text);
create or replace function multiplyPolynomials(polynomal1 text, polynomial2 text) returns table(c integer, d integer) as
$$

select polynomal1.c from p

$$ language sql;

select * from multiplyPolynomials('p','p')


select * from p;
select * from q;


drop function if exists multiplyPolynomials(polynomial1 text, polynomial2 text);
create or replace function multiplyPolynomials(polynomial1 text, polynomial2 text) returns table(c integer, d integer) as
$$
begin 
return query
execute 'with mul as (select p1.c*p2.c as c, p1.d+p2.d as d from ' || polynomial1 || ' as p1,' || polynomial2 ||' as p2)
select cast(sum(mul.c) as INTEGER), cast(mul.d as INTEGER) from mul group by mul.d order by mul.d desc';

end;
$$ language plpgsql;



select * from multiplyPolynomials('p','q')
select * from multiplyPolynomials('p','p')

select * from multiplyPolynomials('p',$$ multiplyPolynomials('q','p') $$)

-- test query
with mul as (select p.c*q.c as c, p.d+q.d as d from p,q)
select sum(mul.c), mul.d from mul group by mul.d order by mul.d desc;

with test as (
	select * from multiplyPolynomials('q','p')
)
q2 := (select * from multiplyPolynomials('q','p'));
select * from multiplyPolynomials('p', 'test');

select * from multiplyPolynomials('p', $$multiplyPolynomials('q','p')$$);


