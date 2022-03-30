/*Practice simple TRIGGER in Oracle*/

--- How to use instead of trigger to issue Update the location detail statement on this complex view.
--Step 1: Create 2 tables Emp & Dept
create table Emp(
emp_no number,
emp_name varchar2(50),
salary number,
manager varchar2(50),
dept_no number
);
/

create table Dept(
dept_no number,
dept_name varchar2(50),
location varchar2(50)
);
/

--Step 2: Insert data into 2 tables (Emp & Dept)
/*Way 1: using insert all*/
insert all
    into Dept(dept_no, dept_name, location) values (10, 'HR', 'USA')
    into Dept(dept_no, dept_name, location) values (20, 'SALES', 'UK')
    into Dept(dept_no, dept_name, location) values (30, 'FINANCIAL', 'JAPAN')

select 1 from dual;

/*Way 2: simple*/
insert into Dept values(10, 'HR', 'USA');
insert into Dept values(20, 'SALES', 'UK');
insert into Dept values(30, 'FINANCIAL', 'JAPAN');

--Insert data table Emp
insert into Emp values(1000, 'XXX', 15000, 'AAA', 30);
insert into Emp values(1001, 'YYY', 18000, 'AAA', 20);
insert into Emp values(1002, 'ZZZ',  20000, 'AAA', 10);


--Step 3: 
create view v_emp_dept as
select emp.emp_name, dept.dept_name, dept.location
from emp, dept
where dept.dept_no = emp.dept_no;

select * from v_emp_dept;

--Step 4: update in view
begin
update v_emp_dept set location = 'FRANCE' where dept_name = 'JAPAN';
commit;
end;
/

--=> Having problem: Can not modify a column which maps to a non key-preserved table
-----  Solution: using instead of trigger

--Step 5: 
create trigger view_modify_dept_name
instead of update
on v_emp_dept
for each row
begin
update dept set location =:new.location where dept_name = :old.dept_name;
end;
/

--Step 6:
begin
update v_emp_dept set location = 'FRANCE' where dept_name = 'JAPAN';
commit;
end;
/

----=> Update successful. Because "Instead of trigger" has stopped the actual update in view and performed update stament in table
select * from dept;

/*We can ENABLE or DISABLE the trigger*/
alter  trigger view_modify_dept_name disable;

/*Or ENABLE or DISABLE all triggers*/
alter table emp enable ALL triggers;


/*
    Homework:

*/
create or replace trigger check_date
before insert on emp
begin
    if (to_char(sysdate, 'DY') in ('SAT', 'SUN'))
        or to_char(sysdate, 'HH24') not between '08' and '18'
        then raise_application_error(-20500, 'Thoi gian lam viec khong hieu qua');
    end if;
end;
/



