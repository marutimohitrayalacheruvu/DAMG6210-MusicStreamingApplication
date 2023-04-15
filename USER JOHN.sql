
select * from app_admin.users;

SET SERVEROUTPUT ON;
------------- Update User record from package
BEGIN
  app_admin.user_pkg.update_user_from_user(p_user_id => 11, p_first_name => 'John', p_last_name => 'Doe', p_email => 'john.doe@exaddddmple', p_user_name => 'JOHNDOE');
END;
/

select * from app_admin.users;
select * from app_admin.favourite;
---------- Insert record to Favourite
BEGIN
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 1, p_user_id => 11);
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 2, p_user_id => 11);
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 3, p_user_id => 11);
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 4, p_user_id => 11);
END;
/

select * from app_admin.favourite;

select * from app_admin.favourite;

---------- Delete record from Favourite
BEGIN
  app_admin.user_pkg.delete_favorite_from_user(p_song_id => 2, p_user_id => 11);
END;
/
SET SERVEROUTPUT ON;
select * from app_admin.favourite;
select * from app_admin.playlist;

--------------- Insert to Playlist
BEGIN
  app_admin.user_pkg.add_playlist(p_playlist_name => 'My Favourites', p_user_id => 11);
  app_admin.user_pkg.add_playlist(p_playlist_name => 'My Favourites 1- 2',p_user_id => 11);
END;
/

select * from app_admin.playlist;
SELECT * from app_admin.songs_playlist;

-------- Update or Insert the record songs_playlist Table
BEGIN
  app_admin.user_pkg.add_song_to_playlist(p_song_id => 3, p_playlist_id => 11, p_user_id => 11);
  app_admin.user_pkg.add_song_to_playlist(p_song_id => 1, p_playlist_id => 12, p_user_id => 11);
  app_admin.user_pkg.add_song_to_playlist(p_song_id => 4, p_playlist_id => 12, p_user_id => 11);
END;
/
COMMIT;
SELECT * from app_admin.songs_playlist;
-------- Delete record from songs_playlist Table
BEGIN
  app_admin.user_pkg.DELETE_SONG_FROM_PLAYLIST(p_song_id => 4, p_playlist_id => 12, p_user_id => 11); -- replace with actual song_id, playlist_id, and user_id values
END;
/
COMMIT;
SELECT * from app_admin.songs_playlist;
SELECT * from app_admin.playlist;

--------Delete records from Playlist and related records from songs_playlist

BEGIN
  app_admin.user_pkg.DELETE_PLAYLIST(p_playlist_id => 11, p_user_id => 11); -- replace with actual song_id, playlist_id, and user_id values
END;
/
SELECT * from app_admin.playlist;


------------ Views of User
select * from app_admin.songs_by_rating;
select * from app_admin.artist_song_count;
select * from app_admin.user_genre_preference;
select * from app_admin.user_favorites;
select * from app_admin.user_recommendations;
select * from app_admin.top_rated_album;
