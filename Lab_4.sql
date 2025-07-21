--1
select d.Dependent_name ,d.Sex
from Dependent d , Employee e
where e.SSN = d.ESSN
and d.Sex='F' and e.Sex='F'
union all
select d.Dependent_name ,d.Sex
from Dependent d , Employee e
where e.SSN = d.ESSN
and d.Sex='M' and e.Sex='M'


--2
select p.Pname ,sum(w.Hours)
from Project p , Works_for w
where p.Pnumber = w.Pno
group by(p.Pname)


--3

select *
from Departments
where Dnum = (
	select Dno
	from Employee
	where SSN = (
		select  min(SSN)
		from Employee))


select top(1) d.*
from Departments d left outer join Employee e on d.Dnum = e.Dno 
order by e.SSN

--4
select Dname, min(e.Salary), max(e.Salary), avg(e.Salary)
from Employee e , Departments d
where e.Dno = d.Dnum
group by Dname


--5

select Fname + ' ' + Lname
from Employee
where SSN = (select d.MGRSSN
			from Departments d
			where d.MGRSSN not in (select ESSN from Dependent))

--6

select avg(Salary) as Average , d.Dname, d.Dnum ,count(SSN) as Num_Employees
from Employee e , Departments d
where d.Dnum = e.Dno 
group by d.Dnum , d.Dname
having avg(Salary) <(select avg(Salary) from Employee)

--7

select e.Fname, e.Lname, p.Pname
from Employee e ,Works_for w ,Project p
where e.SSN=w.ESSn
and w.Pno= p.Pnumber
order by e.Dno ,e.Fname ,e.Lname



--8

select Salary
from Employee 
where salary >=(select max(Salary)
				from Employee 
				where Salary <(select max(Salary)from Employee ))



--9

select  e.Fname + ' ' + e.Lname
from Employee e , Dependent d
where e.Fname + ' ' + e.Lname = d.Dependent_name

--10

select e.SSN, e.Fname
from Employee e
where exists (
select ESSN from Dependent
where ESSN = e.SSN)
  

--11
insert into Departments
(Dname, Dnum, MGRSSN, [MGRStart Date])
values('DEPT IT', 100, 112233, '1-11-2006')

--12
update Departments
set MGRSSN = 968574
where Dnum = 100

update Departments
set MGRSSN = 102672
where Dnum = 20

update Employee
set Dno =
(select Dnum from Departments where MGRSSN = 102672),
Superssn =102672
where SSN = 102660

--13

delete from Dependent
where  Essn = 223344

UPDATE Departments
set MGRSSN = 102672
where MGRSSN = 223344

UPDATE Employee
set SuperSSN = 102672
where SuperSSN = 223344

delete from Works_for
where ESSN = 223344

delete from Employee
where SSN = 223344



--14
update Employee
set Salary = Salary + (Salary * 30) / 100
where SSN IN (
    select ESSN
    from Works_for
    where PNO = (
        select Pnumber
        from Project
        where Pname = 'Al Rabwah'))
