-- Verificar la carga de datos en FactOrders
SELECT COUNT(*) AS OrdersCount FROM FactOrders;

-- Verificar la carga de datos en FactClientesAtendidos
SELECT COUNT(*) AS ClientesAtendidosCount FROM FactClientesAtendidos;

-- Verificar la carga de datos en FactOrderDetails
SELECT COUNT(*) AS OrderDetailsCount FROM FactOrderDetails;

-- Ejemplos de consultas para análisis
-- Top 5 clientes por monto total
SELECT TOP 5
    dc.CompanyName,
    SUM(fca.TotalSpent) AS TotalGastado
FROM 
    FactClientesAtendidos fca
JOIN 
    DimCustomer dc ON fca.CustomerKey = dc.CustomerKey
GROUP BY 
    dc.CompanyName
ORDER BY 
    TotalGastado DESC;

-- Top 5 productos más vendidos
SELECT TOP 5
    dp.ProductName,
    SUM(fod.Quantity) AS CantidadTotal,
    SUM(fod.LineTotal) AS MontoTotal
FROM 
    FactOrderDetails fod
JOIN 
    DimProduct dp ON fod.ProductKey = dp.ProductKey
GROUP BY 
    dp.ProductName
ORDER BY 
    CantidadTotal DESC;

-- Ventas por país
SELECT 
    fo.ShipCountry,
    COUNT(DISTINCT fo.OrderID) AS NumeroOrdenes,
    SUM(fod.LineTotal) AS MontoTotal
FROM 
    FactOrders fo
JOIN 
    FactOrderDetails fod ON fo.OrderKey = fod.OrderKey
GROUP BY 
    fo.ShipCountry
ORDER BY 
    MontoTotal DESC;

-- Rendimiento de empleados
SELECT 
    de.FirstName + ' ' + de.LastName AS NombreEmpleado,
    COUNT(DISTINCT fo.OrderID) AS NumeroOrdenes,
    SUM(fod.LineTotal) AS MontoVentas
FROM 
    FactOrders fo
JOIN 
    FactOrderDetails fod ON fo.OrderKey = fod.OrderKey
JOIN 
    DimEmployee de ON fo.EmployeeKey = de.EmployeeKey
GROUP BY 
    de.FirstName + ' ' + de.LastName
ORDER BY 
    MontoVentas DESC;