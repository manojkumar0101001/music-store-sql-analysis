SELECT COUNT(*) FROM artist;        
SELECT COUNT(*) FROM album;        
SELECT COUNT(*) FROM track;        
SELECT COUNT(*) FROM customer;     
SELECT COUNT(*) FROM invoice;      
SELECT COUNT(*) FROM invoice_line;  
SELECT COUNT(*) FROM employee;     
SELECT COUNT(*) FROM genre;         

SELECT COUNT(*) FROM artist;
SELECT COUNT(*) FROM album;
SELECT COUNT(*) FROM track;
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM invoice;
SELECT COUNT(*) FROM invoice_line;
SELECT COUNT(*) FROM employee;
SELECT COUNT(*) FROM genre;

-- Q1: Find the most senior employee based on job title
SELECT 
    employee_id,
    first_name,
    last_name,
    title,
    levels
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- Q2: Which countries have the most invoices?
SELECT 
    billing_country,
    COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;

-- Q3: Top 3 highest invoice totals
SELECT 
    invoice_id,
    customer_id,
    total
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Q4: City with highest total invoice amount
SELECT 
    billing_city,
    ROUND(SUM(total), 2) AS total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;

-- Q5: Top spending customer
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    ROUND(SUM(i.total), 2) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email
ORDER BY total_spent DESC
LIMIT 1;

-- Q6: Email, first name, last name of Rock music listeners
SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;

-- Q7: Top 10 rock artists based on number of tracks
SELECT 
    ar.artist_id,
    ar.name AS artist_name,
    COUNT(t.track_id) AS total_tracks
FROM artist ar
JOIN album al ON ar.artist_id = al.artist_id
JOIN track t ON al.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY total_tracks DESC
LIMIT 10;

-- Q8: All tracks longer than the average track length
SELECT 
    name,
    milliseconds,
    ROUND(milliseconds / 60000, 2) AS duration_minutes
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM track
)
ORDER BY milliseconds DESC;

-- Q9: How much each customer spent on each artist
WITH artist_earnings AS (
    SELECT 
        ar.artist_id,
        ar.name AS artist_name,
        il.invoice_id,
        il.unit_price,
        il.quantity
    FROM invoice_line il
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
)

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ae.artist_name,
    ROUND(SUM(ae.unit_price * ae.quantity), 2) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN artist_earnings ae ON i.invoice_id = ae.invoice_id
GROUP BY c.customer_id, c.first_name, c.last_name, ae.artist_name
ORDER BY total_spent DESC;

-- Q10: Most popular music genre for each country
WITH country_genre AS (
    SELECT 
        i.billing_country,
        g.name AS genre_name,
        COUNT(il.quantity) AS purchases,
        ROW_NUMBER() OVER (
            PARTITION BY i.billing_country 
            ORDER BY COUNT(il.quantity) DESC
        ) AS row_num
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY i.billing_country, g.name
)
SELECT 
    billing_country,
    genre_name,
    purchases
FROM country_genre
WHERE row_num = 1
ORDER BY billing_country;