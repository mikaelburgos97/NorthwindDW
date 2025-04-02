-- Procedimiento para poblar DimDate (ejecutar una sola vez)
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_PopulateDimDate')
    DROP PROCEDURE sp_PopulateDimDate
GO

CREATE PROCEDURE sp_PopulateDimDate
AS
BEGIN
    DECLARE @StartDate DATETIME = '1996-01-01'
    DECLARE @EndDate DATETIME = '1998-12-31'
    
    DECLARE @CurrentDate DATETIME = @StartDate
    
    -- Verificar si ya existen fechas en la tabla
    IF EXISTS (SELECT TOP 1 1 FROM DimDate WHERE DateKey > 0)
    BEGIN
        PRINT 'DimDate already populated. Skipping date population.';
        RETURN;
    END
    
    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Verificar si la fecha ya existe antes de insertarla
        IF NOT EXISTS (SELECT 1 FROM DimDate WHERE DateKey = CONVERT(INT, CONVERT(VARCHAR, @CurrentDate, 112)))
        BEGIN
            INSERT INTO DimDate (
                DateKey,
                FullDate,
                Year,
                Quarter,
                Month,
                MonthName,
                Day,
                DayOfWeek,
                DayName
            )
            VALUES (
                CONVERT(INT, CONVERT(VARCHAR, @CurrentDate, 112)),
                @CurrentDate,
                YEAR(@CurrentDate),
                DATEPART(QUARTER, @CurrentDate),
                MONTH(@CurrentDate),
                DATENAME(MONTH, @CurrentDate),
                DAY(@CurrentDate),
                DATEPART(WEEKDAY, @CurrentDate),
                DATENAME(WEEKDAY, @CurrentDate)
            )
        END
        
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate)
    END
    
    -- Agregar un registro para fechas NULL si no existe
    IF NOT EXISTS (SELECT 1 FROM DimDate WHERE DateKey = -1)
    BEGIN
        INSERT INTO DimDate (
            DateKey,
            FullDate,
            Year,
            Quarter,
            Month,
            MonthName,
            Day,
            DayOfWeek,
            DayName
        )
        VALUES (
            -1,
            NULL,
            -1,
            -1,
            -1,
            'Unknown',
            -1,
            -1,
            'Unknown'
        )
    END
    
    PRINT 'DimDate populated successfully.';
END
GO

-- Procedimiento para cargar DimCustomer
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadDimCustomer')
    DROP PROCEDURE sp_LoadDimCustomer
GO

CREATE PROCEDURE sp_LoadDimCustomer
AS
BEGIN
    -- Insertar nuevos clientes
    INSERT INTO DimCustomer (
        CustomerID,
        CompanyName,
        ContactName,
        ContactTitle,
        City,
        Region,
        Country,
        Phone
    )
    SELECT 
        c.CustomerID,
        c.CompanyName,
        c.ContactName,
        c.ContactTitle,
        c.City,
        c.Region,
        c.Country,
        c.Phone
    FROM 
        Northwind.dbo.Customers c
    LEFT JOIN 
        DimCustomer dc ON c.CustomerID = dc.CustomerID
    WHERE 
        dc.CustomerID IS NULL;
        
    PRINT 'DimCustomer loaded successfully.';
END
GO

-- Procedimiento para cargar DimEmployee
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadDimEmployee')
    DROP PROCEDURE sp_LoadDimEmployee
GO

CREATE PROCEDURE sp_LoadDimEmployee
AS
BEGIN
    -- Insertar nuevos empleados
    INSERT INTO DimEmployee (
        EmployeeID,
        FirstName,
        LastName,
        Title,
        HireDate,
        ReportsTo
    )
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Title,
        e.HireDate,
        e.ReportsTo
    FROM 
        Northwind.dbo.Employees e
    LEFT JOIN 
        DimEmployee de ON e.EmployeeID = de.EmployeeID
    WHERE 
        de.EmployeeID IS NULL;
        
    PRINT 'DimEmployee loaded successfully.';
END
GO

-- Procedimiento para cargar DimProduct
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadDimProduct')
    DROP PROCEDURE sp_LoadDimProduct
GO

CREATE PROCEDURE sp_LoadDimProduct
AS
BEGIN
    -- Insertar nuevos productos
    INSERT INTO DimProduct (
        ProductID,
        ProductName,
        CategoryID,
        CategoryName,
        UnitPrice
    )
    SELECT 
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        c.CategoryName,
        p.UnitPrice
    FROM 
        Northwind.dbo.Products p
    JOIN 
        Northwind.dbo.Categories c ON p.CategoryID = c.CategoryID
    LEFT JOIN 
        DimProduct dp ON p.ProductID = dp.ProductID
    WHERE 
        dp.ProductID IS NULL;
        
    PRINT 'DimProduct loaded successfully.';
END
GO