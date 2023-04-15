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

EXECUTE insert_playlist('Favorites', 1);
EXECUTE insert_playlist('Road Trip', 1);
EXECUTE insert_playlist('Study Music', 2);
EXECUTE insert_playlist('Chill Vibes', 2);
EXECUTE insert_playlist('Rock Anthems', 3);
EXECUTE insert_playlist('Jazz Nights', 3);
EXECUTE insert_playlist('Hip Hop Beats', 4);
EXECUTE insert_playlist('Pop Hits', 4);
EXECUTE insert_playlist('Classical Wonders', 5);
EXECUTE insert_playlist('Workout Jams', 5);

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

select * from album;


BEGIN
insert_artist('John', 'Doe', 'John Doe is a musician known for his soulful melodies and heartfelt lyrics.', 'johndoe');
insert_artist('Jane', 'Doe', 'Jane Doe is a singer-songwriter with a unique blend of indie and folk influences.', 'janedoe');
insert_artist('Bob', 'Smith', 'Bob Smith is a rock guitarist who has been making music for over 20 years.', 'bobsmith');
insert_artist('Alice', 'Jones', 'Alice Jones is a jazz vocalist who has collaborated with some of the biggest names in the industry.', 'alicejones');
insert_artist('David', 'Lee', 'David Lee is a country singer with a voice as smooth as whiskey.', 'davidlee');
insert_artist('Emily', 'Nguyen', 'Emily Nguyen is a classically trained pianist who has transitioned to electronic music.', 'emilynguyen');
insert_artist('Michael', 'Chen', 'Michael Chen is a hip-hop artist who raps about social justice and inequality.', 'michaelchen');
insert_artist('Sara', 'Kim', 'Sara Kim is a K-pop singer who has taken the world by storm with her catchy tunes and infectious energy.', 'sarakhim');
insert_artist('Alex', 'Wong', 'Alex Wong is a multi-instrumentalist and producer who has worked with a wide range of artists.', 'alexwong');
insert_artist('Olivia', 'Zhang', 'Olivia Zhang is a rising star in the world of classical music, known for her virtuosic violin playing.', 'oliviazhang');

END;

BEGIN
  -- Link artists and albums
  insert_artist_album(1, 1);
  insert_artist_album(2, 2);
  insert_artist_album(3, 3);
  insert_artist_album(4, 4);
  insert_artist_album(5, 5);
  insert_artist_album(6, 6);
  insert_artist_album(7, 7);
  insert_artist_album(8, 8);
  insert_artist_album(9, 9);
  insert_artist_album(10, 10);
END;

select * from artist_album;

BEGIN
  insert_song('Song 1', 'Artist 1', 4.5, TO_TIMESTAMP('00:03:30.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 1, 1, 1, 1);
  insert_song('Song 2', 'Artist 2', 3.2, TO_TIMESTAMP('00:04:00.000000000','HH24:MI:SS.FF'), 'Spanish', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 2, 2, 2, 2);
  insert_song('Song 3', 'Artist 3', 4.7, TO_TIMESTAMP('00:03:45.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 3, 3, 3, 3);
  insert_song('Song 4', 'Artist 4', 2.8, TO_TIMESTAMP('00:04:20.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 4, 4, 4, 4);
  insert_song('Song 5', 'Artist 5', 4.9, TO_TIMESTAMP('00:03:15.000000000','HH24:MI:SS.FF'), 'Spanish', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 5, 5, 5, 5);
  insert_song('Song 6', 'Artist 6', 3.1, TO_TIMESTAMP('00:04:30.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 6, 6, 6, 6);
  insert_song('Song 7', 'Artist 7', 4.8, TO_TIMESTAMP('00:03:50.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 7, 7, 7, 7);
  insert_song('Song 8', 'Artist 8', 3.9, TO_TIMESTAMP('00:04:10.000000000','HH24:MI:SS.FF'), 'Spanish', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 8, 8, 8, 8);
  insert_song('Song 9', 'Artist 9', 4.6, TO_TIMESTAMP('00:03:20.000000000','HH24:MI:SS.FF'), 'French', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 9, 9, 9, 9);
  insert_song('Song 10', 'Artist 10', 3.5, TO_TIMESTAMP('00:04:40.000000000','HH24:MI:SS.FF'), 'English', TO_DATE('2023-04-14', 'YYYY-MM-DD'), 10, 10, 10, 10);
END;


BEGIN
  insert_songs_playlist(1, 1);
  insert_songs_playlist(2, 1);
  insert_songs_playlist(3, 1);
  insert_songs_playlist(4, 2);
  insert_songs_playlist(5, 2);
  insert_songs_playlist(6, 3);
  insert_songs_playlist(7, 3);
  insert_songs_playlist(8, 3);
  insert_songs_playlist(9, 4);
  insert_songs_playlist(10, 5);
END;

BEGIN
insert_favourite(1, 1);
insert_favourite(2, 1);
insert_favourite(3, 2);
insert_favourite(4, 3);
insert_favourite(5, 4);
insert_favourite(6, 5);
insert_favourite(7, 6);
insert_favourite(8, 7);
insert_favourite(9, 8);
insert_favourite(10, 9);
END;
