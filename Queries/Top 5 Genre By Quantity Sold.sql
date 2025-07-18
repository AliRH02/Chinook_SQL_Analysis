SELECT Genre.Name AS Genre, SUM(InvoiceLine.Quantity) AS Quantity_Sold
FROM InvoiceLine 
JOIN Track 
	ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre
	ON Track.GenreId = Genre.GenreId
GROUP BY Genre.Name
ORDER BY Quantity_Sold DESC
LIMIT 5;
