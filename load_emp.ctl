LOAD DATA
INFILE 'D:\LONG\DataEngineer\SQL_Advance\Oracle\emp_data.dat'
TRUNCATE
INTO TABLE EMPS
fields terminated by ","
(
  emp_id,
  emp_name,
  dept_num
)