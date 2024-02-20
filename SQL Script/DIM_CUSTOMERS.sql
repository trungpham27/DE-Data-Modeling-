--Create Customer Dimension Table
CREATE TABLE DIM_CUSTOMERS(
	CustomerID nchar(5) PRIMARY KEY,
    ContactTitle nvarchar(30),
    ContactName nvarchar (30),
    CompanyName nvarchar(40),
    Address nvarchar(60),
    City nvarchar(15),
    Region nvarchar(15),
    PostalCOde nvarchar(10),
    Country nvarchar(15),
    Phone nvarchar(24),
    Fax nvarchar(24),
);

--Insert Data To DIM_CUSTOMERS
INSERT INTO DIM_PRODUCTS(
    CustomerID,
    ContactTitle,
    ContactName,
    CompanyName,
    Address,
    City,
    Region,
    PostalCOde,
    Country,
    Phone,
    Fax
)
SELECT
    hc.CustomerID,
    scg.ContactTitle,
    scg.ContactName,
    scg.CompanyName,
    scc.Address,
    scc.City,
    scc.Region,
    scc.PostalCOde,
    scc.Country,
    scc.Phone,
    scc.Fax
FROM H_CUSTOMERS AS hc
INNER JOIN S_CUSTOMERS_GENERAL AS scg
    ON hc.HK_CustomerID = scg.HK_CustomerID
INNER JOIN S_CUSTOMERS_CONTACT AS scc
    ON hc.HK_CustomerID = scc.HK_CustomerID
WHERE
    scg.END_DTS = '9999-12-31'
    AND scc.END_DTS = '9999-12-31'