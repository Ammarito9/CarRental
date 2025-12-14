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

------------------------------------------------------------


CREATE OR REPLACE FUNCTION "trg_customer_check_person"()
RETURNS TRIGGER
AS $$
BEGIN
    -- Simple business rule check
    IF NEW."PersonID" IS NULL THEN
        RAISE EXCEPTION 'Customer must be linked to a Person';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "check_customer_person"
BEFORE INSERT ON "Customers"
FOR EACH ROW
EXECUTE PROCEDURE "trg_customer_check_person"();


------------------------------------------------------------