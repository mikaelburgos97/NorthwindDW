IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DimDate')
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATETIME,
    Year INT,
    Quarter INT,
    Month INT,
    MonthName NVARCHAR(10),
    Day INT,
    DayOfWeek INT,
    DayName NVARCHAR(10)
);

-- DimCustomer
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DimCustomer')
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NCHAR(5),
    CompanyName NVARCHAR(40),
    ContactName NVARCHAR(30),
    ContactTitle NVARCHAR(30),
    City NVARCHAR(15),
    Region NVARCHAR(15),
    Country NVARCHAR(15),
    Phone NVARCHAR(24),
    EffectiveDate DATETIME DEFAULT GETDATE(),
    ExpiryDate DATETIME DEFAULT NULL
);

-- DimProduct
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DimProduct')
CREATE TABLE DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(40),
    CategoryID INT,
    CategoryName NVARCHAR(15),
    UnitPrice MONEY,
    EffectiveDate DATETIME DEFAULT GETDATE(),
    ExpiryDate DATETIME DEFAULT NULL
);

-- DimEmployee
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DimEmployee')
CREATE TABLE DimEmployee (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    FirstName NVARCHAR(10),
    LastName NVARCHAR(20),
    Title NVARCHAR(30),
    HireDate DATETIME,
    ReportsTo INT,
    EffectiveDate DATETIME DEFAULT GETDATE(),
    ExpiryDate DATETIME DEFAULT NULL
);