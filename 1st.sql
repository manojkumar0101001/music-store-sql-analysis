-- Create and select database
CREATE DATABASE music_store;
USE music_store;

-- 1. artist
CREATE TABLE artist (
  artist_id INT PRIMARY KEY,
  name VARCHAR(200)
);

-- 2. album
CREATE TABLE album (
  album_id INT PRIMARY KEY,
  title VARCHAR(200),
  artist_id INT,
  FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

-- 3. media_type
CREATE TABLE media_type (
  media_type_id INT PRIMARY KEY,
  name VARCHAR(200)
);

-- 4. genre
CREATE TABLE genre (
  genre_id INT PRIMARY KEY,
  name VARCHAR(200)
);

-- 5. track
CREATE TABLE track (
  track_id INT PRIMARY KEY,
  name VARCHAR(200),
  album_id INT,
  media_type_id INT,
  genre_id INT,
  composer VARCHAR(300),
  milliseconds BIGINT,
  bytes BIGINT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (album_id) REFERENCES album(album_id),
  FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
  FOREIGN KEY (genre_id) REFERENCES genre(genre_id)
);

-- 6. employee
CREATE TABLE employee (
  employee_id INT PRIMARY KEY,
  last_name VARCHAR(100),
  first_name VARCHAR(100),
  title VARCHAR(100),
  reports_to INT,
  levels VARCHAR(10),
  birthdate VARCHAR(50),
  hire_date VARCHAR(50),
  address VARCHAR(200),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20),
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(100)
);

-- 7. customer
CREATE TABLE customer (
  customer_id INT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  company VARCHAR(200),
  address VARCHAR(200),
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20),
  phone VARCHAR(50),
  fax VARCHAR(50),
  email VARCHAR(100),
  support_rep_id INT
);

-- 8. invoice
CREATE TABLE invoice (
  invoice_id INT PRIMARY KEY,
  customer_id INT,
  invoice_date DATETIME,
  billing_address VARCHAR(200),
  billing_city VARCHAR(100),
  billing_state VARCHAR(100),
  billing_country VARCHAR(100),
  billing_postal_code VARCHAR(20),
  total DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- 9. invoice_line
CREATE TABLE invoice_line (
  invoice_line_id INT PRIMARY KEY,
  invoice_id INT,
  track_id INT,
  unit_price DECIMAL(10,2),
  quantity INT,
  FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
  FOREIGN KEY (track_id) REFERENCES track(track_id)
);

-- 10. playlist
CREATE TABLE playlist (
  playlist_id INT PRIMARY KEY,
  name VARCHAR(200)
);

-- 11. playlist_track
CREATE TABLE playlist_track (
  playlist_id INT,
  track_id INT,
  PRIMARY KEY (playlist_id, track_id),
  FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
  FOREIGN KEY (track_id) REFERENCES track(track_id)
);


SET GLOBAL local_infile = 1;

