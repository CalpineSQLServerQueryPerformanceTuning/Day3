use AdventureWorks;
go

--	Turn on Actual Execution Plan (Ctrl-M)


-- When stats are not used or out of date
-- Notice that the Estimated Number of Rows and the Actual Number of Rows
--		Are very different
--		There are stats on StateProvinceID because of an index
--		Reason is the Query Optimizer used a trival plan so Stats not included
select AddressID, StateProvinceID 
from Person.[Address]
where StateProvinceID = 9;


-- Note how many ladies vs men
select 
	  count(*)														as [Female Employees]
	, (select count(*) from HumanResources.Employee) - count(*)		as [Male Employees]
from 
	HumanResources.Employee
where 
	Gender = 'F'
;


-- Create Index on Gender
create index IX_Employee_Gender
on HumanResources.Employee(Gender);


-- View Stats | Details And notice Density and Details
dbcc show_statistics ('HumanResources.Employee', IX_Employee_Gender);


-- Clean Up
drop index IX_Employee_Gender
on HumanResources.Employee;

