-- FactOrders
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactOrders')
CREATE TABLE FactOrders (
    OrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    DateKey INT,
    RequiredDateKey INT,
    ShippedDateKey INT,
    CustomerKey INT,
    EmployeeKey INT,
    ShipVia INT,
    Freight MONEY,
    ShipName NVARCHAR(40),
    ShipCity NVARCHAR(15),
    ShipRegion NVARCHAR(15),
    ShipCountry NVARCHAR(15),
    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (RequiredDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (ShippedDateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    FOREIGN KEY (EmployeeKey) REFERENCES DimEmployee(EmployeeKey)
);

-- FactClientesAtendidos
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactClientesAtendidos')
CREATE TABLE FactClientesAtendidos (
    ClienteAtendidoKey INT IDENTITY(1,1) PRIMARY KEY,
    DateKey INT,
    CustomerKey INT,
    EmployeeKey INT,
    OrderCount INT,
    LastOrderDate DATETIME,
    TotalSpent MONEY,
    FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomer(CustomerKey),
    FOREIGN KEY (EmployeeKey) REFERENCES DimEmployee(EmployeeKey)
);

-- FactOrderDetails
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'FactOrderDetails')
CREATE TABLE FactOrderDetails (
    OrderDetailKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderKey INT,
    ProductKey INT,
    UnitPrice MONEY,
    Quantity SMALLINT,
    Discount REAL,
    LineTotal MONEY,
    FOREIGN KEY (OrderKey) REFERENCES FactOrders(OrderKey),
    FOREIGN KEY (ProductKey) REFERENCES DimProduct(ProductKey)
);