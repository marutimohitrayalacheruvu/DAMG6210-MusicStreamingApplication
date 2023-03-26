select user from dual;
------------------------------------roleArtist----------------------------------------------------
DECLARE
  ncount NUMBER;
BEGIN
  SELECT COUNT(1) INTO ncount FROM DBA_ROLES WHERE role = 'ARTIST_ROLE';
  IF (ncount > 0) THEN
    DBMS_OUTPUT.PUT_LINE('ARTIST_ROLE ALREADY EXISTS');
  ELSE
    EXECUTE IMMEDIATE 'CREATE ROLE ARTIST_ROLE';
    FOR x IN (SELECT * FROM user_tables WHERE table_name='Artist')
    LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, DELETE ON ' || x.table_name || ' TO ARTIST_ROLE';
    END LOOP;
    COMMIT;
    FOR x IN (SELECT * FROM user_tables WHERE table_name IN ('Album','Songs'))
    LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON ' || x.table_name || ' TO ARTIST_ROLE';
    END LOOP;
    COMMIT;
    FOR x IN (SELECT * FROM user_tables WHERE table_name IN ('Favorite', 'Genre'))
    LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT ON ' || x.table_name || ' TO ARTIST_ROLE';
    END LOOP;
    EXECUTE IMMEDIATE 'grant create session, connect to ARTIST_ROLE';
    COMMIT;
  END IF;
END;
/

------------------------------------roleUser----------------------------------------------------
Declare
ncount number;
BEGIN
 select count(1) into ncount from DBA_ROLES where role = 'USER_ROLE';
 if (ncount>0) THEN
  dbms_output.put_line('USER ROLE ALREADY EXISTS');
 else EXECUTE IMMEDIATE 'CREATE ROLE USER_ROLE';
   FOR x IN (SELECT * FROM user_tables where table_name in ('Users'))
   LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, DELETE ON ' || x.table_name || ' TO USER_ROLE';
   END LOOP;
   COMMIT;
   FOR x IN (SELECT * FROM user_tables where table_name in ('Artist','Genre','Album','Songs'))
   LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || x.table_name || ' TO USER_ROLE';
   END LOOP;
   COMMIT;
   FOR x IN (SELECT * FROM user_tables where table_name in ('Favourite','Playlist'))
   LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, DELETE, INSERT ON ' || x.table_name || ' TO USER_ROLE';
   END LOOP;
   EXECUTE IMMEDIATE 'grant create session, connect to USER_ROLE';
   COMMIT;
   END IF;
END;
/




---------------------------------------Customer_User Creation and Role assignment-----------------------------
DECLARE 
    nCount number;
BEGIN
    SELECT count(1) INTO nCount FROM ALL_USERS WHERE USERNAME = 'TAYLOR_SWIFT';
    IF nCount > 0 THEN 
        dbms_output.put_line('User custuser already exists');
    ELSE
        EXECUTE IMMEDIATE 'create user Taylor_Swift identified by Password#6210';
        EXECUTE IMMEDIATE 'grant ARTIST_ROLE to Taylor_Swift';
        dbms_output.put_line('User custuser created successfully');
    END IF;
EXCEPTION 
    WHEN OTHERS THEN 
        dbms_output.put_line(dbms_utility.format_error_backtrace);
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/ 


---------------------------------------Customer_User Creation and Role assignment-----------------------------
Declare 
    nCount number;
BEGIN
  SELECT count(1) INTO nCount FROM ALL_USERS WHERE USERNAME = 'JOHN';
  IF nCount > 0 THEN 
        dbms_output.put_line('User custuser already exists');
    ELSE
        EXECUTE IMMEDIATE 'create user John identified by Password#6210';
        EXECUTE IMMEDIATE 'grant USER_ROLE to John';
        dbms_output.put_line('User custuser created successfully');
    END IF;
EXCEPTION 
    WHEN OTHERS THEN 
        dbms_output.put_line(dbms_utility.format_error_backtrace);
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/