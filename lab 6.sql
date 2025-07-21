use [SD32-Company]

-- Department
--- 1

create table Department(
DeptNo nchar(2) primary key,
DeptName nchar(20),
Location locDT )

--2

sp_addtype locDT,'nchar(2)'

create rule loc as @x in('NY','DS','KW')
sp_bindrule Loc,locDT

create default def1 as 'NY'
sp_bindefault def1,locDT


-- Employee

--- 1

create table Employee(
EmpNo int,
DeptNo nchar(2),
Salary int,
EmpFname nchar(20),
EmpLname nchar(20)

constraint c1 primary key(EmpNo),
constraint c2 foreign key (DeptNo) references Department(DeptNo),
constraint c3 unique(Salary),
constraint c4 check(EmpFname is not null)
)

create rule R2Salary as @s>6000
sp_bindrule R2Salary,'Employee.Salary'

-- project and works_on table create by design not coding

-- add data

insert into Department values
('d1', 'Research', 'NY'),
('d2', 'Accounting', 'DS'),
('d3', 'Markiting', 'KW')


insert into Employee values
(25348,'d3', 7000, 'Mathew', 'Smith'),
(10102, 'd3', 8000 ,'Ann', 'Jones'),
(18316,'d1',10000,'John' ,'Barrimore'),
(29346, 'd2' ,9000,'James', 'James'),
(2581,'d2',6500,'Elisa' ,'Hansel'),
(28559,'d1' ,8500,'Sybl' ,'Moser' )


insert into Project values
('p1' ,'Apollo', 120000),
('p2' ,'Gemini', 95000),
('p3', 'Mercury', 185600)


insert into works_on values
(10102, 'p1' ,'Analyst' ,'2006.10.1'),
(10102, 'p3' ,'Manager' ,'2012.1.1'),
(25348 ,'p2' ,'Clerk' ,'2007.2.15')

--- Testing Referential Integrity

insert into works_on values
(11111, 'p1', 'name', '2004.10.5') --Error as the EmpNo FK did not exist in employee table as PK

update works_on
set EmpNo = 11111
where EmpNo = 10102  --it will fail as 11111 did not exist in employee table


update Employee
set EmpNo = 11111
where EmpNo = 10102  -- i have to update the refrence in other table to enable me to update the PK

delete from Employee
where EmpNo = 10102 -- i have to delete the refrence in other table to enable me to delete the PK


--- Table modification

alter table Employee
add TelephoneNumber int

alter table Employee
drop column TelephoneNumber

---------------------------------------------------------------------------
--2

create schema Company

alter schema Company transfer Department

create schema Human_Resource

alter schema Human_Resource transfer Employee

--3

SELECT * FROM INFORMATION_SCHEMA.TABLES

select 
    constraint_name, 
    constraint_type
from 
    information_schema.table_constraints
where 
    table_name = 'Employee'

--4
create synonym EMP for Employee
create synonym EMP1 for Human_Resource.Employee

Select * from Employee --Error
Select * from Human_Resource.Employee
Select * from EMP --Error
Select * from Human_Resource.EMP --Error
Select * from EMP1

--5

update Company.Project
set Budget += (Budget*20)/100
where projectNo in(
select projectNo
from works_on 
where EmpNo = 10102
)

--6

update Company.Department
set DeptName = 'Sales'
where DeptNo in (
select DeptNo
from Human_Resource.Employee e
where e.EmpFname = 'James'
)


--7
update works_on
set Enter_Date = '12.12.2007'
where EmpNo in (
select EmpNo 
from Human_Resource.Employee e inner join Company.Department d
on e.DeptNo = d.DeptNo
where d.DeptNo = 'p1' and d.DeptName = 'Sales'
)

--8
delete works_on
where EmpNo in (
select EmpNo 
from Human_Resource.Employee e inner join Company.Department d
on e.DeptNo = d.DeptNo
where d.Location = 'KW' 
)