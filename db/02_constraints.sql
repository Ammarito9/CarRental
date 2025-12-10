---- CONSTRAINTS
-- PKs
ALTER TABLE "Person" ADD CONSTRAINT pk_persons PRIMARY KEY("PersonID");
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
ALTER TABLE "Customers" ADD CONSTRAINT fk_customers_personid_person FOREIGN KEY ("PersonID") REFERENCES "Person"("PersonID");
ALTER TABLE "Customers" ADD CONSTRAINT fk_customers_licencenumberid_licenses FOREIGN KEY ("LicenceNumberID") REFERENCES "Licenses"("LicenceNumberID");

ALTER TABLE "Employees" ADD CONSTRAINT fk_employees_personid_person FOREIGN KEY ("PersonID") REFERENCES "Person"("PersonID");
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







