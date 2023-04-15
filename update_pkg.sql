CREATE OR REPLACE PACKAGE update_pkg AS
  -- Update Artist
  PROCEDURE update_artist(
  p_artist_id IN NUMBER,
  p_artist_fname IN VARCHAR2,
  p_artist_lname IN VARCHAR2,
  p_artist_bio IN VARCHAR2,
  p_user_name IN VARCHAR2
  );
  
  -- Update Album
  PROCEDURE update_album(
  p_album_id IN NUMBER,
  p_album_name IN VARCHAR2,
  p_album_rating IN NUMBER
  );
  
  -- Update Genre
  PROCEDURE update_genre(
  p_genre_id IN NUMBER,
  p_genre_name IN VARCHAR2
  );
  
  -- Update User
  PROCEDURE update_user(
  p_user_id IN NUMBER,
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2,
  p_status IN VARCHAR2,
  p_registration_date IN DATE
  );
  
  -- Update Song
  PROCEDURE update_song(
  p_song_id IN NUMBER,
  p_song_name IN VARCHAR2,
  p_song_artistName IN VARCHAR2,
  p_song_rating IN BINARY_FLOAT,
  p_song_length IN TIMESTAMP,
  p_song_language IN VARCHAR2,
  p_song_releaseDate IN DATE,
  p_song_trackNo IN NUMBER,
  p_sgenre_id IN NUMBER,
  p_salbum_id IN NUMBER,
  p_sartist_id IN NUMBER
  );
  
  -- Update Playlist
  PROCEDURE update_playlist (
  p_playlist_id IN NUMBER,
  p_playlist_name IN VARCHAR2,
  p_user_id IN NUMBER
  );
  
  --Update Album
  PROCEDURE update_artist_album(
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
  );
  
  --Update Songs_Playlist
  PROCEDURE update_songs_playlist(
  p_song_id IN NUMBER,
  p_playlist_id IN NUMBER
  );
  
  -- Update Favourite
  PROCEDURE update_favourite(
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
END;
/

CREATE OR REPLACE PACKAGE BODY update_pkg AS
  -- Update Artist
  PROCEDURE update_artist(
  p_artist_id IN NUMBER,
  p_artist_fname IN VARCHAR2,
  p_artist_lname IN VARCHAR2,
  p_artist_bio IN VARCHAR2,
  p_user_name IN VARCHAR2
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the artist exists
  SELECT COUNT(*) INTO l_count FROM artist WHERE artist_id = p_artist_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Artist with ID ' || p_artist_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update artist record
  UPDATE artist SET artist_fname = p_artist_fname, artist_lname = p_artist_lname, artist_bio = p_artist_bio, user_name = p_user_name WHERE artist_id = p_artist_id;

  COMMIT;
END update_artist;

  PROCEDURE update_album(
  p_album_id IN NUMBER,
  p_album_name IN VARCHAR2,
  p_album_rating IN NUMBER
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the record exists
  SELECT COUNT(*) INTO l_count FROM album WHERE album_id = p_album_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Album with ID ' || p_album_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update album record
  UPDATE album SET album_name = p_album_name, album_rating = p_album_rating WHERE album_id = p_album_id;
  DBMS_OUTPUT.PUT_LINE('Updated album with ID ' || p_album_id || '.');
  COMMIT;
END update_album;

PROCEDURE update_genre(
  p_genre_id IN NUMBER,
  p_genre_name IN VARCHAR2
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the record exists
  SELECT COUNT(*) INTO l_count FROM genre WHERE genre_id = p_genre_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Genre with ID ' || p_genre_id || ' does not exist. Nothing updated.');
    RETURN;
  END IF;

  -- Update genre record
  UPDATE genre SET genre_name = p_genre_name WHERE genre_id = p_genre_id;
  DBMS_OUTPUT.PUT_LINE('Updated genre with ID ' || p_genre_id || '.');
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Genre with ID ' || p_genre_id || ' updated.');
END update_genre;

  PROCEDURE update_user(
  p_user_id IN NUMBER,
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2,
  p_status IN VARCHAR2,
  p_registration_date IN DATE
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the record exists
  SELECT COUNT(*) INTO l_count FROM users WHERE user_id = p_user_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: User with ID ' || p_user_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update user record
  UPDATE users SET
    first_name = p_first_name,
    last_name = p_last_name,
    email = p_email,
    user_name = p_user_name,
    status = p_status,
    registration_date = p_registration_date
  WHERE user_id = p_user_id;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('User with ID ' || p_user_id || ' has been updated.');
END update_user;

  PROCEDURE update_song(
  p_song_id IN NUMBER,
  p_song_name IN VARCHAR2,
  p_song_artistName IN VARCHAR2,
  p_song_rating IN BINARY_FLOAT,
  p_song_length IN TIMESTAMP,
  p_song_language IN VARCHAR2,
  p_song_releaseDate IN DATE,
  p_song_trackNo IN NUMBER,
  p_sgenre_id IN NUMBER,
  p_salbum_id IN NUMBER,
  p_sartist_id IN NUMBER
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the given song_id exists
  SELECT COUNT(*) INTO l_count FROM songs WHERE song_id = p_song_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Song with ID ' || p_song_id || ' does not exist.');
    RETURN;
  END IF;
  -- Check if the foreign keys exist
  SELECT COUNT(*) INTO l_count FROM genre WHERE genre_id = p_sgenre_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Genre with ID ' || p_sgenre_id || ' does not exist.');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO l_count FROM album WHERE album_id = p_salbum_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Album with ID ' || p_salbum_id || ' does not exist.');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO l_count FROM artist WHERE artist_id = p_sartist_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Artist with ID ' || p_sartist_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update song record
  UPDATE songs SET 
  song_name = p_song_name,
  song_artistName = p_song_artistName,
  song_rating = p_song_rating,
  song_length = p_song_length,
  song_language = p_song_language,
  song_releaseDate = p_song_releaseDate,
  song_trackNo = p_song_trackNo,
  sgenre_id = p_sgenre_id,
  salbum_id = p_salbum_id,
  sartist_id = p_sartist_id
  WHERE song_id = p_song_id;

  COMMIT;
END update_song; 

  PROCEDURE update_playlist (
  p_playlist_id IN NUMBER,
  p_playlist_name IN VARCHAR2,
  p_user_id IN NUMBER
) AS
    l_count NUMBER := 0;
BEGIN
    -- Check if the user_id exists in the users table
    SELECT COUNT(*) INTO l_count FROM users WHERE user_id = p_user_id;
    IF l_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: User with ID ' || p_user_id || ' does not exist.');
        RETURN;
    END IF;

    -- Check if the playlist_id exists in the playlist table
    SELECT COUNT(*) INTO l_count FROM playlist WHERE playlist_id = p_playlist_id;
    IF l_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Error: Playlist with ID ' || p_playlist_id || ' does not exist.');
        RETURN;
    END IF;

    -- Update playlist record
    UPDATE playlist SET
        playlist_name = p_playlist_name,
        user_id = p_user_id
    WHERE playlist_id = p_playlist_id;
    DBMS_OUTPUT.PUT_LINE('Updated Playlist with ID ' || p_playlist_id || '.');

    COMMIT;
END update_playlist;

  PROCEDURE update_artist_album(
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the foreign keys exist
  SELECT COUNT(*) INTO l_count FROM artist WHERE artist_id = p_artist_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Artist with ID ' || p_artist_id || ' does not exist.');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO l_count FROM album WHERE album_id = p_album_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Album with ID ' || p_album_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update artist_album record
  UPDATE artist_album SET 
    album_id = p_album_id
  WHERE artist_id = p_artist_id;
  DBMS_OUTPUT.PUT_LINE('Updated artist_album.');
  COMMIT;
END update_artist_album;

PROCEDURE update_songs_playlist(
  p_song_id IN NUMBER,
  p_playlist_id IN NUMBER
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the foreign keys exist
  SELECT COUNT(*) INTO l_count FROM songs WHERE song_id = p_song_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Song with ID ' || p_song_id || ' does not exist.');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO l_count FROM playlist WHERE playlist_id = p_playlist_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Playlist with ID ' || p_playlist_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update songs_playlist record
  UPDATE songs_playlist SET 
    playlist_id = p_playlist_id
  WHERE song_id = p_song_id;
  DBMS_OUTPUT.PUT_LINE('Updated songs_playlist.');
  COMMIT;
END update_songs_playlist;

  PROCEDURE update_favourite(
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
) AS
  l_count NUMBER := 0;
BEGIN
  -- Check if the foreign keys exist
  SELECT COUNT(*) INTO l_count FROM songs WHERE song_id = p_song_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Song with ID ' || p_song_id || ' does not exist.');
    RETURN;
  END IF;

  SELECT COUNT(*) INTO l_count FROM users WHERE user_id = p_user_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: User with ID ' || p_user_id || ' does not exist.');
    RETURN;
  END IF;

  -- Update favourite record
  UPDATE favourite SET 
    user_id = p_user_id
  WHERE song_id = p_song_id;
  DBMS_OUTPUT.PUT_LINE('Updated favourite table.');
  COMMIT;
END update_favourite;

END;
/

select * from artist;

BEGIN
  update_pkg.update_artist('Album 1', 4, 'John', 'Doe', 'Bio', 'johndoe');
END;
/

