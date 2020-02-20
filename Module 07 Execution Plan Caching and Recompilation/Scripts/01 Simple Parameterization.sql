use AdventureWorks;
go


-- Clear Buffer and Procedure Caches
checkpoint
go
dbcc dropcleanbuffers;
dbcc freeproccache;
go


-- Note that Queries with StateProvinceID Predicates return back very different number of rows
--		But the Queries with AddressID Predicates return back same number of rows
--		This means it is a better candidate for Simple Parameterization
go
select * from Person.Address where StateProvinceID = 32;
go
select * from Person.Address where StateProvinceID = 42;
go
select * from Person.Address where StateProvinceID = 9;
go
select * from Person.Address where AddressID = 42;
go
select * from Person.Address where AddressID = 52;
go


-- Cached Plans
select 
	  usecounts
	, cacheobjtype
	, objtype
	, [text]
	, query_plan
from 
				sys.dm_exec_cached_plans
	cross apply sys.dm_exec_query_plan(plan_handle)
	cross apply sys.dm_exec_sql_text(plan_handle)
;

-- query_hash is a hash of the parameterized query (could be the same for similar queries)
-- query_plan_hash is a hash of the execution plan (could be the same for similar plans including distribution)
select 
	  execution_count
	, total_logical_reads
	, [text]
	, query_plan
	, query_hash
	, query_plan_hash
from 
				sys.dm_exec_query_stats
	cross apply sys.dm_exec_query_plan(plan_handle)
	cross apply sys.dm_exec_sql_text(plan_handle)
order by
	query_hash
;