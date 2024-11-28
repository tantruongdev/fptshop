CREATE DATABASE ASSIGNMENT
GO
USE ASSIGNMENT
GO
SET DATEFORMAT dmy;
GO

CREATE TABLE MembershipClass (
	[Name]			Varchar(30)		PRIMARY KEY,
	DiscountPercent Smallint		UNIQUE NOT NULL CHECK (DiscountPercent > 0 AND DiscountPercent < 100),
	MinimumNoPoint	Int				UNIQUE NOT NULL
);

CREATE TABLE Customer (
	CustomerID			Char(9)			PRIMARY KEY,
	PhoneNumber			Char(10)		UNIQUE NOT NULL,
	Email				Varchar(50)		UNIQUE,
	RegistrationDate	Date			NOT NULL DEFAULT '01/01/2000',
	ShippingAddress		Varchar(100),
	Lname				Varchar(40)		NOT NULL,
	Fname				Varchar(15)		NOT NULL,
	TotalPoints			Int				NOT NULL DEFAULT 0,	-- derived
	MembershipClass		Varchar(30)		NOT NULL,
	CONSTRAINT FK_MembershipClass_Customer
		FOREIGN KEY (MembershipClass) REFERENCES MembershipClass([Name])
);

CREATE TABLE Cart (
	CustomerID		Char(9)			PRIMARY KEY,
	TotalAmount		Decimal(10,2)	NOT NULL DEFAULT 0,	-- derived
	CreatedDate		Date,
	CONSTRAINT FK_CustomerID_Cart
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Store (
	StoreID				Char(7)			PRIMARY KEY,
	NumberOfEmployees	Int				NOT NULL DEFAULT 0,	-- derived
	Area				Decimal(15,2),
	StoreName			Varchar(50),
	[Address]			Varchar(150)	UNIQUE NOT NULL
);

CREATE TABLE Promotion (
	PromotionID		Char(9)			PRIMARY KEY,
	[Type]			Varchar(20),
	[Name]			Varchar(70)		NOT NULL,
	StartDate		Date			NOT NULL,
	EndDate			Date			NOT NULL
);

CREATE TABLE CategoryType (
	CategoryTypeID	Char(4)			PRIMARY KEY,
	[Name]			Varchar(30)		UNIQUE NOT NULL
);

CREATE TABLE ProductLine (
	ID					Char(8)			PRIMARY KEY,
	[Name]				Varchar(100)	NOT NULL,
	Brand				Varchar(50)		NOT NULL,
	IsUsed				Bit				NOT NULL,
	StockStatus			Bit				NOT NULL,
	Price				Decimal(15,2)	NOT NULL,
	[Description]		Text,
	Category			Varchar			CHECK (Category IN ('Device', 'Accessory')),
	Color				Varchar(15),
	PromotionID			Char(9),
	DiscountPercentage	Smallint		CHECK (DiscountPercentage > 0 AND DiscountPercentage < 100),
	CategoryTypeID		Char(4)			NOT NULL,
	CONSTRAINT FK_PromotionID_ProductLine
		FOREIGN KEY (PromotionID) REFERENCES Promotion(PromotionID),
	CONSTRAINT FK_CategoryTypeID_ProductLine
		FOREIGN KEY	(CategoryTypeID) REFERENCES CategoryType(CategoryTypeID)
);

CREATE TABLE Device (
	ID					Char(8)			PRIMARY KEY,
	RAM					Smallint,
	OperatorSystem		Varchar(20),
	BatteryCapacity		Varchar(30),
	[Weight]			Varchar(15),
	Camera				Varchar(50),
	Storage				Varchar(15),
	ScreenSize			Varchar(30),
	DisplayResolution	Varchar(30),
	CONSTRAINT FK_ID_Device
		FOREIGN KEY (ID) REFERENCES ProductLine(ID)
);

CREATE TABLE Accessory (
	ID					Char(8)			PRIMARY KEY,
	BatteryCapacity		Varchar(30),	-- both Device and Accessory have BatteryCapacity???
	CONSTRAINT FK_ID_Accessory
		FOREIGN KEY (ID) REFERENCES ProductLine(ID)
);

CREATE TABLE Delivery (
	DeliveryID				Char(10)		PRIMARY KEY,
	ShippingProvider		Varchar(30),
	DeliveryStatus			Varchar(20)		NOT NULL DEFAULT 'Shipping' CHECK (DeliveryStatus IN ('Shipping', 'Completed')),
	ActualDeliveryDate		Date,
	EstimatedDeliveryDate	Date,
	ShippingAddress			Varchar(100),
	Lname					Varchar(40)		NOT NULL,
	Fname					Varchar(15)		NOT NULL
);

CREATE TABLE Employee (
	EmployeeID		Char(7)			PRIMARY KEY,
	IdentityCard	Char(12)		UNIQUE NOT NULL,
	Lname			Varchar(40)		NOT NULL,
	Fname			Varchar(15)		NOT NULL,
	PhoneNumber		Char(10)		UNIQUE,
	DOB DATE NOT NULL CHECK (DOB <= GETDATE()),
	HireDate DATE NOT NULL CHECK (HireDate <= GETDATE()) DEFAULT CONVERT(DATE, '2000-01-01'),
	Email			Varchar(50),
	SupervisorID	Char(7),
	SuperviseDate	Date,
	StoreID			Char(7)			NOT NULL,
	CONSTRAINT FK_SupervisorID_Employee
		FOREIGN KEY (SupervisorID) REFERENCES Employee(EmployeeID),
	CONSTRAINT FK_StoreID_Employee
		FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

ALTER TABLE Employee
ADD IsDeleted BIT DEFAULT 0;

CREATE TABLE [Order] (
	OrderID			Char(10)		PRIMARY KEY,
	OrderDate		Date,
	OrderStatus		Varchar(20)		NOT NULL DEFAULT 'Pending' CHECK (OrderStatus IN ('Pending', 'Shipping', 'Completed')),
	TotalAmount		Decimal(10,2)	NOT NULL DEFAULT 0,	-- derived
	EmployeeID		Char(7),
	CustomerID		Char(9)			NOT NULL,
	DeliveryID		Char(10),
	CONSTRAINT FK_EmployeeID_Order
		FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT FK_CustomerID_Order
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT FK_DeliveryID_Order
		FOREIGN KEY (DeliveryID) REFERENCES Delivery(DeliveryID)
);

CREATE TABLE Payment (
	OrderID			Char(10)		PRIMARY KEY,
	PaymentDate		Date,
	PaymentStatus	Varchar(20)		NOT NULL DEFAULT 'Pending' CHECK (PaymentStatus IN ('Pending', 'Completed')),
	Method			Varchar(30),
	CONSTRAINT FK_OrderID_Payment
		FOREIGN KEY (OrderID) REFERENCES [Order](OrderID)
);

CREATE TABLE GoodsDeliveryNote (
	ID				INT IDENTITY(1,1)	PRIMARY KEY,
	[Date]			Date,
	OrderID			Char(10)		UNIQUE NOT NULL,
	EmployeeID		Char(7),
	CONSTRAINT FK_OrderID_GoodsDeliveryNote
		FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
	CONSTRAINT FK_EmployeeID_GoodsDeliveryNote
		FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE [Product] (
	Serial			Char(10)	PRIMARY KEY,
	StoreID			Char(7)		NOT NULL,
	DeviceID		Char(8)		NOT NULL,
	NoteID			Char(10),
	CONSTRAINT FK_StoreID_Product
		FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
	CONSTRAINT FK_DeviceID_Product
		FOREIGN KEY (DeviceID) REFERENCES Device(ID),
	CONSTRAINT FK_NoteID_Product
		FOREIGN KEY (NoteID) REFERENCES GoodsDeliveryNote(ID)
);

CREATE TABLE Review (
	ProductID		Char(10),
	CustomerID		Char(9),	
	[Index]			Int ,
	ReviewDate		Date,
	ApprovalStatus	Varchar(20)		NOT NULL DEFAULT 'Pending' CHECK (ApprovalStatus IN ('Pending', 'Accepted', 'Rejected')),
	ReviewText		Text,
	Rating			Smallint		NOT NULL CHECK (Rating >= 1 AND Rating <= 5)
	CONSTRAINT PK_Review
		PRIMARY KEY (ProductID, CustomerID, [Index]),
	CONSTRAINT FK_ProductID_Review
		FOREIGN KEY (ProductID) REFERENCES [Product](Serial),
	CONSTRAINT FK_CustomerID_Review
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE SpecialFeature (
	DeviceID		Char(8),
	SpecialFeature	Varchar(75),
	CONSTRAINT PK_SpecialFeature
		PRIMARY KEY (DeviceID, SpecialFeature),
	CONSTRAINT FK_DeviceID_SpecialFeature
		FOREIGN KEY (DeviceID) REFERENCES Device(ID)
);

CREATE TABLE Connections (
	AccessoryID		Char(8),
	[Connection]	Varchar(30),
	CONSTRAINT PK_Connections
		PRIMARY KEY (AccessoryID, [Connection]),
	CONSTRAINT FK_AccessoryID_Connections
		FOREIGN KEY (AccessoryID) REFERENCES Accessory(ID)
);

CREATE TABLE Images (
	ProductLineID	Char(8),
	[Image]			Varchar(50),
	CONSTRAINT PK_Images
		PRIMARY KEY (ProductLineID, [Image]),
	CONSTRAINT FK_ProductLineID_Connections
		FOREIGN KEY (ProductLineID) REFERENCES ProductLine(ID)
);

CREATE TABLE CartIncludesProductLine (
	ProductLineID	Char(8),
	CustomerID		Char(9),
	Price			Decimal(15,2)	NOT NULL,
	Quantity		Int				NOT NULL,
	CONSTRAINT PK_CartIncludesProductLine
		PRIMARY KEY (ProductLineID, CustomerID),
	CONSTRAINT FK_ProductLineID_CartIncludesProductLine
		FOREIGN KEY (ProductLineID) REFERENCES ProductLine(ID),
	CONSTRAINT FK_CustomerID_CartIncludesProductLine
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE OrderIncludesProductLine (
	ProductLineID	Char(8),
	OrderID			Char(10),
	Price			Decimal(15,2)	NOT NULL,
	Quantity		Int				NOT NULL,
	CONSTRAINT PK_OrderIncludesProductLine
		PRIMARY KEY (ProductLineID, OrderID),
	CONSTRAINT FK_ProductLineID_OrderIncludesProductLine
		FOREIGN KEY (ProductLineID) REFERENCES ProductLine(ID),
	CONSTRAINT FK_OrderID_OrderIncludesProductLine
		FOREIGN KEY (OrderID) REFERENCES [Order](OrderID)
);

CREATE TABLE ProductLineManagedByEmployee(
	ProductLineID	Char(8),
	EmployeeID		Char(7),
	CONSTRAINT PK_ProductLineManagedByEmployee
		PRIMARY KEY (ProductLineID, EmployeeID),
	CONSTRAINT FK_ProductLineID_ProductLineManagedByEmployee
		FOREIGN KEY (ProductLineID) REFERENCES ProductLine(ID),
	CONSTRAINT FK_EmployeeID_ProductLineManagedByEmployee
		FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

CREATE TABLE AccessoryInStore (
	AccessoryID		Char(8),
	StoreID			Char(7),
	StockQuantity	Int			NOT NULL,
	CONSTRAINT PK_AccessoryInStore
		PRIMARY KEY (AccessoryID, StoreID),
	CONSTRAINT FK_AccessoryID_AccessoryInStore
		FOREIGN KEY (AccessoryID) REFERENCES Accessory(ID),
	CONSTRAINT FK_StoreID_AccessoryInStore
		FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);
