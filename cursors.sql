/*/Cursors no parameters*/
set serveroutput on;
declare
    v_name varchar2(30);
    --Declare cursor
    CURSOR cur_name IS
    select Tenthanhvien from thanhvien where luong >= 20000;
begin
    OPEN cur_name;
    loop
        FETCH cur_name into v_name;
        DBMS_OUTPUT.PUT_LINE(v_name);
        EXIT WHEN cur_name%NOTFOUND;
    end loop;
    CLOSE cur_name; 
end;
/

select * from thanhvien;
desc thanhvien;

/*Cursor with one parameter*/
SET SERVEROUTPUT ON;
DECLARE
    v_name varchar2(30);
    v_id number(5);
    CURSOR cur_name_id (var_luong number := 25000) IS
    SELECT Ma, tenthanhvien from Thanhvien where luong >= var_luong;
BEGIN
    OPEN cur_name_id;
    LOOP
        FETCH cur_name_id into v_id, v_name;
        EXIT WHEN cur_name_id%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_name); 
    END LOOP;
    CLOSE cur_name_id; 
END;
/
    

    
