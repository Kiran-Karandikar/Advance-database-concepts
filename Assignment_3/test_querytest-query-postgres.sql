-- write the query for 1,2
-- write the query 4,5
-- optimize all the queries from 6-10
-- Probelm 1,2 ,10 are realted

-- Problem 1
create table F( random_numbers int);
select * from F;
insert into F values(1),(2),(3);
select * from F;
delete from F where random_numbers in (1,2,3);
drop table F;

create temp view exp1 as (
	select 5*4 as a
);
create temp view exp2 as (
	select 20*4 as a
);
drop view exp1, exp2;
select * from exp1;
select * from exp2;

select * from exp1 where not exists(select distinct row() from F)
union
select * from exp2 where exists(select distinct row() from F);
select * from F;



-- step 1
with subq as (select distinct row() from F)
select * from exp1 where not exists(select * from subq)
union
select * from exp2 where exists(select * from subq);
-- step 2
with single_record as (select distinct row() as arecord from F),
subq as (select True as arecord from single_record)
select distinct exp1.* from exp1 
except
select distinct exp1.* from exp1 cross join subq where subq.arecord=True
union
select distinct exp2.* from exp2 cross join subq where subq.arecord=True;




-- problem 2

create table r(	x int);
insert into r values (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
select * from r;
select not exists(select 1 from r r1, r r2 where r1.x<>r2.x) as fewerThanTwo;
drop table r;


with less_than_2 as (select 1 from r r1, r r2 where r1.x<>r2.x),
drow as (select distinct row() as fewerThanTwo  from less_than_2)
select q.* from (select True as fewerThanTwo
except
select True as fewerThanTwo from drow)q
union
select False as fewerThanTwo from drow;

-- Problem 3
select L1(r1,...,rn) from R1 r1, ..., Rn rn where C1(r1,...,rn) and [not] exists (select L2(s1,...,sm)
from S1 s1,..., S1 sm where C2(s1,...,sm,r1,...,rn) [union | intersect | except] select L3(t1,...,tk)
from T1 t1, ..., Tk tk where C3(t1,...,tk,r1,...,rn))

-- single query
select L1(r) from R r where C1(r) [not] exists (select L2(s) from S s where C2(s,r) [union | intersect | except] select L3(t) from T t where C3(t,r))

-- exists and union
select L1(r) from (
select L1(r), L2(s) from S s cross join R r where C1(r) and C2(s,r) union select L3(t), L1(s) from T t cross join R r where C1(r) and C3(t,r)))

-- exists and intersect
select L1(r) from (
select L1(r), L2(s) from S s, R r where C1(r) and C2(s,r) intersect select L3(t), L2(s) from T t, R r where C1(r) and C3(t,r)))

-- exists and except
select L1(r) from (
select L1(r), L2(s) from S s, R r where C1(r) and C2(s,r) except select L3(t), L2(s) from T t, R r where C1(r) and C3(t,r)))


-- single query

select L1(r) from R r where C1(r) not exists (select L2(s) from S s where C2(s,r) union select L3(t) from T t where C3(t,r))

-- Problem 4
-- LHS
select r.cname as a, s.pid as d from worksfor r, person s where r.pid=s.pid

--LHS -step 1
select r.cname as a, w.pid from worksfor r where  exists(select 1 from person p where p.pid=w.pid)

-- LHS -- step 2= RHS
with s as (select p.pid from person p),
r as (select w.cname, w.pid from worksfor w)
select r.cname, s.pid from r join s on(r.pid=s.pid)


-- RHS
select q.cname, q.salary form (select )


-- Probelm 6:
select c.cname, c.headquarter
from   company c where  c.cname in (select w.cname from worksfor w where  w.salary < 55000 and w.pid = SOME (select p.pid from   person p where p.city <>'Bloomington'));
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

-- step 8 test
with required_person as (select p.pid from person p where p.city<>'Bloomington'),
salry_details as (select w.pid, w.cname from worksfor w where  w.salary < 55000),
required_company as (select sd.cname from salry_details sd natural join required_person rp)
select distinct q.* from  (select c.cname, c.headquarter from company c natural join required_company rd)q;


-- problem 2
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
select s1.*, s2.* from   skill s1, skill s2, personSkill ps where  s1.skill <> s2.skill and p.pid=ps.pid and s2.skill=ps.skill) q1)
-- step 7:
with required_person as (select * from  skill s cross join person p except select s.*, p.* from skill s cross join personSkill ps cross join person p where ps.pid=p.pid and ps.skill=s.skill)
select p.pid from required_person p except select p.pid from  (select q1.* from (select * from   skill s1 cross join skill s2 cross join required_person p where  s1.skill <> s2.skill except
select s1.*, s2.*, p.* from   skill s1 cross join skill s2 cross join personSkill ps cross join required_person p where  s1.skill <> s2.skill and p.pid=ps.pid and s1.skill=ps.skill) q1 intersect select q2.* from (select * from   skill s1 cross join skill s2 cross join required_person p where  s1.skill <> s2.skill except
select s1.*, s2.*, p.* from   skill s1 cross join skill s2 cross join personSkill ps cross join required_person p where  s1.skill <> s2.skill and p.pid=ps.pid and s2.skill=ps.skill) q2) p;


--- step 8 test
with required_person as (select p.pid, s.skill  from  skill s cross join person p except select ps.* from personSkill ps)
select p.pid from required_person p except select p.pid from  (select q1.* from (select * from   skill s1 join skill s2 on (s1.skill <> s2.skill) cross join required_person p ) q1 except												   
select q2.* from (select s1.*, s2.*, p.* from   skill s1 join skill s2 on (s1.skill <> s2.skill )cross join personSkill ps join required_person p on (p.pid=ps.pid)  where   s1.skill=ps.skill or s2.skill=ps.skill) q2) p;






-- Problem 3:
-- step 1
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

-- step 11 --test
with worksdetail as (select w.pid from worksFor w cross join companyLocation c where w.cname = c.cname and c.city = 'Bloomington'), persondetail as (select p.pid from person p where p.city ='Chicago'), 
knowdetails as (select k.pid1 from knows k join persondetail pd on (k.pid2 = pd.pid))
select q.* from (select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) except select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) join knowdetails kd on (p.pid=kd.pid1)) q;

-- step 12 test
with worksdetail as (select w.pid from worksFor w where w.cname in (select c.cname from companyLocation c where c.city = 'Bloomington')), persondetail as (select p.pid from person p where p.city ='Chicago'), 
knowdetails as (select k.pid1 from knows k where k.pid2 in (select * from persondetail))
select q.* from (select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) except select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) join knowdetails kd on (p.pid=kd.pid1)) q;


-- step 13 test
with worksdetail as (select w.pid from worksFor w where w.cname in (select c.cname from companyLocation c where c.city = 'Bloomington')), persondetail as (select p.pid from person p where p.city ='Chicago'), 
knowdetails as (select k.pid1 from knows k where k.pid2 in (select * from persondetail))
select q.* from (select p.pid, p.pname from   person p join worksdetail wd on (p.pid=wd.pid) except select p.pid, p.pname from   person p join knowdetails kd on (p.pid=kd.pid1)) q;

-- problem 9
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



-- step 11 test
with prog as (select ps.pid from personskill ps where skill = 'Programming'),
ai  as (select ps.pid from personskill ps where skill = 'AI'),
c_details as (select distinct w.pid, c.cname, c.headquarter from company c natural join worksfor w where w.salary <= 70000)
select q.* from (select c.cname, c.headquarter from  c_details c except select subq.cc, subq.hq from (	
select c.pid, c.cname as cc, c.headquarter as hq from c_details c except (select c.pid, c.cname as cc, c.headquarter as hq from c_details c join prog ps on (c.pid=ps.pid) intersect (select c.pid, c.cname as cc, c.headquarter as hq from c_details c join ai on (ai.pid=c.pid))))subq )q;






-- problem 10

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


-- step 4  --test
with q as (
with true_d as (select distinct hm1.mid as pid, True from   hasManager hm1 join hasManager hm2 on (hm1.eid <> hm2.eid and hm1.mid =hm2.mid ))
select q.pid, False from (select p.pid from person p 
except
select true_d.pid from true_d) q
union
select true_d.* from true_d)
select count(*) from q where q.bool=True;


-- step 5 test
with q as (
with true_d as (select distinct hm1.mid as pid, True from   hasManager hm1 join hasManager hm2 on (hm1.eid <> hm2.eid and hm1.mid =hm2.mid ))
select p.pid, False from person p 
union
select true_d.* from true_d)
select distinct * from q where q.bool=True;


-- step 6 test
with q as (
with true_d as (select distinct hm1.mid as pid, True from   hasManager hm1 where hm1.mid in (select hm2.mid from hasManager hm2 where hm1.eid <> hm2.eid))
select p.pid, False from person p 
union
select true_d.* from true_d)
select distinct * from q where q.bool=True;