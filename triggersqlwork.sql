--Create a new database named "CompanyDB."
create database Company;

use Company;
--Design and create two tables Employees and Departments.

--Employees table should have fields: EmployeeID (int, primary key), FirstName (varchar), LastName (varchar), DepartmentID (int, foreign key to Departments table), and Salary (decimal).
CREATE TABLE Employees (
    EmployeeID INT not null unique identity,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
	gender varchar,
    Salary DECIMAL(10, 2),
		foreign key (DepartmentID) references Departments(DepartmentID)
	
	);
	
INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
VALUES
    ('Tayyaba', 'Muslim', 1,'F', 78000.00),
    ('Sawera', 'Ansari', 2,'F', 98000.00),
    ('Ayra', 'khan', 4,'F', 45000.00),
    ('Shahzain', 'Ali', 3,'M', 60000.00),
    ('Muhammad', 'Ahmed', 2,'M', 40000.00),
    ('Ahmed', 'Raza', 5, 'M',65000.00),
    ('Mishal', 'Khan', 3,'F', 85000.00),
    ('Sunny', 'Ansari', 5,'M', 43000.00),
    ('Ruhi', 'Imran', 1,'F', 57000.00),
    ('Shibra', 'Ikram', 4,'F', 77000.00);

	
--Departments table should have fields: DepartmentID (int, primary key), DepartmentName (varchar).
CREATE TABLE Departments (
    DepartmentID INT not null unique identity,
    DepartmentName VARCHAR(50)
);


INSERT INTO Departments (DepartmentName)
VALUES
    ('HR'),
    ( 'Marketing Department'),
	( 'Administration'),    
	( 'Finance'),
    ( 'Sales');
	select * from Departments;
	
	 --Aggregate function with group by clause
	 --rollup with inner join
   select Dept.DepartmentName,sum(salary) as total_salary from Employees Emp INNER JOIN Departments Dept on Emp.DepartmentID = Dept.DepartmentID group
   by (Dept.DepartmentName) with rollup;

   --cube with inner join
    select Dept.DepartmentName,sum(salary) as total_salary from Employees Emp INNER JOIN Departments Dept on Emp.DepartmentID = Dept.DepartmentID group
    by cube(Emp.firstname,Dept.DepartmentName);

   --with rollup
   select gender, sum(salary) as total_salary from Employees group by (gender) with rollup;

   --with cube
   select gender, sum(salary) as total_salary from Employees group by cube(gender, salary);
     
    --views
	create view emp_view 
	as
	select * from Employees;

	select * from emp_view;

	select FirstName, LastName,Salary from Employees;
	--join
	select  FirstName, LastName,Salary  from Departments as Dept join Employees as Emp on Dept.DepartmentID = Emp.DepartmentID; 
	--join select all 
    select  * from Departments as Dept join Employees as Emp on Dept.DepartmentID = Emp.DepartmentID; 




	--update
	update Employees set FirstName = 'Alyana', LastName = 'Fakhar' where DepartmentID =1;
	select * from Employees;

	--Display view function
	--method1
	Sp_helptext emp_view;

	--method2
	select definition from sys.sql_modules where object_id = object_id ('emp_view');

	--method3
	select object_definition(object_id('emp_view'));


		--login
	create login sawera with password ='sawera';

	--create user tayyaba for login tayyaba
	create user sawera for login sawera;
	GO
	--grant
	grant select, update, insert on dbo.employees to sawera;
	select * from employees;
	update employees set FirstName = 'ayrakhan' where EmployeeID= 3;
	INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
      VALUES
    ('Tayyaba', 'Muslim', 1,'F', 78000.00);

	delete from employees where EmployeeID = 11;

	--revoke
	revoke select, update  on dbo.employees from sawera;

	--deny
	deny delete on dbo.employees to sawera;
	--functions
	--FLOOR
	select FLOOR(4.4);

	--scalar function without parameters
	create function FullName()
	returns varchar(255)
	begin 

	return 'sawera ansari'
	end

	select dbo.FullName();

	--scalar function with parameters
	create function addition(@num1 as int, @num2 as int)
	returns int
	begin
	return (@num1 + @num2)
	end
	select dbo.addition(7,5) as addition;

	--function with variable
	create function students_name(@age as int)
	returns varchar(255)
	as
	begin
	declare @str varchar(100)
	if(@age >= 15)
	begin
	set @str = 'you are eligible'
	end
	else
	begin
	set @str = 'sorry! you are not eligible'
	end
	return @str
	end
	select dbo.students_name(20)  
	
	--table valued function
	create function emp()
	returns table
	as
	return select * from Employees

	select * from emp();

	--with parameter
	create function employee(@gender as varchar(20))
	returns table
	as
	return select * from Employees where gender = @gender

	select * from employee('M');

	--alter
	alter function employee()
	returns table
	as
	return select distinct FirstName from Employees

	select * from employee();
	--subquery
	select * from employees;
	select * from Departments;
	select * from employees where EmployeeID in (select EmployeeID from employees where gender ='M')
	select * from employees where EmployeeID in (select EmployeeID from employees where Salary < 70000)
	select * from employees where EmployeeID =(select DepartmentID from Departments where DepartmentName = 'Sales')
	---three tables subquery; 
	create table HR_Emp(
	EmployeeID INT,
	FirstName varchar (255),
	LastName varchar (255),
	gender varchar(40)
	);
	insert into HR_Emp(EmployeeID,FirstName,LastName,gender)
	Select EmployeeID,FirstName,LastName,gender from employees where EmployeeID =(select DepartmentID from Departments where DepartmentName = 'Sales')
	select * from HR_Emp;
	--triggers--

	create trigger insert_emp on employees
	for insert
	as 
	begin
	print 'someone trying to access your table'
	end
	 
	 alter trigger tr_insert_emp on employees
	 after delete
	 as
	 begin
	 select * from deleted
	 end

	  create trigger update_emp on employees
	 after update
	 as
	 begin
	select * from inserted
	select * from deleted
	 end


	 --inserting value in employees

	 INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
VALUES
    ('ayesha', 'khan', 2,'F', 33000.00),
    ('rameen', 'abid', 2,'F', 98000.00),
    ('wajiha', 'nadeem', 4,'F', 45000.00),
    ('zainab', 'Ali', 3,'F', 60000.00),
    ('Mohtasham', 'Ahmed', 2,'M', 40000.00),
    ('Amira', 'Raza', 5, 'M',65000.00),
    ('Minali', 'Khan', 3,'F', 85000.00),
    ('Sunni', 'deol', 5,'M', 43000.00),
    ('Ruhi', 'Imran', 1,'F', 57000.00),
    ('shanib', 'Ikram', 4,'F', 77000.00);

		 DELETE from Employees where EmployeeID= 40
VALUES
    ('Tayaba', 'khan', 1,'F', 78000.00),
    ('Sawara', 'abid', 2,'F', 98000.00),
    ('Ayra', 'nadeem', 4,'F', 45000.00),
    ('zain', 'Ali', 3,'M', 60000.00),
    ('Mohtashim', 'Ahmed', 2,'M', 40000.00),
    ('Amir', 'Raza', 5, 'M',65000.00),
    ('Minal', 'Khan', 3,'F', 85000.00),
    ('Sunny', 'deol', 5,'M', 43000.00),
    ('shani', 'Ikram', 4,'F', 77000.00);

	INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
VALUES
 
	  ('Ruhi', 'Imrani', 2,'F', 70000.00)

	select * from inserted
	update Employees set FirstName = 'shibi' where EmployeeID = 11 
	select * from Employees;
	-- creating audit table--

create table insert_trigger_details(
id int primary key identity,
auditInfo varchar(60)
)
create trigger tr_insert_audit on employees
after insert
as
begin
declare @id int, @name varchar(50)
select @id= EmployeeID,@name = FirstName from inserted
insert into insert_trigger_details values ('user with id ' + cast(@id as varchar(50)) + 'with name ' + @name + 'is inserted in the table')
end

 
-- creatin audit table for deleted--
create trigger tr_deleted_audit on employees
after delete
as
begin
declare @id int, @name varchar(50)
select @id= EmployeeID,@name = FirstName from deleted
insert into insert_trigger_details values ('user with id ' + cast(@id as varchar(50)) + 'with name ' + @name + 'is deleted in the table')
end
 DELETE FROM insert_trigger_details where id =1
 select * from insert_trigger_details;

 -- instead of triggers--
 create trigger tr_instead_insert on employees
 instead of insert
 as
 begin 'someone trying to insert the value is the employees table'
 end 

 	-- creating audit table for insteadoff--

create table instead_of_audit(
id int primary key identity,
auditInfo varchar(60)
)


INSERT INTO Employees (FirstName, LastName, DepartmentID,gender, Salary)
VALUES
 
	  ('Rabi', 'Imrani', 2,'F', 70000.00)

	select * from inserted

	create trigger tr_audit_inserted on employees
instead of insert
as
begin
declare @id int, @name varchar(50)
select @id= EmployeeID,@name = FirstName from inserted
insert into instead_of_audit values ('user with id ' + cast(@id as varchar(50)) + 'with name ' + @name + 'is inserted in the table')
end

create trigger instead_audit_deleted on employees
instead of delete
as
begin
declare @id int, @name varchar(50)
select @id= EmployeeID,@name = FirstName from deleted
insert into instead_of_audit values ('user with id ' + cast(@id as varchar(50)) + 'with name ' + @name + 'is deleted in the table')
end
		 DELETE from Employees where EmployeeID= 53
select * from instead_of_audit;
select * from Employees;

sp_helptext tr_audit_inserted;
--DDL TRIGGERS

create trigger tr_create on database
for CREATE_TABLE
as
begin
print 'someone trying to create table'
end
-- to check command 
create table std(id int)
 
 -- for alter
 create trigger tr_alter on database
for ALTER_TABLE
as
begin
print 'you cannot alter tha table'
end
alter table  departments drop column departmentName

-- for drop table
create trigger tr_drop on database
for DROP_TABLE
as
begin
print 'someone trying to drop the table'
end
--command for drop the table
drop table Departments

--ddl trigger on server
--to create table
create trigger tr_onServer on ALL server
for CREATE_TABLE
as
begin
print 'you cannot create the database on current server'
end
create table SERVER(id int)
--to alter table
create trigger tr_Server on ALL server
for ALTER_TABLE
as
begin
print 'you cannot CANNOT alter the table on current server'
end
alter table Employees drop column LastName
--to drop table

create trigger tr_ondropServer on ALL server
for DROP_TABLE
as
begin
print 'you cannot drop the table on current server'
end
drop table HR_Emp
--to create database
create trigger tr_databaseServer on ALL server
for CREATE_DATABASE
as
begin
print 'you cannot create the database on current server'
end
 create database trigger_1
