use ecommercedata_uk;

CREATE TABLE ecom_d_uk (
    InvoiceNo varchar(15),
    StockCode varchar(15),
    Description varchar(200),
    Quantity INT,
    InvoiceDate datetime,
    UnitPrice decimal(20,5),
    CustomerID INT,
    Country varchar(40)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/UK_retailer_ecommerce_data.csv'
INTO TABLE ecom_d_uk
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(InvoiceNo, StockCode, Description, Quantity, @InvoiceDate, UnitPrice, @CustomerID, Country)
SET InvoiceDate = STR_TO_DATE(@InvoiceDate, '%m/%d/%Y %H:%i'),
    CustomerID = NULLIF(@CustomerID, '');
    
-- 541909 row(s) affected, 4 warning(s): 1265 Data truncated for column 'UnitPrice' at row 157196 1265 Data truncated for column 'UnitPrice' at row 279046 1265 Data truncated for column 'UnitPrice' at row 359872 1265 Data truncated for column 'UnitPrice' at row 361742 Records: 541909  Deleted: 0  Skipped: 0  Warnings: 4


-- Error Code: 1264. Out of range value for column 'UnitPrice' at row 15017
