set SERVEROUTPUT on;
BEGIN
  insert_or_update_user('Alice', 'Smith', 'alice.smith@example.com', 'alice123', 'active', '01-JAN-2022');
  insert_or_update_user('Bob', 'Johnson', 'bob.johnson@example.com', 'bob456', 'active', '02-JAN-2022');
  insert_or_update_user('Charlie', 'Brown', 'charlie.brown@example.com', 'charlie789', 'inactive', '03-JAN-2022');
  insert_or_update_user('David', 'Davis', 'david.davis@example.com', 'david321', 'active', '04-JAN-2022');
  insert_or_update_user('Emily', 'Evans', 'emily.evans@example.com', 'emily654', 'inactive', '05-JAN-2022');
  insert_or_update_user('Frank', 'Franklin', 'frank.franklin@example.com', 'frank987', 'active', '06-JAN-2022');
  insert_or_update_user('Grace', 'Garcia', 'grace.garcia@example.com', 'grace234', 'inactive', '07-JAN-2022');
  insert_or_update_user('Henry', 'Hernandez', 'henry.hernandez@example.com', 'henry567', 'active', '08-JAN-2022');
  insert_or_update_user('Isabelle', 'Ivanov', 'isabelle.ivanov@example.com', 'isabelle890', 'inactive', '09-JAN-2022');
  insert_or_update_user('John', 'Jackson', 'john.jackson@example.com', 'john123', 'active', '10-JAN-2022');
END;
/
COMMIT;
BEGIN
  insert_playlist('My Favorites', 6);
  insert_playlist('Relaxation', 7); 
  insert_playlist('Rock Classics', 8); 
  insert_playlist('Hip Hop Mix', 9);
  insert_playlist('Road Trip', 10); 
  insert_playlist('Chillout Vibes', 6); 
  insert_playlist('Summer Hits', 7); 
  insert_playlist('Pop Party', 8); 
  insert_playlist('Country Living', 9); 
  insert_playlist('Throwback Jams', 10); 
END;

/
COMMIT;
BEGIN
  insert_genre('Rock');
  insert_genre('Pop');
  insert_genre('Hip Hop');
  insert_genre('Electronic');
  insert_genre('Jazz');
  insert_genre('Classical');
  insert_genre('Folk');
  insert_genre('Blues');
  insert_genre('Country');
  insert_genre('Reggae');
END;
/
BEGIN
  insert_album('Folklore', 4);
  insert_album('Evermore', 5);
  insert_album('Sorry', 9);
  insert_album('21', 8);
  insert_album('Red', 4);
  insert_album('Yet to Come', 5);
  insert_album('Rare', 3);
  insert_album('Sour', 10);
  insert_album('We dont talk anymore', 9);
  insert_album('Love me', 8);
END;
/
COMMIT;
BEGIN
insert_artist('Taylor', 'Swift', ' musician known for soulful melodies and heartfelt lyrics.', 'taylor');
insert_artist('Justin', 'Bieber', 'singer-songwriter with a unique blend of indie and folk influences.', 'justin');
insert_artist('Nickie', 'Minaj', 'rock guitarist who has been making music for over 20 years.', 'nickie');
insert_artist('Adele', 'Adkins', 'jazz vocalist who has collaborated with some of the biggest names in the industry.', 'adele');
insert_artist('Shawn', 'Mendes', 'country singer with a voice as smooth as whiskey.', 'shawn');

END;
/
COMMIT;

BEGIN
  -- Link artists and albums
  insert_artist_album(2,1);
  insert_artist_album(1,2);
  insert_artist_album(1,3);
  insert_artist_album(2,10);
  insert_artist_album(3,6);
  insert_artist_album(3,7);
  insert_artist_album(4,8);
  insert_artist_album(4,9);
  insert_artist_album(5,4);
  insert_artist_album(5,5);
END;
/
COMMIT;
BEGIN
  insert_song('Love Story', 'Taylor Swift', 9.1, TO_TIMESTAMP('00:03:30.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 1, 3, 1);
  insert_song('White Horse', 'Taylor Swift',8.9, TO_TIMESTAMP('00:04:00.000000000','HH24:MI:SS.FF'), 'Spanish', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 2, 2, 3, 1);
  insert_song('I know What You Did Last Summer', 'Shawn Mendes', 8.6, TO_TIMESTAMP('00:03:45.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 3, 4, 5);
  insert_song('No Promises', 'Shawn Mendes', 8.3, TO_TIMESTAMP('00:04:20.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 4, 5, 5);
  insert_song('Chasing Pavements', 'Adele', 9.2, TO_TIMESTAMP('00:03:15.000000000','HH24:MI:SS.FF'), 'Spanish', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 5, 8, 4);
  insert_song('Cardigan', 'Taylor Swift', 8.9, TO_TIMESTAMP('00:04:30.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 1, 2, 1);
  insert_song('Cant stop Wont Stop', 'Nicki Minaj', 8.9, TO_TIMESTAMP('00:03:50.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 2, 6, 3);
  insert_song('Stuck in the Moment', 'Justin Bieber', 8.9, TO_TIMESTAMP('00:04:10.000000000','HH24:MI:SS.FF'), 'Spanish', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 3,1, 2);
  insert_song('Rumour has it', 'Adele', 8.9, TO_TIMESTAMP('00:03:20.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 3, 9, 4);
  insert_song('Teardrops on my guitar', 'Taylor', 9.9, TO_TIMESTAMP('00:03:20.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 3, 3, 3, 1);

  insert_song('Rolling in the Deep', 'Adele', 9.9, TO_TIMESTAMP('00:03:20.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 3, 9, 4);

  insert_song('Someone Like you', 'Adele', 9.4, TO_TIMESTAMP('00:04:40.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 2, 5, 9, 4);
  insert_song('Turning Tables', 'Adele', 9.8, TO_TIMESTAMP('00:04:40.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 3, 5, 9, 4);
  insert_song('Stitches', 'Shawn Mendes', 8.8, TO_TIMESTAMP('00:04:40.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 2, 2, 4, 5);
  insert_song('Thought I knew you', 'Nicki Minaj', 9.0, TO_TIMESTAMP('00:04:40.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 2, 2, 6, 3);



END;
/
COMMIT;

BEGIN
  insert_songs_playlist(1, 1);
  insert_songs_playlist(2, 1);
  insert_songs_playlist(3, 2);
  insert_songs_playlist(4, 2);
  insert_songs_playlist(5, 2);
  insert_songs_playlist(6, 3);
  insert_songs_playlist(7, 4);
  insert_songs_playlist(8, 5);
  insert_songs_playlist(9, 6);
  insert_songs_playlist(3, 6);
  insert_songs_playlist(1, 7);
  insert_songs_playlist(2, 7);
  insert_songs_playlist(4, 8);
  insert_songs_playlist(7, 8);
END;
/
BEGIN
insert_favourite(1, 1);
insert_favourite(1, 2);
insert_favourite(2, 3);
insert_favourite(4, 2);
insert_favourite(6, 1);
insert_favourite(6, 4);
insert_favourite(2, 5);
insert_favourite(3, 5);
insert_favourite(11,2);
insert_favourite(3, 5);
insert_favourite(12,2);
insert_favourite(13,2);
END;
/

COMMIT;