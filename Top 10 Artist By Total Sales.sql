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