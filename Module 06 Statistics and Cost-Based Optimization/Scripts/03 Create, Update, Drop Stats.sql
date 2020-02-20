use AdventureWorks;
go

-- Statistics
--		Stats are automatically created for all indexes, can't change that

-- DB Configurable Settings - SSMS | Object Explorer | Right Click AdventureWorks | Properties | Options Page (top under Automatic)
--		Auto Update Stats - Automatically updates stats if there are sufficient changes to the data
--		Auto Update Stats Asyn - Automatically updates stats if there are sufficient changes to the data
--			but query that caused it will run without waiting for the update to complete
--		Auto Create Stats - Automatically create stats on non-indexed column in a where clause


-- Manually Create User Stats
--		Sample 5% of data to generate stats
create statistics stat_ListPrice1
    on Production.Product (ListPrice)
    with sample 5 percent;

--		Scan the entire table to generate stats
--		NoRecompute turns off auto-update of these stats
create statistics stat_ListPrice2
    on Production.Product (ListPrice)
    with fullscan, norecompute;


-- Auto Create Stats on Non-Indexed Column Color
--		View in Object Explorer
select 
	*
from 
	Production.Product
where 
	Color = 'Blue'
;


-- Show StatsName, Last Updated, And Type
select 
	  [name]																	as [StatsName]
	, stats_date(object_id, stats_id)											as [StatsUpdated]
	, iif(auto_created = 0 and user_created = 0, 'Yes', 'No')					as [IndexCreated]
	, iif(auto_created = 1 and user_created = 0, 'Yes', 'No')					as [AutoCreated] 
	, iif(user_created = 1, 'Yes', 'No')										as [UserCreated]
from 
	sys.stats
where 
	object_id = object_id('Production.Product')
;


-- Update for all Indexes on Production.Product
update statistics Production.Product;


-- Update for only the PK_Product_ProductID Index
update statistics Production.Product PK_Product_ProductID
with fullscan, norecompute;

-- Update Specific Stats by Name
update statistics Production.Product(stat_ListPrice1) 
with fullscan, norecompute;


-- View Stats Info for Table
exec sp_autostats 'Production.Product';


-- Update All Stats on DB
exec sp_updatestats;


-- Drop Stats Created
drop statistics Production.Product.stat_ListPrice1;
drop statistics Production.Product.stat_ListPrice2;
drop statistics Production.Product.[_WA_Sys_00000013_1BC821DD]
drop statistics Production.Product.[_WA_Sys_00000014_1BC821DD]

