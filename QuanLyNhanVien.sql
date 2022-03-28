/*Bai tap QuanLyNhanVien*/
DECLARE tmp1 number;
BEGIN
    select count(*) into tmp1
    from user_tables
    where table_name = 'DEPT';
    if(tmp1 <> 0) then execute immediate 'DROP TABLE DEPT';
    end if;
    tmp1:=0;
    select count(*) into tmp1
    from user_tables
    where table_name = 'EMP';
    if(tmp1 <> 0) then execute immediate 'DROP TABLE EMP';
    end if;
    tmp1:=0;
    select count(*) into tmp1
    from user_tables
    where table_name = 'SALGRADE';
    if(tmp1 <> 0) then execute immediate 'DROP TABLE SALGRADE';
    end if;
END;
/
--- Tao bang DEPT
create table DEPT
(
    "DEPTNO" NUMBER(2) PRIMARY KEY,
    "DNAME" VARCHAR2(14),
    "LOC" VARCHAR2(13)
);
--- Tao bang SALGRADE
create table SALGRADE
(
    "GRADE" NUMBER PRIMARY KEY,
    "LOSAL" NUMBER,
    "HISAL" NUMBER
);
--- Tao bang EMP
create table EMP
(
    "EMPNO" NUMBER(4) PRIMARY KEY,
    "ENAME" VARCHAR2(10),
    "JOB" VARCHAR2(9),
    "MGR" NUMBER(4),
    "HIREDATE" DATE,
    "SAL" NUMBER(7,2),
    "COMM" NUMBER(7,2),
    "DEPTNO" NUMBER(2) NOT NULL
);
---Rang buoc khoa ngoai
alter table EMP 
add constraint FK_EMP_EMP
Foreign key(MGR)
References EMP(EMPNO);
----Rang buoc khoa ngoai
alter table DEPT
add constraint FK_EMP_DEPT
foreign key(DEPTNO)
References DEPT(DEPTNO);
--- Chèn du lieu vào SALGRADE
insert into SALGRADE values(1, 700, 1200);
insert into SALGRADE values(2, 1201, 1400);
insert into SALGRADE values(3,1401,2000);
insert into SALGRADE values(4, 2001, 3000);
insert into SALGRADE values(5, 3001, 9999);

--- Chèn du lieu vào EMP
INSERT INTO EMP VALUES(7839, 'KING', 'PRESIDENT', NULL, '17-NOV-1981', 5000, NULL, 10);
INSERT INTO EMP VALUES(7698,'BLACKE','MANAGER',7839 , '01-MAY-1981',2850 ,NULL ,30);
INSERT INTO EMP VALUES(7782, 'CLARK', 'MANAGER',7839 , '09-JUN-1981',2450,null ,10);
INSERT INTO EMP VALUES(7566, 'JONES', 'MANAGER',7839 , '02-APR-1981', 2975,NULL,20);
INSERT INTO EMP VALUES(7654, 'MARTIN', 'SALESMAN',7698 , '28-SEP-1981',1250,1400,30);
INSERT INTO EMP VALUES(7499, 'ALLEN', 'SALESMAN',7698 , '20-FEB-1981',1600,300,30);
INSERT INTO EMP VALUES(7844, 'TURNER', 'SALESMAN',7698, '08-SEP-1981',1500,0,30);
INSERT INTO EMP VALUES(7900, 'JAMES', 'CLERK', 7698, '03-DEC-1981',960 ,NULL,30);
INSERT INTO EMP VALUES(7521, 'WARD', 'SALESMAN',7698, '22-FEB-1981',1250 , 500,30);
INSERT INTO EMP VALUES(7902, 'FORD', 'ANALYST',7566 , '03-DEC-1981',3000 ,NULL ,20);
INSERT INTO EMP VALUES(7369, 'SMITCH', 'CLEARRK',7902 , '17-DEC-1980',800,NULL, 20);
INSERT INTO EMP VALUES(7788, 'SCOTT', 'ANALYST',7566 , '09-DEC-1982',3000 ,NULL ,20);
INSERT INTO EMP VALUES(7876, 'ADAMS', 'CLEARK', 7788, '12-JAN-1983',1100 ,NULL,20);
INSERT INTO EMP VALUES(7934, 'MILLERR', 'CLEARK',7782 , '23-JAN-1982',1300,NULL,10);


--- Chèn du lieu vào bang DEPT
insert into DEPT values(10,'ACCOUNTING', 'NEW YORK');
insert into DEPT values(20,'RESEARCH', 'DALLAS');
insert into DEPT values(30, 'SALES', 'CHICAGO');
insert into DEPT values(40, 'OPERATIONS', 'BOSTON');

/*Cau 1 Hien thi nhanvien cu the va thu nhap cua nhan vien do trong mot nam*/
select * from emp;
create or replace procedure sp_showInfor_Emp(p_ename in varchar2)
AS
    v_empno number;
    v_ename varchar2(242);
    v_sal number;

Begin
    select empno, ename, sal into v_empno, v_ename, v_sal from emp where ename = p_ename;
    DBMS_OUTPUT.PUT_LINE(v_empno || ' ' ||  v_ename || ' ' || v_sal);
end;
/
exec  sp_showInfor_Emp('KING');

/*Cau 2 Hien thi cau truc bang EMP*/
create or replace procedure sp_CauTrucBangEMP(cur_out OUT SYS_REFCURSOR)
IS
begin
    OPEN cur_out for
    select column_name as "Name", nullable as "Null ?", concat(concat(concat(data_type, '('), data_length), ')') as "Type"    from user_tab_columns where table_name = 'EMP';
    --CLOSE cur_out;
end;
/

desc emp;

var res REFCURSOR;
exec sp_CauTrucBangEMP(:res);
print res;

select *  from user_tab_columns where table_name = 'EMP';


/*Cau 3: Thay doi nhan va dinh dang bieu thi cua cot sal va hiredate trong bang emp*/
create or replace procedure sp_SalHireDate
AS
    cursor cur is select sal, hiredate   from emp;
    employee_rec cur%ROWTYPE;
BEGIN
    OPEN cur;

     LOOP
        FETCH cur into employee_rec;
        EXIT When cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Ngay vao lam: ' || to_Char(employee_rec.hiredate, 'DD/MM/YYYY') || ' va luong nhan duoc la ' || concat(employee_rec.sal , ' VND'));
    END LOOP;
    CLOSE cur;
   --  as "Luong" "Ngay vao lam"  concat(sal, ' VND'), to_Char(hiredate, 'DD/MM/YYYY')
END;
/
/*Neu lap trinh PL/SQL muon query multi-row => need to use cursor, sothat fetch data*/
DECLARE
    cursor cur IS select hiredate, sal from emp;
    ---Khai bao 1 bien record de dai dien cho mot hang duoc fetch tu bang employee
    employee_rec cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur into employee_rec;
        EXIT When cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Ngay vao lam: ' || employee_rec.hiredate || ' ' || employee_rec.sal);
    END LOOP;
    CLOSE cur;
END;
/


exec sp_SalHireDate;
/*Chon nhan vien co luong 3000 hoac 5000*/
select * from emp where sal in (1000, 3000, 5000);

/*Tim ten phong ban neu phong ban do co nhan vien lam viec*/
select distinct dept.dname
from dept, emp
where dept.deptno = emp.deptno;

select dname
from dept
where exists(
                        select *
                        from emp
                        where dept.deptno = emp.deptno);
select * from emp;
/*Cau 4 : Cho biet thong tin nhan vien có muc luong tu 1000 den 2000*/
create or replace procedure sp_DanhSachNVLuong(value_begin in number, value_end in number)
as
    cursor cur is select empno, ename, job, deptno from emp where sal between value_begin and value_end;
    rec_emp cur%ROWTYPE;
begin
    OPEN cur;
    LOOP
        FETCH cur into rec_emp;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Ma NV: ' || rec_emp.empno || ' , ten nv: ' || rec_emp.ename || ' , nghe: ' || rec_emp.job || ' , thuoc phong: ' || rec_emp.deptno);
    END LOOP;
    CLOSE cur;
end;
/
exec sp_DanhSachNVLuong(1000, 2000);

select * from emp;

/*Cau 5: Hien thi tat ca nhung nhan vien ma ten co cac ky tu TH hoac LL*/
select * from emp where ename LIKE '%LL%' or ename LIKE '%TH%';

create or replace procedure sp_DanhSachNV_THLL
as
    cursor cur is select * from emp where ename LIKE '%LL%' or ename LIKE '%TH%';
    rec_emp cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur into rec_emp;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Empno: ' || rec_emp.empno ||
                                                   ' Ename: ' || rec_emp.ename ||
                                                   ' Job: ' || rec_emp.job ||
                                                   ' Sal: ' || rec_emp.sal);
    END LOOP;
    CLOSE cur;
END;
/
exec sp_DanhSachNV_THLL;


/*Cau 6: Hien thi ten nhan vien, ma phong ban, ngay gia nhap sao cho gia nhap cong ty trong nam 1983*/

select * from emp;
select ename, deptno, to_char(hiredate, 'DD') as "Ngay gia nhap" from emp where to_char(hiredate, 'YYYY') = '1981';

create or replace procedure sp_DanhSachNV_vao1983 as
    cursor cur is select ename, deptno, to_char(hiredate, 'DD') as "Ngay gia nhap" from emp where to_char(hiredate, 'YYYY') = '1981';
    cur_emp cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur into cur_emp;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Ename: ' || cur_emp.ename || ' , deptno: ' || cur_emp.deptno || ' , Ngay gia nhap: ' || cur_emp."Ngay gia nhap");
    END LOOP;
    CLOSE cur;
END;
/
exec sp_DanhSachNV_vao1983;

/*Cau 7: Liet ke ten nhan vien, ma phong ban, va luong nhan vien duoc tang 15%*/

select ename, deptno, (sal + sal * 0.15) as "Luong sau tang" from emp;

create or replace procedure sp_DanhSachNV_Luongtang15 as
    cursor cur is select ename, deptno, (sal + sal * 0.15) as "Luong sau tang" from emp;
    rec_cur cur%ROWTYPE;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur into rec_cur;
        EXIT WHEN cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Ename: ' || rec_cur.ename || ' , deptno: ' || rec_cur.deptno || ' , Luong sau tang la: ' || rec_cur."Luong sau tang"); 
    END LOOP;
    CLOSE cur;
END;
/

exec sp_DanhSachNV_Luongtang15;

/*Cau 8: Hien thi ten nhan vien (Job) */

select ename || ' (' || job || ' )' as "EMPLOYEE" from emp;

create or replace procedure sp_HienThi as
    cursor cur is select ename || ' (' || job || ' )' as "EMPLOYEE" from emp;
    rec_emp cur%ROWTYPE;
begin
    open cur;
    loop
        fetch cur into rec_emp;
        exit when cur%NOTFOUND;
        dbms_output.put_line(rec_emp."EMPLOYEE");
    end loop;
    close cur;
end;
/
exec sp_HienThi;

/*Cau 9: Tim thong tin ve nhan vien, ngay gia nhap cong ty cua nhan vien phong so 20*/
select ename, lower(to_char(hiredate, 'MONTH')) || ', ' || to_char(hiredate, 'DDSPTH YYYY') as "DATE_HIRED" from emp where deptno = 20;

create or replace procedure sp_DanhSachNV20_Hienthi as
    cursor cur is select ename, lower(to_char(hiredate, 'MONTH')) || ', ' || to_char(hiredate, 'DDSPTH YYYY') as "DATE_HIRED" from emp where deptno = 20;
    rec_emp cur%ROWTYPE;
begin
    open cur;
    DBMS_output.put_line('ENAME        DATE_HIRED');
    loop
        fetch cur into rec_emp;
        exit when cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(rec_emp.ename || '       ' || rec_emp.DATE_HIRED);
    end loop;
    close cur;
end;
/
exec sp_DanhSachNV20_Hienthi;

/*Cau 10: Tim luong cao nhat, thap nhat va trung binh cua nhan vien*/

select max(sal) as "Max_Sal", min(sal) as Min_Sal, round(avg(sal)) as Avg_Sal from emp;

create or replace procedure sp_DanhSachMax_Min_AvgSalary as
    cursor cur is select max(sal) as "Max_Sal", min(sal) as Min_Sal, round(avg(sal)) as Avg_Sal from emp;
    rec_emp cur%Rowtype;
begin
    open cur;
    loop
        fetch cur into rec_emp;
        exit when cur%NOTFOUND;
        DBMS_output.put_line('Max of salary: ' || rec_emp."Max_Sal" || ' , min of salary: ' || rec_emp.Min_Sal || ' and avg of salary: ' || rec_emp.Avg_Sal);
    end loop;
    
    close cur;
end;
/

exec sp_DanhSachMax_Min_AvgSalary;