--------------
-- Function:1
--------------
CREATE OR REPLACE FUNCTION "fn_car_available"(
    p_plate_number VARCHAR,
    p_start_date   DATE,
    p_end_date     DATE
)
RETURNS BOOLEAN
AS
$$
DECLARE
    v_count INT;
BEGIN
    IF p_start_date > p_end_date THEN
        RAISE EXCEPTION 'Start date (%) cannot be after end date (%)', p_start_date, p_end_date;
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM "RentalContracts" rc
    WHERE rc."PlateNumber" = p_plate_number
      AND NOT (rc."EndingDate" < p_start_date
           OR  rc."StartingDate" > p_end_date);

    RETURN v_count = 0;
END;
$$
LANGUAGE "plpgsql";
-----------------------------------------------------------------------------------
--------------
-- Function:2
--------------

CREATE OR REPLACE FUNCTION "fn_get_customer_active_contracts"(
    p_customer_id INT
)
RETURNS SETOF "RentalContracts"
AS
$$
BEGIN
    RETURN QUERY
    SELECT *
    FROM "RentalContracts" rc
    WHERE rc."CustomerID" = p_customer_id
      AND CURRENT_DATE BETWEEN rc."StartingDate" AND rc."EndingDate";
END;
$$
LANGUAGE "plpgsql";
-----------------------------------------------------------------------------------
--------------
-- Function:3
--------------

CREATE OR REPLACE FUNCTION "fn_get_person_fullname"(
    p_person_id INT
)
RETURNS TEXT
AS
$$
DECLARE
    v_fullname TEXT;
BEGIN
    SELECT per."FirstName" || ' ' || per."LastName"
    INTO v_fullname
    FROM "Customers" cust
    INNER JOIN "Person" per 
        ON per."NationalID" = cust."PersonID"
    WHERE cust."PersonID" = p_person_id;

    RETURN v_fullname;
END;
$$
LANGUAGE "plpgsql";
-----------------------------------------------------------------------------------
--------------
-- Function:4
--------------

CREATE OR REPLACE FUNCTION "fn_get_car_age"(
    p_manufacture_year INT
)
RETURNS INT
AS
$$
DECLARE
    v_current_year INT;
    v_age INT;
BEGIN
    -- Get current year as an integer
    v_current_year := EXTRACT(YEAR FROM CURRENT_DATE)::INT;

    -- Calculate the age of the car
    v_age := v_current_year - p_manufacture_year;

    RETURN v_age;
END;
$$
LANGUAGE "plpgsql";
-----------------------------------------------------------------------------------


