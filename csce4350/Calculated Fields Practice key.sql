-- Database: db50
-- set search_path to tb_tst;

DROP TABLE IF EXISTS tbl_calc_fields;

DROP SEQUENCE IF EXISTS seq_pk;
CREATE SEQUENCE seq_pk;
/*
    New idea here: a SEQUENCE is like a "take a number" roll
    in a busy service shop.  Each customer may take one and 
    no two customers will receive the same number.  You have
    a lot of control over these... *much* more than making
    the field an AUTONUMBER (Access)... see also: IDENTITY, or
    SERIAL which creates an automatically incrementing field.
    
    Using this isn't really a *calculated field*, but it's
    a similar idea.')
    
    Now, since the table tbl_calc_fields refers to the sequence,
    it must exist before the table may be created.  Moreover,
    the sequence cannot be dropped while the table exists.
    
    Notice that I dropped the table before I could drop the sequence.
*/




CREATE TABLE tbl_calc_fields
(
    fld_cf_pk  BIGINT DEFAULT NEXTVAL('seq_pk'),
    -- You will se a lot of variation of the NEXTVAL
    -- syntax across platforms.  this is how PostgreSQL
    -- does it.  Note that you may also provide a value;
    -- however, with SERIAL or IDENTITY, you usually can't.
    -- 
    -- By default, a SEQUENCE is of type BIGINT; however, it
    -- may be changed.
    --
    fld_cf_empname VARCHAR(16),
    fld_cf_salary NUMERIC(6,2), -- I'm avoiding MONEY for now.
    fld_cf_hrs SMALLINT
);

INSERT INTO tbl_calc_fields( fld_cf_empname, fld_cf_salary, fld_cf_hrs )
VALUES ( 'Al', 10.30, 23 ),
       ( 'Bob', 8.75, 52 ),
       ( 'Cindi', 19.32, 40 ),
       ( 'Debbie', 10.00, 33 ),
       ( 'Ed', 11.30, 35 ),
       ( 'Francis', 10.00, 50);
       
-- Select all employees, their salary, and hours.  Calculate their total pay
-- as hours worked * salary.

-- Straight-time
SELECT fld_cf_empname, fld_cf_salary, 
       fld_cf_hrs, fld_cf_salary * fld_cf_hrs AS total_pay
FROM tbl_calc_fields
WHERE fld_cf_hrs <= 40;

-- overtime
SELECT fld_cf_empname, fld_cf_salary, fld_cf_hrs,
       fld_cf_salary*(fld_cf_hrs + 0.5*(fld_cf_hrs-40)) AS total_pay
FROM tbl_calc_fields
WHERE fld_cf_hrs > 40;


-- Some platforms inplement "IF" logic similar to =IF(... in Excel, 
-- however, it is nonstandard SQL.  Postgres *can* do it, but it is beyond the
-- scope of this class.
-- it is usually written something like:
/*
    -- NOTICE!  Non-standard SQL.  Not required by this class!
    -- The following would work in Oracle and SQL Server (propriatary platforms),
    -- but not in the open-source platforms like PostgreSQL and MySQL
    
    SELECT fld_cf_empname, fld_cf_salary, fld_cf_hrs,
        IIF( fld_cf_hrs<=40,
             fld_cf_salary * fld_cf_hrs,
             fld_cf_salary*(fld_cf_hrs + 0.5*(fld_cf_hrs-40)
           ) AS total_pay;
             

    
    In ANSCI C:  hrs<=40 ? salary*hrs : salary*(hrs+hrs*0.5);