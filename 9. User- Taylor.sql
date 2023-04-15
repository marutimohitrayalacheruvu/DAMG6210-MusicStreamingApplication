SELECT * FROM app_admin.songs_by_rating;
SELECT * FROM app_admin.artist_song_count;
SELECT * FROM app_admin.song_count_by_genre;
SELECT * FROM app_admin.top_rated_album;



BEGIN
  app_admin.update_artist_byartist(1, 'Taylor', 'Swift', 'An American singer-songwriter known for her narrative songwriting and distinctive voice.', 'TAYLOR_SWIFT');
END;

BEGIN
app_admin.insert_album_artist_m(1, 'Cardigan', 9);
END;