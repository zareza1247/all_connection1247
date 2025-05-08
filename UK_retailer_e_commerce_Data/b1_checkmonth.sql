SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,  -- Extracts "YYYY-MM" format
    ROUND(SUM(Quantity * UnitPrice), 2) AS Sales  -- Computes total sales per month
FROM ecom_d_uk
WHERE StockCode NOT IN ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')  -- Exclude non-product codes
GROUP BY Month
ORDER BY Month ASC;
