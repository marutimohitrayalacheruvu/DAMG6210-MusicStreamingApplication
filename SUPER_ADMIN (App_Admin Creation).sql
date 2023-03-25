select user from dual;

------------------------------------APP_ADMIN----------------------------------------------------
Declare 
ncount number;
BEGIN
 select count(1) into ncount from all_users where username = 'APP_ADMIN';
 if (ncount>0) THEN
      dbms_output.put_line('USER APP_ADMIN ALREADY EXISTS - DELETING');
      EXECUTE IMMEDIATE 'DROP USER APP_ADMIN CASCADE';
 end if;
-- create the new user
EXECUTE IMMEDIATE 'create user APP_ADMIN identified by GCQiRbpWBk1q';
EXECUTE IMMEDIATE 'GRANT CONNECT,RESOURCE to APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO APP_ADMIN';
EXECUTE IMMEDIATE 'Grant create view, create sequence,create trigger, create procedure to APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT CREATE user to APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT DROP user to APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT CREATE role to APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT CREATE SESSION,connect TO APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT CREATE ROLE TO APP_ADMIN';
EXECUTE IMMEDIATE 'GRANT SELECT ON DBA_ROLES TO APP_ADMIN';
dbms_output.put_line('USER APP_ADMIN CREATED');
COMMIT;
END; 
/