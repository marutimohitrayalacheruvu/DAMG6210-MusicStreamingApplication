SET SERVEROUTPUT ON;
DROP USER APP_ADMIN;
DROP USER TAYLOR_SWIFT;
DROP USER JOHN;
DROP ROLE ARTIST_ROLE;
DROP ROLE USER_ROLE;


-- Super_Admin creates the APP_ADMIN and Roles(USER_ROLE, ARTIST_ROLE)
-- APP_ADMIN will create the users and assign the specific roles created by Super_Admin

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
EXECUTE IMMEDIATE 'create user APP_ADMIN identified by Password#6210';
EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'grant create view, create procedure, create sequence, CREATE USER, DROP USER to APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'GRANT UNLIMITED TABLESPACE TO APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'GRANT CREATE user to APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'GRANT DROP user to APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'GRANT CREATE SESSION,connect TO APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'GRANT CREATE ROLE TO APP_ADMIN with admin option';
EXECUTE IMMEDIATE 'GRANT SELECT ON DBA_ROLES TO APP_ADMIN';
dbms_output.put_line('USER APP_ADMIN CREATED');
COMMIT;
END; 
/