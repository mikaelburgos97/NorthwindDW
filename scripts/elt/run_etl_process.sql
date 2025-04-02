-- Procedimiento maestro para ejecutar todo el proceso ETL
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_RunETLProcess')
    DROP PROCEDURE sp_RunETLProcess
GO

CREATE PROCEDURE sp_RunETLProcess
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        PRINT 'Starting ETL process...';
        
        -- Limpiar tablas de hechos
        EXEC sp_CleanFactTables;
        
        -- Verificar si DimDate ya está poblada
        IF NOT EXISTS (SELECT TOP 1 1 FROM DimDate WHERE DateKey > 0)
        BEGIN
            -- Cargar dimensiones solo si es necesario
            EXEC sp_PopulateDimDate;
        END
        ELSE
        BEGIN
            PRINT 'DimDate already populated. Skipping date population.';
        END
        
        -- Cargar otras dimensiones
        EXEC sp_LoadDimCustomer;
        EXEC sp_LoadDimEmployee;
        EXEC sp_LoadDimProduct;
        
        -- Cargar tablas de hechos
        EXEC sp_LoadFactOrders;
        EXEC sp_LoadFactOrderDetails;
        EXEC sp_LoadFactClientesAtendidos;
        
        COMMIT TRANSACTION;
        PRINT 'ETL process completed successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        PRINT 'ETL process failed with error: ' + @ErrorMessage;
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Ejecutar el proceso ETL
EXEC sp_RunETLProcess;