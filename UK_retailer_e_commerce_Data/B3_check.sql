-- Identify which products are returned most often
-- This involves analyzing the frequency and volume of returns. You should:

-- Count how many times each product appears in return transactions.
-- Sum the total negative quantity per product to determine the total number of units returned.
-- Rank products by total return volume.
-- Insight: Helps identify problematic products that may have quality issues, incorrect descriptions, or other reasons for dissatisfaction.






-- Track return rates by product, category, or time period
-- To understand return patterns, we need to:

-- Group return data by product category (if available).
-- Aggregate returns over time (daily, weekly, or monthly) to detect patterns.
-- Calculate the return rate for each product or category.
-- 💡 Formula for Return Rate:

-- Return Rate
-- =
-- Total Returns (Negative Quantity * UnitPrice)
-- Gross Sales
-- Return Rate= 
-- Gross Sales
-- Total Returns (Negative Quantity * UnitPrice)
-- ​
--  
-- Insight:

-- Helps pinpoint if certain categories (e.g., apparel vs. electronics) have higher return rates.
-- Detects seasonal return trends (e.g., after holiday shopping).


-- total returns in product value based on price and quantity per stockcode
SELECT 
    StockCode,
    SUM(Quantity * UnitPrice) AS Total_Returns
FROM 
    ecom_d_uk
WHERE 
    Quantity < 0 -- Filter for returns (negative quantity)
GROUP BY 
    StockCode
ORDER BY 
    Total_Returns DESC;
    
-- different description same stockcode 
SELECT StockCode, COUNT(DISTINCT Description) AS DescriptionCount
FROM ecom_d_uk
GROUP BY StockCode
HAVING DescriptionCount > 1;

-- ----------------------------------------------------------------------------------------

SELECT 
    StockCode,
    Description,
    SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) AS Total_Returns,
    SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END) AS Gross_Sales,
    (SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) / 
     SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END)) AS Return_Rate
FROM ecom_d_uk2
GROUP BY StockCode, Description
ORDER BY Return_Rate DESC;

SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) AS Total_Returns,
    SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END) AS Gross_Sales,
    (SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) / 
     SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END)) AS Return_Rate
FROM ecom_d_uk2
GROUP BY Month
ORDER BY month asc;

select count(*)
from ecom_d_uk2; -- 1023998 doubled somehow? - now back to normal



    


