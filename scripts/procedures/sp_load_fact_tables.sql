-- Procedimiento para limpiar las tablas de hechos
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_CleanFactTables')
    DROP PROCEDURE sp_CleanFactTables
GO

CREATE PROCEDURE sp_CleanFactTables
AS
BEGIN
    -- Eliminar registros en el orden correcto
    DELETE FROM FactOrderDetails;
    DELETE FROM FactClientesAtendidos;
    DELETE FROM FactOrders;
    
    PRINT 'Fact tables cleaned successfully.';
END
GO

-- Procedimiento para cargar FactOrders
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadFactOrders')
    DROP PROCEDURE sp_LoadFactOrders
GO

CREATE PROCEDURE sp_LoadFactOrders
AS
BEGIN
    -- Insertar órdenes
    INSERT INTO FactOrders (
        OrderID,
        DateKey,
        RequiredDateKey,
        ShippedDateKey,
        CustomerKey,
        EmployeeKey,
        ShipVia,
        Freight,
        ShipName,
        ShipCity,
        ShipRegion,
        ShipCountry
    )
    SELECT 
        o.OrderID,
        ISNULL(CONVERT(INT, CONVERT(VARCHAR, o.OrderDate, 112)), -1) AS DateKey,
        ISNULL(CONVERT(INT, CONVERT(VARCHAR, o.RequiredDate, 112)), -1) AS RequiredDateKey,
        ISNULL(CONVERT(INT, CONVERT(VARCHAR, o.ShippedDate, 112)), -1) AS ShippedDateKey,
        dc.CustomerKey,
        de.EmployeeKey,
        o.ShipVia,
        o.Freight,
        o.ShipName,
        o.ShipCity,
        o.ShipRegion,
        o.ShipCountry
    FROM 
        Northwind.dbo.Orders o
    JOIN 
        DimCustomer dc ON o.CustomerID = dc.CustomerID
    JOIN 
        DimEmployee de ON o.EmployeeID = de.EmployeeID
    LEFT JOIN 
        FactOrders fo ON o.OrderID = fo.OrderID
    WHERE 
        fo.OrderID IS NULL;
        
    PRINT 'FactOrders loaded successfully.';
END
GO

-- Procedimiento para cargar FactOrderDetails
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadFactOrderDetails')
    DROP PROCEDURE sp_LoadFactOrderDetails
GO

CREATE PROCEDURE sp_LoadFactOrderDetails
AS
BEGIN
    -- Insertar detalles de órdenes
    INSERT INTO FactOrderDetails (
        OrderKey,
        ProductKey,
        UnitPrice,
        Quantity,
        Discount,
        LineTotal
    )
    SELECT 
        fo.OrderKey,
        dp.ProductKey,
        od.UnitPrice,
        od.Quantity,
        od.Discount,
        od.UnitPrice * od.Quantity * (1 - od.Discount) AS LineTotal
    FROM 
        Northwind.dbo.[Order Details] od
    JOIN 
        FactOrders fo ON od.OrderID = fo.OrderID
    JOIN 
        DimProduct dp ON od.ProductID = dp.ProductID
    LEFT JOIN 
        FactOrderDetails fod ON fo.OrderKey = fod.OrderKey AND dp.ProductKey = fod.ProductKey
    WHERE 
        fod.OrderDetailKey IS NULL;
        
    PRINT 'FactOrderDetails loaded successfully.';
END
GO

-- Procedimiento para cargar FactClientesAtendidos
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadFactClientesAtendidos')
    DROP PROCEDURE sp_LoadFactClientesAtendidos
GO

CREATE PROCEDURE sp_LoadFactClientesAtendidos
AS
BEGIN
    -- Calcular clientes atendidos
    INSERT INTO FactClientesAtendidos (
        DateKey,
        CustomerKey,
        EmployeeKey,
        OrderCount,
        LastOrderDate,
        TotalSpent
    )
    SELECT 
        CONVERT(INT, CONVERT(VARCHAR, MAX(o.OrderDate), 112)) AS DateKey,
        dc.CustomerKey,
        de.EmployeeKey,
        COUNT(DISTINCT o.OrderID) AS OrderCount,
        MAX(o.OrderDate) AS LastOrderDate,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpent
    FROM 
        Northwind.dbo.Orders o
    JOIN 
        Northwind.dbo.[Order Details] od ON o.OrderID = od.OrderID
    JOIN 
        DimCustomer dc ON o.CustomerID = dc.CustomerID
    JOIN 
        DimEmployee de ON o.EmployeeID = de.EmployeeID
    JOIN 
        DimDate dd ON CONVERT(INT, CONVERT(VARCHAR, o.OrderDate, 112)) = dd.DateKey
    GROUP BY 
        dc.CustomerKey, de.EmployeeKey;
        
    PRINT 'FactClientesAtendidos loaded successfully.';
END
GO