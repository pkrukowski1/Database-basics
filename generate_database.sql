CREATE TABLE BufferMenu
(
  ProductID   int         NOT NULL UNIQUE,
  ProductName varchar(20) NOT NULL UNIQUE
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Zbiór kandydatów na miejsce w menu', 'user', dbo, 'table', 'BufferMenu'
GO

CREATE TABLE Categories
(
  CategoryID   int          NOT NULL UNIQUE,
  CategoryName nvarchar(20) NOT NULL UNIQUE,
  Description  ntext   ,
  CONSTRAINT PK_Categories PRIMARY KEY (CategoryID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Kategorie produktów', 'user', dbo, 'table', 'Categories'
GO

CREATE TABLE CostsOfMaintenance
(
  CostID           int       NOT NULL UNIQUE,
  LocalID          int       NOT NULL,
  CostTypeID       int       NOT NULL,
  CostName         nvarchar(20) NOT NULL UNIQUE,
  CostDescription  nvarchar(60),
  Cost             money CHECK (Cost>=0)   ,
  CostDate         datetime ,
  FrequencyPerYear int      ,
  CONSTRAINT PK_CostsOfMaintenance PRIMARY KEY (CostID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Koszty utrzymania lokalu', 'user', dbo, 'table', 'CostsOfMaintenance'
GO

CREATE TABLE CostType
(
  CostTypeID          int       NOT NULL UNIQUE,
  CostTypeName        nvarchar(40) NOT NULL UNIQUE,
  CostTypeDescription nvarchar(60),
  CONSTRAINT PK_CostType PRIMARY KEY (CostTypeID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Typy kosztów', 'user', dbo, 'table', 'CostType'
GO

CREATE TABLE Customers
(
  CustomerID     int       NOT NULL UNIQUE,
  ReservationID  int       NOT NULL,
  CustomerTypeID int       NOT NULL,
  ContactName    nvarchar(60) NOT NULL,
  Address        nvarchar(60),
  WasFormUsed    bit CHECK (WasFormUsed=0 OR WasFormUsed=1),
  CONSTRAINT PK_Customers PRIMARY KEY (CustomerID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o klientach', 'user', dbo, 'table', 'Customers'
GO

CREATE TABLE CustomerType
(
  CustomerTypeID   int       NOT NULL UNIQUE,
  CustomerTypeName nvarchar(20) NOT NULL UNIQUE,
  Description      nvarchar(60),
  CONSTRAINT PK_CustomerType PRIMARY KEY (CustomerTypeID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Typy klientów', 'user', dbo, 'table', 'CustomerType'
GO

CREATE TABLE Employees
(
  EmployeeID      int       NOT NULL UNIQUE,
  LastName        nvarchar(30) NOT NULL,
  FirstName       nvarchar(30) NOT NULL,
  Title           nvarchar(30) CHECK (Title in ('Seller', 'Supplier', 'Manager', 'Pizzaiolo', 'Cleaner')),
  TitleOfCourtesy nvarchar(25) CHECK (TitleOfCourtesy in ('Mrs.', 'Mr.', 'Pan', 'Pani')),
  BirthDate       datetime CHECK (BirthDate > '1921.01.01' and Birthdate < GETDATE()),
  HireDate        datetime,
  Address         nvarchar(60) NOT NULL,
  City            nvarchar(30) NOT NULL,
  PostalCode      nvarchar(6) NOT NULL,
  Country         nvarchar(30) NOT NULL,
  Phone           nvarchar(24) NOT NULL UNIQUE,
  Email           nvarchar(40) NOT NULL UNIQUE,
  Photography     image   ,
  Notes           ntext   ,
  ReportsTo       int      ,
  SalaryBrutto    money CHECK (SalaryBrutto > 3010.00)   ,
  SalaryNetto     money CHECK (SalaryNetto > 2363.56)   ,
  CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o zatrudnionych pracownikach', 'user', dbo, 'table', 'Employees'
GO

CREATE TABLE Locals
(
  LocalID     int       NOT NULL UNIQUE,
  LocalName   nvarchar(20) NOT NULL UNIQUE,
  OpeningDate datetime CHECK (OpeningDate <= GETDATE()) ,
  Meterage    int CHECK (Meterage > 0)     ,
  Address     nvarchar(60) NOT NULL UNIQUE,
  City        nvarchar(30) NOT NULL,
  PostalCode  nvarchar(6) NOT NULL,
  Country     nvarchar(30) NOT NULL,
  Phone       nvarchar(24) NOT NULL UNIQUE,
  Email       nvarchar(40) NOT NULL UNIQUE,
  CONSTRAINT PK_Locals PRIMARY KEY (LocalID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o lokalach', 'user', dbo, 'table', 'Locals'
GO

CREATE TABLE Menu
(
  ProductID   int          NOT NULL UNIQUE,
  ProductName nvarchar(20) NOT NULL UNIQUE
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Aktualne menu', 'user', dbo, 'table', 'Menu'
GO

CREATE TABLE MethodOfPayment
(
  PaymentID   int       NOT NULL UNIQUE,
  PaymentName nvarchar(20) NOT NULL UNIQUE,
  Commission  real CHECK (Commission > 0)    ,
  CONSTRAINT PK_MethodOfPayment PRIMARY KEY (PaymentID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Metody płatnoœci', 'user', dbo, 'table', 'MethodOfPayment'
GO

CREATE TABLE OrderDetails
(
  ProductID    int      NOT NULL,
  OrderID      int     NOT NULL,
  ProductPrice money CHECK (ProductPrice > 0)  ,
  Quantity     smallint CHECK (Quantity > 0),
  Discount     real CHECK (Discount >= 0 and Discount < 100)     
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Szczegółowe informacje o zamówionych produktach', 'user', dbo, 'table', 'OrderDetails'
GO

CREATE TABLE OrderMethod
(
  OrderMethodID   int       NOT NULL UNIQUE,
  OrderMethodName nvarchar(20) NOT NULL UNIQUE,
  Description     nvarchar(30),
  CONSTRAINT PK_OrderMethod PRIMARY KEY (OrderMethodID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacja o metodzie zamówienia', 'user', dbo, 'table', 'OrderMethod'
GO

CREATE TABLE Orders
(
  OrderID       int      NOT NULL UNIQUE,
  EmployeeID    int       NOT NULL,
  CustomerID    int      NOT NULL,
  OrderDate     datetime ,
  RequiredDate  datetime ,
  DeliveryDate  datetime,
  DateOfPayment datetime,
  OrderPlace    nvarchar(20) NOT NULL UNIQUE,
  PaymentID     int       NOT NULL,
  LocalID       int       NOT NULL,
  OrderMethodID int       NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY (OrderID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o zamówieniach', 'user', dbo, 'table', 'Orders'
GO

CREATE TABLE PersonalReservation
(
  PersonID      int       NOT NULL UNIQUE,
  ReservationID int       NOT NULL,
  LastName      nvarchar(30) NOT NULL,
  FirstName     nvarchar(30) NOT NULL,
  CompanyName   nvarchar(40) NOT NULL,
  CONSTRAINT PK_PersonalReservation PRIMARY KEY (PersonID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Rezerwacje imienne', 'user', dbo, 'table', 'PersonalReservation'
GO

CREATE TABLE ProductDetails
(
  SupplyID  int NOT NULL UNIQUE,
  ProductID int NOT NULL UNIQUE,
  Amount    real CHECK(Amount>0) NOT NULL,
  Unit      nvarchar(20)  NOT NULL
)
GO
EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o składnikach (z zapasów), z których składają się poszczególne produkty', 'user', dbo, 'table', 'ProductDetails'
GO

CREATE TABLE Products
(
  ProductID          int       NOT NULL,
  CategoryID         int UNIQUE NOT NULL,
  TaxID              int       NOT NULL,
  ProductName        nvarchar(20) NOT NULL,
  ProductDescription nvarchar(30),
  ProductPrice       money CHECK(ProductPrice>0)   ,
  PreparationTime    real CHECK(PreparationTime BETWEEN 0 AND 60) NOT NULL ,
  DateMenuAddition   datetime CHECK(DateMenuAddition > '2000-01-01' and DateMenuAddition <= GETDATE()),
  DateMenuRemoval    datetime CHECK (DateMenuRemoval > '2000-01-01' AND DateMenuRemoval < GETDATE()),
  CONSTRAINT PK_Products PRIMARY KEY (ProductID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Sprzedawane produkty czyli dania i napoje', 'user', dbo, 'table', 'Products'
GO

CREATE TABLE RegisteredCompanies
(
  CustomerID       int      NOT NULL,
  CompanyName      nvarchar(40) NOT NULL,
  ContactName      nvarchar(60) NOT NULL,
  Address          nvarchar(60) NOT NULL,
  City             nvarchar(30) NOT NULL,
  PostalCode       nvarchar(6) NOT NULL,
  Country          nvarchar(30) NOT NULL,
  Phone            nvarchar(24) UNIQUE NOT NULL,
  Email            nvarchar(40) UNIQUE NOT NULL,
  Discount         real CHECK (Discount BETWEEN 0 AND 1),
  EndDiscountDate  datetime
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Zarejestrowani klienci-firmy', 'user', dbo, 'table', 'RegisteredCompanies'
GO

CREATE TABLE RegisteredCustomers
(
  CustomerID       int      NOT NULL,
  LastName         nvarchar(30) NOT NULL,
  FirstName        nvarchar(30) NOT NULL,
  Address          nvarchar(60) NOT NULL,
  City             nvarchar(30) NOT NULL,
  PostalCode       nvarchar(6) NOT NULL,
  Country          nvarchar(30) NOT NULL,
  Phone            nvarchar(24) UNIQUE NOT NULL,
  Email            nvarchar(40) UNIQUE NOT NULL,
  Discount real CHECK(Discount BETWEEN 0 AND 1),
  EndDiscountDate  datetime
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Zarejestrowani klienci prywatni', 'user', dbo, 'table', 'RegisteredCustomers'
GO

CREATE TABLE ReservationType
(
  ReservationType     int       NOT NULL,
  ReservationTypeName nvarchar(20) UNIQUE NOT NULL,
  CONSTRAINT PK_ReservationType PRIMARY KEY (ReservationType)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacja o sposobie dokonania rezerwacji', 'user', dbo, 'table', 'ReservationType'
GO

CREATE TABLE ReservedTables
(
  ReservationID int NOT NULL UNIQUE,
  TableID       int NOT NULL UNIQUE
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Zarezerwowane stoliki', 'user', dbo, 'table', 'ReservedTables'
GO

CREATE TABLE Staff
(
  EmployeeID int NOT NULL,
  LocalID    int NOT NULL
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Personel lokali', 'user', dbo, 'table', 'Staff'
GO

CREATE TABLE Suppliers
(
  SupplierID   int       NOT NULL,
  CompanyName  nvarchar(40) NOT NULL,
  ContactName  nvarchar(60) UNIQUE NOT NULL,
  ContactTitle nvarchar(30) CHECK (ContactTitle IN ('Marketing Manager', 'Purchasing Manager', 'Export Administrator', 'Sales Agent', 'Order Administrator', 'Sales Representative', 'Marketing Representative')),
  Address      nvarchar(60) NOT NULL,
  City         nvarchar(30) NOT NULL,
  PostalCode   nvarchar(6) NOT NULL,
  Country      nvarchar(30) NOT NULL,
  Phone        nvarchar(24) UNIQUE NOT NULL,
  Email        nvarchar(40) UNIQUE NOT NULL,
  HomePage     ntext   ,
  CONSTRAINT PK_Suppliers PRIMARY KEY (SupplierID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o dostawcach produktów do pizzerii', 'user', dbo, 'table', 'Suppliers'
GO

CREATE TABLE Supplies
(
  SupplyID        int       NOT NULL,
  SupplyName      nvarchar(40) NOT NULL,
  PackageType     nvarchar(20) NOT NULL,
  QuantityPerPackage  int       CHECK(QuantityPerPackage>0) NOT NULL,
  Unit            nvarchar(20)  NOT NULL,
  PackagesInStock int       CHECK(PackagesInStock>=0) NOT NULL,
  CONSTRAINT PK_Supplies PRIMARY KEY (SupplyID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o aktualnie posiadanych zapasach', 'user', dbo, 'table', 'Supplies'
GO

CREATE TABLE SuppliesToOrder
(
  SupplierID      int       NOT NULL,
  SupplyID        int       NOT NULL,
  PriceOfUnit     money CHECK (PriceOfUnit > 0) NOT NULL,
  Quantity        smallint CHECK(Quantity>0) NOT NULL 
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o zapasach, które firma chce zamówić', 'user', dbo, 'table', 'SuppliesToOrder'
GO

CREATE TABLE TableReservation
(
  ReservationID     int     NOT NULL,
  ReservationType   int CHECK (ReservationType IN ('Online', 'ByPhone')),
  DateOfReservation datetime NOT NULL,
  ReservationDate   datetime NOT NULL,
  ReservationExpire datetime NOT NULL,
  ReservationTime   real DEFAULT 2 CHECK(ReservationTime > 0 AND ReservationTime < 2)    ,
  Discontinued      bit CHECK(Discontinued IN (0,1)),
  CONSTRAINT PK_TableReservation PRIMARY KEY (ReservationID),
  CONSTRAINT CHK_TableReservationDate CHECK (DateOfReservation > ReservationDate)
)
GO

CREATE TABLE Tables
(
  TableID       int NOT NULL,
  LocalID       int NOT NULL,
  Seats         int CHECK (Seats IN (0,4)),
  NumberOfTable int CHECK(NumberOfTable > 0),
  CONSTRAINT PK_Tables PRIMARY KEY (TableID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Informacje o stolikach', 'user', dbo, 'table', 'Tables'
GO

CREATE TABLE Taxes
(
  TaxID      int       NOT NULL,
  TaxName    nvarchar(20) UNIQUE,
  Percentage real CHECK (Percentage >=0),
  CONSTRAINT PK_Taxes PRIMARY KEY (TaxID)
)
GO

EXECUTE sys.sp_addextendedproperty 'MS_Description',
  'Rodzaje podatków', 'user', dbo, 'table', 'Taxes'
GO

ALTER TABLE SuppliesToOrder
  ADD CONSTRAINT FK_Supplies_TO_SuppliesToOrder
    FOREIGN KEY (SupplierID)
    REFERENCES Supplies (SupplyID)
GO

ALTER TABLE SuppliesToOrder
  ADD CONSTRAINT FK_Suppliers_TO_SuppliesToOrder
    FOREIGN KEY (SupplyID)
    REFERENCES Suppliers (SupplierID)
GO

ALTER TABLE OrderDetails
  ADD CONSTRAINT FK_Products_TO_OrderDetails
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
GO

ALTER TABLE ProductDetails
  ADD CONSTRAINT FK_Supplies_TO_ProductDetails
    FOREIGN KEY (SupplyID)
    REFERENCES Supplies (SupplyID)
GO

ALTER TABLE RegisteredCustomers
  ADD CONSTRAINT FK_Customers_TO_RegisteredCustomers
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID)
GO

ALTER TABLE Products
  ADD CONSTRAINT FK_Categories_TO_Products
    FOREIGN KEY (CategoryID)
    REFERENCES Categories (CategoryID)
GO

ALTER TABLE ProductDetails
  ADD CONSTRAINT FK_Products_TO_ProductDetails
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
GO

ALTER TABLE Products
  ADD CONSTRAINT FK_Taxes_TO_Products
    FOREIGN KEY (TaxID)
    REFERENCES Taxes (TaxID)
GO

ALTER TABLE OrderDetails
  ADD CONSTRAINT FK_Orders_TO_OrderDetails
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID)
GO

ALTER TABLE Orders
  ADD CONSTRAINT FK_Employees_TO_Orders
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID)
GO

ALTER TABLE Orders
  ADD CONSTRAINT FK_MethodOfPayment_TO_Orders
    FOREIGN KEY (PaymentID)
    REFERENCES MethodOfPayment (PaymentID)
GO

ALTER TABLE Orders
  ADD CONSTRAINT FK_Locals_TO_Orders
    FOREIGN KEY (LocalID)
    REFERENCES Locals (LocalID)
GO

ALTER TABLE Staff
  ADD CONSTRAINT FK_Employees_TO_Staff
    FOREIGN KEY (EmployeeID)
    REFERENCES Employees (EmployeeID)
GO

ALTER TABLE Staff
  ADD CONSTRAINT FK_Locals_TO_Staff
    FOREIGN KEY (LocalID)
    REFERENCES Locals (LocalID)
GO

ALTER TABLE CostsOfMaintenance
  ADD CONSTRAINT FK_CostType_TO_CostsOfMaintenance
    FOREIGN KEY (CostTypeID)
    REFERENCES CostType (CostTypeID)
GO

ALTER TABLE CostsOfMaintenance
  ADD CONSTRAINT FK_Locals_TO_CostsOfMaintenance
    FOREIGN KEY (LocalID)
    REFERENCES Locals (LocalID)
GO

ALTER TABLE Orders
  ADD CONSTRAINT FK_Customers_TO_Orders
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID)
GO

ALTER TABLE Customers
  ADD CONSTRAINT FK_TableReservation_TO_Customers
    FOREIGN KEY (ReservationID)
    REFERENCES TableReservation (ReservationID)
GO

ALTER TABLE PersonalReservation
  ADD CONSTRAINT FK_TableReservation_TO_PersonalReservation
    FOREIGN KEY (ReservationID)
    REFERENCES TableReservation (ReservationID)
GO

ALTER TABLE ReservedTables
  ADD CONSTRAINT FK_TableReservation_TO_ReservedTables
    FOREIGN KEY (ReservationID)
    REFERENCES TableReservation (ReservationID)
GO

ALTER TABLE ReservedTables
  ADD CONSTRAINT FK_Tables_TO_ReservedTables
    FOREIGN KEY (TableID)
    REFERENCES Tables (TableID)
GO

ALTER TABLE Tables
  ADD CONSTRAINT FK_Locals_TO_Tables
    FOREIGN KEY (LocalID)
    REFERENCES Locals (LocalID)
GO

ALTER TABLE Customers
  ADD CONSTRAINT FK_CustomerType_TO_Customers
    FOREIGN KEY (CustomerTypeID)
    REFERENCES CustomerType (CustomerTypeID)
GO

ALTER TABLE RegisteredCompanies
  ADD CONSTRAINT FK_Customers_TO_RegisteredCompanies
    FOREIGN KEY (CustomerID)
    REFERENCES Customers (CustomerID)
GO

ALTER TABLE TableReservation
  ADD CONSTRAINT FK_ReservationType_TO_TableReservation
    FOREIGN KEY (ReservationType)
    REFERENCES ReservationType (ReservationType)
GO

ALTER TABLE Orders
  ADD CONSTRAINT FK_OrderMethod_TO_Orders
    FOREIGN KEY (OrderMethodID)
    REFERENCES OrderMethod (OrderMethodID)
GO

ALTER TABLE BufferMenu
  ADD CONSTRAINT FK_Products_TO_BufferMenu
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
GO

ALTER TABLE Menu
  ADD CONSTRAINT FK_Products_TO_Menu
    FOREIGN KEY (ProductID)
    REFERENCES Products (ProductID)
GO
