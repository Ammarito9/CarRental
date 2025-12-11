---- CONSTRAINTS
-- PKs
ALTER TABLE "Persons" ADD CONSTRAINT pk_persons PRIMARY KEY("PersonID");
ALTER TABLE "Customers" ADD CONSTRAINT pk_customers PRIMARY KEY("PersonID");
ALTER TABLE "Employees" ADD CONSTRAINT pk_employees PRIMARY KEY("PersonID");
ALTER TABLE "Licenses" ADD CONSTRAINT pk_licenses PRIMARY KEY("LicenceNumberID");
ALTER TABLE "RentalContracts" ADD CONSTRAINT pk_rentalcontracts PRIMARY KEY("ContractID");
ALTER TABLE "PenaltyTypes" ADD CONSTRAINT pk_penaltytypes PRIMARY KEY("PenaltyTypeID");
ALTER TABLE "Penalties" ADD CONSTRAINT pk_penalties PRIMARY KEY("PenaltyID");
ALTER TABLE "CarsCatalogs" ADD CONSTRAINT pk_carscatalogs PRIMARY KEY("CarID");
ALTER TABLE "CarCategories" ADD CONSTRAINT pk_carcategories PRIMARY KEY("CategoryID");
ALTER TABLE "Payments" ADD CONSTRAINT pk_payments PRIMARY KEY("PaymentID");
ALTER TABLE "Discounts" ADD CONSTRAINT pk_discounts PRIMARY KEY("DiscountID");
ALTER TABLE "ReturningRecords" ADD CONSTRAINT pk_returningrecords PRIMARY KEY("RecordCode");


-- FKs
ALTER TABLE "Customers" ADD CONSTRAINT fk_customers_personid_person FOREIGN KEY ("PersonID") REFERENCES "Persons"("PersonID");
ALTER TABLE "Customers" ADD CONSTRAINT fk_customers_licencenumberid_licenses FOREIGN KEY ("LicenceNumberID") REFERENCES "Licenses"("LicenceNumberID");

ALTER TABLE "Employees" ADD CONSTRAINT fk_employees_personid_person FOREIGN KEY ("PersonID") REFERENCES "Persons"("PersonID");
ALTER TABLE "Employees" ADD CONSTRAINT fk_employees_managerid_employees FOREIGN KEY ("ManagerID") REFERENCES "Employees"("PersonID");

ALTER TABLE "RentalContracts" ADD CONSTRAINT fk_rentalcontracts_customerid_customers FOREIGN KEY ("CustomerID") REFERENCES "Customers"("PersonID");
ALTER TABLE "RentalContracts" ADD CONSTRAINT fk_rentalcontracts_carid_carscatalogs FOREIGN KEY ("CarID") REFERENCES "CarsCatalogs"("CarID");
ALTER TABLE "RentalContracts" ADD CONSTRAINT fk_rentalcontracts_paymentid_payments FOREIGN KEY ("PaymentID") REFERENCES "Payments"("PaymentID");
ALTER TABLE "RentalContracts" ADD CONSTRAINT fk_rentalcontracts_approvedbyid_employees FOREIGN KEY ("ApprovedByID") REFERENCES "Employees"("PersonID");

ALTER TABLE "Penalties" ADD CONSTRAINT fk_penalties_penaltytypeid_penaltytypes FOREIGN KEY ("PenaltyTypeID") REFERENCES "PenaltyTypes"("PenaltyTypeID");
ALTER TABLE "Penalties" ADD CONSTRAINT fk_penalties_contractid_rentalcontracts FOREIGN KEY ("ContractID") REFERENCES "RentalContracts"("ContractID");

ALTER TABLE "CarsCatalogs" ADD CONSTRAINT fk_carscatalogs_carcategoryid_carcategories FOREIGN KEY ("CarCategoryID") REFERENCES "CarCategories"("CategoryID");

ALTER TABLE "Payments" ADD CONSTRAINT fk_payments_discountid_discounts FOREIGN KEY ("DiscountID") REFERENCES "Discounts"("DiscountID");
ALTER TABLE "Payments" ADD CONSTRAINT fk_payments_issuedby_employees FOREIGN KEY ("IssuedBy") REFERENCES "Employees"("PersonID");

ALTER TABLE "ReturningRecords" ADD CONSTRAINT fk_returningrecords_contractid_rentalcontracts FOREIGN KEY ("ContractID") REFERENCES "RentalContracts"("ContractID");


-- Checks
ALTER TABLE "Licenses" ADD CONSTRAINT chk_licences_validDate CHECK ("EndingDate" > "StartingDate");

ALTER TABLE "Persons" ADD CONSTRAINT chk_persons_gender CHECK ("Gender" = 'M' OR "Gender" = 'F');
ALTER TABLE "Person" ADD CONSTRAINT chk_persons_dateofbirth CHECK ("DateOfBirth" < now());

ALTER TABLE "Employees" ADD CONSTRAINT chk_employees_salary CHECK ("Salary" >= 0);
ALTER TABLE "Employees" ADD CONSTRAINT chk_employees_permissions CHECK ("Permissions" >= 0);
ALTER TABLE "Employees" ADD CONSTRAINT chk_employees_jobDate CHECK ("JobEndingDate" IS NULL OR "JobEndingDate" >= "JobStartingDate");

ALTER TABLE "RentalContracts" ADD CONSTRAINT chk_rentalcontracts_validDate CHECK ("EndingDate" > "StartingDate");

ALTER TABLE "Discounts" ADD CONSTRAINT chk_discounts_percentage_range CHECK ("DiscountPercentage" BETWEEN 0 AND 100);

-- Unique
ALTER TABLE "PenaltyTypes" ADD CONSTRAINT uq_penaltytypes_typename UNIQUE ("TypeName");

ALTER TABLE "CarCategories" ADD CONSTRAINT uq_carcategories_categoryname UNIQUE ("CategoryName");

ALTER TABLE "Discounts" ADD CONSTRAINT uq_discounts_discountpersentage UNIQUE ("DiscountPercentage");

-- Default 

ALTER TABLE "Licenses" ALTER COLUMN "IsValid" SET DEFAULT FALSE;

-- Not Null
ALTER TABLE "Persons" ALTER COLUMN "NationalID" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "FirstName" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "LastName" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "Age" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "Gender" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "PhoneNumber" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "Address" SET NOT NULL;
ALTER TABLE "Persons" ALTER COLUMN "DateOfBirth" SET NOT NULL;

ALTER TABLE "Customers" ALTER COLUMN "LicenceNumberID" SET NOT NULL;

ALTER TABLE "Licenses" ALTER COLUMN "StartingDate" SET NOT NULL;
ALTER TABLE "Licenses" ALTER COLUMN "EndingDate" SET NOT NULL;
ALTER TABLE "Licenses" ALTER COLUMN "IsValid" SET NOT NULL;

ALTER TABLE "Employees" ALTER COLUMN "Salary" SET NOT NULL;
ALTER TABLE "Employees" ALTER COLUMN "Permissions" SET NOT NULL;
ALTER TABLE "Employees" ALTER COLUMN "JobStartingDate" SET NOT NULL;

ALTER TABLE "RentalContracts" ALTER COLUMN "CustomerID" SET NOT NULL;
ALTER TABLE "RentalContracts" ALTER COLUMN "CarID" SET NOT NULL;
ALTER TABLE "RentalContracts" ALTER COLUMN "StartingDate" SET NOT NULL;
ALTER TABLE "RentalContracts" ALTER COLUMN "EndingDate" SET NOT NULL;
ALTER TABLE "RentalContracts" ALTER COLUMN "PaymentID" SET NOT NULL;
ALTER TABLE "RentalContracts" ALTER COLUMN "ApprovedByID" SET NOT NULL;

ALTER TABLE "Penalties" ALTER COLUMN "PenaltyTypeID" SET NOT NULL;
ALTER TABLE "Penalties" ALTER COLUMN "PenaltyPrice" SET NOT NULL;
ALTER TABLE "Penalties" ALTER COLUMN "ContractID" SET NOT NULL;

ALTER TABLE "PenaltyTypes" ALTER COLUMN "TypeName" SET NOT NULL;

ALTER TABLE "CarsCatalogs" ALTER COLUMN "PlateNumber" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "CarName" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "Status" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "CarCategoryID" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "FuelType" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "FuelLevel" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "DistanceKM" SET NOT NULL;
ALTER TABLE "CarsCatalogs" ALTER COLUMN "ModelYear" SET NOT NULL;

ALTER TABLE "CarCategories" ALTER COLUMN "CategoryName" SET NOT NULL;
ALTER TABLE "CarCategories" ALTER COLUMN "PricePerDay" SET NOT NULL;

ALTER TABLE "Discounts" ALTER COLUMN "DiscountPercentage" SET NOT NULL;

ALTER TABLE "Payments" ALTER COLUMN "PaymentType" SET NOT NULL;
ALTER TABLE "Payments" ALTER COLUMN "TotalPrice" SET NOT NULL;
ALTER TABLE "Payments" ALTER COLUMN "PaidPrice" SET NOT NULL;
ALTER TABLE "Payments" ALTER COLUMN "IssuedBy" SET NOT NULL;

ALTER TABLE "ReturningRecords" ALTER COLUMN "ContractID" SET NOT NULL;
ALTER TABLE "ReturningRecords" ALTER COLUMN "ConsumedMileage" SET NOT NULL;
ALTER TABLE "ReturningRecords" ALTER COLUMN "ActualReturnDate" SET NOT NULL;
ALTER TABLE "ReturningRecords" ALTER COLUMN "LateDays" SET NOT NULL;
ALTER TABLE "ReturningRecords" ALTER COLUMN "AdditionalCharge" SET NOT NULL;