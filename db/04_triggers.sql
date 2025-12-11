---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 1: Check car availability BEFORE INSERT
-- Ensures the car is not rented at the same time
------------------------------------------------------------

CREATE OR REPLACE FUNCTION "trg_check_rental_before_insert"()
RETURNS TRIGGER
AS
$$
DECLARE
    v_available BOOLEAN;
BEGIN
    -- Check if the car is available for the given dates
    v_available := "fn_car_available"(NEW."PlateNumber", NEW."StartingDate", NEW."EndingDate");

    IF v_available = FALSE THEN
        RAISE EXCEPTION 'Car % is not available between % and %',
            NEW."PlateNumber", NEW."StartingDate", NEW."EndingDate";
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "check_rental_before_insert"
BEFORE INSERT ON "RentalContracts"
FOR EACH ROW
EXECUTE PROCEDURE "trg_check_rental_before_insert"();



---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 2: Check car availability BEFORE UPDATE
-- Ensures changes do not violate rental date availability
------------------------------------------------------------

CREATE OR REPLACE FUNCTION "trg_check_rental_before_update"()
RETURNS TRIGGER
AS
$$
DECLARE
    v_available BOOLEAN;
BEGIN
    -- Re-check car availability when dates are updated
    v_available := "fn_car_available"(NEW."PlateNumber", NEW."StartingDate", NEW."EndingDate");

    IF v_available = FALSE THEN
        RAISE EXCEPTION 'Car % is not available for updated dates (% to %)',
            NEW."PlateNumber", NEW."StartingDate", NEW."EndingDate";
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "check_rental_before_update"
BEFORE UPDATE ON "RentalContracts"
FOR EACH ROW
EXECUTE PROCEDURE "trg_check_rental_before_update"();


---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 3: After a car return → update mileage & maintenance
-- Uses fn_get_car_age to determine maintenance needs
------------------------------------------------------------

CREATE OR REPLACE FUNCTION "trg_update_car_after_return"()
RETURNS TRIGGER
AS
$$
DECLARE
    v_age INT;
BEGIN
    -- Get car age using function
    SELECT "fn_get_car_age"(car."ManufactureYear")
    INTO v_age
    FROM "CarsCatalogs" car
    WHERE car."PlateNumber" = NEW."PlateNumber";

    -- Update car mileage
    UPDATE "CarsCatalogs"
    SET "DistanceKM" = "DistanceKM" + NEW."ConsumedMileage"
    WHERE "PlateNumber" = NEW."PlateNumber";

    -- Example rule: Cars older than 10 years require maintenance
    IF v_age >= 10 THEN
        UPDATE "CarsCatalogs"
        SET "Status" = 'UnderMaintenance'
        WHERE "PlateNumber" = NEW."PlateNumber";
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "update_car_after_return"
AFTER INSERT ON "ReturningRecords"
FOR EACH ROW
EXECUTE PROCEDURE "trg_update_car_after_return"();



---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 4: Log customer creation
-- Uses fn_get_person_fullname to write log entries
------------------------------------------------------------

-- Make sure you have this log table:
-- CREATE TABLE "CustomerLogs" (
--     "LogID" SERIAL PRIMARY KEY,
--     "CustomerID" INT NOT NULL,
--     "FullName" TEXT NOT NULL,
--     "LogDate" TIMESTAMP NOT NULL
-- );

CREATE OR REPLACE FUNCTION "trg_log_customer_insert"()
RETURNS TRIGGER
AS
$$
DECLARE
    v_fullname TEXT;
BEGIN
    -- Get full name using function
    v_fullname := "fn_get_person_fullname"(NEW."PersonID");

    -- Insert into log table
    INSERT INTO "CustomerLogs"
    ("CustomerID", "FullName", "LogDate")
    VALUES
    (NEW."CustomerID", v_fullname, CURRENT_TIMESTAMP);

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "log_customer_insert"
AFTER INSERT ON "Customers"
FOR EACH ROW
EXECUTE PROCEDURE "trg_log_customer_insert"();
