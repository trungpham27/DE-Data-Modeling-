--Create Date Dimension Table
CREATE TABLE DIM_DATE(
    Date datetime PRIMARY KEY,
    Week int,
    Month int,
    Year int,
    Month int,
    Quarter int,
    Year int
);

--Insert Data To DIM_DATE
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = '2020-01-01' --TEST DATE
SET @EndDate = '2021-12-31' --TEST DATE

WHILE @StartDate <= @EndDate
    BEGIN
        INSERT INTO DIM_DATE
        (
            Date
            Week,
            Month,
            Quarter,
            Year
        )
        SELECT
            @StartDate
            DATEPART(Week,[@StartDate]) AS Week,
            DATEPART(Month,[OrderDate]) As Month,
            DATEPART(Quarter,[OrderDate]) As Quarter,
            DATEPART(Year,[OrderDate]) As Year
        SET @StartDate = DATEADD(dd, 1, @StartDate)
    END