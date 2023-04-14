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