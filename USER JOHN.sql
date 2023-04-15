
select * from app_admin.users;

select * from app_admin.songs;

select * from app_admin.favourite;
select * from app_admin.playlist;
select * from app_admin.songs_playlist;

SET SERVEROUTPUT ON;
------------- Update User record from package
BEGIN
  app_admin.user_pkg.update_user_from_user(p_user_id => 11, p_first_name => 'John', p_last_name => 'Doe', p_email => 'john.doe@exaddddmple', p_user_name => 'JOHNDOE');
END;
/


---------- Insert record to Favourite
BEGIN
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 1, p_user_id => 11);
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 2, p_user_id => 11);
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 3, p_user_id => 11);
  app_admin.user_pkg.add_favorite_from_user(p_song_id => 4, p_user_id => 11);
END;
/



---------- Delete record from Favourite
BEGIN
  app_admin.user_pkg.delete_favorite_from_user(p_song_id => 2, p_user_id => 11);
END;
/
SET SERVEROUTPUT ON;

--------------- Insert to Playlist
BEGIN
  app_admin.user_pkg.add_playlist(p_playlist_name => 'My Favourites', p_user_id => 11);
  app_admin.user_pkg.add_playlist(p_playlist_name => 'My Favourites 1- 2',p_user_id => 11);
END;
/

-------- Update or Insert the record songs_playlist Table
BEGIN
  app_admin.user_pkg.add_song_to_playlist(p_song_id => 3, p_playlist_id => 11, p_user_id => 11);
  app_admin.user_pkg.add_song_to_playlist(p_song_id => 1, p_playlist_id => 12, p_user_id => 11);
  app_admin.user_pkg.add_song_to_playlist(p_song_id => 4, p_playlist_id => 13, p_user_id => 11);
END;
/
COMMIT;

SET SERVEROUTPUT ON;
-------- Delete record from songs_playlist Table
BEGIN
  app_admin.user_pkg.DELETE_SONG_FROM_PLAYLIST(p_song_id => 4, p_playlist_id => 11, p_user_id => 11); -- replace with actual song_id, playlist_id, and user_id values
END;
/
COMMIT;

--------Delete records from Playlist and related records from songs_playlist

BEGIN
  app_admin.user_pkg.DELETE_PLAYLIST(p_playlist_id => 11, p_user_id => 11); -- replace with actual song_id, playlist_id, and user_id values
END;
/


------------ Views of User
select * from app_admin.songs_by_rating;
select * from app_admin.artist_song_count;
select * from app_admin.user_genre_preference;
select * from app_admin.user_favorites;
select * from app_admin.user_recommendations;
select * from app_admin.top_rated_album;
