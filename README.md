# Chinook_SQL_Analysis

## Overview
This project explores sales and customer trends in a fictional music store using the Chinook database. The goal was to practice SQL querying, data validation.

## Key Questions:
1. Who are the top 10 artists by total sales?
2. What are the top 5 most popular genres by quantity sold?
3. What are the average sales per year?
4. Who are the top 10 customers by total spending?

## Sample Queries

### Top 10 Artists by Total Sales
```sql
SELECT Artist.name AS Artist, SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) As Total_sales
FROM InvoiceLine 
JOIN Track  
	ON InvoiceLine.TrackId= Track.TrackId
JOIN Album
	ON Track.AlbumId=Album.AlbumId
JOIN Artist
	ON Album.ArtistId=Artist.ArtistId
GROUP BY Artist.Name
ORDER BY Total_sales DESC
LIMIT 10;
```
<p align="center">
  <img width="597" height="579" alt="Screenshot 2025-07-15 123555" src="https://github.com/user-attachments/assets/0c2e0fd2-bccd-48b5-b019-4d39a12c32d0" width="600"/>
</p>

### Top 5 Most Popular Genres By Quantity Sold
```sql
SELECT Genre.Name AS Genre, SUM(InvoiceLine.Quantity) AS Quantity_Sold
FROM InvoiceLine 
JOIN Track 
	ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre
	ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name
ORDER BY Quantity_Sold DESC
LIMIT 5;

```
<p align="center">
<img width="528" height="314" alt="Screenshot 2025-07-15 123625" src="https://github.com/user-attachments/assets/fb1ad403-ece2-4536-a4ce-efeaa89c1598" width="600"/>
</p>

### Average Sales Per Year
```sql
SELECT strftime('%Y', Invoice.InvoiceDate) AS Year, 
       ROUND(AVG(Invoice.Total), 2) AS Average_Sales
FROM Invoice 
GROUP BY Year
ORDER BY Year;
```
<p align="center">
<img width="326" height="320" alt="Screenshot 2025-07-15 130504" src="https://github.com/user-attachments/assets/2e601955-5e45-4665-9340-d546dcb6853f" width="600"/>
</p>

### Top 10 Customers by Total Spending (ranked)
```sql
WITH Ranked_Customers AS(
	SELECT 
		Concat(Customer.FirstName,' ',Customer.LastName) AS Name, 
		ROUND(SUM(Invoice.Total), 2) AS Total_Spent,
		DENSE_RANK() OVER(ORDER BY SUM(Invoice.Total) DESC) AS rk
	FROM Invoice
	JOIN Customer
		ON Invoice.CustomerId = Customer.CustomerId
	GROUP BY Customer.CustomerId
)

SELECT Name, Total_Spent
FROM Ranked_Customers
Where rk<=10;
```
<p align="center">
<img width="548" height="992" alt="Screenshot 2025-07-15 123617" src="https://github.com/user-attachments/assets/3de09a7e-5d09-45a8-9580-821aa991287b" width="600"/>
</p>

## Data Validation Summary
1. Cross checked total sales and quantities against company totals.
2. Verified joins did not duplicate rows.
3. Spot-checked individual artists, genres, and customers.

## Tool Used
SQLite (via DB Browser or SQL tool)
