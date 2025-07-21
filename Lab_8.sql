--1

create view StudGrade 
as
	select s.st_fname+' '+s.st_lname as Full_Name,c.Crs_Name as Course
	from Student s
	inner join Stud_Course sc 
	on s.St_Id=sc.St_Id
	inner join course c
	on sc.Crs_Id=c.Crs_Id
	where sc.Grade>50

select * from StudGrade


--2

create view MangerTopics
with encryption
as
	select ins.ins_Name , t.top_name
	from instructor ins
	join Department d
	on d.Dept_Manager=ins.Ins_Id
	join Ins_Course inc
	on inc.Ins_Id=ins.Ins_Id
	join Course c
	on inc.Crs_Id=c.Crs_Id
	join Topic t
	on t.Top_Id=c.Top_Id

select * from MangerTopics


--3

create view InsDept 
as
	select i.ins_name , d.dept_name 
	from Instructor i
	inner join Department d
	on i.Dept_Id=d.Dept_Id
	where d.Dept_Name in('sd','java')

select * from InsDept


--4

create view V1 
as 
	select * from Student
	where St_Address in ('Cairo','Alex')
	with check option

select * from V1

update V1 
	set st_address='tanta'
	where st_address ='alex'


--5
use Company_SD
create view Pro
as 
	select  p.Pname,count(w.essn) as no_emp
	from Works_for w
	inner join project p 
	on p.Pnumber=w.Pno
	group by p.Pname

select * from Pro

--6
create clustered index idx_MGRStartDate
ON Departments([MGRStart Date])			--Cannot create more than one clustered index on table 'Department'

--7

create unique index idx_student_age
ON student(st_age)						--terminated because a duplicate key was found


--8

create table daily_transactions 

    (userid int primary key,
    transactionamount int)

insert into daily_transactions (userid, transactionamount)
values 
    (1, 1000),
    (2, 2000),
    (3, 1000)


create table last_transactions 
    (userid int primary key,
    transactionamount int)

insert into last_transactions (userid, transactionamount)
values 
    (1, 4000),
    (4, 2000),
    (2, 10000)



Merge into Daily_Transactions as t -- target
	  using Last_Transactions as s -- source
on t.userid=s.userid
when matched then
	update
	set t.transactionamount=s.transactionamount
when not matched then
	insert
	values(s.userid,s.transactionamount);



--9
declare c1 cursor
for select salary from Employee
for update
declare @sal int
open c1
fetch c1 into @sal
	while @@Fetch_Status =0
	begin
		if @sal >=3000
			update Employee
			set  Salary=@sal*1.20
			where current of c1

		else if @sal <=3000
			update Employee
			set salary =@sal*1.10
			where current of c1
		
		fetch c1 into @sal
	end
select @sal
close c1
deallocate c1


--10
declare c2 cursor
for select d.dept_name,i.ins_name
	from Department d , instructor i
	where d.dept_manager=i.dept_id
for read only
declare @dept_name varchar(50),@Manager_name varchar(50)
open c2
fetch c2 into @dept_name,@Manager_name
	while @@Fetch_Status =0
	begin
		select 'Department: ' + @dept_name + ' | Manager: ' + @Manager_name
		
		fetch c2 into @dept_name,@Manager_name
	end
select @dept_name,@Manager_name
close c2
deallocate c2


--11
declare c3 cursor
for select distinct st_fname 
	from Student 
	where st_fname is not null
for read only
declare @name varchar(20),@all_names varchar(300)=''
open c3
fetch c3 into @name
	while @@FETCH_STATUS=0
	begin
		set @all_names=CONCAT(@all_names,',',@name)
		fetch c3 into @name
		
	end
select @all_names
close c3
deallocate c3
		

--12
--.	Try to generate script from DB ITI that describes all tables and views in this DB

DROP VIEW MangerTopics


-- 13.	Use import export wizard to display student’s data (ITI DB) in excel sheet

--------------------------------------------------------------------------------------
--Part 2

--1

create view v_clerk 
as 
select E.EmpNo, P.ProjectNo, W.Enter_Date
	from Company.project P,Human_Resource.employee E, Company.Department D, Works_On W
where 
	E.EmpNo = W.EmpNo
and W.ProjectNo = P.ProjectNo
and job = 'Clerk'


--2

create view v_without_budget
as 
select * 
	from Company.project
	where Budget is null

--3

create view v_count 
as 
select COUNT(job) as number, P.ProjectName
	from Company.project P, Works_On W
where P.ProjectNo = W.ProjectNo
group by p.ProjectName


--4

create view v_project_p2 
as 
select empno 
	from v_clerk
where ProjectNo = '2'


--5

alter view v_without_budget
as 
select * 
	from Company.project p
where p.ProjectNo in ('1','2')

--6
drop view v_clerk , v_count

--7
create view emps 
as 
select e.EmpLname, e.EmpNo
	from Human_Resource.employee e, Company.Department d
	where e.DeptNo = d.DeptNo
	and   d.DeptNo = '2'


--8

select emplname 
	from emps
	where EmpLname like '%j%'

--9
create view v_dept
as 
select D.DeptNo, d.DeptName
	from Company.Department D


--10
insert into v_dept 
	values ('d4', 'Development')

--11
create view v_2006_check as
select e.EmpNo , p.ProjectNo, w.Enter_Date
	from Human_Resource.employee E, Company.project P, Works_On W
where e.EmpNo = w.EmpNo 
and   w.ProjectNo = p.ProjectNo
and   w.Enter_Date between '01/01/2006' and '31/12/2006'
with check option