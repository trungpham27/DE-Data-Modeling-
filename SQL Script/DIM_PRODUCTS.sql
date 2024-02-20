--Create Product Dimension Table
CREATE TABLE DIM_PRODUCTS(
	ProductID int PRIMARY KEY,
	ProductName nvarchar(40),
    QuantityPerUnit nvarchar(40) NOT NULL,
	UnitPrice decimal,
	UnitsInStock smallint,
	UnitsOnOrder smallint,
	ValidFrom datetime,
	ValidTo datetime
);

--Insert Data To DIM_PRODUCTS
INSERT INTO DIM_PRODUCTS(
	ProductID,
	ProductName,
	QuantityPerUnit,
	UnitPrice,
	UnitsInStock,
	UnitsOnOrder,
	ValidFrom,
	ValidTo
)
SELECT
	hp.ProductID,
	spg.ProductName,
	spg.QuantityPerUnit,
	CAST(pg.UnitPrice AS decimal),
	spg.UnitsInStock,
	spg.UnitsOnOrder,
	spg.LOAD_DTS AS ValidFrom,
	spg.END_DTS AS ValidTo
FROM H_PRODUCTS AS hp
INNER JOIN S_PRODUCTS_GENERAL AS spg
	ON hp.HK_ProductID = spg.HK_ProductID
WHERE spg.END_DTS = '9999-12-31'
