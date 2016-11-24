CREATE DATABASE product_db
    ON ( NAME = N'product_db_data', FILENAME = N'/mssql-data/product_db.mdf')
    LOG ON ( NAME = N'product_db_log', FILENAME = N'/mssql-data/product_db.ldf')
GO

USE product_db;
GO

CREATE TABLE inventory (id INT, name NVARCHAR(50), quantity INT);
GO
