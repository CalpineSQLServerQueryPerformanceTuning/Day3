use AdventureWorks;
go

-- Create Test Schema
create Schema Test;
go

-- Create Test.Person with no data
select 
	* 
into 
	Test.Person
from
	Person.Person
where 
	BusinessEntityID = 0
;

select * from Test.Person;


-- Create Indexes
create clustered index PK_Person_BusinessEntityID
on Test.Person(BusinessEntityID);

create nonclustered index IX_Person_LastName
on Test.Person(LastName);


-- Views Stats in Object Explorer, Details has no stats
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID);
dbcc show_statistics ('Test.Person', IX_Person_LastName);

-- Add Some Rows
insert into Test.Person
	select * from Person.Person;

-- Views Stats in Object Explorer, Details has no stats
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID);
dbcc show_statistics ('Test.Person', IX_Person_LastName);


-- Turn Off Auto Update of Stats
exec sp_autostats 'Test.Person', 'Off';


-- Execution Plan Warning
--		Turn on Execution Plan
--		View Estimated Rows vs Actual Rows and Plan Warning on Index Seek (NonClustered)
select * 
from Test.Person
where LastName = 'Diaz';


-- Still no stats
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID);
dbcc show_statistics ('Test.Person', IX_Person_LastName);


-- Try Again with Autostats turned back on
exec sp_autostats 'Test.Person', 'On';

select * 
from Test.Person
where LastName = 'Diaz';


-- Now there are stats!
dbcc show_statistics ('Test.Person', PK_Person_BusinessEntityID);
dbcc show_statistics ('Test.Person', IX_Person_LastName);


-- Clean Up
drop table Test.Person;
drop schema Test;