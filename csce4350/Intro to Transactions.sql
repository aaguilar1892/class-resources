/*

    In the old days, transactions looked like this:
    
*/

BEGIN TRANSACTION

    -- executable code

COMMIT TRANSACTION;


-- That syntax is depreciated in favor of:

BEGIN

END;


/*
    There is usually some identifier that identifies it as a compilation block.  These are callec "compilation delimiters".  In PostgreSQL, a compilation delimiter is an identifier of zero or more characters.
    enclosed in two '$'.  The one I frequently use is: $GO$.
*/

DO $GO$
BEGIN 

    -- executable code
    
END $GO$;

/*
    Now, as you read the blogs, you will see that *many* programmers use $$ as a delimiter;  PLEASE DO NOT USE $$ AS A DELIMITER BECAUSE IT MESSES UP CANVAS FORMAT!  It's a Canvas issue, not a problem for PostgreSQL.
    
    This language has been around since the dawn of history (in computer terms, anyway) and is the oldest one still in use.
    
    Soon, a DECLARE block and an EXCEPTION block were added:
*/

DO $GO$
DECLARE
    -- here I may declare variables
    
    lv_name VARCHAR(16);
    
BEGIN
    -- Executable code goes here
    
    lv_name := 'John Doe'; -- note the assignment operator ":="
    
    RAISE INFO 'Good afternoon, %.', lv_name;
EXCEPTION
    -- If anything goes wrong, the execution block rolls *everything* back
    -- and aborts to here.  It does not reenter the execution block!
    
    WHEN OTHERS THEN NULL;
        /*
            The EXCEPTION block isn't required, but, if it's there, it cannot be empty.  That statement says effectively: WHEN ANY ERROR, DO NOTHING
        */    
END $GO$;




/*
    Now, we will take that anonymous transaction block and give it a name:
*/
DROP PROCEDURE IF EXISTS proc_hello; -- This is a *very* good idea, but not required

CREATE OR REPLACE PROCEDURE proc_hello()
    LANGUAGE PLPGSQL
AS $GO$
DECLARE
    -- here I may declare variables
    
    lv_name VARCHAR(16);
    
BEGIN
    -- Executable code goes here
    
    lv_name := 'John Doe'; -- note the assignment operator ":="
    
    RAISE INFO 'Good afternoon, %.', lv_name;
EXCEPTION
    -- If anything goes wrong, the execution block rolls *everything* back
    -- and aborts to here.  It does not reenter the execution block!
    
    WHEN OTHERS THEN NULL;
        /*
            The EXCEPTION block isn't required, but, if it's there, it cannot be empty.  That statement says effectively: WHEN ANY ERROR, DO NOTHING
        */    
END $GO$;


CALL proc_hello();


/*
    Let's add the idea of input parameters to our procedure:
*/

DROP PROCEDURE IF EXISTS proc_hello; -- This is a *very* good idea, but not required

CREATE OR REPLACE PROCEDURE proc_hello(IN parm_name VARCHAR(16))
    LANGUAGE PLPGSQL
AS $GO$    
BEGIN
    -- Executable code goes here
    
    RAISE INFO 'Good afternoon, %.', parm_name;
EXCEPTION
    -- If anything goes wrong, the execution block rolls *everything* back
    -- and aborts to here.  It does not reenter the execution block!
    
    WHEN OTHERS THEN NULL;
        /*
            The EXCEPTION block isn't required, but, if it's there, it cannot be empty.  That statement says effectively: WHEN ANY ERROR, DO NOTHING
        */    
END $GO$;

CALL proc_hello('Roger K.');

/*
    In C (and others), you had input only parameters (passed by *value*) and parameters passed by *reference* which were either input or output.
    
    This next example will demonstrate value & reference parameters as well as IF/THEN/ELSE logic.
    
    Write a procedure named proc_max that will receive four integer parameters.  The first three are input only, and the fourth in INOUT (reference).  The procedure will place the value of the greatest parameter passed in the first three into the fourth and return that.
    
    There are two variations on the old IF-THEN-ELSE thing:
    
        IF condition
        THEN
            BEGIN
                consequent code
            END
        ELSE (optional)
            BEGIN
                alternative code
            END
            
    We know this one from C.  Of course, se use {brackets} instead of BEGIN/END, but it works the same way.
    
    The other be like:
    
        IF condition
        THEN
            consequent code
        ELSE (optional)
            alternative code
        END IF;
        
    In the second example, we don't have a BEGIN/END, so we need the END IF to close it.
    
    When you see the second version, look for an ELSIF syntax:
    
        IF condition1
        THEN
            consequent1 code
        ELSIF condition2
            THEN
                consequent1 code
            ELSE
                alternative code
        END IF;
        
        Notice that this form allows me to write: "ELSE IF" without needing another "END IF"
        
        (The issue I have is its spelling!!!)
*/

    DROP PROCEDURE IF EXISTS proc_max;
    
    CREATE OR REPLACE PROCEDURE proc_max(IN parm_x INTEGER, IN parm_y INTEGER, 
                                          IN parm_z INTEGER, INOUT parm_max INTEGER)
        LANGUAGE PLPGSQL
    AS $GO$    
    BEGIN   
        IF parm_x >= parm_y AND parm_x >= parm_z
        THEN parm_max := parm_x;
        ELSIF parm_y >= parm_x AND parm_y >= parm_z
            THEN parm_max := parm_y;
            ELSIF parm_z >= parm_x AND parm_z >= parm_y
                THEN parm_max := parm_z;
        END IF;
    END $GO$;
    
/*
    Now, I hope you see how to make that procedure more efficient.  (If not, go back to CSCE 2100!)
*/

    DROP PROCEDURE IF EXISTS proc_max;
    
    CREATE OR REPLACE PROCEDURE proc_max(IN parm_x INTEGER, IN parm_y INTEGER, 
                                          IN parm_z INTEGER, INOUT parm_max INTEGER)
        LANGUAGE PLPGSQL
    AS $GO$    
    BEGIN   
        IF parm_x >= parm_y AND parm_x >= parm_z
        THEN parm_max := parm_x;
        ELSIF parm_y >= parm_z
            THEN parm_max := parm_y;
            ELSE parm_max := parm_z;
        END IF;
    END $GO$; 

/*
    Now, we want to execute our profound code.  So, we'll try:
    
    CALL proc_max(2, 5, 1, ... uuuh, oops, I need a variable here!
    
    In order to have a variable, I must be in a block, so I'll open an anonymous block
*/

    DO $GO$
    DECLARE
        lv_max INT;
    BEGIN
        CALL proc_max(2, 5, 1, lv_max);
        
        -- output
        RAISE INFO E'\n\nThe maximum value entered is: %.\n\n', lv_max;
    END $GO$;
    
/* -- ----------------------------------------------------------------------------

Another use for a procedure

*/
    DROP TABLE IF EXISTS tbl_names;
    
    CREATE TABLE tbl_names
    (
        fld_name VARCHAR(32) PRIMARY KEY -- Inline constraint!!!
    );
    
    
    TRUNCATE TABLE tbl_names;
    
    
    DROP PROCEDURE IF EXISTS proc_insert_name;
    
    CREATE OR REPLACE PROCEDURE proc_insert_name(parm_name VARCHAR(32))  -- "IN" is default
        LANGUAGE PLPGSQL
    AS $GO$    
    BEGIN
        INSERT INTO tbl_names(fld_name)
        VALUES (parm_name);
    END $GO$;
    
    CALL proc_insert_name('Al');
    CALL proc_insert_name('Bob');
    CALL proc_insert_name('Chas');
    
    SELECT * FROM tbl_names;
    
    CALL proc_insert_name('Bob');
    
    
-- ------------------------------
    
    
    
    DROP TABLE IF EXISTS tbl_names;
    
    CREATE TABLE tbl_names
    (
        fld_name VARCHAR(32),
        --
        CONSTRAINT names_pk PRIMARY KEY(fld_name)
    );
            
            
    DROP PROCEDURE IF EXISTS proc_insert_name;
    
    CREATE OR REPLACE PROCEDURE proc_insert_name(parm_name VARCHAR(32))  -- "IN" is default
        LANGUAGE PLPGSQL
    AS $GO$
    DECLARE 
        lv_constraint TEXT;
    BEGIN
        INSERT INTO tbl_names(fld_name)
        VALUES (parm_name);
    EXCEPTION
        WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS lv_constraint = CONSTRAINT_NAME;
   
            RAISE WARNING 
                E'\n\n\nException raised! You violated the constraint named: %.\n\n', lv_constraint;    
    END $GO$;
    
-- ----------------------------------------------------------------
-- Another approach

    DROP PROCEDURE IF EXISTS proc_insert_name;
    
    CREATE OR REPLACE PROCEDURE proc_insert_name(parm_name VARCHAR(32), 
                                                  INOUT parm_errlvl SMALLINT)
        LANGUAGE PLPGSQL
    AS $GO$
    DECLARE 
        lv_errlvl SMALLINT;
    BEGIN
        lv_errlvl := 0;
        
        IF parm_name IS NULL
        THEN lv_errlvl := 1;
        ELSIF
            EXISTS
            (
                SELECT *
                FROM tbl_names
                WHERE fld_name = parm_name
            )
            THEN lv_errlvl := 2;
            ELSE
                INSERT INTO tbl_names(fld_name)
                VALUES (parm_name);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN   
            RAISE WARNING 
                E'\n\n\nAn event that cannot occur has just occurred!\n\n';    
    END $GO$;
    
    -- Now, here I have added the INOUT parameter, so I need a variable:
    
    DO $GO$
    DECLARE
        lv_errlvl SMALLINT;
    BEGIN
            CALL proc_insert_name('Al', lv_errlvl);

            IF lv_errlvl = 0
            THEN RAISE INFO E'\n\nSuccess!';
            ELSE RAISE INFO E'\n\nError code = %.', lv_errlvl;
            END IF;

            CALL proc_insert_name('Bob', lv_errlvl);

            IF lv_errlvl = 0
            THEN RAISE INFO E'\n\nSuccess!';
            ELSE RAISE INFO E'\n\nError code = %.', lv_errlvl;
            END IF;

            CALL proc_insert_name('Chas', lv_errlvl);

            IF lv_errlvl = 0
            THEN RAISE INFO E'\n\nSuccess!';
            ELSE RAISE INFO E'\n\nError code = %.', lv_errlvl;
            END IF;

            CALL proc_insert_name(NULL, lv_errlvl);

            IF lv_errlvl = 0
            THEN RAISE INFO E'\n\nSuccess!';
            ELSE RAISE INFO E'\n\nError code = %.', lv_errlvl;
            END IF;

            CALL proc_insert_name('Bob', lv_errlvl);

            IF lv_errlvl = 0
            THEN RAISE INFO E'\n\nSuccess!';
            ELSE RAISE INFO E'\n\nError code = %.', lv_errlvl;
            END IF;
    END $GO$;

    