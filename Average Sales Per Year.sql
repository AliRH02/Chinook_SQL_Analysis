SELECT strftime('%Y', Invoice.InvoiceDate) AS Year, 
       ROUND(AVG(Invoice.Total), 2) AS Average_Sales
FROM Invoice 
GROUP BY Year
ORDER BY Year;
