/*
    We'll try to find some reason to give some credit for making progress.

    Format matters, but we'll try to warn them on this one.  We hope to get them started.
*/



-- CREATE TABLE 50%

CREATE SCHEMA IF NOT EXISTS csce5350_hw1;
SET SEARCH_PATH TO csce5350_hw1; -- minus 2 if SEARCH_PATH not set; SCHEMA name may vary
                                  -- may already exist

DROP TABLE IF EXISTS tbl_employees;  -- Minus 5 if not dropped

CREATE TABLE tbl_employees
(
    fld_e_id_pk     INTEGER, -- accept CHAR/VARCHAR (typical); field may be named: "fld_e_id"
    fld_e_fname     CHAR(16),
    fld_e_lname     CHAR(16),
    fld_e_dob       DATE,       -- minus 10 for a character field (not DATE)
    fld_e_dept      CHAR(16),
    fld_e_salary    NUMERIC(7,2), -- could be MONEY  Minus 3 for INTEGER
    fld_e_phone     CHAR(9),         -- Minus 2 for VARCHAR
    --
    CONSTRAINT emp_PK PRIMARY KEY(fld_e_id_pk),  -- Minus 15 if not a named constraint
    CONSTRAINT emp_null_lname CHECK(fld_e_lname IS NOT NULL), -- minus 10 for others
    CONSTRAINT emp_invalid_salary CHECK(fld_e_salary > 0)
);



-- INSERT 40%

INSERT INTO tbl_employees
    (fld_e_id_pk, fld_e_fname, fld_e_lname, fld_e_dob, fld_e_dept, fld_e_salary, fld_e_phone)
VALUES (1111,    'John',	   'Doe',	    '01/26/1997', 'Admin',	     56000,	  '8733'),
        (2222,   'Jane',	   'Roe',	    '07/23/1982', 'Engineering', 73000,	  '2239'),
        (3333,   'Joe',	       'Bloe',	    '03/14/2001', 'Circulation', 3200,	  '1595'),
        (4444,   'Sally',      'Waldron',  '06/22/1993',  'Engineering', 61000,	  '2220'),
        (5555,   'Bill',	   'Thompson',  '12/01/1989', 'Admin',	     53000,	  '1288');
/*
    I corrected the typo in "Jane Roe" record  Year = "1082" OK
    No field list - 15
    OK to write individual insert statements
    Minus 3 on invalid date format.  PostgreSQL accepts single digit day/month; most don't
*/

-- Data manipulation: 10%

UPDATE tbl_employees
SET fld_e_phone = '2340'
WHERE fld_e_id_pk = 2222; -- types in UPDATE match table

DELETE FROM tbl_employees
WHERE fld_e_dept = 'Circulation';


-- Optional
RESET SEARCH_PATH;
DROP TABLE tbl_employees CASCADE; -- CASCADE OK on a SCHEMA clean-up