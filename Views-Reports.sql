-- view 1: NUMBER_OF_SONGS_IN_GENRE
CREATE OR REPLACE VIEW song_count_by_genre AS
SELECT g.genre_name, COUNT(*) AS song_count
FROM songs s
JOIN genre g 
ON s.sgenre_id = g.genre_id
GROUP BY g.genre_name;

SELECT 'Report to show song count in genre' AS REPORT_TITLE FROM dual;
SELECT genre_name || ' has ' || song_count || ' songs.' AS report
FROM song_count_by_genre;

-- view 2: NUMBER_OF_SONGS_IN_PLAYLISTS
CREATE OR REPLACE VIEW playlist_song_count AS 
SELECT p.playlist_id, p.playlist_name, 
COUNT(sp.song_id) AS song_count 
FROM playlist p 
JOIN songs_playlist sp 
ON p.playlist_id = sp.playlist_id 
GROUP BY p.playlist_id, p.playlist_name 
ORDER BY song_count DESC;

SELECT 'Report to show song count in playlist' AS REPORT_TITLE FROM dual;
SELECT playlist_name || ' has ' || song_count || ' songs.' AS report
FROM playlist_song_count;

-- view 3: SONGS_BY_RATING
CREATE OR REPLACE VIEW songs_by_rating AS 
SELECT song_id, song_name, song_artistName, salbum_id, song_rating 
FROM songs 
ORDER BY song_rating DESC;


SELECT 'Report to show songs by rating' AS REPORT_TITLE FROM dual;
SELECT song_name || ' by ' || song_artistName || ' has a rating of ' || song_rating AS song_info
FROM songs_by_rating;

-- view 4: SONGS_RELEASED_BY_ARTIST
CREATE OR REPLACE VIEW artist_song_count AS 
SELECT a.artist_id, a.artist_lname, COUNT(s.song_id) AS song_count 
FROM artist a 
JOIN songs s 
ON a.artist_id = s.sartist_id 
GROUP BY a.artist_id, a.artist_lname 
ORDER BY song_count DESC;

SELECT 'Report to show song count by artist' AS report_title FROM dual;

SELECT a.artist_lname || ' has ' || song_count || ' songs.' AS report
FROM artist_song_count a;

-- view 5: ACTIVE_USERS
CREATE OR REPLACE VIEW active_users AS 
SELECT user_id, first_name, last_name 
FROM users 
WHERE status = 'active';

SELECT 'Report to show active users' AS report_title FROM dual;
SELECT 'User ' || first_name || ' ' || last_name || ' is active.' AS report
FROM active_users;

-- view 6: USERS _GENRE_PREFERENCE
CREATE OR REPLACE VIEW user_genre_preference AS 
SELECT u.user_id, u.user_name,
COUNT(*) AS genre_preference_count
FROM users u 
JOIN favourite f 
ON u.user_id = f.user_id 
JOIN songs s 
ON f.song_id = s.song_id 
GROUP BY u.user_id, u.user_name 
ORDER BY genre_preference_count DESC;

SELECT 'Report to show user genre preferences' AS report_title FROM dual;

SELECT 'User ' || user_name || ' has ' || genre_preference_count || ' genre preferences.' AS report
FROM user_genre_preference;

-- view 7: DISPLAY_FAVOURITE_SONGS_FOR_A_USER
CREATE OR REPLACE VIEW user_favorites AS 
SELECT s.song_id, s.song_name, s.sartist_id, s.sgenre_id, s.song_rating 
FROM songs s 
JOIN favourite f 
ON s.song_id = f.song_id 
WHERE f.user_id = 2;

SELECT 'Report to show user favorite songs' AS report_title FROM dual;
SELECT song_name || ' by ' || artist_lname || ' (' || genre_name || ') - Rating: ' || song_rating AS report
FROM user_favorites
JOIN artist ON sartist_id = artist_id
JOIN genre ON sgenre_id = genre_id;

-- view 8: RECOMMENDATIONS_FOR_USER
CREATE OR REPLACE VIEW user_recommendations AS 
Select s.song_name, s.song_artistname 
FROM songs s
JOIN artist a
on s.sartist_id=a.artist_id 
where a.artist_id = (
SELECT a.artist_id 
FROM favourite f
JOIN songs s ON f.song_id = s.song_id
JOIN artist a ON s.sartist_id = a.artist_id
WHERE f.user_id = 2
GROUP BY a.artist_id,a.artist_fname
ORDER BY COUNT(*) DESC
FETCH FIRST 1 ROW ONLY
);

SELECT 'Report to show recommended songs for user' AS report_title FROM dual;
SELECT 'Song: ' || song_name || ' Artist: ' || song_artistname AS recommendation
FROM user_recommendations;

-- view 9: MOST_RATED_ALBUM
CREATE OR REPLACE VIEW top_rated_album AS
SELECT a.album_id, a.album_name, AVG(s.song_rating) AS avg_rating
FROM songs s JOIN album a 
ON s.salbum_id = a.album_id
GROUP BY a.album_id, a.album_name
ORDER BY avg_rating DESC
FETCH FIRST 1 ROWS ONLY;

SELECT 'Report to show the top rated album' AS report_title FROM dual;
SELECT 'Album: ' || album_name || ', Average Rating: ' || avg_rating AS album_rating
FROM top_rated_album;







