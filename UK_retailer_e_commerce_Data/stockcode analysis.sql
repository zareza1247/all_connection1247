 -- stockcode analysis

SELECT count(distinct(StockCode)) from `ecom_d_uk`;

SELECT 
    AVG(DistinctStockCount) AS AvgStockCodesPerCustomer
FROM (
    SELECT 
        CustomerID,
        COUNT(DISTINCT StockCode) AS DistinctStockCount
    FROM 
        `ecom_d_uk`
    GROUP BY 
        CustomerID
) AS CustomerStockCounts;
