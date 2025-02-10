use ecommercedata_uk;

CREATE TABLE sales_by_date (
    sales_date datetime,
    CustomerID varchar(15),
    gross_sales decimal(20,5),
    returns decimal(20,5),
    net_sales decimal(20,5)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/UK_ecommerce_gross_sales_etc3.csv'
INTO TABLE ecom_d_uk
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@sales_date, CustomerID, gross_sales, returns, net_sales)
SET sales_date = STR_TO_DATE(@InvoiceDate, '%d/%m/%Y'),
    CustomerID = NULLIF(@CustomerID, '');
    
-- 541909 row(s) affected, 4 warning(s): 1265 Data truncated for column 'UnitPrice' at row 157196 1265 Data truncated for column 'UnitPrice' at row 279046 1265 Data truncated for column 'UnitPrice' at row 359872 1265 Data truncated for column 'UnitPrice' at row 361742 Records: 541909  Deleted: 0  Skipped: 0  Warnings: 4


-- Error Code: 1264. Out of range value for column 'UnitPrice' at row 15017

-- sales_date CustomerID gross_sales returns net_sales
