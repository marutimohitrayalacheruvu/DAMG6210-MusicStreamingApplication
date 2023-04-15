Select * from songs;
SET SERVEROUTPUT ON;
BEGIN
    app_admin.delete_pkg.delete_song(11);
END;
/

SET SERVEROUTPUT ON;
Select * from songs;
Select * from artist;
Select * from album;
Select * from songs;
Select * from artist_album;
SET SERVEROUTPUT ON
BEGIN
    app_admin.delete_pkg.delete_artist(2);
END;
/
Select * from artist;
Select * from album;
Select * from songs;
Select * from artist_album;




---------------------------------Reports

SELECT 'Report to show song count in genre' AS REPORT_TITLE FROM dual;
SELECT genre_name || ' has ' || song_count || ' songs.' AS report
FROM song_count_by_genre;

SELECT 'Report to show song count in playlist' AS REPORT_TITLE FROM dual;
SELECT playlist_name || ' has ' || song_count || ' songs.' AS report
FROM playlist_song_count;

SELECT 'Report to show songs by rating' AS REPORT_TITLE FROM dual;
SELECT song_name || ' by ' || song_artistName || ' has a rating of ' || ROUND(song_rating, 2) AS song_info
FROM songs_by_rating;

SELECT 'Report to show song count by artist' AS report_title FROM dual;
SELECT a.artist_lname || ' has ' || song_count || ' songs.' AS report
FROM artist_song_count a;

SELECT 'Report to show active users' AS report_title FROM dual;
SELECT 'User ' || first_name || ' ' || last_name || ' is active.' AS report
FROM active_users;

SELECT 'Report to show user genre preferences' AS report_title FROM dual;
SELECT 'User ' || user_name || ' has ' || genre_preference_count || ' genre preferences.' AS report
FROM user_genre_preference;

SELECT 'Report to show user favorite songs' AS report_title FROM dual;
SELECT song_name || ' by ' || artist_lname || ' (' || genre_name || ') - Rating: ' || ROUND(song_rating, 2) AS report
FROM user_favorites
JOIN artist ON sartist_id = artist_id
JOIN genre ON sgenre_id = genre_id;

SELECT 'Report to show recommended songs for user' AS report_title FROM dual;
SELECT 'Song: ' || song_name || ' Artist: ' || song_artistname AS recommendation
FROM user_recommendations;

SELECT 'Report to show the top rated album' AS report_title FROM dual;
SELECT 'Album: ' || album_name || ', Average Rating: ' || ROUND(album_rating, 2) AS album_rating
FROM top_rated_album;