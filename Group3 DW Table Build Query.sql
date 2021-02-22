/****** Object:  Database ist722_kvogel_dw    Script Date: 6/4/2020 1:46:24 PM ******/
/*
Kimball Group, The Microsoft Data Warehouse Toolkit
Generate a database from the datamodel worksheet, version: 4

You can use this Excel workbook as a data modeling tool during the logical design phase of your project.
As discussed in the book, it is in some ways preferable to a real data modeling tool during the inital design.
We expect you to move away from this spreadsheet and into a real modeling tool during the physical design phase.
The authors provide this macro so that the spreadsheet isn't a dead-end. You can 'import' into your
data modeling tool by generating a database using this script, then reverse-engineering that database into
your tool.

Uncomment the next lines if you want to drop and create the database
*/
/*
DROP DATABASE ist722_kvogel_dw
GO
CREATE DATABASE ist722_kvogel_dw
GO
ALTER DATABASE ist722_kvogel_dw
SET RECOVERY SIMPLE
GO
*/
USE ist722_hhkhan_oc3_dw

/*
-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA Fudgemart
GO

*/

/* Drop table Fudgemart.FactSales */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Fudgemart.FactSales') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Fudgemart.FactSales 
;

/* Create table Fudgemart.FactSales */
CREATE TABLE Fudgemart.FactSales (
   [CustomerKey]  int NOT NULL
,  [ProductKey]  int NOT NULL
,  [OrderDateKey]  int  NOT NULL
,  [OrderID]  int   NOT NULL
,  [OrderQuantity]  int   NOT NULL
,  [OrderAmount]  money   NOT NULL
, CONSTRAINT [PK_Fudgemart.FactSales] PRIMARY KEY NONCLUSTERED 
( [ProductKey], [OrderID] )
) ON [PRIMARY]
;

GO

/* Drop table Fudgemart.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Fudgemart.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Fudgemart.DimDate 
;

/* Create table Fudgemart.DimDate */
CREATE TABLE Fudgemart.DimDate (
   [DateKey]  int   NOT NULL
,  [Date]  datetime   NULL
,  [FullDateUSA]  nchar(11)   NOT NULL
,  [DayOfWeek]  tinyint   NOT NULL
,  [DayName]  nchar(10)   NOT NULL
,  [DayOfMonth]  tinyint   NOT NULL
,  [DayOfYear]  int   NOT NULL
,  [WeekOfYear]  tinyint   NOT NULL
,  [MonthName]  nchar(10)   NOT NULL
,  [MonthOfYear]  tinyint   NOT NULL
,  [Quarter]  tinyint   NOT NULL
,  [QuarterName]  nchar(10)   NOT NULL
,  [Year]  int   NOT NULL
,  [IsWeekday]  bit  DEFAULT 0 NOT NULL
, CONSTRAINT [PK_Fudgemart.DimDate] PRIMARY KEY CLUSTERED 
( [DateKey] )
) ON [PRIMARY]
;

INSERT INTO Fudgemart.DimDate (DateKey, Date, FullDateUSA, DayOfWeek, DayName, DayOfMonth, DayOfYear, WeekOfYear, MonthName, MonthOfYear, Quarter, QuarterName, Year, IsWeekday)
VALUES (-1, '', 'Unk date', 0, 'Unk date', 0, 0, 0, 'Unk month', 0, 0, 'Unk qtr', 0, 0)
;


/* Drop table Fudgemart.DimProduct */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Fudgemart.DimProduct') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Fudgemart.DimProduct 
;

/* Create table Fudgemart.DimProduct */
CREATE TABLE Fudgemart.DimProduct (
   [ProductKey]  int IDENTITY  NOT NULL
,  [ProductID]  int   NOT NULL
,  [Subsidiary]  char(9)   NULL
,  [VendorName]  varchar(50)   NOT NULL
,  [ProductName]  varchar(50)   NOT NULL
,  [ProductDepartment]  varchar(20)   NOT NULL
,  [ProductStatus]  varchar(1)   NOT NULL
,  [ProductIsActive]  bit   NOT NULL
,  [ProductPrice]  money   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_Fudgemart.DimProduct] PRIMARY KEY CLUSTERED 
( [ProductKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT Fudgemart.DimProduct ON
;
INSERT INTO Fudgemart.DimProduct (ProductKey, ProductID, Subsidiary, VendorName, ProductName, ProductDepartment, ProductStatus, ProductIsActive, ProductPrice, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'UNK', 'UNK', 'UNK', 'UNK', '?', 0, 0, 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT Fudgemart.DimProduct OFF
;


/* Drop table Fudgemart.DimCustomer */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Fudgemart.DimCustomer') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Fudgemart.DimCustomer 
;

/* Create table Fudgemart.DimCustomer */
CREATE TABLE Fudgemart.DimCustomer (
   [CustomerKey]  int IDENTITY  NOT NULL
,  [CustomerID]  int   NOT NULL
,  [Susidiary]  char(9)   NULL
,  [Email]  varchar(200)  DEFAULT 'Not Listed' NOT NULL
,  [CustomerName]  varchar(101)   NOT NULL
,  [CustomerCity]  varchar(50)   NOT NULL
,  [CustomerState]  char(2)   NOT NULL
,  [ZipCode]  varchar(5)   NOT NULL
,  [RowIsCurrent]  nchar(1)   NOT NULL
,  [RowStartDate]  datetime   NOT NULL
,  [RowEndDate]  datetime  DEFAULT '12/31/9999' NOT NULL
,  [RowChangeReason]  nvarchar(200)   NOT NULL
, CONSTRAINT [PK_Fudgemart.DimCustomer] PRIMARY KEY CLUSTERED 
( [CustomerKey] )
) ON [PRIMARY]
;


SET IDENTITY_INSERT Fudgemart.DimCustomer ON
;
INSERT INTO Fudgemart.DimCustomer (CustomerKey, CustomerID, Susidiary, Email, CustomerName, CustomerCity, CustomerState, ZipCode, RowIsCurrent, RowStartDate, RowEndDate, RowChangeReason)
VALUES (-1, -1, 'Unknown', 'Unknown', 'Unknown', 'Unknown', 'NK', 'UNK', 'Y', '12/31/1899', '12/31/9999', 'N/A')
;
SET IDENTITY_INSERT Fudgemart.DimCustomer OFF
;

