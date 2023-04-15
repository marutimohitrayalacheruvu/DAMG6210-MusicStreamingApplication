CREATE OR REPLACE PACKAGE insert_pkg AS
  -- Insert Artist
  PROCEDURE insert_artist (
    p_artist_fname IN VARCHAR2,
    p_artist_lname IN VARCHAR2,
    p_artist_bio IN VARCHAR2,
    p_user_name IN VARCHAR2
  );
  
  -- Insert Album
  PROCEDURE insert_album (
    p_album_name IN VARCHAR2,
    p_album_rating IN NUMBER
  );
  
  -- Insert Genre
  PROCEDURE insert_genre (
    p_genre_name IN VARCHAR2
  );
  
  -- Insert User
  PROCEDURE insert_or_update_user (
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2,
  p_status IN VARCHAR2,
  p_registration_date IN DATE
  );
  
  -- Insert Song
  PROCEDURE insert_song (
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
  
  -- Insert Playlist
  PROCEDURE insert_playlist (
  p_playlist_name IN VARCHAR2,
  p_user_id IN NUMBER
  );
  
  --Insert Album
  PROCEDURE insert_artist_album(
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
  );
  
  --Insert Songs_Playlist
  PROCEDURE insert_songs_playlist(
  p_song_id IN NUMBER,
  p_playlist_id IN NUMBER
  );
  
  -- Insert Favourite
  PROCEDURE insert_favourite(
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
END;
/

CREATE OR REPLACE PACKAGE BODY insert_pkg AS
  -- Insert Artist
  PROCEDURE insert_artist (
    p_artist_fname IN VARCHAR2,
    p_artist_lname IN VARCHAR2,
    p_artist_bio IN VARCHAR2,
    p_user_name IN VARCHAR2
  ) AS
    l_artist_id NUMBER;
  BEGIN
    -- Check if artist already exists
    BEGIN
      SELECT artist_id INTO l_artist_id
      FROM artist
      WHERE artist_fname = p_artist_fname AND artist_lname = p_artist_lname;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_artist_id := NULL;
    END;

    -- If artist exists, return message
    IF l_artist_id IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('Artist already exists.');
      RETURN;
    END IF;

    -- Otherwise, insert artist
    SELECT artist_id_seq.NEXTVAL INTO l_artist_id FROM DUAL;
    INSERT INTO artist (artist_id, artist_fname, artist_lname, artist_bio, user_name)
    VALUES (l_artist_id, p_artist_fname, p_artist_lname, p_artist_bio, p_user_name);

    DBMS_OUTPUT.PUT_LINE('Artist inserted with ID ' || l_artist_id);
  END insert_artist;

  -- Insert Album
  PROCEDURE insert_album (
    p_album_name IN VARCHAR2,
    p_album_rating IN NUMBER
  ) AS
    l_album_id NUMBER;
  BEGIN
    -- Check if album already exists
    BEGIN
      SELECT album_id INTO l_album_id
      FROM album
      WHERE album_name = p_album_name;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        l_album_id := NULL;
    END;

    -- If album exists, update its rating
    IF l_album_id IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('Album already exists.');
      RETURN;
    END IF;

    -- Otherwise, insert album
    SELECT album_id_seq.NEXTVAL INTO l_album_id FROM DUAL;
    INSERT INTO album (album_id, album_name, album_rating)
    VALUES (l_album_id, p_album_name, p_album_rating);

    DBMS_OUTPUT.PUT_LINE('Album inserted with ID ' || l_album_id);
  END insert_album;
  
  -- Insert Genre
  PROCEDURE insert_genre (
    p_genre_name IN VARCHAR2
  ) AS
    l_genre_id NUMBER;
  BEGIN
    -- Check if genre already exists
    BEGIN
      SELECT genre_id INTO l_genre_id
      FROM genre
      WHERE genre_name = p_genre_name;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      l_genre_id := NULL;
    END;

    -- If genre exists, print message and return
    IF l_genre_id IS NOT NULL THEN
      DBMS_OUTPUT.PUT_LINE('Genre already exists with ID ' || l_genre_id);
      RETURN;
    END IF;

    -- Otherwise, insert genre
    SELECT genre_id_seq.NEXTVAL INTO l_genre_id FROM DUAL;
    INSERT INTO genre (genre_id, genre_name)
    VALUES (l_genre_id, p_genre_name);

    DBMS_OUTPUT.PUT_LINE('Genre inserted with ID ' || l_genre_id);
  END insert_genre;
  
  -- Insert User
  PROCEDURE insert_or_update_user (
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2,
  p_status IN VARCHAR2,
  p_registration_date IN DATE
) AS
  l_user_id NUMBER;
BEGIN
  -- Check if user already exists
  SELECT user_id INTO l_user_id FROM users WHERE user_name = p_user_name;
  
  -- If user exists, update user information
  DBMS_OUTPUT.PUT_LINE('User already exists');
  RETURN;
EXCEPTION
  -- If user doesn't exist, insert new user
  WHEN NO_DATA_FOUND THEN
    SELECT user_id_seq.NEXTVAL INTO l_user_id FROM DUAL;
    
    INSERT INTO users (user_id, first_name, last_name, email, user_name, status, registration_date)
    VALUES (l_user_id, p_first_name, p_last_name, p_email, p_user_name, p_status, p_registration_date);
    
    DBMS_OUTPUT.PUT_LINE('New user with username ' || p_user_name || ' inserted');
    RETURN;
    END insert_or_update_user;
    
    -- Insert Song
  PROCEDURE insert_song (
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
  l_song_id NUMBER;
  l_genre_id NUMBER;
  l_album_id NUMBER;
  l_artist_id NUMBER;
BEGIN
  -- Check if the record already exists
  BEGIN
    SELECT song_id INTO l_song_id
    FROM songs
    WHERE song_name = p_song_name AND song_artistName = p_song_artistName;

    -- If the record exists, return a message and exit
    DBMS_OUTPUT.PUT_LINE('Record already exists with ID ' || l_song_id);
    RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;

  -- Check if foreign keys exist in their respective tables
  BEGIN
    SELECT genre_id INTO l_genre_id FROM genre WHERE genre_id = p_sgenre_id;
    SELECT album_id INTO l_album_id FROM album WHERE album_id = p_salbum_id;
    SELECT artist_id INTO l_artist_id FROM artist WHERE artist_id = p_sartist_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Foreign key constraint violation. Check if genre, album, and artist exist in their respective tables.');
      RETURN;
  END;

  -- Generate new song_id
  SELECT song_id_seq.NEXTVAL INTO l_song_id FROM DUAL;

  -- Insert song
  INSERT INTO songs (song_id, song_name, song_artistName, song_rating, song_length, song_language, song_releaseDate, song_trackNo, sgenre_id, salbum_id, sartist_id)
  VALUES (l_song_id, p_song_name, p_song_artistName, p_song_rating, p_song_length, p_song_language, p_song_releaseDate, p_song_trackNo, p_sgenre_id, p_salbum_id, p_sartist_id);

  COMMIT;
END insert_song;

-- Insert Playlist
  PROCEDURE insert_playlist (
  p_playlist_name IN VARCHAR2,
  p_user_id IN NUMBER
) AS
  l_playlist_id NUMBER;
  l_user_id NUMBER;
BEGIN

  BEGIN
  -- Check if the record already exists
  SELECT playlist_id INTO l_playlist_id
  FROM playlist
  WHERE playlist_name = p_playlist_name AND user_id = p_user_id;

  -- If the record exists, return a message and exit
  DBMS_OUTPUT.PUT_LINE('Record already exists with ID ' || l_playlist_id);
    RETURN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
  END;
  -- Check if foreign key exists in the user table
  BEGIN
    SELECT user_id INTO l_user_id FROM users WHERE user_id = p_user_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Foreign key constraint violation. Check if the user exists in the users table.');
      RETURN;
  END;

  -- Generate new playlist_id
  SELECT playlist_id_seq.NEXTVAL INTO l_playlist_id FROM DUAL;

  -- Insert playlist
  INSERT INTO playlist (playlist_id, playlist_name, user_id)
  VALUES (l_playlist_id, p_playlist_name, p_user_id);

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Record inserted with ID ' || l_playlist_id);
END insert_playlist;

--Insert Album
  PROCEDURE insert_artist_album(
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
) AS
  l_artist_id NUMBER;
  l_album_id NUMBER;
  l_count NUMBER;
BEGIN
  -- Check if the artist_id and album_id already exist
  BEGIN
    SELECT artist_id INTO l_artist_id FROM artist WHERE artist_id = p_artist_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Artist with ID ' || p_artist_id || ' does not exist.');
      RETURN;
  END;

  BEGIN
    SELECT album_id INTO l_album_id FROM album WHERE album_id = p_album_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Album with ID ' || p_album_id || ' does not exist.');
      RETURN;
  END;

  -- Check if the record already exists in the artist_album table
  SELECT COUNT(*) INTO l_count FROM artist_album WHERE artist_id = p_artist_id AND album_id = p_album_id;

  -- If the record already exists, return a message and exit
  IF l_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Record already exists in the artist_album table.');
    RETURN;
  END IF;

  -- Insert artist_album record
  INSERT INTO artist_album (artist_id, album_id) VALUES (p_artist_id, p_album_id);

  COMMIT;
END insert_artist_album;

--Insert Songs_Playlist
  PROCEDURE insert_songs_playlist(
  p_song_id IN NUMBER,
  p_playlist_id IN NUMBER
) AS
  l_song_id NUMBER;
  l_playlist_id NUMBER;
  l_count NUMBER := 0;
BEGIN
  -- Check if the song_id and playlist_id already exist
  SELECT song_id INTO l_song_id FROM songs WHERE song_id = p_song_id;
  SELECT playlist_id INTO l_playlist_id FROM playlist WHERE playlist_id = p_playlist_id;

  -- If the song_id or playlist_id does not exist, return a message and exit
  IF l_song_id IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Song with ID ' || p_song_id || ' does not exist.');
    RETURN;
  END IF;

  IF l_playlist_id IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Playlist with ID ' || p_playlist_id || ' does not exist.');
    RETURN;
  END IF;

  -- Check if the record already exists in the songs_playlist table
  SELECT COUNT(*) INTO l_count FROM songs_playlist WHERE song_id = p_song_id AND playlist_id = p_playlist_id;

  -- If the record already exists, return a message and exit
  IF l_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Record already exists in the songs_playlist table.');
    RETURN;
  END IF;

  -- Insert songs_playlist record
  INSERT INTO songs_playlist (song_id, playlist_id) VALUES (p_song_id, p_playlist_id);

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: One or more IDs do not exist.');
    RETURN;
END insert_songs_playlist;

-- Insert Favourite
  PROCEDURE insert_favourite(
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
) AS
  l_song_id NUMBER;
  l_user_id NUMBER;
  l_count NUMBER := 0;
BEGIN
  -- Check if the song_id and user_id already exist
  SELECT song_id INTO l_song_id FROM songs WHERE song_id = p_song_id;
  SELECT user_id INTO l_user_id FROM users WHERE user_id = p_user_id;

  -- If the song_id or user_id does not exist, return a message and exit
  IF l_song_id IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Song with ID ' || p_song_id || ' does not exist.');
    RETURN;
  END IF;

  IF l_user_id IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('User with ID ' || p_user_id || ' does not exist.');
    RETURN;
  END IF;

  -- Check if the record already exists in the favourite table
  SELECT COUNT(*) INTO l_count FROM favourite WHERE song_id = p_song_id AND user_id = p_user_id;

  -- If the record already exists, return a message and exit
  IF l_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Record already exists in the favourite table.');
    RETURN;
  END IF;

  -- Insert favourite record
  INSERT INTO favourite (song_id, user_id) VALUES (p_song_id, p_user_id);

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: One or more IDs do not exist.');
    RETURN;
END insert_favourite;
END;
/


