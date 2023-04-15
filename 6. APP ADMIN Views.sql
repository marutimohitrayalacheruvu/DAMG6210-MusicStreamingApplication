-- views code 

-- view 1: NUMBER_OF_SONGS_IN_GENRE
Select * from artist;
CREATE OR REPLACE VIEW song_count_by_genre AS
SELECT g.genre_name, COUNT(*) AS song_count
FROM songs s
JOIN genre g 
ON s.sgenre_id = g.genre_id
GROUP BY g.genre_name;

SELECT * FROM song_count_by_genre;

-- view 2: NUMBER_OF_SONGS_IN_PLAYLISTS
CREATE OR REPLACE VIEW playlist_song_count AS 
SELECT p.playlist_id, p.playlist_name, 
COUNT(sp.song_id) AS song_count 
FROM playlist p 
JOIN songs_playlist sp 
ON p.playlist_id = sp.playlist_id 
GROUP BY p.playlist_id, p.playlist_name 
ORDER BY song_count DESC;

SELECT * FROM playlist_song_count;

-- view 3: SONGS_BY_RATING
CREATE OR REPLACE VIEW songs_by_rating AS 
SELECT song_id, song_name, song_artistName, salbum_id, song_rating 
FROM songs 
ORDER BY song_rating DESC;

SELECT * FROM songs_by_rating;

-- view 4: SONGS_RELEASED_BY_ARTIST
CREATE OR REPLACE VIEW artist_song_count AS 
SELECT a.artist_id, a.artist_lname, COUNT(s.song_id) AS song_count 
FROM artist a 
JOIN songs s 
ON a.artist_id = s.sartist_id 
GROUP BY a.artist_id, a.artist_lname 
ORDER BY song_count DESC;

SELECT * FROM artist_song_count;


-- view 5: ACTIVE_USERS
CREATE OR REPLACE VIEW active_users AS 
SELECT user_id, first_name, last_name 
FROM users 
WHERE status = 'active';

select * from active_users;

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

select * from user_genre_preference;

-- view 7: DISPLAY_FAVOURITE_SONGS_FOR_A_USER
CREATE OR REPLACE VIEW user_favorites AS 
SELECT s.song_id, s.song_name, s.sartist_id, s.sgenre_id, ROUND(s.song_rating, 2) AS song_rating
FROM songs s 
JOIN favourite f 
ON s.song_id = f.song_id 
WHERE f.user_id = 2;

select * from user_favorites;

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

Select * from user_recommendations;

-- view 9: MOST_RATED_ALBUM
CREATE OR REPLACE VIEW top_rated_album AS
SELECT album_id, album_name, album_rating
FROM album
WHERE album_rating = (SELECT MAX(album_rating) FROM album);

select * from top_rated_album;

-- commit views creation
commit;