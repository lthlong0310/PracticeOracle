/*PL/SQL Case statement*/

declare
a number:= 55;
b number:= 5;
res number;
opearation varchar2(30):= 'Substract';
Begin
    res := a - b;
    dbms_output.put_line('Program is started!');
    case (opearation)
        when 'Add' then dbms_output.put_line('Additional of the numbers are: ' || a+b);
        when 'Substract' then dbms_output.put_line('Substraction of the numbers are: ' || res);
        when 'Multiply' then dbms_output.put_line('Multiplication of the numbers are: ' || a*b);
        when 'Divide' then dbms_output.put_line('Division of the numbers are: ' || a/b);
        else dbms_output.put_line('No operation action defined. Invaild operation');
    end case;
    dbms_output.put_line('Program completed');

end;
/

/*PL/SQL Records Type*/

--Example 1: Record type as database object

create type emp_dept is object
(
    emp_no number,
    emp_name varchar2(150),
    manager number,
    salary number
);
/

--Example 2: Record type at subprogram level-Column level access
DECLARE
    TYPE emp_dept_column IS RECORD
    (
    emp_no number,
    emp_name varchar2(150),
    manager number,
    salary number
    );
    
rec_emp emp_dept_column;
BEGIN
    rec_emp.emp_no:= 10;
    rec_emp.emp_name := 'Long';
    rec_emp.manager :=  1000;
    rec_emp.salary := 15000;
    dbms_output.put_line('Employee Detail');
    dbms_output.put_line('Employee number: ' ||  rec_emp.emp_no);
    dbms_output.put_line('Employee name: ' || rec_emp.emp_name);
    dbms_output.put_line('Employee manager: ' || rec_emp.manager);
    dbms_output.put_line('Employee salary: ' || rec_emp.salary);
END;
/

--Example 3: Record type at subprogram level-Row level access
DECLARE
    TYPE emp_dept_row IS RECORD
    (
    emp_no number,
    emp_name varchar2(150),
    manager number,
    salary number
    );
    
rec_emp emp_dept_column;
BEGIN
    

END;
/


/*Basic loop statement*/
-- Write program print number from 1 to 5 using basic loop statement
DECLARE
    a number:= 1;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('Program started!');
    LOOP
    DBMS_OUTPUT.PUT_LINE(a);
    a:=a + 1;
    EXIT WHEN a>5;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Program completed!');

END;
/
select * from emp;

/*create Function get salary of worker with input employee number*/
create or replace function get_salary(manv in number)
return number
as
    v_sal number;
BEGIN
    select sal into v_sal from emp where empno = manv;
    return v_sal;
END;
/
--Calling function from sql dual
select get_salary(7839) from dual;

--Calling function from PL/SQL block
set serveroutput on;
declare 
    p_sal number;
begin
    p_sal := get_salary(7839);
     dbms_output.put_line('Salary is: ' || p_sal);
end;
/

/*Write function calculating the area of a circle*/
create or replace function calculate_circle_area(radius number)
return number IS
pi constant number (7,3) := 3.141;
area number(7,3);

BEGIN
    ---Area of circle pi * r * r
    area := pi * radius * radius;
    return area;
END;
/

set serveroutput on;

begin
    dbms_output.put_line(calculate_circle_area(25));
end;
/

declare
    v_area number(7, 3);
begin
    v_area := calculate_circle_area(25);
    dbms_output.put_line(v_area);
end;
/

select * from emp;
select * from dept;
/*Insert from select query*/

create table emp1(
    id number(3),
    name varchar2(10)
);
/

create table emp2(
    id number(3),
    name varchar2(10)
);
/

insert into emp1 values (10, 'Long');
insert into emp1 values (11, 'Hung');
commit;

insert into emp2 select * from emp1;
select * from emp2;
drop table emp2;


/*Create package to get and set the values of employee's information in table emp*/
-----The get_record function will return record type output for the given employee number
-----The set_record procedure will insert record type into emp table

select * from dept;
---Step 1: Package specification creation
CREATE OR REPLACE PACKAGE Get_Set_InforDept
IS
    PROCEDURE set_record(p_dept_rec IN dept%ROWTYPE);
    FUNCTION get_record(p_dept_no IN number) RETURN dept%ROWTYPE;
END Get_Set_InforDept;

---Step 2: Package contains Package body

CREATE OR REPLACE PACKAGE BODY Get_Set_InforDept
IS
    PROCEDURE set_record(p_dept_rec IN dept%ROWTYPE)
    IS
    BEGIN
        INSERT INTO dept VALUES(p_dept_rec.deptno, p_dept_rec.dname, p_dept_rec.loc);
        COMMIT;
    END set_record;
    
     FUNCTION get_record(p_dept_no IN number) 
     RETURN dept%ROWTYPE
     IS
        f_dept_record dept%ROWTYPE;
    BEGIN
        select * into f_dept_record from dept where deptno = p_dept_no;
        return f_dept_record;
    END get_record;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Control is now executing the package initialization part');
END Get_Set_InforDept;
/

---Step 3: Create an anonymous block to insert and display the records by created above
SET SERVEROUTPUT on;
DECLARE
    l_get_record dept%ROWTYPE;
    l_set_record dept%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insert new record for dept 50');
    l_set_record.deptno := 50;
    l_set_record.dname := 'SOFTWARE';
    l_set_record.loc := 'ASHELEY TEXAS';
    Get_Set_InforDept.set_record(l_set_record);
    
    DBMS_OUTPUT.PUT_LINE('Record inserted!');
    dbms_output.put_line('Calling get function to display the inserted record');
    l_get_record :=  Get_Set_InforDept.get_record(50);
    DBMS_OUTPUT.PUT_LINE('Department number: ' || l_get_record.deptno);
    DBMS_OUTPUT.PUT_LINE('Department name: ' || l_get_record.dname);
    DBMS_OUTPUT.PUT_LINE('Department loc: ' || l_get_record.loc);
    
END;
/

DELETE FROM dept WHERE deptno = 50;