--1
create function GetMonth(@inputdate date)
Returns varchar(20)
as
begin
	declare @monthname varchar(20)
	set @monthname=datename(month,@inputdate)
	return @monthname
end

select dbo.GetMonth('2025-04-22')


--2
create function GetRange(@start int , @end int)
Returns @t table (resutls int)
as
begin
	declare @current int

	if @start <= @end
	begin
		set @current=@start

		while @current<=@end
		begin
			insert into @t
			values(@current)
			set @current = @current + 1
		end
	end

	else
	begin
		set @current=@start

		while @current>=@end
		begin
			insert into @t
			values(@current)
			set @current = @current - 1
		end
	end

	return
end

SELECT * FROM dbo.GetRange(10, 5)			
SELECT * FROM dbo.GetRange(5, 10)		


--3

create function GetDept(@studid int)
Returns table 
AS  
	RETURN
 	( 
	select s.St_Fname+' '+s.ST_LNAME AS FULLNAME, d.DEPT_NAME
	from HR.Student s
	join Department d
	on s.Dept_Id=d.Dept_Id
	where s.St_Id=@studid 


	)

SELECT * FROM GetDept(1)


--4

create function Checkname (@studid int)
Returns varchar (50)
as
begin

	declare @message varchar(50);
    declare @firstname varchar(50);
    declare @lastname varchar(50)

	select 
        @firstname = s.St_Fname,
        @lastname = s.St_Lname
    from Hr.Student s
    where s.St_Id = @studid

	if @firstname is null and @lastname is null
        set @message = 'first name & last name are null';
    else if @firstname is null
        set @message = 'first name is null';
    else if @lastname is null
        set @message = 'last name is null';
    else
        set @message = 'first name & last name are not null';

    return @message

end

select dbo.Checkname(1)


--5

create function GetManager(@managerid int)
returns table
As
	Return
	(
		select 
			d.Dept_Name as department_name,
			i.Ins_Name as manager_name,
			d.Manager_hiredate as hiringdate
		from Hr.Instructor i
		inner join department d 
		on i.Ins_Id=d.Dept_Manager
		where i.Ins_Id = @managerid
	)

select * from dbo.GetManager(2)


--6

create function Getname (@format varchar(50))
returns @t table (stname varchar(50))
as
begin
    if @format = 'firstname'
    begin
        insert into @t
        select isnull(st_fname, 'no firstname') from Hr.Student;
    end

    else if @format = 'lastname'
    begin
        insert into @t
        select isnull(st_lname, 'no lastname') from Hr.Student;
    end

    else if @format = 'fullname'
    begin
        insert into @t
        select concat(isnull(st_fname, 'no firstname'), ' ', isnull(st_lname, 'no lastname')) from Hr.Student;
    end

    return
end

select * from dbo.Getname('firstname')

--7

select 
    St_Id,
    left(St_Fname, len(St_Fname) - 1) as firstname_without_last_char
from 
    hr.student


--8

DELETE  
FROM Stud_Course
where St_Id in (select s.St_id from hr.Student s
				inner join Department d
				on s.Dept_Id=d.Dept_Id
				where d.Dept_Name='SD')




--Bonus

declare @i INT = 3000;

while @i <= 6000
begin
    insert into HR.Student (st_id, st_fname, st_lname)
    values (@i, 'Jane', 'Smith');
    
    set @i = @i + 1;
end

select st_id, st_fname, st_lname
from HR.Student
where st_id between 3000 and 6000

