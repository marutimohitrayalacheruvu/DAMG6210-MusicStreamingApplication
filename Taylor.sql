--SELECT * FROM app_admin.songs_by_rating;
--SELECT * FROM app_admin.artist_song_count;
--SELECT * FROM app_admin.song_count_by_genre;
--SELECT * FROM app_admin.top_rated_album;
SELECT * FROM app_admin.artist;

SET SERVEROUTPUT ON;
-------------Updating artist information------------
BEGIN
  app_admin.artist_pkg.update_artist_byartist(1, 'Taylor', 'Swift', 'HAn American singer-songwriter known for her narrative songwriting and distinctive voice.', 'taylor');
END;
/
SELECT * FROM app_admin.artist;

Select * from app_admin.songs;
SET SERVEROUTPUT ON;
BEGIN
  app_admin.artist_pkg.insert_song('Thought I knew youcc', 'Taylor swift', 9.0, TO_TIMESTAMP('00:04:40.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 3, 2, 3, 1);
END;
/

Select * from app_admin.songs;
Select * from app_admin.album;
SET SERVEROUTPUT ON;
BEGIN
  app_admin.artist_pkg.insert_album_artist_m(1, 'Cardigan', 9);
END;
/
Select * from app_admin.album;
COMMIT;