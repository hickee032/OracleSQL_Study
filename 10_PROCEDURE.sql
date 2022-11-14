--���ν���
--�Ϸ��� �۾����� �ϳ��� ��� �����صξ��ٰ� ȣ�� �Ͽ� �̷� �۾����� ���� �Ҽ��ְ� ��

/*
CREATE OR REPLACE PROCEDURE [���ν��� ��](
     [�Ű�������] [MODE] [����������]) 
     IS
     [������] [����������] -- ���� ����
    );
BEGIN
...
END;
/


*/
--���ν����� ���� 
--EXECUTE PROCEDURE_NAME
--���ν����� ����
--DROP PROCEDURE_NAME

--IN -- �ܺο��� ���ν��� ������ (�Ű�����)
--�����͸� ���� ������

--OUT --�ܺο��� ���ν��� ������� Ȯ�� 
--����� ����� �޾ư���

--INPUT --�� �ΰ��� ������ ���� ���

SET SERVEROUTPUT ON 

CREATE OR REPLACE PROCEDURE emp_info(
    p_empno IN employee.eno%TYPE) IS
    v_eno employee.eno%TYPE;
    v_sal NUMBER;
    v_ename employee.ename%TYPE;
BEGIN
    SELECT eno,ename,salary INTO v_eno,v_ename,v_sal
        FROM employee WHERE eno = p_empno;
    dbms_output.put_line('��� :'||v_eno);
    dbms_output.put_line('�̸� :'||v_ename);
    dbms_output.put_line('�޿� :'||v_sal);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('�˼� ���� ����');
 END;
 /
 
 --���ν��� ȣ��
 EXECUTE emp_info(7788);
 
 -------------------------------------------------------------------
 
CREATE OR REPLACE PROCEDURE emp_info(
    p_empdno IN employee.dno%TYPE) IS
BEGIN
for empdno_buf in( SELECT * FROM employee WHERE dno = p_empdno)
    loop
    dbms_output.put_line('�μ���ȣ : '||empdno_buf.dno||' �����ȣ : '||empdno_buf.eno||' �̸� : '||empdno_buf.ename||'/ �޿� : '||empdno_buf.salary);
    end loop;
END;
/

EXECUTE emp_info(10);    
 -------------------------------------------------------------------
 
CREATE OR REPLACE PROCEDURE emp_info2(
    p_empdno IN employee.dno%TYPE) IS
    CURSOR EMP2_CURSOR IS 
    SELECT * FROM EMPLOYEE WHERE DNO = p_empdno;
    empdno_buf EMPLOYEE%ROWTYPE;
BEGIN
open EMP2_CURSOR;
    loop
    FETCH EMP2_CURSOR INTO empdno_buf;
    EXIT WHEN EMP2_CURSOR%NOTFOUND;
    dbms_output.put_line('�μ���ȣ : '||empdno_buf.dno||' �����ȣ : '||empdno_buf.eno||' �̸� : '||empdno_buf.ename||'/ �޿� : '||empdno_buf.salary);
    end loop;
    CLOSE EMP2_CURSOR;
END;
/

EXECUTE emp_info2(10);

--out ������ ����غ���
--�μ� ���̺� ������ �߰� (dno,dname,loc �߰�)
--���� dno�� ������ ���� �ƴϸ� �߰���
create or replace procedure dept_ins_p(
    v_dno in number, 
    v_dname in department.dname%type,
    v_loc in varchar2,
    v_result out varchar2 --�ܺη� ������ ���
)is
    cnt number :=0; --���� dno�� �ִ� �� �Ǻ��ϴ� ����
--����� ó�� ����ó�� (exception)
    EXIST_DNO_ERR exception;
begin
    select count(*) into cnt from department where dno = v_dno and rownum = 1;--dno = v_dno �� ������ -- and rownum = 1 > ����������� 1���� 
    if cnt > 0 then
        v_result :='��ϵ� �μ���ȣ';
        raise EXIST_DNO_ERR; --������ ����(����)�� �߻� exception ȣ�� -- (��� ������ ������ �빮�ڷ� ���)
    else insert into department(dno, dname,loc) VALUES (v_dno,v_dname,v_loc);
        commit;
        v_result := '�����Է�';
    end if;
exception 
 when EXIST_DNO_ERR then
 rollback;
 dbms_output.put_line('DB �����߻�');
end;
/

SET SERVEROUTPUT ON 
--out ���� bind ����
variable v_res varchar2(50); --�˳��ϰ� ��ƾ��� -- ���� �߻�
execute dept_ins_p(12,'����1��','�뱸',:v_res);
print v_res;

var v_res varchar2(50);
execute dept_ins_p(15,'����2��','����',:v_res);
print v_res;

--exception �߻�
variable v_res varchar2(50); 
execute dept_ins_p(10,'����1��','�뱸',:v_res);
print v_res;

 
 