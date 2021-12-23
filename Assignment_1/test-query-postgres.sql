-- Problem 4


select p.pid, p.pname from person p, hasmanager hm where hm.eid=p.pid and not exists (select 1 from person m, hasmanager hm1 where hm1.mid=m.pid and m.city=p.city and hm1.eid=p.pid) order by p.pid;

-- Problem 6
select p.pid, p.pname, wf.salary from worksFor wf, person p where wf.pid=p.pid and Exists (
		select 1 from hasmanager hm1, hasmanager hm2 where 					hm1.eid=hm2.eid and 
			hm1.eid=p.pid and 
			hm1.mid<>hm2.mid and 
			Exists(
				select 1 from personskill ps1, personskill ps2
					where
						ps1.skill<>'Networks' and
						ps1.pid=hm1.mid and
						ps2.pid=hm2.mid and
						ps1.skill=ps2.skill
			)
);


-- problem 10
select p.pid, p.pname, w.cname, w.salary from 
	person p, worksfor w where p.pid=w.pid and p.city='Bloomington' and w.cname<>'Apple' and w.salary >= 40000;
	
--problem 11

select p.pid, p.pname From person p where Exists(
	select 1 from company c, worksfor w where
		p.pid=w.pid and 
		c.cname=w.cname and
		c.headquarter='LosGatos' and
		Exists (
			select 1 from hasmanager hm, person m where 
				hm.eid=p.pid and 
				hm.mid=m.pid and 
				m.city<>'LosGatos'
		)
);


-- Problem 12

select s.skill from skill s where Not Exists(
	select 1 from Personskill ps, person p where 
	ps.pid=p.pid and 
	ps.skill=s.skill and
	p.city='Bloomington'
);


-- Problem 13
select m.pid, m.pname from Person m where Not Exists(
	select 1 from hasmanager hm where 
		hm.mid=m.pid and 
		Not Exists(
			select 1 from Person e where
				hm.eid=e.pid and e.city=m.city
		)
) order by m.pid;

-- Problem 18
select not exists(
	select 1 from worksfor wf where Not Exists(
		select 1 from personskill ps1, personskill ps2 where 
			ps1.pid=ps2.pid and ps1.skill<>ps2.skill and 					ps1.pid=wf.pid
	)
) as constraintSatisfied;

-- Problem 19
select exists(
	select  1 from hasmanager hm where Exists (
		select 1 from worksfor w1, worksfor w2 where 
		w1.pid=hm.eid and w2.pid=hm.mid and w1.salary>w2.salary
	)
) as constraintSatisfied;

-- Problem 20
select not exists(
	select 1 from hasmanager hm where not Exists (
		select 1 from worksfor w1, worksfor w2 where 
		w1.pid=hm.eid and w2.pid=hm.mid and w1.cname=w2.cname
	)
) as constraintSatisfied;

--- Testing
-- Problem 2
-- select distinct p.pid, p.pname from person p, worksFor w, hasManager hm where p.city='Bloomington' and p.pid=w.pid and w.salary > 30000 and hm.eid=p.pid;

-- select distinct p.pid, p.pname from person p where p.city='Bloomington' and p.pid in (
-- 	select hm.eid from hasManager hm, worksFor w where hm.eid=w.pid and w.salary > 30000
-- )


SELECT w.cname, w.salary FROM worksfor w, company cm where cm.cname=w.cname and not exists (select 1 from worksfor wf, worksfor  where wf.cname=cm.cname and wf.salary<w.salary) order by w.cname;

problem 8-->
SELECT w.cname, w.salary FROM worksfor w where exists (
	select 1 from worksfor wf where wf.cname = w.cname and 
	w.salary>= wf.salary and not exists (select 1 from worksfor w2 where wf.cname = w2.cname and 
	w2.salary> wf.salary )
	) order by w.cname;


