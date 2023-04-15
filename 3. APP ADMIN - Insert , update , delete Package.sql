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

CREATE OR REPLACE PACKAGE delete_pkg AS
  -- Update Artist
  PROCEDURE drop_fk_constraint (
  p_constraint_name IN VARCHAR2,
  p_table_name IN VARCHAR2
  );
  
  PROCEDURE add_fk_constraint (
  p_constraint_name IN VARCHAR2,
  p_table_name IN VARCHAR2,
  p_column_name IN VARCHAR2,
  p_ref_table_name IN VARCHAR2,
  p_ref_column_name IN VARCHAR2
  );
  
  PROCEDURE delete_song (
  p_song_id IN NUMBER
  );
  
  PROCEDURE delete_from_favorites(
  p_song_id IN NUMBER
  );
  
  PROCEDURE delete_from_songs_playlist(
  p_song_id IN NUMBER
  );
  
  PROCEDURE delete_artist_album (
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
  );
  
  PROCEDURE delete_album (
  p_album_id IN NUMBER
  );
  
  PROCEDURE delete_artist (
    p_artist_id IN NUMBER
  );
  
END;
/

CREATE OR REPLACE PACKAGE BODY delete_pkg AS
PROCEDURE drop_fk_constraint (
  p_constraint_name IN VARCHAR2,
  p_table_name IN VARCHAR2
) AS
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' DROP CONSTRAINT ' || p_constraint_name;
END drop_fk_constraint;

PROCEDURE add_fk_constraint (
  p_constraint_name IN VARCHAR2,
  p_table_name IN VARCHAR2,
  p_column_name IN VARCHAR2,
  p_ref_table_name IN VARCHAR2,
  p_ref_column_name IN VARCHAR2
) AS
BEGIN
  EXECUTE IMMEDIATE 'ALTER TABLE ' || p_table_name || ' ADD CONSTRAINT ' || p_constraint_name || ' FOREIGN KEY (' || p_column_name || ') REFERENCES ' || p_ref_table_name || '(' || p_ref_column_name || ')';
      DBMS_OUTPUT.PUT_LINE('constraint record added successfully.');

END add_fk_constraint;

PROCEDURE delete_song (
  p_song_id IN NUMBER
) AS
  l_song_count NUMBER;
BEGIN
  -- Check if song exists
  SELECT COUNT(*) INTO l_song_count FROM songs WHERE song_id = p_song_id;

  IF l_song_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Song ID ' || p_song_id || ' does not exist.');
    RETURN;
  END IF;
 --Delete from playlist
  DELETE FROM songs_playlist WHERE song_id = p_song_id;

-- delete from favourite
  DELETE FROM favourite WHERE song_id = p_song_id;

    
  -- Delete song
  DELETE FROM songs WHERE song_id = p_song_id;

  DBMS_OUTPUT.PUT_LINE('Song with ID ' || p_song_id || ' deleted.');
  COMMIT;
END delete_song;

PROCEDURE delete_from_favorites(
  p_song_id IN NUMBER
) AS
BEGIN
  DELETE FROM favourite
  WHERE song_id = p_song_id;
  
  DBMS_OUTPUT.PUT_LINE('Song with ID ' || p_song_id || ' deleted from favorites successfully.');
  COMMIT;
END delete_from_favorites;

PROCEDURE delete_from_songs_playlist(
  p_song_id IN NUMBER
) AS
BEGIN
  DELETE FROM songs_playlist
  WHERE song_id = p_song_id;
  
  DBMS_OUTPUT.PUT_LINE('Song with ID ' || p_song_id || ' deleted from playlist successfully.');
  COMMIT;
END delete_from_songs_playlist;

PROCEDURE delete_artist_album (
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
) AS
  l_count NUMBER;
BEGIN
  -- Check if the artist_id exists in the artist table
  SELECT COUNT(*) INTO l_count FROM artist WHERE artist_id = p_artist_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Artist ID ' || p_artist_id || ' does not exist in the artist table.');
    RETURN;
  END IF;

  -- Check if the album_id exists in the album table
  SELECT COUNT(*) INTO l_count FROM album WHERE album_id = p_album_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Album ID ' || p_album_id || ' does not exist in the album table.');
    RETURN;
  END IF;

  -- Delete the record from the artist_album table
  DELETE FROM artist_album WHERE artist_id = p_artist_id AND album_id = p_album_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Artist-Album record deleted successfully.');
END delete_artist_album;

PROCEDURE delete_album (
  p_album_id IN NUMBER
) AS
  l_album_count NUMBER;

BEGIN
  -- Check if album exists
  SELECT COUNT(*) INTO l_album_count
  FROM album
  WHERE album_id = p_album_id;

  IF l_album_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Album with ID ' || p_album_id || ' does not exist.');
    RETURN;
  END IF;
  

  FOR song IN (SELECT song_id FROM songs WHERE salbum_id = p_album_id) LOOP
    delete_song(song.song_id);
  END LOOP;
  drop_fk_constraint('fk_art_album_id', 'artist_album');

  -- Delete album
  
  FOR aa IN (SELECT artist_album.album_id,artist.artist_id FROM artist_album JOIN artist on artist_album.artist_id=artist.artist_id WHERE album_id = p_album_id) LOOP
    delete_artist_album(aa.artist_id, aa.album_id);
  END LOOP;
  add_fk_constraint('fk_art_album_id', 'artist_album', 'album_id', 'album', 'album_id');
  DELETE FROM album
  WHERE album_id = p_album_id;

  DBMS_OUTPUT.PUT_LINE('Album with ID ' || p_album_id || ' deleted successfully.');
  COMMIT;
END delete_album;

PROCEDURE delete_artist (
    p_artist_id IN NUMBER
) AS 
    artist_id NUMBER;
    sartist_id NUMBER;
BEGIN
 -- Delete songs associated with artist
  FOR song IN (SELECT song_id FROM songs WHERE sartist_id = p_artist_id) LOOP
    DBMS_OUTPUT.PUT_LINE(song.song_id);

    delete_song(song.song_id);
  END LOOP;

  -- Delete albums AND ARTIST ALBUM associated with artist
  FOR album IN (SELECT a.album_id FROM album a JOIN artist_album aa on a.album_id = aa.album_id where aa.artist_id=p_artist_id) LOOP
    DBMS_OUTPUT.PUT_LINE(album.album_id);

    delete_album(album.album_id);
  END LOOP;

  -- Delete artist
  DELETE FROM artist WHERE artist_id = p_artist_id;

  DBMS_OUTPUT.PUT_LINE('Artist with ID ' || p_artist_id || ' deleted successfully.');
  COMMIT;
END delete_artist;

END;
/
----------------------------------Artist package ------------------

CREATE OR REPLACE PACKAGE artist_pkg AS
 

  PROCEDURE update_artist_byartist(
  p_artist_id IN NUMBER,
  p_artist_fname IN VARCHAR2,
  p_artist_lname IN VARCHAR2,
  p_artist_bio IN VARCHAR2,
  p_user_name IN VARCHAR2
  );
  ---Inserting artist and album association
  PROCEDURE insert_artist_album(
  p_artist_id IN NUMBER,
  p_album_id IN NUMBER
  );
  --Insert song
  
  -- Insert Album
  PROCEDURE insert_album_artist_m (
  m_artist_id IN NUMBER,
  p_album_name IN VARCHAR2,
  p_album_rating IN NUMBER
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
  
  

END;
/

CREATE OR REPLACE PACKAGE BODY artist_pkg AS
  
PROCEDURE update_artist_byartist(
  p_artist_id IN NUMBER,
  p_artist_fname IN VARCHAR2,
  p_artist_lname IN VARCHAR2,
  p_artist_bio IN VARCHAR2,
  p_user_name IN VARCHAR2
) AS
  l_count NUMBER := 0;
  auth_user_name VARCHAR2(100);
BEGIN
  -- Check if the artist exists
  SELECT COUNT(*) INTO l_count FROM artist WHERE artist_id = p_artist_id;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Artist with ID ' || p_artist_id || ' does not exist.');
    RETURN;
  END IF;

  -- Check if the artist is trying to update their own information
  SELECT COUNT(*) INTO l_count FROM artist WHERE artist_id = p_artist_id AND user_name = p_user_name;
  IF l_count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('Error: Artist ' || p_user_name || ' is not authorized to update this record.');
    RETURN;
  END IF;

  -- Update artist record
  UPDATE artist SET artist_fname = p_artist_fname, artist_lname = p_artist_lname, artist_bio = p_artist_bio WHERE artist_id = p_artist_id;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Artist with ID ' || p_artist_id || ' has been updated.');
END update_artist_byartist;
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
--- Insert Album
PROCEDURE insert_album_artist_m (
  m_artist_id IN NUMBER,
  p_album_name IN VARCHAR2,
  p_album_rating IN NUMBER
) AS
  l_album_id NUMBER;
  l_artist_id NUMBER;
  l_a_name VARCHAR2(100);
  
  
BEGIN
--Check if artist exists
    BEGIN
    SELECT artist_id INTO l_artist_id
    FROM artist
    WHERE artist_id = m_artist_id;
   
    IF l_artist_id IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Artist does not exist');
    RETURN;
    END IF;
  --Check if the same user is trying to insert
    SELECT user_name into l_a_name from artist where artist_id=m_artist_id;
  
    IF user = l_a_name THEN
    -- Check if album already exists
        BEGIN
            SELECT album_id INTO l_album_id
            FROM album
            WHERE album_name = p_album_name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            l_album_id := NULL;
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
        --m
        -- Adding into the artist_album table
        BEGIN
            artist_pkg.insert_artist_album(l_artist_id, l_album_id);
        END;
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error: User ' || m_artist_id || ' is not authorized to update this record.');
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      l_artist_id := NULL;
    END;
END insert_album_artist_m;
    
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
END;
/

---------------------Triggers--------------

CREATE OR REPLACE TRIGGER check_album_rating
BEFORE INSERT OR UPDATE ON album
FOR EACH ROW
BEGIN
  IF :NEW.album_rating < 0 OR :NEW.album_rating > 10 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Album rating must be between 0 and 10');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER check_song_rating
  BEFORE INSERT OR UPDATE ON songs
  FOR EACH ROW
BEGIN
  IF :NEW.song_rating < 0 OR :NEW.song_rating > 10 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Song rating must be between 0 and 10');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER check_artist_name
BEFORE INSERT OR UPDATE ON artist
FOR EACH ROW
BEGIN
  IF :NEW.artist_fname IS NULL OR :NEW.artist_fname = '' OR :NEW.artist_lname is NULL OR :NEW.artist_lname = '' THEN
    RAISE_APPLICATION_ERROR(-20001, 'Artist name cannot be empty');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER check_user_email
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
BEGIN
  IF :NEW.email IS NULL OR :NEW.email = '' THEN
    RAISE_APPLICATION_ERROR(-20001, 'Users email cannot be empty');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER update_song_artist_name
AFTER UPDATE ON artist
FOR EACH ROW
BEGIN
  IF UPDATING('artist_fname') OR UPDATING('artist_lname') THEN
    UPDATE songs
    SET song_artistName = :NEW.artist_fname || ' ' || :NEW.artist_lname
    WHERE sartist_id = :OLD.artist_id;
  END IF;
END;
/




---------------------------------User package 


CREATE OR REPLACE PACKAGE user_pkg AS
     -- Insert to favourite
  PROCEDURE add_favorite_from_user (
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
  -- Update User details
  PROCEDURE update_user_from_user (
  p_user_id IN NUMBER,
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2
  );
  
  -- Delete from Favourite
  PROCEDURE delete_favorite_from_user (
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
  -- Insert to Playlist Table
  PROCEDURE add_playlist (
  p_playlist_name IN VARCHAR2,
  p_user_id IN NUMBER
  );
  
  -- Update or Insert into songs_playlist Table
  PROCEDURE add_song_to_playlist (
  p_song_id IN NUMBER,
  p_playlist_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
  -- Delete record from songs_playlist Table
  PROCEDURE delete_song_from_playlist (
  p_song_id IN NUMBER,
  p_playlist_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
  -- Delete records form Playlist table as well as related records from songs_playlist
  PROCEDURE delete_playlist (
  p_playlist_id IN NUMBER,
  p_user_id IN NUMBER
  );
  
  
END;
/

CREATE OR REPLACE PACKAGE BODY user_pkg AS
  PROCEDURE add_favorite_from_user (
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
)
IS
  l_song_count NUMBER;
  l_favorite_count NUMBER;
BEGIN
  -- check if the song exists in the songs table
  SELECT COUNT(*) INTO l_song_count 
  FROM songs  
  WHERE song_id = p_song_id;

  IF l_song_count > 0 THEN
    -- check if the user_id matches the currently logged in user
    SELECT COUNT(*) INTO l_song_count 
    FROM users 
    WHERE user_id = p_user_id 
      AND user_name = user;

    IF l_song_count > 0 THEN
      -- check if the user has already favorited the song
      SELECT COUNT(*) INTO l_favorite_count 
      FROM favourite 
      WHERE song_id = p_song_id 
        AND user_id = p_user_id;

      IF l_favorite_count = 0 THEN
        -- insert the favorite
        INSERT INTO favourite (song_id, user_id)
        VALUES (p_song_id, p_user_id);

        DBMS_OUTPUT.PUT_LINE('Favorite added successfully.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' has already favorited this song.');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' is not authorized to add this favorite.');
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Error: Song with ID ' || p_song_id || ' not found.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: User or song not found.');
END add_favorite_from_user;

-- Update User details
PROCEDURE update_user_from_user (
  p_user_id IN NUMBER,
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2
)
IS
  auth_user_name VARCHAR2(100);
BEGIN
  -- check if the user is trying to update their own information
  SELECT user_name into auth_user_name FROM USERS where user_id=p_user_id;
  
  IF user = auth_user_name THEN
    -- update the user row
     DBMS_OUTPUT.PUT_LINE(user);
    DBMS_OUTPUT.PUT_LINE(p_user_name);
    UPDATE users SET
      first_name = p_first_name,
      last_name = p_last_name,
      email = p_email
    WHERE user_id = p_user_id;

    DBMS_OUTPUT.PUT_LINE('User ' || p_user_name || ' updated successfully.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Error: User ' || p_user_name || ' is not authorized to update this record.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: User ' || p_user_name || ' not found.');
END update_user_from_user;

-- Delete from Favourite
PROCEDURE delete_favorite_from_user (
  p_song_id IN NUMBER,
  p_user_id IN NUMBER
)
IS
  l_song_count NUMBER;
  l_favorite_count NUMBER;
BEGIN
  -- check if the song exists in the songs table
  SELECT COUNT(*) INTO l_song_count 
  FROM songs  
  WHERE song_id = p_song_id;

  IF l_song_count > 0 THEN
    -- check if the user_id matches the currently logged in user
    SELECT COUNT(*) INTO l_song_count 
    FROM users 
    WHERE user_id = p_user_id 
      AND user_name = user;

    IF l_song_count > 0 THEN
      -- check if the user has already favorited the song
      SELECT COUNT(*) INTO l_favorite_count 
      FROM favourite 
      WHERE song_id = p_song_id 
        AND user_id = p_user_id;

      IF l_favorite_count > 0 THEN
        -- delete the favorite
        DELETE FROM favourite 
        WHERE song_id = p_song_id 
          AND user_id = p_user_id;

        DBMS_OUTPUT.PUT_LINE('Favorite deleted successfully.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' has not favorited this song.');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' is not authorized to delete this favorite.');
    END IF;
  ELSE
    DBMS_OUTPUT.PUT_LINE('Error: Song with ID ' || p_song_id || ' not found.');
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error: User or song not found.');
END delete_favorite_from_user;

-- Insert to Playlist Table
PROCEDURE add_playlist (
    p_playlist_name IN VARCHAR2,
    p_user_id IN NUMBER
)
IS
    l_user_count NUMBER;
    l_playlist_count NUMBER;
BEGIN
    -- Check if the user_id matches the currently logged in user
    SELECT COUNT(*) INTO l_user_count
    FROM users
    WHERE user_id = p_user_id
      AND user_name = user;

    IF l_user_count = 0 THEN
        -- User is not authorized to add playlist
        DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' is not authorized to add playlist.');
    ELSE
        -- Check if playlist name already exists for this user
        SELECT COUNT(*) INTO l_playlist_count
        FROM playlist
        WHERE user_id = p_user_id
          AND playlist_name = p_playlist_name;

        IF l_playlist_count > 0 THEN
            -- Playlist name already exists for this user
            DBMS_OUTPUT.PUT_LINE('Error: Playlist ' || p_playlist_name || ' already exists for user ' || user || '.');
        ELSE
            -- User is authorized and playlist name does not already exist, insert new playlist
            INSERT INTO playlist (playlist_id, playlist_name, user_id)
            VALUES (playlist_id_seq.NEXTVAL, p_playlist_name, p_user_id);

            DBMS_OUTPUT.PUT_LINE('Playlist added successfully.');
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User not found.');
END add_playlist;

-- Update or Insert into songs_playlist Table
PROCEDURE add_song_to_playlist (
    p_song_id IN NUMBER,
    p_playlist_id IN NUMBER,
    p_user_id IN NUMBER
)
IS
    l_user_count NUMBER;
    l_playlist_count NUMBER;
    l_song_count NUMBER;
    l_record_count NUMBER;
BEGIN
    -- Check if the user_id matches the currently logged in user
    SELECT COUNT(*) INTO l_user_count
    FROM users
    WHERE user_id = p_user_id
      AND user_name = user;

    IF l_user_count = 0 THEN
        -- User is not authorized to add song to playlist
        DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' is not authorized to add song to playlist.');
    ELSE
        -- Check if playlist_id belongs to the user
        SELECT COUNT(*) INTO l_playlist_count
        FROM playlist
        WHERE playlist_id = p_playlist_id
          AND user_id = p_user_id;

        IF l_playlist_count = 0 THEN
            -- Playlist does not belong to the user
            DBMS_OUTPUT.PUT_LINE('Error: Playlist does not belong to user ' || user || '.');
        ELSE
            -- Check if the song_id and playlist_id combination already exists in the songs_playlist table
            SELECT COUNT(*) INTO l_record_count
            FROM songs_playlist
            WHERE song_id = p_song_id
              AND playlist_id = p_playlist_id;

            IF l_record_count > 0 THEN
                -- Song and playlist already exist in the songs_playlist table
                UPDATE songs_playlist
                SET song_id = p_song_id, playlist_id = p_playlist_id
                WHERE song_id = p_song_id
                  AND playlist_id = p_playlist_id;

                DBMS_OUTPUT.PUT_LINE('Record updated successfully.');
            ELSE
                -- Check if the song_id exists in the songs table
                SELECT COUNT(*) INTO l_song_count
                FROM songs
                WHERE song_id = p_song_id;

                IF l_song_count = 0 THEN
                    -- Song does not exist in the songs table
                    DBMS_OUTPUT.PUT_LINE('Error: Song with ID ' || p_song_id || ' not found.');
                ELSE
                    -- User is authorized and song_id and playlist_id combination does not already exist, insert new record into songs_playlist table
                    INSERT INTO songs_playlist (song_id, playlist_id)
                    VALUES (p_song_id, p_playlist_id);

                    DBMS_OUTPUT.PUT_LINE('Record added successfully.');
                END IF;
            END IF;
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User, playlist or song not found.');
END add_song_to_playlist;

-- Delete record from songs_playlist Table
PROCEDURE delete_song_from_playlist (
    p_song_id IN NUMBER,
    p_playlist_id IN NUMBER,
    p_user_id IN NUMBER
)
IS
    l_user_count NUMBER;
    l_playlist_count NUMBER;
    count_exist_song_id NUMBER;
BEGIN
    -- Check if the user_id matches the currently logged in user
    SELECT COUNT(*) INTO l_user_count
    FROM users
    WHERE user_id = p_user_id
      AND user_name = user;

    IF l_user_count = 0 THEN
        -- User is not authorized to delete song from playlist
        DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' is not authorized to delete song from playlist.');
    ELSE
        -- Check if playlist_id belongs to the user
        SELECT COUNT(*) INTO l_playlist_count
        FROM playlist
        WHERE playlist_id = p_playlist_id
          AND user_id = p_user_id;

        IF l_playlist_count = 0 THEN
            -- Playlist does not belong to the user
            DBMS_OUTPUT.PUT_LINE('Error: Playlist does not belong to user ' || user || '.');
        ELSE
            --Check if song exists
            SELECT COUNT(*) INTO count_exist_song_id FROM songs_playlist sp JOIN playlist p on p.playlist_id=sp.playlist_id WHERE sp.song_id=p_song_id AND sp.playlist_id=p_playlist_id AND p.user_id=p_user_id;
            IF count_exist_song_id = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Song does not exist in this playlist for this user');
            ELSE
                -- Check if the song_id and playlist_id combination exists in the songs_playlist table
                DELETE FROM songs_playlist
                WHERE song_id = p_song_id
                AND playlist_id = p_playlist_id;

                DBMS_OUTPUT.PUT_LINE('Record deleted successfully.');
            END IF;
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User, playlist or song not found.');
END delete_song_from_playlist;

-- Delete records form Playlist table as well as related records from songs_playlist
PROCEDURE delete_playlist (
    p_playlist_id IN NUMBER,
    p_user_id IN NUMBER
)
IS
    l_user_count NUMBER;
    l_playlist_count NUMBER;
BEGIN
    -- Check if the user_id matches the currently logged in user
    SELECT COUNT(*) INTO l_user_count
    FROM users
    WHERE user_id = p_user_id
      AND user_name = user;

    IF l_user_count = 0 THEN
        -- User is not authorized to delete playlist
        DBMS_OUTPUT.PUT_LINE('Error: User ' || user || ' is not authorized to delete playlist.');
    ELSE
        -- Check if playlist_id belongs to the user
        SELECT COUNT(*) INTO l_playlist_count
        FROM playlist
        WHERE playlist_id = p_playlist_id
          AND user_id = p_user_id;

        IF l_playlist_count = 0 THEN
            -- Playlist does not belong to the user
            DBMS_OUTPUT.PUT_LINE('Error: Playlist does not belong to user ' || user || '.');
        ELSE
            -- User is authorized and playlist_id belongs to the user, delete records from songs_playlist table where playlist_id matches with the playlist_id being deleted
            DELETE FROM songs_playlist
            WHERE playlist_id = p_playlist_id;
            DBMS_OUTPUT.PUT_LINE('songs_playlist deleted successfully.');
            -- Delete playlist record from playlist table
            DELETE FROM playlist
            WHERE playlist_id = p_playlist_id;

            DBMS_OUTPUT.PUT_LINE('Playlist deleted successfully.');
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User or playlist not found.');
END delete_playlist;
  

END;
/

COMMIT;


  