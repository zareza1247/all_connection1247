SELECT 
    count(*)
FROM 
    `ecom_d_uk`
;

SELECT min(InvoiceDate), max(InvoiceDate) FROM `ecom_d_uk`
;

-- how many varieties of stockcode are there?

select count(distinct(StockCode)) as v_stockcode
from `ecom_d_uk`;

-- how many customer_ids are null?

SELECT 
    count(*)
FROM 
    `ecom_d_uk`
WHERE 
    CustomerID is null; -- '135080'

-- ranking based on customer id and the invoiceno

WITH RankedInvoices AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate) AS InvoiceRank
    FROM 
        `ecom_d_uk`
)
SELECT *
FROM RankedInvoices
WHERE (SELECT COUNT(DISTINCT InvoiceNo) FROM `ecom_d_uk`) > 1;

-- a syntax that can show me the count of the distinct stockcode but has a '' description or otherwise a blank description. 
SELECT COUNT(DISTINCT StockCode) AS distinct_stockcodes
FROM ecom_d_uk
WHERE Description IS NULL OR Description = ''; -- 950
-- a syntax that can show me the '' description or otherwise a blank description. 
SELECT *
FROM ecom_d_uk
WHERE Description IS NULL OR Description = ''; -- 1454


-- syntax count where the unitprice is zero
SELECT *
FROM ecom_d_uk
WHERE UnitPrice IS NULL OR UnitPrice = ''; -- 2515

SELECT *
FROM ecom_d_uk
WHERE UnitPrice < 0;



SELECT *
FROM ecom_d_uk
;

SELECT count(*)
FROM ecom_d_uk
WHERE LENGTH(StockCode) < 5; -- 2839

SELECT DISTINCT StockCode
FROM ecom_d_uk
WHERE LENGTH(StockCode) < 5; -- POST, D , C2 , DOT , M , S , PADS , B , CRUK



SELECT *
FROM ecom_d_uk
WHERE StockCode IN (
    SELECT DISTINCT StockCode
    FROM ecom_d_uk
    WHERE LENGTH(StockCode) < 4
);

SELECT DISTINCT
    (Country)
FROM
    ecom_d_uk; -- United Kingdom, France, Australia, Netherlands, Germany, Norway, EIRE, Switzerland, Spain, Poland, Portugal, Italy, Belgium, Lithuania, Japan, Iceland, Channel Islands, Denmark, Cyprus, Sweden,  Austria, Israel, Finland, Bahrain, Greece, Hong Kong, Singapore, Lebanon, United Arab Emirates, Saudi Arabia, Czech Republic, Canada, Unspecified, Brazil, USA, European Community, Malta, RSA

SELECT StockCode, COUNT(*) AS CountPerStockCode
FROM ecom_d_uk
WHERE StockCode IN ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')
GROUP BY StockCode
order by CountPerStockCode desc;

SELECT distinct(description)
FROM ecom_d_uk
WHERE StockCode IN ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')
;

SELECT *
FROM ecom_d_uk
WHERE StockCode IN ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')
AND Quantity < 0
;

SELECT distinct(description)
FROM ecom_d_uk
WHERE StockCode IN ('POST', 'D', 'C2', 'DOT', 'M', 'S', 'PADS', 'B', 'CRUK')
AND Quantity < 0
;


SELECT Country, COUNT(*) AS CountPercountry
FROM ecom_d_uk
WHERE Country IN ('United Kingdom', 'France', 'Australia', 'Netherlands', 'Germany', 'Norway', 'EIRE', 'Switzerland', 'Spain', 'Poland', 'Portugal', 'Italy', 'Belgium', 'Lithuania', 'Japan', 'Iceland', 'Channel Islands', 'Denmark', 'Cyprus', 'Sweden', 'Austria', 'Israel', 'Finland', 'Bahrain', 'Greece', 'Hong Kong', 'Singapore', 'Lebanon', 'United Arab Emirates', 'Saudi Arabia', 'Czech Republic', 'Canada', 'Unspecified', 'Brazil', 'USA', 'European Community', 'Malta', 'RSA')
GROUP BY Country
order by CountPercountry desc;

-- UNIT PRICING ?
SELECT *
FROM ecom_d_uk
WHERE UnitPrice < 0;

select min(UnitPrice)
, max(UnitPrice)
FROM ecom_d_uk;

WITH BinData AS (
    SELECT 
        *,
        NTILE(10) OVER (ORDER BY UnitPrice) AS PriceGroup
    FROM ecom_d_uk
)
SELECT *
FROM BinData
ORDER BY PriceGroup; -- not so good

SELECT *,
       CASE 
           WHEN UnitPrice BETWEEN -11062.06 AND -7000 THEN 'Group 1'
           WHEN UnitPrice BETWEEN -7000 AND -3000 THEN 'Group 2'
           WHEN UnitPrice BETWEEN -3000 AND 1000 THEN 'Group 3'
           WHEN UnitPrice BETWEEN 1000 AND 5000 THEN 'Group 4'
           WHEN UnitPrice BETWEEN 5000 AND 9000 THEN 'Group 5'
           WHEN UnitPrice BETWEEN 9000 AND 13000 THEN 'Group 6'
           WHEN UnitPrice BETWEEN 13000 AND 17000 THEN 'Group 7'
           WHEN UnitPrice BETWEEN 17000 AND 21000 THEN 'Group 8'
           WHEN UnitPrice BETWEEN 21000 AND 25000 THEN 'Group 9'
           ELSE 'Group 10'
       END AS PriceGroup
FROM ecom_d_uk
order by PriceGroup asc;


SELECT Description, COUNT(*) AS Count, SUM(UnitPrice) AS TotalAdjustment
FROM ecom_d_uk
WHERE UnitPrice < 0
GROUP BY Description
ORDER BY TotalAdjustment ASC;

SELECT InvoiceNo, StockCode, Description, UnitPrice, Quantity
FROM ecom_d_uk
WHERE UnitPrice < 0
ORDER BY InvoiceNo;

-- PINK  HEART CONFETTI IN TUBE , why missing values 

SELECT *
FROM ecom_d_uk
WHERE InvoiceNo = 552042
and StockCode = 21199
; -- no missing values

-- why are some values in the quantities column negative?

SELECT *
FROM ecom_d_uk
WHERE Quantity < 0
order by Quantity asc; -- 9762 row(s) returned, lowest is -80995

-- lets seperate the table into gross sales, returns, and net sales

SELECT 
    DATE(invoicedate) AS sales_date,
    SUM(CASE 
        WHEN quantity > 0 THEN quantity * unitprice 
        ELSE 0 
    END) AS gross_sales,
    SUM(CASE 
        WHEN quantity < 0 THEN quantity * unitprice 
        ELSE 0 
    END) AS returns,
    SUM(quantity * unitprice) AS net_sales
FROM ecom_d_uk
GROUP BY sales_date
ORDER BY sales_date; -- 305 row(s) returned (-meaning that there are 305 recordedd days-)

-- see what seems like the outlier at the very last date
SELECT * FROM ecom_d_uk
where InvoiceDate between '2011-12-09 00:00:00' and '2011-12-09 23:59:59'
and Description = "VICTORIAN GLASS HANGING T-LIGHT"
order by Quantity;

SELECT  SUM(CASE 
        WHEN quantity > 0 THEN quantity * unitprice 
        ELSE 0
end) as gross_sales
FROM ecom_d_uk
where InvoiceDate between '2011-12-09 00:00:00' and '2011-12-09 23:59:59';

SELECT  *
FROM ecom_d_uk
where quantity > 0 and
InvoiceDate between '2011-12-09 00:00:00' and '2011-12-09 23:59:59';

SELECT  SUM(CASE 
        WHEN quantity < 0 THEN quantity * unitprice 
        ELSE 0
end) as returns
FROM ecom_d_uk
where InvoiceDate between '2011-12-09 00:00:00' and '2011-12-09 23:59:59';


-- returns 
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-12-09 00:00:00' and '2011-12-09 23:59:59';

SELECT SUM(Quantity * UnitPrice) AS TotalSales
FROM ecom_d_uk
WHERE Quantity < 0 
  AND InvoiceDate BETWEEN '2011-12-09 00:00:00' AND '2011-12-09 23:59:59';
  
-- theres one that I avoided, for the very last date had a lot of returns
  
-- --------------------------------------------------------------------------------------- 

-- gross sales
SELECT  *
FROM ecom_d_uk
where quantity > 0 and
InvoiceDate between '2011-12-09 00:00:00' and '2011-12-09 23:59:59';

SELECT SUM(Quantity * UnitPrice) AS TotalSales
FROM ecom_d_uk
WHERE Quantity > 0 
  AND InvoiceDate BETWEEN '2011-12-09 00:00:00' AND '2011-12-09 23:59:59';
  
-- -------------------------------------------------------------------------------------------

-- customerID '12346'

SELECT *
FROM ecom_d_uk
WHERE CustomerID = 12346
; -- Cbefore the number on the invoice means cancelled

-- lets check all the cancelled ones 

SELECT *
FROM ecom_d_uk
WHERE InvoiceNo like 'c%'
; -- 9288 row(s) returned (-cancelled orders-)

-- customerID '12472'
SELECT *
FROM ecom_d_uk
WHERE CustomerID = 12472
order by InvoiceNo desc; -- this person likes to cancel orders (-391 row(s) returned-)

SELECT *,
       RANK() OVER (PARTITION BY CustomerID ORDER BY InvoiceDate ASC) AS InvoiceRank
FROM ecom_d_uk
WHERE CustomerID = 12472
ORDER BY InvoiceNo DESC;

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
AND (SELECT COUNT(DISTINCT InvoiceNo) FROM `ecom_d_uk` WHERE CustomerID = 17850) > 1;


-- see if it sums up with the excel version
SELECT sum(UnitPrice) as sum
FROM ecom_d_uk
WHERE CustomerID = 12472
order by InvoiceNo desc;


-- -------------------------------------------------------------------------------------------------
SELECT  *
FROM ecom_d_uk
where quantity > 0 and
InvoiceDate between '2010-12-24 00:00:00' and '2011-01-04 23:59:59'; -- data between 24th of december to january 4th missing 

SELECT  *
FROM ecom_d_uk
where quantity > 0 and
InvoiceDate between '2011-04-21 00:00:00' and '2011-04-26 23:59:59'; -- April 22, 2011 (Good Friday), April 24, 2011 (Easter Sunday), Easter Monday (April 25, 2011)

-- --------------------------------------------------------------------------------------- 

-- 15/9/2011
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-09-15 00:00:00' and '2011-09-15 23:59:59' 
order by Quantity; -- amazon fee (5522.14) and manual (7427.97) is very expensive

SELECT SUM(Quantity * UnitPrice) AS TotalSales
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-09-15 00:00:00' and '2011-09-15 23:59:59'; -- -15275.14

-- --------------------------------------------------------------------------------------- 

-- 07/12/10
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2010-12-07 00:00:00' and '2010-12-07 23:59:59' 
order by Quantity; -- samples (52), discount (281), amazon fee (13541.33), manual (631.31)

-- --------------------------------------------------------------------------------------- 

-- 05/01/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-01-05 00:00:00' and '2011-01-05 23:59:59' 
order by Quantity; -- amazon fee (16888.02)

-- 07/12/11 (not the one im looking for)
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-12-07 00:00:00' and '2011-12-07 23:59:59' 
order by Quantity; -- Lost, ????damages????, mixed up, damages? Check, mixed up, damages, check, manual

-- 18/01/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-01-18 00:00:00' and '2011-01-18 23:59:59' 
order by Quantity; -- MEDIUM CERAMIC TOP STORAGE JAR (quantity -74215 price 1.04)

-- check "MEDIUM CERAMIC TOP STORAGE JAR"
SELECT  *
FROM ecom_d_uk
where Description = "MEDIUM CERAMIC TOP STORAGE JAR"
order by Quantity; -- the medium ceramic top storage jar is not the cause for returns

--  21/02/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-02-21 00:00:00' and '2011-02-21 23:59:59' 
order by Quantity; -- Bank Charges (149.16), Manual (320.69), SAMPLES (107.99), AMAZON FEE (5575.28)

--  18/03/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-03-18 00:00:00' and '2011-03-18 23:59:59' 
order by Quantity; -- AMAZON FEE (5693.05)

-- 04/04/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-04-04 00:00:00' and '2011-04-04 23:59:59' 
order by Quantity; -- Manual (2382.92)

-- 18/04/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-04-18 00:00:00' and '2011-04-18 23:59:59' 
order by Quantity; -- Manual (222.75), large returns from the united kingdom, In the UK, on April 18, 2011, the notable event was the intensification of preparations for the Royal Wedding of Prince William and Catherine Middleton, which was scheduled for April 29, 2011.

-- 03/05/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-05-03 00:00:00' and '2011-05-03 23:59:59' 
order by Quantity; -- damages/showroom etc (0), Manual (6930.00), POSTAGE(8142.75)

-- 16/05/11
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
InvoiceDate between '2011-05-16 00:00:00' and '2011-05-16 23:59:59' 
order by Quantity; -- AMAZON FEE (7006.83)

-- -------------------------------------------------------------------

-- (-find all the description in the returns columns where the unit price are zero-)
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
UnitPrice = 0 
order by Quantity; -- 474 rows returned

-- (-find all the description in the returns columns where the unit price are more than 1000-)
SELECT  *
FROM ecom_d_uk
where quantity < 0 and
UnitPrice > 1000 
order by Quantity; -- 66 rows returned 

-- ----------------------------------------------------------------------------------------

SELECT DATEDIFF('2011-12-09', '2010-12-01') + 1 AS total_dates; -- 374 dates between 2011-12-09', '2010-12-01'

-- lets find the missing dates part 1

WITH RECURSIVE date_range AS (
    SELECT MIN(InvoiceDate) AS date
    FROM ecom_d_uk
    UNION ALL
    SELECT DATE_ADD(date, INTERVAL 1 DAY)
    FROM date_range
    WHERE date < (SELECT MAX(InvoiceDate) FROM ecom_d_uk)
)
SELECT date
FROM date_range; -- 375 row(s) returned (-suppossedly there are 375 days in the dataset expectedly-)

-- lets find the missing dates part 2

WITH RECURSIVE date_range AS (
    -- Generate a range of dates starting from the minimum date
    SELECT DATE('2010-12-01') AS date
    UNION ALL
    -- Increment the date by one day recursively
    SELECT DATE_ADD(date, INTERVAL 1 DAY)
    FROM date_range
    WHERE date < '2011-12-09'
)
SELECT date_range.date
FROM date_range
LEFT JOIN (
    SELECT DISTINCT DATE(InvoiceDate) AS InvoiceDate
    FROM ecom_d_uk
) present_dates
ON date_range.date = present_dates.InvoiceDate
WHERE present_dates.InvoiceDate IS NULL
ORDER BY date_range.date ASC;

SELECT * FROM ecom_d_uk
where Description = "Adjust Bad Debt";

SELECT * FROM ecom_d_uk
where InvoiceDate between "2011-12-09 00:00:00" and "2011-12-09 23:59:59"
order by UnitPrice desc;

SELECT * FROM ecom_d_uk
where InvoiceDate between "2011-12-09 00:00:00" and "2011-12-09 23:59:59"
order by Quantity desc;

-- --------------------------------------------------------------------------------------------------
-- To ensure clarity and separate same-day returns per customer, you could modify the query to include CustomerID or InvoiceNo in the grouping:

SELECT 
    DATE(invoicedate) AS sales_date, 
    CustomerID,
    SUM(CASE WHEN quantity > 0 THEN quantity * unitprice ELSE 0 END) AS gross_sales, 
    SUM(CASE WHEN quantity < 0 THEN quantity * unitprice ELSE 0 END) AS returns, 
    SUM(quantity * unitprice) AS net_sales 
FROM ecom_d_uk 
GROUP BY sales_date, CustomerID 
ORDER BY sales_date;

-- This approach accounts for individual customer activity while still aggregating daily totals.
