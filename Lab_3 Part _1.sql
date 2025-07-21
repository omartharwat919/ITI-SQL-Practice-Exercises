--1
select d.Dname, d.Dnum,d.MGRSSN,e.Fname 
from Departments d , Employee e
where e.SSN=d.MGRSSN

--2
select d.Dname,p.Pname
from Departments d , Project p
where d.Dnum=p.Dnum

--3
select concat(e.Fname,' ',e.Lname) as full_name ,d.*
from Employee e , Dependent d
where d.ESSN=e.SSN

--4
select Pnumber,Pname,Plocation
from Project  
where City in('Cairo','Alex')

--5
select *
from Project
where Pname like('a%')

--6
select *
from Employee 
where Dno=30 and Salary between 1000 and 2000

--7
select concat(e.Fname,' ',e.Lname) as full_name
from Employee e , Project p , Works_for w
where e.SSN=w.ESSn
and p.Pnumber = w.Pno
and e.Dno=10
and w.Hours>=10
and p.Pname='AL Rabwah'


--8
select concat(y.Fname,' ',y.Lname)
from Employee x ,Employee y
where x.Fname='Kamel'
and x.Lname='Mohamed'
and y.Superssn=x.SSN


--9
select concat(e.Fname,' ',e.Lname) ,p.Pname
from Employee e ,Works_for w , Project p
where e.SSN= w.ESSn
and w.Pno=p.Pnumber
order by p.Pname


--10
select p.Pnumber , d.Dname, e.Lname, e.Address, e.Bdate
from Project p , Departments d , Employee e
where p.Dnum=d.Dnum
and e.SSN=d.MGRSSN
and p.City='Cairo'


--11
select e.* 
from Employee e, Departments d
where d.MGRSSN = e.SSN;


--12
select e.*
from Employee e left outer join Dependent d
on e.SSN= d.ESSN

--13
insert into Employee
values('Omar','Tharwat',102672,'2000/06/14','Mansoura','M',3000,112233,30)

--14
insert into Employee
values('mohamed', 'ahmed', 102660, '2002/12/12', 'mansoura', 'M', NULL,NULL, 30)


--15
update Employee
set Salary= Salary+(Salary*20)/100
where SSN=102672

select Salary
from Employee 
where ssn=102672