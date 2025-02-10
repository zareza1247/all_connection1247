-- check out customer 17850 

WITH RankedInvoices AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS InvoiceRank
    FROM 
        `ecom_d_uk`
)
SELECT *
FROM RankedInvoices
WHERE CustomerID = 17850
AND (SELECT COUNT(DISTINCT InvoiceNo) FROM `ecom_d_uk` WHERE CustomerID = 17850) > 1
; 
select * from ecom_d_uk where CustomerID = 17850;

-- 'see all the returned item from customer 17850'

WITH RankedInvoices AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS InvoiceRank
    FROM 
        `ecom_d_uk`
)
SELECT *
FROM RankedInvoices
WHERE CustomerID = 17850
  AND (SELECT COUNT(DISTINCT InvoiceNo) FROM `ecom_d_uk` WHERE CustomerID = 17850) > 1
  AND quantity < 0
;

-- check the nearest timeline
SELECT *
FROM `ecom_d_uk`
WHERE CustomerID = 17850
  AND InvoiceDate BETWEEN '2011-02-01' AND '2011-02-20'
ORDER BY InvoiceDate;

-- check the specific stockcode

SELECT *
FROM `ecom_d_uk`
WHERE StockCode = 22632
  -- AND Description = 'HAND WARMER RED RETROSPOT'
  -- AND Quantity > 0
  -- AND InvoiceDate < '2011-02-10'
ORDER BY quantity DESC;

-- HAND WARMER RED POLKA DOT 22632
-- HAND WARMER UNION JACK 22633
-- HAND WARMER RED RETROSPOT 22632

-- Check records with "C" in InvoiceNo
SELECT 
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    InvoiceDate, 
    UnitPrice, 
    CustomerID
FROM 
    `ecom_d_uk`
WHERE 
    InvoiceNo LIKE 'C%'
    AND Quantity < 0
ORDER BY 
    CustomerID, InvoiceDate;
    
-- ------------------------------------
-- Match cancellations/returns with their original transactions
SELECT 
    r.InvoiceNo AS ReturnInvoiceNo,
    r.StockCode,
    r.Description,
    r.Quantity AS ReturnQuantity,
    r.InvoiceDate AS ReturnDate,
    p.InvoiceNo AS PurchaseInvoiceNo,
    p.Quantity AS PurchaseQuantity,
    p.InvoiceDate AS PurchaseDate,
    r.CustomerID
FROM 
    `ecom_d_uk` r
JOIN 
    `ecom_d_uk` p
ON 
    r.StockCode = p.StockCode
    AND r.CustomerID = p.CustomerID
    AND r.Quantity = -p.Quantity
    AND p.InvoiceDate < r.InvoiceDate
WHERE 
    r.InvoiceNo LIKE 'C%'
    AND r.Quantity < 0
    AND r.CustomerID = 17850
ORDER BY 
    r.CustomerID, r.InvoiceDate; -- doesnt work
    
-- Match returns with their purchases and preserve all original data
-- Optimized query to match returns with purchases
SELECT 
    r.InvoiceNo AS ReturnInvoiceNo,
    r.StockCode,
    r.Description AS ReturnDescription,
    r.Quantity AS ReturnQuantity,
    r.InvoiceDate AS ReturnDate,
    p.InvoiceNo AS PurchaseInvoiceNo,
    p.Description AS PurchaseDescription,
    p.Quantity AS PurchaseQuantity,
    p.InvoiceDate AS PurchaseDate,
    r.CustomerID
FROM 
    `ecom_d_uk` r
JOIN 
    `ecom_d_uk` p
ON 
    r.StockCode = p.StockCode
    AND r.CustomerID = p.CustomerID
    AND r.Quantity = -p.Quantity -- Matches returns to purchases
    AND p.InvoiceDate < r.InvoiceDate
WHERE 
    r.InvoiceNo LIKE 'C%'
    AND r.Quantity <= 0
    AND p.Quantity > 0
    AND r.CustomerID = 17850
ORDER BY 
    r.CustomerID, r.InvoiceDate;
    
-- 

SELECT 
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    CASE 
        WHEN Quantity > 0 THEN 'Purchase'
        WHEN Quantity < 0 THEN 'Return'
    END AS RecordType
FROM 
    `ecom_d_uk`
WHERE 
    Description = 'HAND WARMER RED RETROSPOT'
ORDER BY 
    RecordType, InvoiceDate;
-- summary purchases vs returns of hand warmer red retrospot 
SELECT 
    CASE 
        WHEN Quantity > 0 THEN 'Total Purchases'
        WHEN Quantity < 0 THEN 'Total Returns'
    END AS RecordType,
    SUM(Quantity) AS TotalQuantity,
    COUNT(*) AS RecordCount
FROM 
    `ecom_d_uk`
WHERE 
    Description = 'HAND WARMER RED RETROSPOT'
GROUP BY 
    RecordType;
    
-- -------------------------------------------------------------

SELECT 
    StockCode,
    Description,
    SUM(
        CASE 
            WHEN Quantity < 0 THEN 0 -- Ignore returns
            ELSE Quantity + COALESCE((SELECT SUM(Quantity) 
                                      FROM `ecom_d_uk` 
                                      WHERE StockCode = r.StockCode 
                                      AND Quantity < 0), 0) -- Adjust for unmatched returns
        END
    ) AS AdjustedQuantity
FROM `ecom_d_uk` r
GROUP BY StockCode, Description;

-- -------------------------------------------------------------
SELECT 
    StockCode,
    Description,
    SUM(CASE WHEN Quantity > 0 THEN Quantity ELSE 0 END) AS TotalPurchases,
    SUM(CASE WHEN Quantity < 0 THEN ABS(Quantity) ELSE 0 END) AS TotalReturns,
    SUM(Quantity) AS NetQuantity
FROM `ecom_d_uk`
GROUP BY StockCode, Description
HAVING StockCode = 22632;







