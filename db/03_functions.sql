--------------
-- Function:1
--------------
CREATE OR REPLACE FUNCTION fn_car_available(
    p_car_id INT,
    p_start_date DATE,
    p_end_date DATE
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN
    IF p_start_date > p_end_date THEN
        RAISE EXCEPTION 'Start date cannot be after end date';
    END IF;

    SELECT COUNT(*)
    INTO v_count
    FROM "RentalContracts" rc
    WHERE rc."CarID" = p_car_id
      AND NOT (
          rc."EndingDate" < p_start_date
          OR rc."StartingDate" > p_end_date
      );

    RETURN v_count = 0;
END;
$$;
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

CREATE OR REPLACE FUNCTION fn_get_person_fullname(p_person_id integer)
RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    v_name text;
BEGIN
    SELECT per."FirstName" || ' ' || per."LastName"
    INTO v_name
    FROM "Customers" cust
    INNER JOIN "Person" per
        ON per."PersonID" = cust."PersonID"
    WHERE cust."PersonID" = p_person_id;

    RETURN v_name;
END;
$$;

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


