set serveroutput on
-- Cleanup sequences 
/*DECLARE
  sql_statement VARCHAR2(1000);
BEGIN
  FOR s IN (SELECT sequence_name FROM user_sequences)
  LOOP
    sql_statement := 'DROP SEQUENCE ' || s.sequence_name;
    EXECUTE IMMEDIATE sql_statement;
  END LOOP;
END;
*/

BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                   FROM user_objects
                   WHERE object_type IN
                             ('TABLE',
                              'VIEW',
                              'MATERIALIZED VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'SYNONYM',
                              'PACKAGE BODY'
                             ))
   LOOP
      BEGIN
         IF cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         ELSE
            EXECUTE IMMEDIATE 'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
   FOR cur_rec IN (SELECT * 
                   FROM all_synonyms 
                   WHERE table_owner IN (SELECT USER FROM dual))
   LOOP
      BEGIN
         EXECUTE IMMEDIATE 'DROP PUBLIC SYNONYM ' || cur_rec.synonym_name;
      END;
   END LOOP;
END;
/


-- create sequence for artist_id
CREATE SEQUENCE artist_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;

-- create artist table
create table artist (
    artist_id NUMBER DEFAULT artist_id_seq.NEXTVAL PRIMARY KEY, 
    artist_fname varchar(100),
    artist_lname varchar(100),
    artist_bio varchar(1000),
    user_name varchar(100)
)
/

-- create sequence fr album_id
CREATE SEQUENCE album_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;

-- create album table
create table album (
    album_id NUMBER DEFAULT album_id_seq.NEXTVAL PRIMARY KEY,
    album_name varchar(100),
    album_rating number(10)
)
/

-- create sequence for genre_id
CREATE SEQUENCE genre_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;

-- create genre table
create table genre (
    genre_id NUMBER DEFAULT genre_id_seq.NEXTVAL PRIMARY KEY,
    genre_name varchar(100)
)
/



-- create sequence for user_id
CREATE SEQUENCE user_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;
-- create user table
create table users (
    user_id NUMBER DEFAULT user_id_seq.NEXTVAL PRIMARY KEY,
    first_name varchar(100),
    last_name varchar(100),
    email varchar(100),
    user_name varchar(100),
    status varchar(100),
    registration_date DATE
)
/

-- create sequence for song_id
CREATE SEQUENCE song_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;

-- create songs table
create table songs (
    song_id NUMBER DEFAULT song_id_seq.NEXTVAL PRIMARY KEY,
    song_name varchar(100),
    song_artistName varchar(100), 
    song_rating BINARY_FLOAT, 
    song_length TIMESTAMP, 
    song_language varchar(100), 
    song_releaseDate DATE, 
    song_trackNo NUMBER, 
    sgenre_id NUMBER, 
    salbum_id NUMBER, 
    sartist_id NUMBER,
    CONSTRAINT fk_sgenre_id FOREIGN KEY (sgenre_id) REFERENCES genre(genre_id),
    CONSTRAINT fk_salbum_id FOREIGN KEY (salbum_id) REFERENCES album(album_id),
    CONSTRAINT fk_sartist_id FOREIGN KEY (sartist_id) REFERENCES artist(artist_id)
)
/



-- create sequence for playlist_id
CREATE SEQUENCE playlist_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;

-- create playlist table
create table playlist (
    playlist_id NUMBER DEFAULT playlist_id_seq.NEXTVAL PRIMARY KEY,
    playlist_name varchar(100),
    user_id NUMBER,
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
)
/

-- create artist_album table
create table artist_album (
    artist_id NUMBER,
    album_id NUMBER,
    CONSTRAINT fk_art_artist_id FOREIGN KEY (artist_id) REFERENCES artist(artist_id),
    CONSTRAINT fk_art_album_id FOREIGN KEY (album_id) REFERENCES album(album_id)
)
/


-- create songs_playlist table
create table songs_playlist (
    song_id NUMBER,
    playlist_id NUMBER,
    CONSTRAINT fk_song_id FOREIGN KEY (song_id) REFERENCES songs(song_id),
    CONSTRAINT fk_playlist_id FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id)
)
/

-- create favourite table
create table favourite (
    song_id NUMBER,
    user_id NUMBER,
    CONSTRAINT fk_fav_song_id FOREIGN KEY (song_id) REFERENCES songs(song_id),
    CONSTRAINT fk_fav_user_id FOREIGN KEY (user_id) REFERENCES users(user_id)
)
/

-- commit tables creation
COMMIT;



