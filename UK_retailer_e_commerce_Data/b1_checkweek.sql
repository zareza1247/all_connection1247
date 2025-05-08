-- Select weekly aggregated sales
SELECT 
    YEARWEEK(InvoiceDate, 3) AS Week,  -- Get year-week format (ISO-8601 standard)
    ROUND(SUM(Quantity * UnitPrice), 2) AS Sales  -- Compute total sales per week
FROM ecom_d_uk
WHERE StockCode NOT IN ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')  -- Exclude non-product codes
GROUP BY Week
ORDER BY Week ASC;
