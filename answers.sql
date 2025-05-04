-- Step 1: Create and populate the original table
CREATE TEMPORARY TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 2: Normalize to 1NF using a recursive CTE
WITH RECURSIVE product_split AS (
  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2) AS Remaining
  FROM ProductDetail

  UNION ALL

  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Remaining, ',', 1)),
    SUBSTRING(Remaining, LENGTH(SUBSTRING_INDEX(Remaining, ',', 1)) + 2)
  FROM product_split
  WHERE Remaining <> ''
)

SELECT OrderID, CustomerName, Product
FROM product_split
ORDER BY OrderID;


-- Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique OrderID–CustomerName pairs
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;
