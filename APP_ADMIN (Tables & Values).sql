-- drop any existing tables, views, procedures, etc.
set serveroutput on
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

-- create sequence for user_id
CREATE SEQUENCE user_id_seq
  START WITH 1
  INCREMENT BY 1
  MAXVALUE 999999999999999999999999999;

-- create users table
create table users(
    user_id NUMBER DEFAULT user_id_seq.NEXTVAL PRIMARY KEY,
    user_fname varchar(100),
    user_lname varchar(100),
    user_email varchar(100),
    user_username varchar(100),
    user_status varchar(100),
    user_reg_date DATE
)
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
    artist_bio varchar(1000)
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

-- insert values into user table
INSERT INTO users (user_fname, user_lname, user_email, user_username, user_status, user_reg_date)
SELECT 'John', 'Doe', 'johndoe@example.com', 'johndoe', 'active', TO_DATE('2022-01-01', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Jane', 'Doe', 'janedoe@example.com', 'janedoe', 'active', TO_DATE('2022-01-01', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Bob', 'Smith', 'bobsmith@example.com', 'bobsmith', 'active', TO_DATE('2022-01-02', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Alice', 'Smith', 'alicesmith@example.com', 'alicesmith', 'inactive', TO_DATE('2022-01-02', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Michael', 'Johnson', 'michaeljohnson@example.com', 'michaeljohnson', 'active', TO_DATE('2022-01-03', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Emily', 'Johnson', 'emilyjohnson@example.com', 'emilyjohnson', 'active', TO_DATE('2022-01-03', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'David', 'Garcia', 'davidgarcia@example.com', 'davidgarcia', 'inactive', TO_DATE('2022-01-04', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Maria', 'Garcia', 'mariagarcia@example.com', 'mariagarcia', 'active', TO_DATE('2022-01-04', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'James', 'Kim', 'jameskim@example.com', 'jameskim', 'active', TO_DATE('2022-01-05', 'YYYY-MM-DD') FROM DUAL
UNION ALL
SELECT 'Soo', 'Kim', 'sookim@example.com', 'sookim', 'inactive', TO_DATE('2022-01-05', 'YYYY-MM-DD') FROM DUAL;

-- insert values into artist table
INSERT INTO artist (artist_fname, artist_lname, artist_bio)
SELECT 'Taylor', 'Swift', 'American singer' FROM DUAL
UNION ALL
SELECT 'Justin', 'Bieber', 'Canadian singer' FROM DUAL
UNION ALL
SELECT 'Nickie', 'Minaj', 'Trinidadian singer' FROM DUAL
UNION ALL
SELECT 'Adele', 'Adkins', 'British singer' FROM DUAL
UNION ALL
SELECT 'Shawn', 'Mendes', 'Canadian singer-songwriter' FROM DUAL;


-- insert values into album table
INSERT INTO album (album_name, album_rating)
SELECT 'My World 2.0', 8.1 FROM DUAL UNION ALL
SELECT 'Folklore', 8.9 FROM DUAL UNION ALL
SELECT 'Fearless', 8.5 FROM DUAL UNION ALL
SELECT 'Handwritten', 8 FROM DUAL UNION ALL
SELECT 'Illuminate ', 8.2 FROM DUAL UNION ALL
SELECT 'Queen', 8.2 FROM DUAL UNION ALL
SELECT 'Playtime is Over', 7.8 FROM DUAL UNION ALL
SELECT '21', 9.5 FROM DUAL UNION ALL
SELECT 'Adele: MTV Unplugged', 8.0 FROM DUAL UNION ALL
SELECT 'Eenie Meenie ', 8.7 FROM DUAL;


-- insert values into genre table
INSERT INTO genre (genre_name)
SELECT 'Rock' FROM DUAL UNION ALL
SELECT 'Pop' FROM DUAL UNION ALL
SELECT 'Hip hop' FROM DUAL UNION ALL
SELECT 'Jazz' FROM DUAL UNION ALL
SELECT 'Electronic' FROM DUAL UNION ALL
SELECT 'Progressive rock' FROM DUAL UNION ALL
SELECT 'Electronic' FROM DUAL UNION ALL
SELECT 'Country' FROM DUAL UNION ALL
SELECT 'RnB' FROM DUAL;

-- insert values into artist_album table
INSERT INTO artist_album (artist_id, album_id)
SELECT 2, 1 FROM DUAL UNION ALL
SELECT 1, 2 FROM DUAL UNION ALL
SELECT 1, 3 FROM DUAL UNION ALL
SELECT 2, 10 FROM DUAL UNION ALL
SELECT 3, 6 FROM DUAL UNION ALL
SELECT 3, 7 FROM DUAL UNION ALL
SELECT 4, 8 FROM DUAL UNION ALL
SELECT 4, 9 FROM DUAL UNION ALL
SELECT 5, 4 FROM DUAL UNION ALL
SELECT 5, 5 FROM DUAL;


-- insert values into songs table
INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
VALUES ('Love Story', 'Taylor Swift', 9.1, TO_TIMESTAMP('04-11-1991 00:05:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('29-07-1991', 'DD-MM-YYYY'), 1, 1, 3, 1);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
VALUES ('White Horse', 'Taylor Swift', 8.9, TO_TIMESTAMP('30-11-1979 00:06:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('30-11-1979', 'DD-MM-YYYY'), 2, 2, 3, 1);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
VALUES ('I Know What You Did Last Summer', 'Shawn Mendes', 8.6, TO_TIMESTAMP('16-04-1984 00:05:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('16-04-1984', 'DD-MM-YYYY'), 1, 3, 4, 5);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
VALUES ('No Promises', 'Shawn Mendes', 9.2, TO_TIMESTAMP('10-09-1991 00:05:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('10-09-1991', 'DD-MM-YYYY'), 1, 4, 5, 5);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
VALUES ('Chasing Pavements', 'Adele', 9.1, TO_TIMESTAMP('31-10-1975 00:05:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('31-10-1975', 'DD-MM-YYYY'), 1, 5, 8, 4);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
VALUES ('Cardigan', 'Taylor Swift', 8.7, TO_TIMESTAMP('10-09-1990 00:04:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('10-09-1990', 'DD-MM-YYYY'), 1, 1, 2, 1);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Cant Stop Wont Stop', 'Nicki Minaj', 9.0, TO_TIMESTAMP('15-09-1975 00:05:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('15-09-1975', 'DD-MM-YYYY'), 1, 2, 6, 3);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Stuck in the Moment', 'Justin Bieber', 8.5, TO_TIMESTAMP('25-06-1984 00:08:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('25-06-1984', 'DD-MM-YYYY'), 1, 3, 1, 2);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Rumour Has It', 'Adele', 8.9, TO_TIMESTAMP('2-10-1991 00:03:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('2-10-1991', 'DD-MM-YYYY'), 1, 3, 9, 4);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Tear Drops on My Guitar', 'Taylor Swift', 8.9, TO_TIMESTAMP('2-10-1991 00:03:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('2-10-1991', 'DD-MM-YYYY'), 3, 3, 3, 1);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Rumour Has It', 'Adele', 8.9, TO_TIMESTAMP('2-10-1991 00:03:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('2-10-1991', 'DD-MM-YYYY'), 1, 3, 9, 4);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Someone Like You', 'Adele', 9.4, TO_TIMESTAMP('2-10-1991 00:03:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('2-10-1991', 'DD-MM-YYYY'), 2, 5, 9, 4);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Turning Tables', 'Adele', 9.8, TO_TIMESTAMP('2-10-1991 00:03:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('2-10-1991', 'DD-MM-YYYY'), 3, 5, 9, 4);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Stitches', 'Shawn Mendes', 8.8 , TO_TIMESTAMP('2-10-1991 00:03:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('2-10-1991', 'DD-MM-YYYY'), 2, 2, 4, 5);

INSERT INTO songs (song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, songs.sgenre_id, songs.salbum_id, songs.sartist_id) 
VALUES ('Thought I knew you', 'Nicki Minaj', 9.0, TO_TIMESTAMP('15-09-1975 00:05:00', 'DD-MM-YYYY HH24:MI:SS'), 'English', TO_DATE('15-09-1975', 'DD-MM-YYYY'), 2, 2, 6, 3);


-- insert values into playlist table
INSERT INTO playlist (playlist_name, user_id)
SELECT 'My Playlist', 1 FROM DUAL UNION ALL
SELECT 'Road Trip Tunes', 2 FROM DUAL UNION ALL
SELECT 'Summer Jams', 3 FROM DUAL UNION ALL
SELECT 'Throwback Hits', 1 FROM DUAL UNION ALL
SELECT 'Chill Vibes', 2 FROM DUAL UNION ALL
SELECT 'Workout Mix', 3 FROM DUAL UNION ALL
SELECT '90s Nostalgia', 1 FROM DUAL UNION ALL
SELECT 'Sad Songs', 2 FROM DUAL;


-- insert values into songs_playlist table
INSERT INTO songs_playlist (song_id, playlist_id)
SELECT 1, 1 FROM DUAL UNION ALL
SELECT 2, 1 FROM DUAL UNION ALL
SELECT 3, 2 FROM DUAL UNION ALL
SELECT 4, 2 FROM DUAL UNION ALL
SELECT 5, 2 FROM DUAL UNION ALL
SELECT 6, 3 FROM DUAL UNION ALL
SELECT 7, 4 FROM DUAL UNION ALL
SELECT 8, 5 FROM DUAL UNION ALL
SELECT 9, 6 FROM DUAL UNION ALL
SELECT 3, 6 FROM DUAL UNION ALL
SELECT 1, 7 FROM DUAL UNION ALL
SELECT 2, 7 FROM DUAL UNION ALL
SELECT 4, 8 FROM DUAL UNION ALL
SELECT 7, 8 FROM DUAL;


-- insert values into songs table
INSERT INTO favourite (song_id, user_id)
SELECT 1, 1 FROM DUAL UNION ALL
SELECT 1, 2 FROM DUAL UNION ALL
SELECT 2, 3 FROM DUAL UNION ALL
SELECT 4, 2 FROM DUAL UNION ALL
SELECT 6 , 1 FROM DUAL UNION ALL
SELECT 6, 4 FROM DUAL UNION ALL
SELECT 2, 5 FROM DUAL UNION ALL
SELECT 3, 5 FROM DUAL UNION ALL
SELECT 11, 2 FROM DUAL UNION ALL
SELECT 3, 5 FROM DUAL UNION ALL
SELECT 12, 2 FROM DUAL UNION ALL
SELECT 13, 2 FROM DUAL;

-- viewing tables

select * from users;
select * from songs;
select * from artist;
select * from album;
select * from playlist;
select * from favourite;
select * from genre;
select * from artist_album;
select * from songs_playlist;

-- commit values insertion
COMMIT;