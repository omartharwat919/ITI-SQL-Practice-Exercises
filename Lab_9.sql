--1
create proc p1
as
	select d.Dept_Name, count(s.St_Id) as stud_num
	from Student s join Department d
	on s.Dept_Id=d.Dept_Id
	group by d.Dept_Name

exec p1


--2
create proc p2
as 
	declare @num int
	select @num=count(ssn)
	from  Employee e, Works_for w
	where e.SSN=w.ESSn and w.Pno=100
	if (@num>=3)
		select 'The number of employees in the project p1 is 3 or more'
	else
		select 'The following employees work for the project p1' as result, e.Fname,e.Lname
		from Employee e, Works_for w
		where e.SSN=w.ESSn and w.Pno=100

exec p2


--3
create proc p3
    @old_emp int,
    @new_emp int,
    @project_id int
as
    update Works_for
    set ESSn = @new_emp
    where ESSn = @old_emp AND Pno = @project_id

--4
alter table project
add budget int


create table Audit_Table
(
ProjectNo int,
UserName varchar(100),
ModifiedDate date,
Budget_Old int,
Budget_New int
)

create trigger t1
on project
for update
as  
   if update(budget)
   begin
        declare @pnum int, @old_budget int, @new_budget int
		select @pnum=Pnumber from inserted
		select @new_budget=budget from inserted
		select @old_budget=budget from deleted
	insert into Audit_Table values(@pnum,suser_name(),getdate(),@old_budget,@new_budget)
   end



update Project
set budget = 300000
where Pnumber = 100

select * from Audit_Table


--5
create trigger t2
on departments
instead of insert
as
    select 'You cannot insert a new record in that table.'as Result

insert into Departments(Dname)
values('dp5')


--6

alter trigger t3
on employee
after insert
as
	 if (format(getdate(),'MMMM') = 'April')
   begin
       select 'You cannot insert in April'
	   delete from Employee
		where ssn = (select ssn from inserted)
	end

insert into Employee(SSN)
values(4000)


--7
create table stud_audit
 (
 ServerUserName varchar(100),
 _Date date,
 Note varchar(300)
 )

alter trigger t4
on student
after insert 
as
	declare @keyInserted int
	select @keyInserted = St_Id from inserted

	insert into stud_audit
	values (SUSER_NAME(), GETDATE(), CONCAT(SUSER_NAME(), ' Insert New Row with Key=', @keyInserted, ' in table Student'))


insert into Student(St_Id)
values (1100)

select * from stud_audit


--8
create trigger t5
on student
instead of delete  
as
	declare @keyDeleted int
	select @keyDeleted = St_Id from  deleted
	insert into stud_audit
	values(SUSER_NAME(), GETDATE(), CONCAT(SUSER_NAME(), ' tried to delete Row with Key=', @keyDeleted))

DELETE FROM Student
WHERE St_Id = 300

select * from stud_audit


--9
create SEQUENCE _Seq_1_to_10
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 10
    NO CYCLE

SELECT NEXT VALUE FOR _Seq_1_to_10 AS SequenceValue

CREATE TABLE ExampleTable (
    Id INT PRIMARY KEY,
    SequenceColumn INT
)

INSERT INTO ExampleTable (Id, SequenceColumn)
VALUES (1, NEXT VALUE FOR Seq_1_to_10),
       (2, NEXT VALUE FOR Seq_1_to_10),
       (3, NEXT VALUE FOR Seq_1_to_10);

select * from ExampleTable
ALTER SEQUENCE Seq_1_to_10 RESTART WITH 1



---------------------------------------------------------------------
----Part 2

--1
create proc get_month_name 
			@date date
as
	select format(@date,'MMMM')


get_month_name '1-1-2000'


--2
create proc SP_InBetween
			@first int,
			@second int
as
    declare @i int = @first + 1
    declare @final table (number int)
    while @i < @second
    begin
        insert into @final values (@i)
        set @i += 1
    end
    select * from @final

sp_inbetween 1,5

--3
create proc sp_StudDept
			@id int
as
    select S.St_Fname + ' ' + S.St_Lname as Full_name,D.Dept_Name 
	from  Student S
    inner join Department D on S.Dept_Id = D.Dept_Id
    where S.St_Id = @id

sp_StudDept 1

--4
create proc sp_CheckName @id int
as
    declare @Fname varchar(50), @Lname varchar(50)
    select @Fname = St_Fname, @Lname = St_Lname 
    from Student 
    where St_Id = @id

    if @Fname is null and @Lname is null
        select 'First name & last name are null'
    else if @Fname IS NULL
        select 'first name is null'
    else if @Lname IS NULL
        select 'last name is null'
    else
        select 'First name & last name are not null'

sp_CheckName 1


--5
create proc sp_Manager @id int
as
	select D.Dept_Name, I.Ins_Name AS Manager_Name, D.Manager_hiredate
    from Department D inner join Instructor I 
	on D.Dept_Manager = I.Ins_Id
    where D.Dept_Manager = @id

sp_Manager 1


--6
create proc sp_GetName @need varchar(50)
as
    if @need = 'first name'
        select ISNULL(St_Fname, ' ') from Student
    else if @need = 'last name'
        select ISNULL(St_Lname, ' ') from Student
    else if @need = 'full name'
        select ISNULL(St_Fname, ' ') + ' ' + ISNULL(St_Lname, ' ') from Student


sp_GetName 'first name'


