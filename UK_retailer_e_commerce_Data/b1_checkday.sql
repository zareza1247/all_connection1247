SELECT 
    DATE(InvoiceDate) AS Date,
    ROUND(SUM(Quantity * UnitPrice), 2) AS Sales
FROM ecom_d_uk
where stockcode not in ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')
GROUP BY Date
ORDER BY Date;

select * from ecom_d_uk;
