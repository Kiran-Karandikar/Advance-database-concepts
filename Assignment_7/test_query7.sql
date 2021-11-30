-- Problem 7
-- working query


drop function if exists same_Generation_func();
create or replace function same_Generation_func()
returns void as 
$$
declare
	new_count bigint := -1;
	Begin
	drop table if exists connected_nodes;
	drop table if exists temp_connected_nodes;
	create table connected_nodes(m int, n int);
	create table temp_connected_nodes(m int, n int);
	insert into connected_nodes SELECT parent, parent FROM PC;
	insert into connected_nodes SELECT child, child from PC where not exists(select 1 from connected_nodes cn where cn.m=child and cn.n=child);	
	while new_count != 0  loop	
		insert into temp_connected_nodes SELECT  distinct t1.child, t2.child FROM connected_nodes pair, PC t1, PC t2 WHERE   pair.m = t1.parent and pair.n = t2.parent;	
		new_count := cast((select distinct count(*) from temp_connected_nodes tcn where not exists(select 1 from connected_nodes cn where tcn.m=cn.m and tcn.n=cn.n)) as int);
		if new_count <> 0 then
			insert into connected_nodes select distinct * from temp_connected_nodes tcn where not exists(select 1 from connected_nodes cn where tcn.m=cn.m and tcn.n=cn.n);
			truncate temp_connected_nodes;
		end if;											
		raise notice 'new_count is %', (new_count);
	end loop;	
	End
$$ language plpgsql;
select same_Generation_func();
SELECT DISTINCT pair.m, pair.n from connected_nodes pair order by m, n;


-- test query

WITH RECURSIVE sameGeneration(m, n) AS
          ((SELECT parent, parent FROM PC) UNION (select child, child from PC)
          UNION
          SELECT  t1.child, t2.child
          FROM    sameGeneration pair, PC t1, PC t2
          WHERE   pair.m = t1.parent and pair.n = t2.parent)		  		  
SELECT DISTINCT pair.m, pair.n from sameGeneration pair order by m, n;

drop function if exists same_Generation_func();
create or replace function same_Generation_func()
returns void as 
$$
declare
	new_count bigint := -1;
	Begin
	drop table if exists connected_nodes;
	drop table if exists temp_connected_nodes;
	create table connected_nodes(m int, n int);
	create table temp_connected_nodes(m int, n int);
	insert into connected_nodes SELECT parent, parent FROM PC;
	insert into connected_nodes SELECT child, child from PC where not exists(select 1 from connected_nodes cn where cn.m=child and cn.n=child);	
	while new_count != 0  loop	
		insert into temp_connected_nodes SELECT  distinct t1.child, t2.child FROM connected_nodes pair, PC t1, PC t2 WHERE   pair.m = t1.parent and pair.n = t2.parent;	
		new_count := cast((select distinct count(*) from temp_connected_nodes tcn where not exists(select 1 from connected_nodes cn where tcn.m=cn.m and tcn.n=cn.n)) as int);
		if new_count <> 0 then
			insert into connected_nodes select distinct * from temp_connected_nodes tcn where not exists(select 1 from connected_nodes cn where tcn.m=cn.m and tcn.n=cn.n);
			truncate temp_connected_nodes;
		end if;											
		raise notice 'new_count is %', (new_count);
	end loop;	
	End
$$ language plpgsql;
select same_Generation_func();
SELECT DISTINCT pair.m, pair.n from connected_nodes pair  where m =2 or m=3 order by m, n;



-- problem 8
-- working query - a

drop function if exists recursiveAggregatedWeight(part_n int);
create or replace function recursiveAggregatedWeight(part_n int)
returns int8 as 
$$
declare
	total_weight int8 :=0;
	p int8 :=0;
	q int8 :=0;
	s int8 :=0;
	Begin
		if exists(select 1 from basicPart bp where bp.pid=part_n) then
		select into total_weight bp.weight from basicPart bp where bp.pid=part_n;
		return total_weight;
		else 
		FOR p,s,q in (select * from partsubpart ps where ps.pid=part_n)
		loop
			total_weight := total_weight + q * (select recursiveAggregatedWeight(cast(s as integer)));
		end loop;
		return total_weight;
		end if;
	End
$$ language plpgsql;

select * from partsubpart;
select * from basicPart;
with part as 
  (select pid as P
   from   partSubPart
   union  
   select sid as P
   from   partSubpart)
select part.P, recursiveAggregatedWeight(part.P) 
from   part order by 1;


-- test query


select * from partsubpart where pid=2 or pid=5 or pid=9 or pid=12;
select * from basicPart;

drop view if exists bp_weight;
create or replace temp view bp_weight as (
select ps.pid, ps.sid as part_id, bp.weight, ps.quantity, ps.quantity * bp.weight as t_weight from partsubpart ps join basicpart bp on (bp.pid=ps.sid));

select pid, sum(t_weight) from bp_weight group by pid order by pid;

drop function if exists recursiveAggregatedWeight();
create or replace function recursiveAggregatedWeight(part_n int)
returns int8 as 
$$
declare
	total_weight int8 :=0;
	p int8 :=0;
	q int8 :=0;
	s int8 :=0;
	Begin
		if exists(select 1 from basicPart bp where bp.pid=part_n) then
		select into total_weight bp.weight from basicPart bp where bp.pid=part_n;
		return total_weight;
		else 
		FOR p,s,q in (select * from partsubpart ps where ps.pid=part_n)
		loop
			total_weight := total_weight + q * (select recursiveAggregatedWeight(cast(s as integer)));
		end loop;
		return total_weight;
		end if;
	End
$$ language plpgsql;
select 2, recursiveAggregatedWeight(2);
$$
declare
	total_weight int8 :=0;
	
	

-- part b

-- working query


drop function if exists nonRecursiveAggregatedWeight(part_n int);
create or replace function nonRecursiveAggregatedWeight(part_n int)
returns int8 as 
$$
declare
	zero_weight_parts int8 := 0;
	temp_weight int8:= 0;
	total_weight int8 :=0;
	part int8 :=0;
	quan int8 :=0;	
	ss int8 :=0;
	no_w int8 := 0;
	Begin
	drop table if exists temp_weights;
	create table temp_weights(p bigint, s bigint, q bigint, tw bigint);
	insert into temp_weights (select *,0 from partsubpart ps where ps.pid=part_n);
	zero_weight_parts := (select count(1) from temp_weights where tw=0);
		while zero_weight_parts!=0 loop
			for part,ss,quan,no_w in select * from temp_weights where tw=0 loop	
				if exists(select 1 from temp_weights tws where tws.p=ss) then	
					if exists (select 1 from temp_weights tws where tws.p=ss and tws.tw <>0) then 
						temp_weight := quan *(select tws.tw from temp_weights tws where tws.p=ss);
						update temp_weights set p=part,s=ss,q=quan,tw=temp_weight where p=part and s=ss;	
					end if;
				else 
					if exists(select 1 from basicPart bp where bp.pid=ss) then
						temp_weight := quan *(select weight from basicPart bp where bp.pid=ss);
						update temp_weights set p=part,s=ss,q=quan,tw=temp_weight where p=part and s=ss;
					else 
						insert into temp_weights (select *,0 from partsubpart ps where ps.pid=ss);
					end if;							
				end if;			
			end loop;
			zero_weight_parts := (select count(1) from temp_weights where tw=0);
		end loop;
		total_weight := (select sum(tw) from temp_weights where p=part_n);
		return total_weight;
	End
$$ language plpgsql;

select * from partsubpart;
select * from basicPart;
with part as 
  (select pid as P
   from   partSubPart
   union  
   select sid as P
   from   partSubpart)
select part.P, recursiveAggregatedWeight(part.P) 
from   part order by 1;

-- test query
drop function if exists nonRecursiveAggregatedWeight(part_n int);
create or replace function nonRecursiveAggregatedWeight(part_n int)
returns int8 as 
$$
declare
	zero_weight_parts int8 := 0;
	temp_weight int8:= 0;
	total_weight int8 :=0;
	part int8 :=0;
	quan int8 :=0;	
	ss int8 :=0;
	no_w int8 := 0;
	Begin
	drop table if exists temp_weights;
	create table temp_weights(p bigint, s bigint, q bigint, tw bigint);
	insert into temp_weights (select *,0 from partsubpart ps where ps.pid=part_n);
	zero_weight_parts := (select count(1) from temp_weights where tw=0);
		while zero_weight_parts!=0 loop
			for part,ss,quan,no_w in select * from temp_weights where tw=0 loop	
				if exists(select 1 from temp_weights tws where tws.p=ss) then	
					if exists (select 1 from temp_weights tws where tws.p=ss and tws.tw <>0) then 
						temp_weight := quan *(select tws.tw from temp_weights tws where tws.p=ss);
						update temp_weights set p=part,s=ss,q=quan,tw=temp_weight where p=part and s=ss;	
					end if;
				else 
					if exists(select 1 from basicPart bp where bp.pid=ss) then
						temp_weight := quan *(select weight from basicPart bp where bp.pid=ss);
						update temp_weights set p=part,s=ss,q=quan,tw=temp_weight where p=part and s=ss;
					else 
						insert into temp_weights (select *,0 from partsubpart ps where ps.pid=ss);
					end if;							
				end if;			
			end loop;
			zero_weight_parts := (select count(1) from temp_weights where tw=0);
		end loop;
		total_weight := (select sum(tw) from temp_weights where p=part_n);
		return total_weight;
	End
$$ language plpgsql;
select 2, nonRecursiveAggregatedWeight(2);

select sum(tw) from temp_weights where p=2 ;



-- Problem 11

-- test query

-- working query

