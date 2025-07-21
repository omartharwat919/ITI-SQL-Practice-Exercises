--1
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where OrderDate between '7/28/2002' and '7/29/2014'

--2
select ProductID, Name
from Production.Product
where StandardCost < 110.00

--3
select ProductID, Name
from Production.Product
where Weight is null

--4
select Name, Color
from Production.Product
where Color in ('Silver', 'Black', 'Red')

--5
select Name
from Production.Product
where name like 'B%'

--6
update Production.ProductDescription 
set Description = 'Chromoly steel_High of defects'
where ProductDescriptionID = 3


select Description
from Production.ProductDescription 
where Description LIKE '%[_]%'


--7
select OrderDate,sum(TotalDue) as TotalDue_Sum
from Sales.SalesOrderHeader
where OrderDate between '2001/01/07' and '2014/07/31'
group by OrderDate


--8
select distinct HireDate
from HumanResources.Employee
order by HireDate desc

--9
select avg(distinct ListPrice)
from Production.Product


--10
select concat('The ', Name, ' is only! ', ListPrice)
from Production.Product
where ListPrice between 100 and 120
order by ListPrice


--11
select rowguid, Name, SalesPersonID, Demographics into [store_archive]
from Sales.Store

select * 
from store_archive

select rowguid, Name, SalesPersonID, Demographics into [store_archive_2]
from Sales.Store
where 1 = 2


--12
select format(getdate(), 'yyyy MM dd' )
union
select format(getdate(), 'dddd MMMMM yyyy' )
union
select format(getdate(), 'yyyy mm dd hh:ss' )
union
select format(getdate(), 'hh tt' )
union
select format(getdate(), 'dd-mm-yyyy' )
union
select convert(nchar(10), getdate(), 101)
union
select convert(nchar(10), getdate(), 102)
union
select convert(nchar(10), getdate(), 103)
union
select convert(nchar(10), getdate(), 104)
union
select convert(nchar(10), getdate(), 105)