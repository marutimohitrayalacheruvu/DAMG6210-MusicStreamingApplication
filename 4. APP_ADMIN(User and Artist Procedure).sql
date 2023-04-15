
---------------------- Insert to favourite

CREATE OR REPLACE PROCEDURE add_favorite_from_user (
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
END;
/




------------Update User details

CREATE OR REPLACE PROCEDURE update_user_from_user (
  p_user_id IN NUMBER,
  p_first_name IN VARCHAR2,
  p_last_name IN VARCHAR2,
  p_email IN VARCHAR2,
  p_user_name IN VARCHAR2

)
IS
BEGIN
  -- check if the user is trying to update their own information
  IF user = p_user_name THEN
    -- update the user row
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
END;
/



------------Delete from Favourite

CREATE OR REPLACE PROCEDURE delete_favorite_from_user (
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
END;
/



------------------Insert to Playlist Table

CREATE OR REPLACE PROCEDURE add_playlist (
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
END;
/


-------- Update or Insert into songs_playlist Table

CREATE OR REPLACE PROCEDURE add_song_to_playlist (
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
END;
/



------------- Delete record from songs_playlist Table

CREATE OR REPLACE PROCEDURE delete_song_from_playlist (
    p_song_id IN NUMBER,
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
            -- Check if the song_id and playlist_id combination exists in the songs_playlist table
            DELETE FROM songs_playlist
            WHERE song_id = p_song_id
              AND playlist_id = p_playlist_id;

            DBMS_OUTPUT.PUT_LINE('Record deleted successfully.');
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: User, playlist or song not found.');
END;
/



------ Delete records form Playlist table as well as related records from songs_playlist

CREATE OR REPLACE PROCEDURE delete_playlist (
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
END;
/



CREATE OR REPLACE PROCEDURE update_artist_byartist(
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
END;
/




--- Insert Album
CREATE OR REPLACE PROCEDURE insert_album_artist_m (
  m_artist_id IN NUMBER,
  p_album_name IN VARCHAR2,
  p_album_rating IN NUMBER
) AS
  l_album_id NUMBER;
  l_artist_id NUMBER;
  
  
BEGIN
--Check if artist exists
    BEGIN
    SELECT artist_id INTO l_artist_id
    FROM artist
    WHERE artist_id = m_artist_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      l_artist_id := NULL;
  END;
  IF l_artist_id IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Artist does not exist');
    RETURN;
  END IF;
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
  --m
  -- Adding into the artist_album table
  BEGIN
    insert_artist_album(l_artist_id, l_album_id);
  END;
END;
/

