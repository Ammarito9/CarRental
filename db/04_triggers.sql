---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 1: Check car availability BEFORE INSERT
-- Ensures the car is not rented at the same time
------------------------------------------------------------

CREATE OR REPLACE FUNCTION trg_check_rental_before_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT fn_car_available(NEW."CarID", NEW."StartingDate", NEW."EndingDate") THEN
        RAISE EXCEPTION
            'CarID % is not available between % and %',
            NEW."CarID", NEW."StartingDate", NEW."EndingDate";
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS check_rental_before_insert ON "RentalContracts";
CREATE TRIGGER check_rental_before_insert
BEFORE INSERT ON "RentalContracts"
FOR EACH ROW
EXECUTE FUNCTION trg_check_rental_before_insert();


---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 2: Check car availability BEFORE UPDATE
-- Ensures changes do not violate rental date availability
------------------------------------------------------------

CREATE OR REPLACE FUNCTION trg_check_rental_before_update()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT fn_car_available(NEW."CarID", NEW."StartingDate", NEW."EndingDate") THEN
        RAISE EXCEPTION
            'CarID % is not available for updated dates',
            NEW."CarID";
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS check_rental_before_update ON "RentalContracts";
CREATE TRIGGER check_rental_before_update
BEFORE UPDATE ON "RentalContracts"
FOR EACH ROW
EXECUTE FUNCTION trg_check_rental_before_update();


---------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------
-- TRIGGER 3: After a car return → update mileage & maintenance
-- Uses fn_get_car_age to determine maintenance needs
------------------------------------------------------------

CREATE OR REPLACE FUNCTION trg_update_car_after_return()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_car_id INT;
BEGIN
    -- Find the car used in this contract
    SELECT "CarID"
    INTO v_car_id
    FROM "RentalContracts"
    WHERE "ContractID" = NEW."ContractID";

    IF v_car_id IS NULL THEN
        RAISE EXCEPTION 'No car found for contract %', NEW."ContractID";
    END IF;

    -- Update mileage & set car available again
    UPDATE "CarsCatalogs"
    SET
        "DistanceKM" = "DistanceKM" + NEW."ConsumedMileage",
        "Status" = 1  -- Available
    WHERE "CarID" = v_car_id;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS update_car_after_return ON "ReturningRecords";
CREATE TRIGGER update_car_after_return
AFTER INSERT ON "ReturningRecords"
FOR EACH ROW
EXECUTE FUNCTION trg_update_car_after_return();

COMMIT;


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
---------------------------------------------------------=---
-- =========================
-- CREATE TRIGGERS
-- =========================
CREATE TRIGGER check_rental_before_insert
BEFORE INSERT ON "RentalContracts"
FOR EACH ROW
EXECUTE FUNCTION trg_check_rental_before_insert();

CREATE TRIGGER check_rental_before_update
BEFORE UPDATE ON "RentalContracts"
FOR EACH ROW
EXECUTE FUNCTION trg_check_rental_before_update();

CREATE TRIGGER update_car_after_return
AFTER INSERT ON "ReturningRecords"
FOR EACH ROW
EXECUTE FUNCTION trg_update_car_after_return();
