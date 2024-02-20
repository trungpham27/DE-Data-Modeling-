--Create Employee Dimension Table
CREATE TABLE DIM_EMPLOYEES(
	EmployeeID int PRIMARY KEY,
    LastName nvarchar(20) NOT NULL,
    FirstName nvarchar(10) NOT NULL,
    Title nvarchar(30),
    TitleOfCOurtesy nvarchar(25),
    BirthDate datetime,
    HireDate datetime NOT NULL, 
    ResignDate datetime,
    Address nvarchar(60),
    HomePhone nvarchar(24),
);

--Insert Data To DIM_EMPLOYEES
INSERT INTO DIM_EMPLOYEES(
    EmployeeID,
    LastName,
    FirstName ,
    Title,
    TitleOfCOurtesy,
    BirthDate,
    HireDate, 
    ResignDate,
    Address,
    HomePhone,
)
SELECT
    he.EmployeeID,
    seg.LastName,
    seg.FirstName,
    seg.Title,
    seg.TitleOfCOurtesy,
    seg.BirthDate,
    seg.HireDate,
    seg.END_DTS,
    sec.Address,
    sec.HomePhone
FROM H_EMPLOYEES AS he
INNER JOIN S_EMPLOYEES_GENERAL AS seg
    ON he.HK_EmployeeID = seg.EmployeeID
INNER JOIN S_EMPLOYEES_CONTACT AS sec
    ON he.HK_EmployeeID = sec.HK_EmployeeID
WHERE
    seg.END_DTS = '9999-12-31'
    AND sec.END_DTS = '9999-12-31'