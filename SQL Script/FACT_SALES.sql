--Create Sales Fact Table
CREATE TABLE FACT_SALES(
    EmployeeID int FOREIGN KEY REFERENCES DIM_EMPLOYEES(EmployeeID),
    ProductID int FOREIGN KEY REFERENCES DIM_PRODUCTS(ProductID),
    CustomerID nchar(5) FOREIGN KEY REFERENCES DIM_CUSTOMERS(CustomerID),
    Date datetime FOREIGN KEY REFERENCES DIM_DATE(Date),
    Revenue money,
    UnitsSold smallint,
    PRIMARY KEY (EmployeeID, ProductID, CustomerID, Date),
);

--Insert Data To FACT_SALES
INSERT INTO FACT_SALES(
    EmployeeID,
    ProductID,
    CustomerID,
	Date,
    Revenue,
    UnitsSold
)
SELECT
    he.EmployeeID,
    hp.ProductID,
    hc.CustomerID,
    sod.OrderDate,
    sopd.UnitPrice*sopd.Quantity*(1-sopd.Discount),
    sopd.Quantity
FROM H_ORDERS AS ho
--Get EmployeeID
INNER JOIN L_ORD_EE AS loe
    ON ho.HK_OrderID = loe.HK_OrderID
INNER JOIN H_EMPLOYEES AS he
    ON loe.HK_EmployeeID = he.HK_EmployeeID
--Get ProductID
INNER JOIN L_ORD_PROD AS lop
    ON ho.HK_OrderID = lop.HK_OrderID
INNER JOIN H_PRODUCTS AS hp
    ON lop.HK_ProductID = hp.HK_ProductID
--Get CustomerID
INNER JOIN L_ORD_CUST AS loc
    ON ho.HK_OrderID = loc.HK_OrderID
INNER JOIN H_CUSTOMERS AS hc
    ON loc.HK_CustomerID = hc.HK_CustomerID
--Get Date
INNER JOIN S_ORDERS_DETAILS AS sod
    ON ho.HK_OrderID = sod.HK_OrderID
--Get Units Sold (Quantity)
INNER JOIN S_ORD_PROD_DETAILS AS sopd
    ON lop.HK_ORD_PROD = sopd.HK_ORD_PROD
WHERE
    sopd.END_DTS = '9999-12-31'
    sod.END_DTS = '9999-12-31'