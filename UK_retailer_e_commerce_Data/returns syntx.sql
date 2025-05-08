SELECT 
    StockCode, 
    Description, 
    COUNT(*) AS Return_Count,  -- Number of times a product appears in "return transactions"
    SUM(ABS(Quantity)) AS Total_Units_Returned  -- Total units returned
FROM ecom_d_uk
WHERE Quantity < 0  -- Filter for return transactions
GROUP BY StockCode, Description
ORDER BY Return_Count DESC;  -- Ranking products by most frequently returned

-- SUM(ABS(Quantity)) AS Total_Units_Returned:
-- The ABS(Quantity) function is used to ignore the sign of the quantity, ensuring you are summing the absolute value of the quantities (which will be positive). Since returns are represented as negative quantities, this will give you the total units returned.

-- Return_Count: You’ll get the number of times a product has been returned, helping you identify the most frequently returned items.
-- Total_Units_Returned: You’ll also know how many units of each product have been returned in total.
-- Ordering by Return Count: The ORDER BY clause sorts the results by how frequently each product is returned, from most to least, helping you prioritize which products might need further investigation due to high return rates.



-- check bank charges in description
select *
from ecom_d_uk
where description = "Bank charges"
;


-- returns based on unitprice
SELECT 
    StockCode,
    description,
    SUM(Quantity * UnitPrice) AS Total_Returns
FROM 
    ecom_d_uk
WHERE 
    Quantity < 0 -- Filter for returns (negative quantity)
GROUP BY 
    StockCode, description
ORDER BY 
    Total_Returns DESC; -- same rows returned as the first syntax in this file

-- B3 part 2

-- Track return rates by product, category, or time period
-- 		To understand return patterns, we need to:
-- 			• Group return data by product category (if available).
-- 			• Aggregate returns over time (daily, weekly, or monthly) to detect patterns.
-- 			• Calculate the return rate for each product or category.
-- 		💡 Formula for Return Rate:
-- 		Return Rate=Total Returns (Negative Quantity * UnitPrice)Gross Sales\text{Return Rate} = \frac{\text{Total Returns (Negative Quantity * UnitPrice)}}{\text{Gross Sales}}Return Rate=Gross SalesTotal Returns (Negative Quantity * UnitPrice)​
-- 		Insight:
-- 			• Helps pinpoint if certain categories (e.g., apparel vs. electronics) have higher return rates.
-- 			• Detects seasonal return trends (e.g., after holiday shopping).

SELECT 
    StockCode,
    Description,
    SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) AS Total_Returns,
    SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END) AS Gross_Sales,
    (SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) / 
     SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END)) AS Return_Rate
FROM ecom_d_uk
GROUP BY StockCode, Description
ORDER BY Return_Rate DESC;

-- MySQL Query for Return Rates by Product:
SELECT 
    StockCode,
    Description,
    SUM(CASE
        WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice
        ELSE 0
    END) AS Total_Returns,
    SUM(CASE
        WHEN Quantity > 0 THEN Quantity * UnitPrice
        ELSE 0
    END) AS Gross_Sales,
    (SUM(CASE
        WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice
        ELSE 0
    END) / NULLIF(SUM(CASE
                WHEN Quantity > 0 THEN Quantity * UnitPrice
                ELSE 0
            END),
            0)) AS Return_Rate
FROM
    ecom_d_uk
WHERE
    StockCode NOT IN ('POST' , 'D',
        'C2',
        'DOT',
        'M',
        'S',
        'PADS',
        'B',
        'CRUK',
        'BANK CHARGES',
        'amazonfee')
GROUP BY StockCode , Description
ORDER BY Return_Rate DESC;


-- MySQL Query for Return Rates by Time Period (e.g., Monthly):
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
    SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) AS Total_Returns,
    SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END) AS Gross_Sales,
   (SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) / 
     NULLIF(SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END), 0)) AS Return_Rate
FROM ecom_d_uk
where StockCode NOT IN ('POST' , 'D',
        'C2',
        'DOT',
        'M',
        'S',
        'PADS',
        'B',
        'CRUK',
        'BANK CHARGES',
        'amazonfee')
GROUP BY Month
ORDER BY Return_Rate DESC;

-- Return Rate by Category (if you have a category column)
SELECT 
    Category,  -- Assuming you have a Category column in your dataset
    SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) AS Total_Returns,
    SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END) AS Gross_Sales,
    (SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) * UnitPrice ELSE 0 END) / 
     SUM(CASE WHEN Quantity > 0 THEN Quantity * UnitPrice ELSE 0 END)) AS Return_Rate
FROM ecom_d_uk
where StockCode NOT IN ('POST' , 'D',
        'C2',
        'DOT',
        'M',
        'S',
        'PADS',
        'B',
        'CRUK',
        'BANK CHARGES',
        'amazonfee')
GROUP BY Category
ORDER BY Return_Rate DESC;

-- erased all the non number stockcode including bank charges 

