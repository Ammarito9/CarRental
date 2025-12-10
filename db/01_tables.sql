
CREATE TABLE public."Person" (
    "PersonID" SERIAL,
    "NationalID" CHAR(11),
    "FirstName" VARCHAR(20),
    "LastName" VARCHAR(20),
    "Age" SMALLINT,
    "Gender" CHAR(1), -- The gender either 'M' as Male or 'F' as Female
    "PhoneNumber" VARCHAR(15),
    "Address" TEXT,
    "Email" VARCHAR(50),
    "DateOfBirth" DATE
);

CREATE TABLE public."Customers" (
    "PersonID" INTEGER,
    "LicenceNumberID" INTEGER
);

CREATE TABLE public."Employees" (
    "PersonID" INTEGER,
    "Salary" MONEY,
    "Permissions" INTEGER,
    "JobStartingDate" DATE,
    "JobEndingDate" DATE,
    "ManagerID" INTEGER
);

CREATE TABLE public."Licenses" (
    "LicenceNumberID" SERIAL,
    "LicenceNumber" VARCHAR(20),
    "StartingDate" DATE,
    "EndingDate" DATE,
    "IsValid" BOOLEAN
);

CREATE TABLE public."RentalContracts" (
    "ContractID" SERIAL,
    "CustomerID" INTEGER,
    "CarID" INTEGER,
    "StartingDate" DATE,
    "EndingDate" DATE,
    "PaymentID" INTEGER,
    "ApprovedByID" INTEGER
);

CREATE TABLE public."PenaltyTypes" (
    "PenaltyTypeID" SERIAL,
    "TypeName" VARCHAR(50),
    "Discription" TEXT
);

CREATE TABLE public."Penalties" (
    "PenaltyID" SERIAL,
    "PenaltyTypeID" INTEGER,
    "ContractID" INTEGER,
    "PenaltyPrice" MONEY,
    "Note" TEXT
);

CREATE TABLE public."CarsCatalogs" (
    "CarID" SERIAL,
    "CarCategoryID" INTEGER,
    "PlateNumber" VARCHAR(15),
    "CarName" VARCHAR(50),
    "Status" INTEGER, -- It will be transfered into ENUM in the backend, (0 - Rented, 1 - Avaliable, 2 - Under Maintanance)
    "FuelType" INTEGER, -- It will be transfered into ENUM in the backend, (0 - Petrol, 1 - Diesel, 2 - Electric)
    "FuelLevel" INTEGER, -- Is limeted b/w 0 and 100 as a persentage.
    "DistanceKM" INTEGER,
    "ModelYear" VARCHAR(4)
);

CREATE TABLE public."CarCategories" (
    "CategoryID" SERIAL,
    "CategoryName" VARCHAR(50),
    "PricePerDay" MONEY
);

CREATE TABLE public."Payments" (
    "PaymentID" SERIAL,
    "DiscountID" INTEGER,
    "PaymentType" INTEGER, -- It will be transfered into ENUM in the backend, (0 - Cash, 1 - Credit Card, 2 - Bank Transfer)
    "TotalPrice" MONEY,
    "PaidPrice" MONEY,
    "IssuedBy" INTEGER
);

CREATE TABLE public."Discounts" (
    "DiscountID" SERIAL,
    "DiscountPercentage" INTEGER,
    "Note" TEXT
);

CREATE TABLE public."ReturningRecords" (
    "RecordCode" SERIAL,
    "ContractID" INTEGER,
    "ActualReturnDate" DATE,
    "FinalVehicleCheckNotes" TEXT,
    "ConsumedMileage" INTEGER,
    "LateDays" INTEGER,
    "AdditionalCharge" MONEY
);