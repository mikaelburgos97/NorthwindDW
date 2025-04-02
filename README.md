# ETL para Data Warehouse Northwind

Este repositorio contiene los scripts SQL necesarios para implementar un proceso ETL que carga datos desde la base de datos Northwind a un Data Warehouse.

## Estructura del Repositorio

- `/scripts/tables/`: Scripts para crear las tablas de dimensiones y hechos
  - `create_dim_tables.sql`: Crea las tablas de dimensiones
  - `create_fact_tables.sql`: Crea las tablas de hechos

- `/scripts/procedures/`: Procedimientos almacenados para el proceso ETL
  - `sp_populate_dim_tables.sql`: Procedimientos para cargar las dimensiones
  - `sp_load_fact_tables.sql`: Procedimientos para cargar las tablas de hechos

- `/scripts/etl/`: Proceso ETL completo
  - `run_etl_process.sql`: Procedimiento maestro para ejecutar el proceso ETL

- `/scripts/validation/`: Scripts para verificar los resultados
  - `verify_data_load.sql`: Consultas para verificar la carga correcta de datos

## Requisitos

- SQL Server
- Base de datos Northwind instalada

## Instalación y Uso

1. Crear una base de datos para el Data Warehouse:
   ```sql
   CREATE DATABASE DWNorthwind;
   USE DWNorthwind;

Ejecutar los scripts en el siguiente orden:

/scripts/tables/create_dim_tables.sql
/scripts/tables/create_fact_tables.sql
/scripts/procedures/sp_populate_dim_tables.sql
/scripts/procedures/sp_load_fact_tables.sql
/scripts/etl/run_etl_process.sql


Verificar los resultados con:

/scripts/validation/verify_data_load.sql



Descripción del Proceso ETL
El proceso ETL implementado incluye:

Extracción: Los datos se extraen de las tablas de Northwind (Orders, Customers, Order Details, etc.).
Transformación: Se aplican transformaciones para adaptar los datos al modelo de Data Warehouse.
Carga: Los datos transformados se cargan en las tablas de dimensiones y hechos del Data Warehouse.

Tablas de Hechos Implementadas

FactOrders: Contiene información sobre los pedidos, incluyendo fechas, cliente, empleado, costos de envío, etc.
FactClientesAtendidos: Contiene información sobre los clientes atendidos, incluyendo conteo de órdenes, fechas y montos.
FactOrderDetails: Contiene los detalles de los productos en cada pedido, incluyendo precios, cantidades y descuentos.

Proceso de Limpieza
Antes de cargar los datos, se ejecuta un proceso de limpieza que elimina los registros existentes en las tablas de hechos, asegurando que no haya duplicados.
Autor
Mikael Burgos - 2020-9410
Copiar
### 2. /scripts/tables/create_dim_tables.sql


