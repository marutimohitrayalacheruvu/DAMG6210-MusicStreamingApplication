select * FROM DBA_ROLES;



DROP ROLE ARTIST_ROLE;
DROP ROLE USER_ROLE;
------------------------------------roleArtist----------------------------------------------------
DECLARE
  ncount NUMBER;
BEGIN
  SELECT COUNT(1) INTO ncount FROM DBA_ROLES WHERE role = 'ARTIST_ROLE';
  IF (ncount > 0) THEN
    DBMS_OUTPUT.PUT_LINE('ARTIST_ROLE ALREADY EXISTS');
  ELSE
    EXECUTE IMMEDIATE 'CREATE ROLE ARTIST_ROLE';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.UPDATE_ARTIST_BYARTIST TO ARTIST_ROLE';
    EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.INSERT_ALBUM_ARTIST_M TO ARTIST_ROLE'; 
    EXECUTE IMMEDIATE 'grant create session, connect to ARTIST_ROLE';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.song_count_by_genre TO ARTIST_ROLE';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.songs_by_rating TO ARTIST_ROLE';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.artist_song_count TO ARTIST_ROLE';
    EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.top_rated_album TO ARTIST_ROLE';
    FOR x IN (SELECT * FROM user_tables WHERE table_name='ARTIST')
    LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, DELETE ON ' || x.table_name || ' TO ARTIST_ROLE';
    END LOOP;
    COMMIT;
    FOR x IN (SELECT * FROM user_tables WHERE table_name IN ('ALBUM','SONGS'))
    LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, INSERT, DELETE ON ' || x.table_name || ' TO ARTIST_ROLE';
    END LOOP;
    COMMIT;
    FOR x IN (SELECT * FROM user_tables WHERE table_name IN ('FAVOURITE', 'GENRE'))
    LOOP
      EXECUTE IMMEDIATE 'GRANT SELECT ON ' || x.table_name || ' TO ARTIST_ROLE';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('ARTIST_ROLE is created');
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
  dbms_output.put_line('USER_ROLE ALREADY EXISTS');
 else 
   EXECUTE IMMEDIATE 'CREATE ROLE USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.UPDATE_USER_FROM_USER TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.ADD_FAVORITE_FROM_USER TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.DELETE_FAVORITE_FROM_USER TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.ADD_PLAYLIST TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.ADD_SONG_TO_PLAYLIST TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.DELETE_SONG_FROM_PLAYLIST TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT EXECUTE ON APP_ADMIN.DELETE_PLAYLIST TO USER_ROLE';
   EXECUTE IMMEDIATE 'grant create session, connect to USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.songs_by_rating TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.artist_song_count TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.user_genre_preference TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.user_favorites TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.user_recommendations TO USER_ROLE';
   EXECUTE IMMEDIATE 'GRANT SELECT ON APP_ADMIN.top_rated_album TO USER_ROLE';
   FOR x IN (SELECT * FROM user_tables where table_name in ('ARTIST','ALBUM','SONGS', 'FAVOURITE', 'PLAYLIST', 'USERS'))
   LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || x.table_name || ' TO USER_ROLE';
   END LOOP;
    DBMS_OUTPUT.PUT_LINE('USER_ROLE is created');
   COMMIT;
   END IF;
END;
/








DROP USER TAYLOR_SWIFT;
DROP USER JOHNDOE;
---------------------------------------Artist user Creation and Role assignment-----------------------------
DECLARE 
    nCount number;
BEGIN
    SELECT count(1) INTO nCount FROM ALL_USERS WHERE USERNAME = 'TAYLOR_SWIFT';
    IF nCount > 0 THEN 
        dbms_output.put_line('User TAYLOR_SWIFT already exists');
    ELSE
        EXECUTE IMMEDIATE 'create user TAYLOR_SWIFT identified by Password#6210';
        insert_artist('Taylor', 'Swift', 'A talented musician', 'TAYLOR_SWIFT');
        EXECUTE IMMEDIATE 'grant ARTIST_ROLE to TAYLOR_SWIFT';
        dbms_output.put_line('User TAYLOR_SWIFT created successfully');
    END IF;
EXCEPTION 
    WHEN OTHERS THEN 
        dbms_output.put_line(dbms_utility.format_error_backtrace);
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/ 


---------------------------------------User Creation and Role assignment-----------------------------
Declare 
    nCount number;
BEGIN
  SELECT count(1) INTO nCount FROM ALL_USERS WHERE USERNAME = 'JOHNDOE';
  IF nCount > 0 THEN 
        dbms_output.put_line('User JOHN already exists');
    ELSE
        EXECUTE IMMEDIATE 'create user JOHNDOE identified by Password#6210';
        insert_or_update_user('John', 'Doe', 'johndoe@example.com', 'JOHNDOE', 'active', SYSDATE);
        EXECUTE IMMEDIATE 'grant USER_ROLE to JOHNDOE';
        dbms_output.put_line('User JOHN created successfully');
    END IF;
EXCEPTION 
    WHEN OTHERS THEN 
        dbms_output.put_line(dbms_utility.format_error_backtrace);
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
        RAISE;  
END;
/

COMMIT;




SELECT * FROM all_procedures WHERE object_name = 'ADD_PLAYLIST';

select * from artist;
select * from users;

