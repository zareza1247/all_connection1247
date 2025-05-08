CREATE TABLE ecommercedata_uk.investigate_n_quantity (
    StockCode VARCHAR(20),
    Purchase_CustomerID INT,
    Return_CustomerID INT,
    Purchased_Quantity INT,
    Returned_Quantity INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/investigate_n_quantity.csv' 
INTO TABLE ecommercedata_uk.investigate_n_quantity
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- ygkgy