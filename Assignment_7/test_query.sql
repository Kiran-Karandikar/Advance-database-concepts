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
	if exists(select 1 from basicPart bp where bp.pid=part_n) then
		temp_weight := (select weight from basicPart bp where bp.pid=part_n);
		return temp_weight;
	end if;
	drop table if exists temp_weights;
	create table temp_weights(p bigint, s bigint, q bigint, tw bigint);
	insert into temp_weights (select *,0 from partsubpart ps where ps.pid=part_n);
	zero_weight_parts := (select count(1) from temp_weights where tw=0);
		while zero_weight_parts!=0 loop
			for part,ss,quan,no_w in select * from temp_weights where tw=0 loop				
				if exists(select 1 from temp_weights tws where tws.p=ss) then	
					if exists (select 1 from temp_weights tws where tws.p=ss and tws.tw<>0) and not exists (select 1 from temp_weights tws where tws.p=ss and tws.tw=0) then 
						
						temp_weight := quan*(select sum(q.tw) from (select tws.p, tws.tw from temp_weights tws where tws.p=ss and tws.tw<>0) q group by q.p);					update temp_weights set tw=temp_weight where p=part and s=ss;	
					end if;
				else 
					if exists(select 1 from basicPart bp where bp.pid=ss) then
						temp_weight := quan * (select weight from basicPart bp where bp.pid=ss);
						update temp_weights set tw=temp_weight where p=part and s=ss;
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

select sum(quantity) from partsubpart where pid=3 or pid=7 group by pid;

select * from partsubpart where pid =1
select * from basicPart;
with part as 
  (select pid as P
   from   partSubPart
   union  
   select sid as P
   from   partSubpart)
select part.P, nonRecursiveAggregatedWeight(part.P) 
from   part order by 1;

select nonRecursiveAggregatedWeight(1) 

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
-- working query
drop table if exists document;
create table document(doc int, words text[]);
insert into document values (1, ARRAY['A','B','C','D','E']);
insert into document values (2, ARRAY['A','B','C','E', 'F']);
insert into document values (3, ARRAY['A', 'E', 'F']);
insert into document values (4, ARRAY['E', 'A']);
select * from document;


-- Set union $A \cup B$:
create or replace function set_union(A anyarray, B anyarray) 
returns anyarray as
$$
   select array(select unnest(A) union select unnest(B) order by 1);
$$ language sql;

-- Set intersection $A\cap B$:
create or replace function set_intersection(A anyarray, B anyarray) 
returns anyarray as
$$
   select array(select unnest(A) intersect select unnest(B) order by 1);
$$ language sql;

-- Set difference $A-B$:
create or replace function set_difference(A anyarray, B anyarray) 
returns anyarray as
$$
   select array(select unnest(A) except select unnest(B) order by 1);
$$ language sql;


-- Add element to set
create or replace function add_element(x anyelement, A anyarray) 
returns anyarray as
$$
   select bag_to_set(x || A);
$$ language sql;


-- Add element to set
create or replace function remove_element(x anyelement, A anyarray) 
returns anyarray as
$$
   select array_remove(A, x);
$$ language sql;


-- Make singleton  x --->  {x}

create or replace function make_singleton(x anyelement) 
returns anyarray as
$$
   select add_element(x,'{}');
$$ language sql;


-- Choose some element from set A
create or replace function choose_element(A anyarray) 
returns anyelement as
$$
   select x 
   from (select UNNEST(A) as x) q
   order by random();
$$ language sql;


-- Bag operations

-- Bag union 
create or replace function bag_union(A anyarray, B anyarray) 
returns anyarray as
$$
   select A || B;
$$ language sql;

-- bag To set
create or replace function bag_to_set(A anyarray)
returns anyarray as
$$
   select array(select distinct unnest(A) order   by 1);
$$ language sql;


-- Set Predicates: set membership, set non membership, emptyset, subset, superset, overlap, disjoint

-- Set membership $x \in A$:
create or replace function is_in(x anyelement, A anyarray) 
returns boolean as
$$
   select x = SOME(A);
$$ language sql;

-- Set non membership $x \not\in A$:
create or replace function is_not_in(x anyelement, A anyarray) 
returns boolean as
$$
   select not(x = SOME(A));
$$ language sql;

-- emptyset test $A = \emptyset$:
create or replace function is_empty(A anyarray) 
returns boolean as
$$
   select A <@ '{}';
$$ language sql;


-- non emptyset test $A \neq \emptyset$:
create or replace function is_not_empty(A anyarray) 
returns boolean as
$$
   select not(A <@ '{}');
$$ language sql;

-- Subset test $A\subseteq B$:
create or replace function subset(A anyarray, B anyarray) 
returns boolean as
$$
   select A <@ B;
$$ language sql;

-- Superset test $A \supseteq B$:
create or replace function superset(A anyarray, B anyarray) 
returns boolean as
$$
   select A @> B;
$$ language sql;

-- Equality test $A = B$
create or replace function equal(A anyarray, B anyarray) 
returns boolean as
$$
   select A <@ B and A @> B;
$$ language sql;

-- Overlap test $A\cap B \neq \emptyset$:
create or replace function overlap(A anyarray, B anyarray) 
returns boolean as
$$
   select A && B;
$$ language sql;

-- Disjointness test $A\cap B = \emptyset$:
create or replace function disjoint(A anyarray, B anyarray) 
returns boolean as
$$
   select not A && B;
$$ language sql;


drop function if exists count_of_words(all_words anyarray);
create or replace function count_of_words(all_words anyarray)
returns table(doc_count int) as
$$
	select  distinct count(doc) as docs from document where superset(words, all_words)	
$$ language sql;

drop function if exists generate_words(set_length int, t_value int, total_words int);
create or replace function generate_words(set_length int, t_value int, total_words int)
returns void as
$$
	declare
		index_var text[]:= '{}';
		doc_count int := 0;
		inserted int :=0;
	Begin
	 for index_var in select distinct set_union(q.frequentSetswords, q1.frequentSetswords) as gwords from tset q, tset q1 where disjoint(q1.frequentSetswords, q.frequentSetswords) and cardinality(set_union(q.frequentSetswords, q1.frequentSetswords)) > set_length loop
	 		doc_count := (select count_of_words(index_var));
			if doc_count >= t_value then
				if not exists(select 1 from tset  where equal(frequentSetswords,index_var)) then
					insert into tset values (index_var);
					inserted := inserted + 1;
				end if;
			end if;
	 end loop;
	 
	  if inserted <>0 and (set_length + 1) <= total_words then 
	 	perform generate_words(set_length +1 ,t_value, total_words::int);
		end if;
	End
$$ language plpgsql;

drop function if exists frequentSets(t int);
create or replace function frequentSets(t int)
returns table(frequentSetswords text[]) as
$$
declare
	total_words int8 :=0;
	Begin
	drop table if exists tset;
	create table tset(frequentSetswords text[]);
	insert into tset select make_singleton(sw) from (
select *, cardinality(docs) as doc_count from (select  W as sw, array_agg(doc) as docs from document, unnest(words) w where superset(words, '{}') group by W order by W) subq) subqt where doc_count >=t;
	total_words := (select count(*) from (select  distinct unnest(words) from document) subq);
	perform generate_words(1,t, total_words::int);
	insert into tset values ('{}');
	return QUERY select * from tset;
	End
$$ language plpgsql;


select * from frequentSets(1);
select * from frequentSets(2);
select * from frequentSets(3);
select * from frequentSets(4);
select * from frequentSets(5);
select * from frequentSets(6);

----------------------------------------------------------------------------------------------------
-- test query

drop function if exists frequentSets(t int);
create or replace function frequentSets(t int)
returns table(w text[]) as
$$
	Begin
	drop table if exists tset;
	create table tset(words text[]);
	return QUERY select words from document;
	End
$$ language plpgsql;

select * from frequentSets(0);
select * from frequentSets(1);
select * from frequentSets(2);
select * from frequentSets(3);
select * from frequentSets(4);
select * from frequentSets(5);
---------------------------------------------------------------------------------------------------
-- functions copied
-----------------------------------------------------------------------------

------------------------------------------------------------------------------
select * from document where subset('{"A", "E"}', words);



select * from document where subset(make_singleton('D'::text), words)
-- step 1
create temp view temp_view as (
select *, cardinality(docs) as doc_count from (select  W, array_agg(doc) as docs from document, unnest(words) w where superset(words, '{}') group by W order by W) subq);
-- here 4 is nothing but t-values
select make_singleton(w), *, row_number() over (order by W) from temp_view where doc_count >=4;
-- insert those things in temp_table
drop table if exists temp_table;
create table temp_table (swrods text[]);
select * from temp_table;
insert into temp_table select make_singleton(w) from temp_view where doc_count >=4;
--- till here
---------<<< making all possbile combinaitons>>>>

-- at very last insert this.....
insert into temp_table values ('{}');

---------<<< making all possbile combinaitons>>>> here......
select * from temp_table;

with subq as (select make_singleton(w) as te from temp_view where doc_count >=4)
select distinct set_union(q.te, q1.te) from subq q, subq q1 where disjoint(q1.te, q.te)

select * from tset



----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

drop function if exists frequentSets(t int);
create or replace function frequentSets(t int)
returns table(frequentSetswords text[]) as
$$
declare
	total_words int8 :=0;
	Begin
	drop table if exists tset;
	create table tset(frequentSetswords text[]);
	insert into tset select make_singleton(sw) from (
select *, cardinality(docs) as doc_count from (select  W as sw, array_agg(doc) as docs from document, unnest(words) w where superset(words, '{}') group by W order by W) subq) subqt where doc_count >=t;
	total_words := (select count(*) from (select  distinct unnest(words) from document) subq);
	perform generate_words(1,t, total_words::int);
	insert into tset values ('{}');
	return QUERY select * from tset;
	End
$$ language plpgsql;

drop function if exists count_of_words(all_words anyarray);
create or replace function count_of_words(all_words anyarray)
returns table(doc_count int) as
$$
	select  distinct count(doc) as docs from document where superset(words, all_words)	
$$ language sql;

drop function if exists generate_words(set_length int, t_value int, total_words int);
create or replace function generate_words(set_length int, t_value int, total_words int)
returns void as
$$
	declare
		index_var text[]:= '{}';
		doc_count int := 0;
		inserted int :=0;
	Begin
	 for index_var in select distinct set_union(q.frequentSetswords, q1.frequentSetswords) as gwords from tset q, tset q1 where disjoint(q1.frequentSetswords, q.frequentSetswords) and cardinality(set_union(q.frequentSetswords, q1.frequentSetswords)) > set_length loop
	 		doc_count := (select count_of_words(index_var));
			if doc_count >= t_value then
				if not exists(select 1 from tset  where equal(frequentSetswords,index_var)) then
					raise notice 'set_length % and t value is %', set_length, t_value;
					raise notice 'the index var is % %', index_var, doc_count;
					insert into tset values (index_var);
					inserted := inserted + 1;
				end if;
			end if;
	 end loop;
	 
	  if inserted <>0 and (set_length + 1) <= total_words then 
	 	perform generate_words(set_length +1 ,t_value, total_words::int);
		end if;
	End
$$ language plpgsql;

select distinct set_union(q.frequentSetswords, q1.frequentSetswords) as gwords, count_of_words(set_union(q.frequentSetswords, q1.frequentSetswords)) from tset q, tset q1 where disjoint(q1.frequentSetswords, q.frequentSetswords)

select distinct * from tset;
select * from tset;
select * from document;
--------------------------------------------------------------------------------------------------------------
-- Probelm 12
-- working query -- part a

drop function if exists recursiveHamiltonian();
create or replace function recursiveHamiltonian()
returns bool as
$$
declare
	is_hamilton bool := False;
	Begin
		drop table if exists visited;
		create table visited(sources int);
		drop table if exists stage_graph;
		create table stage_graph(ts int, tt int, is_visit int default 0);
		insert into stage_graph select * from graph order by source;
		-- call to recursive function here ---		
		is_hamilton := (select visit_edges());
		return is_hamilton;
	End
$$ language plpgsql;

drop function if exists visit_edges();
create or replace function visit_edges()
returns bool as
$$
	declare
		is_hamilton bool := False;
		s_g int8 :=0;
		t_g int8 :=0;
		not_visited_edges int8 :=0;
	begin
			not_visited_edges := (select count(1) from stage_graph where is_visit=0);
			if not_visited_edges <> 0 then
				select into s_g ts from stage_graph where is_visit=0 order by ts limit 1;
				select into t_g tt from stage_graph where is_visit=0 order by ts limit 1;
				update stage_graph set is_visit=1 where ts=s_g and tt=t_g;
				is_hamilton := (select check_for_cycle(s_g::int,t_g::int));	
				if is_hamilton = False then 
					return false;
				end if;
			end if;
			not_visited_edges := (select count(1) from stage_graph where is_visit=0);
			if not_visited_edges <> 0 then
				is_hamilton := (select visit_edges());
			else
				is_hamilton := (select exists (select count(*) as possible_source from visited group by sources having count(*)>1));
			end if;		
		return is_hamilton;
	end
$$ language plpgsql;

drop function if exists no_cycle();
create or replace function no_cycle()
returns bool as 
$$
	declare
		is_cycle bool := false;
	begin
	is_cycle := (with q as (
		select count(*) as possible_source from visited group by sources having count(*)>1
	),
	multiple_sources as (select count(*) as d_count from q)
	select not exists (
		select 1 from multiple_sources ms where ms.d_count>1
	) as gcycle);
	return is_cycle;
	end

$$ language plpgsql;

drop function if exists check_for_cycle(source_g int,target_g int);
create or replace function check_for_cycle(source_g int,target_g int)
returns bool as
$$
	declare
		total_visited int := 0;
		no_cycle_in_graph bool := True;
	Begin
		total_visited := (select count(*) from visited);
		if total_visited = 0 then
			insert into visited values (source_g);
			insert into visited values (target_g);
			return true;
		else
			if exists(select 1 from visited where sources=source_g) then
					insert into visited values (target_g);
					no_cycle_in_graph := (select no_cycle());
					return no_cycle_in_graph;
			else			
				return false;			
			end if;
		end if;
	end
$$ language plpgsql;







-- test query -- part a
select * from graph;
insert into Graph values
 (1,2),
 (2,3),
 (3,4),
 (4,1);
truncate graph;

--------------------------------------------------------------------------------------------------------
select distinct count(*)/2 as n from graph;

select not exists (select 1 from (select g1.source, (select count(*) from graph g where g.source=g1.source or g.target=g1.source) from graph g1) subq where count<2) -- substitue 2 with n
--------------------------------------------------------------------------------------------------------
drop function if exists recursiveHamiltonian();
create or replace function recursiveHamiltonian()
returns bool as
$$
declare
	is_hamilton bool := False;
	Begin
		drop table if exists visited;
		create table visited(sources int);
		drop table if exists stage_graph;
		create table stage_graph(ts int, tt int, is_visit int default 0);
		insert into stage_graph select * from graph order by source;
		-- call to recursive function here ---		
		is_hamilton := (select visit_edges());
		return is_hamilton;
	End
$$ language plpgsql;

drop function if exists visit_edges();
create or replace function visit_edges()
returns bool as
$$
	declare
		is_hamilton bool := False;
		s_g int8 :=0;
		t_g int8 :=0;
		not_visited_edges int8 :=0;
	begin
			not_visited_edges := (select count(1) from stage_graph where is_visit=0);
			if not_visited_edges <> 0 then
				select into s_g ts from stage_graph where is_visit=0 order by ts limit 1;
				select into t_g tt from stage_graph where is_visit=0 order by ts limit 1;
				update stage_graph set is_visit=1 where ts=s_g and tt=t_g;
				is_hamilton := (select check_for_cycle(s_g::int,t_g::int));	
				if is_hamilton = False then 
					return false;
				end if;
			end if;
			not_visited_edges := (select count(1) from stage_graph where is_visit=0);
			if not_visited_edges <> 0 then
				is_hamilton := (select visit_edges());
			else
				is_hamilton := (select exists (select count(*) as possible_source from visited group by sources having count(*)>1));
			end if;		
		return is_hamilton;
	end
$$ language plpgsql;

drop function if exists no_cycle();
create or replace function no_cycle()
returns bool as 
$$
	with q as (
		select count(*) as possible_source from visited group by sources having count(*)>1
	),
	multiple_sources as (select count(*) as d_count from q)
	select not exists (
		select 1 from multiple_sources ms where ms.d_count>1
	) as gcycle;


$$ language sql;

drop function if exists check_for_cycle(source_g int,target_g int);
create or replace function check_for_cycle(source_g int,target_g int)
returns bool as
$$
	declare
		total_visited int := 0;
		no_cycle_in_graph bool := True;
	Begin
		total_visited := (select count(*) from visited);
		if total_visited = 0 then
			insert into visited values (source_g);
			insert into visited values (target_g);
			return true;
		else
			if exists(select 1 from visited where sources=source_g) then
					insert into visited values (target_g);
					no_cycle_in_graph := (select no_cycle());
					return no_cycle_in_graph;
			else			
				return false;			
			end if;
		end if;
	end
$$ language plpgsql;

truncate graph;
insert into Graph values
 (1,2),
 (2,3),
 (3,4),
 (4,5),
 (5,6),
 (6,7),
 (7,8),
 (8,9),
 (9,10);
select * from graph;
select * from recursiveHamiltonian();


select * from stage_graph;
truncate visited;
select * from visited;
insert into visited values (1),(2),(3),(4),(5), (1);
select no_cycle();

select exists (select count(*) as possible_source from visited group by sources having count(*)>1)


------------------------------------------------------------------------------------------------------
-- working query -- part b
drop function if exists nonRecursiveHamiltonian();
create or replace function nonRecursiveHamiltonian()
returns bool as
$$
declare
	is_hamilton bool := False;
	s_g int8 :=0;
	t_g int8 :=0;
	not_visited_edges int8 :=0;
	Begin
		drop table if exists visited;
		create table visited(sources int);
		drop table if exists stage_graph;
		create table stage_graph(ts int, tt int, is_visit int default 0);
		insert into stage_graph select * from graph order by source;		
		
		not_visited_edges := (select count(1) from stage_graph);
		while not_visited_edges <> 0 loop
			for s_g, t_g in select * from stage_graph where is_visit=0 loop
				is_hamilton := (select check_for_cycle(s_g::int,t_g::int));	
				if is_hamilton = False then 
					return false;
				end if;
				update stage_graph set is_visit=1 where ts=s_g and tt=t_g;
			end loop;
			not_visited_edges := (select count(1) from stage_graph where is_visit=0);
		end loop;
		is_hamilton := (select exists (select count(*) as possible_source from visited group by sources having count(*)>1));
		return is_hamilton;
	End
$$ language plpgsql;

drop function if exists no_cycle();
create or replace function no_cycle()
returns bool as 
$$
	with q as (
		select count(*) as possible_source from visited group by sources having count(*)>1
	),
	multiple_sources as (select count(*) as d_count from q)
	select not exists (
		select 1 from multiple_sources ms where ms.d_count>1
	) as gcycle;


$$ language sql;

drop function if exists check_for_cycle(source_g int,target_g int);
create or replace function check_for_cycle(source_g int,target_g int)
returns bool as
$$
	declare
		total_visited int := 0;
		no_cycle_in_graph bool := True;
	Begin
		total_visited := (select count(*) from visited);
		if total_visited = 0 then
			insert into visited values (source_g);
			insert into visited values (target_g);
			return true;
		else
			if exists(select 1 from visited where sources=source_g) then
					insert into visited values (target_g);
					no_cycle_in_graph := (select no_cycle());
					return no_cycle_in_graph;
			else			
				return false;			
			end if;
		end if;
	end
$$ language plpgsql;

select * from nonRecursiveHamiltonian();
select * from graph;
-- test query -- part b



-- Problem 14

-- working query

drop table EncodingOfRandS;
create table EncodingOfRandS(key text, value jsonb);
insert into EncodingOfRandS select 'R' as key, jsonb_build_object('a', r.a, 'b', r.b) as value
from R r union select 'S' as key, jsonb_build_object('a', s.a, 'b', s.b, 'c', s.c) as value
from S s order by 1;

-- mapper function
CREATE OR REPLACE FUNCTION mapper(key text, value jsonb)
RETURNS TABLE(key jsonb, value text) AS
$$
	SELECT jsonb_build_object('a', value->>'a', 'b', value->>'b'), key 
$$ LANGUAGE SQL;

-- reducer function
CREATE OR REPLACE FUNCTION reducer(key jsonb, valuesArray text[])
RETURNS TABLE(key text, value jsonb) AS
$$
	 SELECT 'R semijoin S'::text, key WHERE ARRAY['R','S'] <@ valuesArray;
$$ LANGUAGE sql;

-- 3-phases simulation of MapReduce Program followed by a decoding step
WITH Map_Phase AS (SELECT m.key, m.value FROM encodingOfRandS, LATERAL(SELECT key, value FROM mapper(key, value)) m),
Group_Phase AS ( SELECT key, array_agg(value) as value FROM Map_Phase GROUP BY (key)),
Reduce_Phase AS (SELECT r.key, r.value FROM Group_Phase, LATERAL(SELECT key, value FROM reducer(key, value)) r)
SELECT p.value->>'a' as a, p.value->>'b' as b FROM Reduce_Phase p order by 1;

-- test query
-- EncodingOfRandS;

drop table if exists R;
drop table if exists S;
create table R(A integer, B integer);
create table S(A integer, B integer, C integer);

insert into R values
   (1,1),
   (1,2),
   (1,3),
   (2,2),
   (2,3);

insert into S values
   (1,1,1),
   (1,1,2),
   (1,2,3),
   (1,4,1),
   (2,2,1),
   (3,4,2);




select value, key from encodingOfRandS ;
SELECT jsonb_build_object('a', value->>'a', 'b', value->>'b'), key FROM encodingOfRandS, 

jsonb_object_keys(value) t where t in ('a', 'b')



-- problem 16

--working query
drop table R;
create table R(A integer, B integer);

insert into R values
   (1,1),
   (1,2),
   (1,3),
   (2,2),
   (2,3),
   (3,2);
drop table if exists EncodingOfR;
create table EncodingOfR(key text, value jsonb);
insert into EncodingOfR select 'R' as key, jsonb_build_object('a', r.a, 'b', r.b) as value from R;
select * from EncodingOfR;

-- mapper function

CREATE OR REPLACE FUNCTION mapper(key text, value jsonb)
RETURNS TABLE(key jsonb, value text) AS
$$
select value as val, value->>'a'
$$ LANGUAGE SQL;

-- reducer function
CREATE OR REPLACE FUNCTION reducer(key int[], values_R text)
RETURNS TABLE(key text, value jsonb) AS
$$
	select values_R as a, jsonb_build_object('bs', key, 'sum_bs', (select sum(e::int) from unnest(key) e)) 

$$ LANGUAGE sql;

-- 3-phases simulation of MapReduce Program followed by a decoding step
WITH Map_Phase AS (
	with q as (select  value->>'a' as r_a from EncodingOfR group by (value->>'a') having count(value->>'b') <3)
	SELECT m.key as value, m.value as key_m   FROM encodingOfRandS, LATERAL(SELECT key, value FROM mapper(key, value)) m join q on (m.value=q.r_a)
),
Group_Phase AS (select array_agg(cast(value->>'b' as int))  as key, key_m as value from map_phase group by key_m),
Reduce_Phase AS (SELECT r.key, r.value FROM Group_Phase, LATERAL(SELECT key, value FROM reducer(key, value)) r)
SELECT p.key as a, p.value->>'bs' as bs, p.value->>'sum_bs' as sum_bs FROM Reduce_Phase p order by 1;



-- test query

SELECT r.A, array_agg(r.B), sum(r.B) FROM R r GROUP BY (r.A) HAVING COUNT(r.B) < 3;

drop table R;
create table R(A integer, B integer);

insert into R values
   (1,1),
   (1,2),
   (1,3),
   (2,2),
   (2,3),
   (3,2);
   
select * from R;

SELECT r.A, array_agg(r.B), sum(r.B) FROM R r GROUP BY (r.A) HAVING COUNT(r.B) < 3;

drop table if exists EncodingOfR;
create table EncodingOfR(key text, value jsonb);
insert into EncodingOfR select 'R' as key, jsonb_build_object('a', r.a, 'b', r.b) as value from R;
select * from EncodingOfR;
-- mapper
with r as (
with g as (
with q as (select  value->>'a' as r_a from EncodingOfR group by (value->>'a') having count(value->>'b') <3)
select value, q.r_a as key from EncodingOfR join q on (value->>'a'=q.r_a))
select key as a, array_agg(cast(value->>'b' as int)) as agg from g group by key)
select *, (select sum(e) from unnest(agg) e) from r;



-- mapper function

CREATE OR REPLACE FUNCTION mapper(key text, value jsonb)
RETURNS TABLE(key jsonb, value text) AS
$$
select value as val, value->>'a'
$$ LANGUAGE SQL;

-- reducer function
CREATE OR REPLACE FUNCTION reducer(key int[], values_R text)
RETURNS TABLE(key text, value jsonb) AS
$$
	select values_R as a, jsonb_build_object('bs', key, 'sum_bs', (select sum(e::int) from unnest(key) e)) 

$$ LANGUAGE sql;


-- 3-phases simulation of MapReduce Program followed by a decoding step

WITH Map_Phase AS (
	with q as (select  value->>'a' as r_a from EncodingOfR group by (value->>'a') having count(value->>'b') <3)
	SELECT m.key as value, m.value as key_m   FROM encodingOfRandS, LATERAL(SELECT key, value FROM mapper(key, value)) m join q on (m.value=q.r_a)
),
Group_Phase AS (select array_agg(cast(value->>'b' as int))  as key, key_m as value from map_phase group by key_m),
Reduce_Phase AS (SELECT r.key, r.value FROM Group_Phase, LATERAL(SELECT key, value FROM reducer(key, value)) r)
SELECT p.key as a, p.value->>'bs' as bs, p.value->>'sum_bs' as sum_bs FROM Reduce_Phase p order by 1;




----------------------------------------------------------------------
-- attempt 2

-- mapper function
drop function if exists mapper(key text, value jsonb);
CREATE OR REPLACE FUNCTION mapper(key text, value jsonb)
RETURNS TABLE(key jsonb, value text) AS
$$
select value, key
$$ LANGUAGE SQL;
drop function if exists reducer(key jsonb, valuesArray text[]);
CREATE OR REPLACE FUNCTION reducer(key jsonb, valuesArray int[])
RETURNS TABLE(key text, value jsonb) AS
$$
	 SELECT key->>'a', jsonb_build_object('agg', valuesArray, 'sum', (select sum(e::int) from unnest(valuesArray) e)::int) WHERE CARDINALITY(valuesArray) < 3;
$$ LANGUAGE sql;

WITH Map_Phase AS (
    SELECT m.key, m.value
    FROM   encodingOfR, LATERAL(SELECT key, value FROM mapper(key, value)) m
), Group_Phase AS (
	select jsonb_build_object('a',mp.key->>'a') as key,
	array_agg(mp.key->>'b'):: int [] as value from Map_Phase mp group by (mp.key->>'a') 
	), Reduce_Phase AS (
    SELECT r.key, r.value
	FROM   Group_Phase, LATERAL(SELECT key, value FROM reducer(key, value)) r
)
select key as a, value->>'agg' as bs, value->>'sum' as sum_bs from Reduce_Phase

----------------------------------------------------------------------
--- probelm 17
----------------------------------------------------------------------
-- working query -- a
drop view if exists coGroup;
create type cogroup_record as (left_relation int[], right_relation int[]);
create or replace view coGroup as (
WITH Kvalues AS (SELECT r.K FROM R r UNION SELECT s.K FROM S s),
R_K AS (SELECT r.K, ARRAY_AGG(r.V) AS RV_values FROM R r
GROUP BY (r.K) UNION SELECT k.K, '{}' AS RV_VALUES FROM Kvalues k
WHERE k.K NOT IN (SELECT r.K FROM R r)),
S_K AS (SELECT s.K, ARRAY_AGG(s.W) AS SW_values FROM S s
GROUP BY (s.K) UNION SELECT k.K, '{}' AS SW_VALUES FROM Kvalues k
WHERE k.K NOT IN (SELECT s.K FROM S s))
SELECT K as keys, (RV_values, SW_values)::cogroup_record as co_group FROM R_K NATURAL JOIN S_K);

select * from coGroup;


-- working query -- b

select cg.keys, unnest(left_r.left_relation) from coGroup cg, lateral (select cardinality((cg.co_group::cogroup_record).left_relation) as c, (cg.co_group::cogroup_record).left_relation) left_r, lateral (select cardinality((cg.co_group::cogroup_record).right_relation) as c, (cg.co_group::cogroup_record).right_relation) right_r  where left_r.c=right_r.c


 -- workign query --c
drop view if exists cgd;
create temp view cgd as (
select * from coGroup cg, lateral (select (cg.co_group::cogroup_record).left_relation as lr,
cardinality((cg.co_group::cogroup_record).left_relation) as lrc,		(cg.co_group::cogroup_record).right_relation as rr,
cardinality((cg.co_group::cogroup_record).right_relation) as rrc) cgr);

SELECT distinct r.K as rK,s.K as sK
FROM   R r, S s WHERE  exists (SELECT 1 FROM cgd c1, cgd c2 WHERE  c1.keys = r.K and c2.keys=s.k and not c1.lr && c2.rr);
 


----------------------------------------------------------------------
-- test query
drop table if exists R;
drop table if exists S;

create table R(K int, V int);
create table S(K int, W int);

insert into R values
   (1,1),
   (1,2),
   (1,3),
   (2,2),
   (2,3),
   (3,2),
   (7,7);

insert into S values
   (1,1),
   (1,2),
   (1,3),
   (3,2),
   (4,1),
   (4,2),
   (5,1),
   (5,2),
   (6,4),
   (6,5);
   
select * from R;
select * from S;

create type cogroup_record as (left_relation int[], right_relation int[]);
drop view if exists coGroup;
create or replace view coGroup as (
WITH Kvalues AS (SELECT r.K FROM R r UNION SELECT s.K FROM S s),
R_K AS (SELECT r.K, ARRAY_AGG(r.V) AS RV_values FROM R r
GROUP BY (r.K) UNION SELECT k.K, '{}' AS RV_VALUES FROM Kvalues k
WHERE k.K NOT IN (SELECT r.K FROM R r)),
S_K AS (SELECT s.K, ARRAY_AGG(s.W) AS SW_values FROM S s
GROUP BY (s.K) UNION SELECT k.K, '{}' AS SW_VALUES FROM Kvalues k
WHERE k.K NOT IN (SELECT s.K FROM S s))
SELECT K as keys, (RV_values, SW_values)::cogroup_record as co_group FROM R_K NATURAL JOIN S_K);

select cg.keys, unnest(left_r.left_relation) from coGroup cg, lateral (select cardinality((cg.co_group::cogroup_record).left_relation) as c, (cg.co_group::cogroup_record).left_relation) left_r, lateral (select cardinality((cg.co_group::cogroup_record).right_relation) as c, (cg.co_group::cogroup_record).right_relation) right_r  where left_r.c=right_r.c


select c1.keys, c1.rr, c2.keys, c2.lr from cgd c1, cgd c2 where c1.lrc=0 or c2.rrc=0 and c1,;
SELECT distinct r.K as rK,s.K as sK
FROM   R r, S s WHERE  NOT ARRAY(SELECT r1.V FROM R r1 WHERE  r1.K = r.K) && ARRAY(SELECT s1.W FROM   S s1 WHERE  s1.K = s.K);

SELECT distinct r.K as rK,s.K as sK
FROM   R r, S s WHERE  exists (SELECT 1 FROM cgd c1, cgd c2 WHERE  c1.keys = r.K and c2.keys=s.k and not c1.lr && c2.rr);
----------------------------------------------------------------------

select SELECT distinct r.K as rK from 


select * from cgd
with l_keys as (
select keys as rk from cgd join  where lrc<>0),
no_l_keys as (select distinct unnest(rr) as sk from cgd where lrc=0 except select * from l_keys)
select * from no_l_keys
select * from l_keys lk, no_l_keys nlk where lk.rk<>nlk.sk


select distinct r.k, sq.keys from R r, lateral(select distinct keys, q from cgd, unnest(rr) as q  where lrc=0 and not exists (select 1 from cgd, unnest(rr) as g where g=r.k)) sq order by 1
union
select distinct s.k, sq.keys from S s, lateral(select distinct keys, q from cgd, unnest(lr) as q  where rrc=0 and not exists (select 1 from cgd, unnest(lr) as g where g=s.k)) sq order by 1

select * from cgd where rrc=0;
select distinct keys, q from cgd, unnest(rr) as q  where rrc=0

;
