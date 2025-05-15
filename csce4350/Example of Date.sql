-- Since it's in the homework, I should mention the use of the data type DATE

DROP TABLE IF EXISTS tbl_date_demo;

CREATE TEMPORARY TABLE tbl_date_demo  -- OK to use "TEMPORARY TABLE"
(
    fld_id_pk INTEGER,
    fld_dob   DATE,   -- example of DATE field
    --
    CONSTRAINT date_demp_pk PRIMARY KEY(fld_id_pk)
);

INSERT INTO tbl_date_demo(fld_id_pk, fld_dob)
VALUES( 1, '2025-01-13' );
-- This is how to do it in the "Create Table" assignment.


-- The default date format is 'yyyy-mm-dd' AS A TEXT STRING.
-- This does *NOT* mean it's stored as a text string!
-- There are a wide range of other options:
-- see: https://www.postgresql.org/docs/current/functions-formatting.html

-- One common option
INSERT INTO tbl_date_demo(fld_id_pk, fld_dob)
VALUES( 2, NOW() );

SELECT * FROM tbl_date_demo;

-- The temporary table disappears when you log off.

/*
    Some points about dates in SQL:
    
    The default format for a date in SQL is 'yyyy-mm-dd'
    
    The input is a text string with two dashes and 8 digits.  It is stored internally in binary form.
    
    We will learn how to change the date format to anything we like (any known date format, anyway).
    
    The 'yyyy-mm-dd' is standard across SQL platforms as the default date format.