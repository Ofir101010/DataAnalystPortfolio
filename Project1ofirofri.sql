-- Project name: Project1ofirofri
-- Submit date:3-5-2023
-- Name: Ofir Ofri

-- Creating new database:
USE master
CREATE DATABASE Project1_db
USE Project1_db

-- CREATE TABLE:
CREATE TABLE SalesTerritory
(TerritoryID INT CONSTRAINT SalesTerritory_TerritoryID_PK PRIMARY KEY,
Name NVARCHAR(50) NOT NULL CONSTRAINT SalesTerritory_Name_UK UNIQUE
CONSTRAINT SalesTerritory_Name_CK CHECK (len(name)>2),
CountryRegionCode NVARCHAR(3) NOT NULL,
[Group] NVARCHAR(50) NOT NULL,
SalesYTD MONEY NOT NULL,
SalesLastYear MONEY NOT NULL,
CostYTD MONEY NOT NULL,
CostLastYear MONEY NOT NULL,
ModifiedDate DATETIME NOT NULL DEFAULT '30/04/2008')

-- INSERT VALUES INTO TABLE:
INSERT INTO SalesTerritory
SELECT [TerritoryID],[Name],[CountryRegionCode],[Group],[SalesYTD],
[SalesLastYear],[CostYTD],[CostLastYear],[ModifiedDate]
FROM TEMPSalesTerritory



-- CREATE TABLE:
CREATE TABLE Customer
(CustomerID INT IDENTITY(1,1) CONSTRAINT Customer_CustomerID_PK PRIMARY KEY,
PersonID INT NULL,
StoreID INT NULL,
TerritoryID INT NULL
CONSTRAINT Customer_TerritoryID_FK FOREIGN KEY(TerritoryID)REFERENCES SalesTerritory(TerritoryID), 
ModifiedDate DATETIME NOT NULL DEFAULT CAST('15:07:3' as DATETIME))

-- INSERT VALUES INTO TABLE:
SET IDENTITY_INSERT Customer ON
INSERT INTO Customer(CustomerID,PersonID,StoreID,TerritoryID,ModifiedDate)
SELECT CustomerID,PersonID,StoreID,TerritoryID,ModifiedDate 
FROM Tempcustomer
SET IDENTITY_INSERT Customer OFF


-- CREATE TABLE:
 CREATE TABLE SalesPerson
 (BusinessEntityID INT IDENTITY(274,1)
 CONSTRAINT SalesPerson_BuisnessEntityID_PK PRIMARY KEY,
 TerritoryID INT NULL
 CONSTRAINT SalesPerson_TerritoryID_FK FOREIGN KEY(TerritoryID)REFERENCES SalesTerritory(TerritoryID),
 SalesQuota MONEY NULL,
 Bonus MONEY NOT NULL,
 CommissionPct SMALLMONEY NOT NULL,
 SalesYTD MONEY NOT NULL,
 SalesLastYear MONEY NOT NULL,
 ModifiedDate DATETIME NOT NULL)

 -- INSERT VALUES INTO TABLE:
 SET IDENTITY_INSERT SalesPerson ON
 INSERT INTO SalesPerson(BusinessEntityID,TerritoryID,SalesQuota,Bonus,CommissionPct,
 SalesYTD,SalesLastYear,ModifiedDate)
 SELECT BusinessEntityID,TerritoryID,SalesQuota,Bonus,CommissionPct,
 SalesYTD,SalesLastYear,ModifiedDate
 FROM TempSalesPerson
 SET IDENTITY_INSERT SalesPerson OFF
 


 -- CREATE TABLE:
 CREATE TABLE CreditCard
 (CreditCardID INT IDENTITY(1,1) CONSTRAINT CreditCard_CreditCardID_PK PRIMARY KEY,
 CardType NVARCHAR(50) NOT NULL,
 CardNumber NVARCHAR(25) NOT NULL
 CONSTRAINT CreditCard_CardNumber_CK CHECK(len(CardNumber)=14),
 ExpMonth TINYINT NOT NULL CONSTRAINT CreditCard_ExpMonth_CK CHECK(len(ExpMonth)<=12),
 ExpYear SMALLINT NOT NULL CONSTRAINT CreditCard_ExpYear_CK CHECK (ExpYear like '2___'),
 ModifiedDate DATETIME NOT NULL)

-- INSERT VALUES INTO TABLE:
SET IDENTITY_INSERT CreditCard ON
INSERT INTO CreditCard(CreditCardID,CardType,CardNumber,ExpMonth,ExpYear,ModifiedDate)
SELECT CreditCardID,CardType,CardNumber,ExpMonth,ExpYear,ModifiedDate
FROM TempCreditCard
SET IDENTITY_INSERT CreditCard OFF



-- CREATE TABLE:
CREATE TABLE ShipMethod
(ShipMethodID INT IDENTITY(1,1)
CONSTRAINT ShipMethod_ShipMethodID_PK PRIMARY KEY,
Name NVARCHAR(50) NOT NULL,
ShipBase MONEY NOT NULL,
ShipRate MONEY NOT NULL,
ModifiedDate DATETIME NOT NULL DEFAULT '30/04/2008')

-- INSERT VALUES INTO TABLE:
SET IDENTITY_INSERT ShipMethod ON
INSERT INTO ShipMethod (ShipMethodID,Name,ShipBase,ShipRate,ModifiedDate)
SELECT ShipMethodID,Name,ShipBase,ShipRate,ModifiedDate
FROM TempShipMethod
SET IDENTITY_INSERT ShipMethod OFF



-- CRATE TABLE:
CREATE TABLE CurrencyRate
(CurrencyRateID INT IDENTITY (1,1) CONSTRAINT CurrencyRate_CurrencyRateID_PK PRIMARY KEY,
CurrencyRateDate DATETIME NOT NULL,
FromCurrencyCode NCHAR(3) NOT NULL DEFAULT 'USD',
ToCurrencyCode NCHAR(3) NOT NULL,
AverageRate MONEY NOT NULL,
EndOfDayRate MONEY NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- INSERT VALUES INTO TABLE:
SET IDENTITY_INSERT CurrencyRate ON
INSERT INTO CurrencyRate(CurrencyRateID,CurrencyRateDate,FromCurrencyCode,
ToCurrencyCode,AverageRate,EndOfDayRate,ModifiedDate)
SELECT CurrencyRateID,CurrencyRateDate,FromCurrencyCode,
ToCurrencyCode,AverageRate,EndOfDayRate,ModifiedDate
FROM TempCurrencyRate
SET IDENTITY_INSERT CurrencyRate OFF



-- CREATE TABLE:
CREATE TABLE Address
(AddressID INT CONSTRAINT Address_AdressID_PK PRIMARY KEY,
AddressLine1 NVARCHAR(60) NOT NULL,
AddressLine2 NVARCHAR(60) NULL,
City NVARCHAR (30) NOT NULL,
StateProvinceID INT NOT NULL,
PostalCode NVARCHAR(15) NOT NULL,
ModifiedDate DATETIME NOT NULL)

-- INSERT VALUES INTO TABLE
INSERT INTO Address(AddressID,AddressLine1,AddressLine2,City,
StateProvinceID,PostalCode,ModifiedDate)
SELECT AddressID,AddressLine1,AddressLine2,City,
StateProvinceID,PostalCode,ModifiedDate 
FROM TempAddress


-- CREATE TABLE:
 CREATE TABLE SpecialOfferProduct
(SpecialOfferID INT NOT NULL,
 ProductID INT NOT NULL,
 CONSTRAINT SpecialOfferProduct_SpecialOfferID_ProductID_PK PRIMARY KEY (SpecialOfferID, ProductID),
 ModifiedDate DATETIME NOT NULL,
)

-- INSERT VALUES INTO TABLE:
INSERT INTO SpecialOfferProduct (SpecialOfferID, ProductID, ModifiedDate)
SELECT SpecialOfferID, ProductID, ModifiedDate 
FROM TempSpecialOfferProduct



--  CREATE TABLE:
CREATE TABLE SalesOrderHeader
(SalesOrderID INT NOT NULL IDENTITY(43659,1)
CONSTRAINT SalesOrderHeader_SalesOrderID_PK PRIMARY KEY,
RevisionNumber TINYINT NOT NULL DEFAULT '8',
OrderDate DATETIME NOT NULL,
DueDate DATETIME NOT NULL,
ShipDate DATETIME NULL,
Status TINYINT NOT NULL DEFAULT '5',
OnlineOrderFlag BIT NOT NULL DEFAULT 'TRUE',
SalesOrderNumber NVARCHAR(25) NOT NULL, ------
PurchaseOrderNumber NVARCHAR(25) NULL,
AccountNumber NVARCHAR(15) NULL CHECK (len(AccountNumber)=14),
CustomerID INT NOT NULL
CONSTRAINT SalesOrderHeader_CustomerID_FK FOREIGN KEY(CustomerID)
REFERENCES Customer(CustomerID),
SalesPersonID INT NULL 
CONSTRAINT SalesOrderHeader_SalesPersonID_FK FOREIGN KEY(SalesPersonID)
REFERENCES SalesPerson(BusinessEntityID),
TerritoryID INT NOT NULL
CONSTRAINT SalesOrderHeader_TerritoryID_FK FOREIGN KEY(TerritoryID)
REFERENCES SalesTerritory(TerritoryID),
BillToAddressID INT NOT NULL,
ShipToAddressID INT NOT NULL
CONSTRAINT SalesOrderHeader_ShipToAddressID_FK FOREIGN KEY(ShipMethodID)
REFERENCES Address(AddressID),
ShipMethodID INT NOT NULL
CONSTRAINT SalesOrderHeader_ShipMethodID_FK FOREIGN KEY(ShipMethodID)
REFERENCES ShipMethod(ShipMethodID),
CreditCardID INT NULL
CONSTRAINT SalesOrderHeader_CreditCardID_FK FOREIGN KEY(CreditCardID)
REFERENCES CreditCard(CreditCardID),
CreditCardApprovalCode VARCHAR(15) NULL,
CurrencyRateID INT NULL
CONSTRAINT SalesOrderHeader_CurrencyRateID_FK FOREIGN KEY(CurrencyRateID)
REFERENCES CurrencyRate(CurrencyRateID),
SubTotal MONEY NOT NULL,
TaxAmt MONEY NOT NULL,
Freight MONEY NOT NULL
)


-- INSERT VALUES INTO TABLE
SET IDENTITY_INSERT SalesOrderHeader ON
INSERT INTO SalesOrderHeader(SalesOrderID,RevisionNumber,OrderDate,DueDate,
ShipDate,Status,OnlineOrderFlag,SalesOrderNumber,PurchaseOrderNumber,
AccountNumber,CustomerID,SalesPersonID,TerritoryID,BillToAddressID,
ShipToAddressID,ShipMethodID,CreditCardID,CreditCardApprovalCode,
CurrencyRateID,SubTotal,TaxAmt,Freight)
SELECT SalesOrderID,RevisionNumber,OrderDate,DueDate,
ShipDate,Status,OnlineOrderFlag,SalesOrderNumber,PurchaseOrderNumber,
AccountNumber,CustomerID,SalesPersonID,TerritoryID,BillToAddressID,
ShipToAddressID,ShipMethodID,CreditCardID,CreditCardApprovalCode,
CurrencyRateID,SubTotal,TaxAmt,Freight
FROM TempSalesOrderHeader
SET IDENTITY_INSERT SalesOrderHeader OFF



--  CREATE  TABLE:
CREATE TABLE SalesOrderDetail
(SalesOrderID INT NOT NULL
CONSTRAINT SalesOrderDetail_SalesOrderID_FK FOREIGN KEY(SalesOrderID)
REFERENCES SalesOrderHeader(SalesOrderID),
SalesOrderDetailID INT IDENTITY (1,1)
CONSTRAINT SalesOrderDetail_SalesOrderDetailID_UK UNIQUE,
CONSTRAINT SalesOrderDetail_SalesOrderID_SalesOrderDetailID_PK PRIMARY KEY (SalesOrderID,SalesOrderDetailID),
CarrierTrackingNumber NVARCHAR(25) NULL,
OrderQty SMALLINT NOT NULL,
ProductID INT NOT NULL,     
SpecialOfferID INT NOT NULL,
CONSTRAINT SalesOrderDetail__SpecialOfferID_ProductID_FK FOREIGN KEY (SpecialOfferID, ProductID)
REFERENCES SpecialOfferProduct (SpecialOfferID, ProductID),
UnitPrice MONEY NOT NULL,
UnitPriceDiscount MONEY NOT NULL DEFAULT 0,
ModifiedDate DATETIME
)

-- INSERT VALUES INTO TABLE:
SET IDENTITY_INSERT SalesOrderDetail ON
INSERT INTO SalesOrderDetail (SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, ModifiedDate)
SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, ProductID, SpecialOfferID, UnitPrice, UnitPriceDiscount, ModifiedDate
FROM TempSalesOrderDetail
SET IDENTITY_INSERT SalesOrderDetail OFF



 






