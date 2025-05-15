/*
    A constraint restricts what data may be entered into a table.
    Common examples of constraints are:
    
        PRIMARY KEY
        
        FOREIGN KEY REFERENCES tbl_name(fld_name)
        
        UNIQUE
        
        NOT NULL
        
        CHECK( Boolean statement )
        
        Others exist; these are common.
        
    When a constraint is declared on the same line as the field name is defined, it is
    known as an *inline constraint*.  Examples of inline constraints are:
*/    
    CREATE TABLE tbl_foo
    (
        fld_fee CHAR(8) PRIMARY KEY,
        fld_fie INT FOREIGN KEY REFERENCES tbl_baz(fld_quux),
        fld_foe VARCHAR(8) UNIQUE,
        fld_fum TEXT NOT NULL,
        fld_moe DATE CHECK(fld_moe < '2025-04-01')
    );
/*
    
    Do they work?  Yes!  Do programmers use them?  Of course they do.  They're all over
    the PostgreSQL documentation.
    
    I have stressed a more rigorous method called *named constraints*.  When a 
    named constraint is used, *only* the field name and type appears on the definition
    line (except the term "DEFAULT", which isn't a constraint because it does not restrict
    data.)
    
    Example of a table with named constraints:
*/
    
    CREATE TABLE tbl_foo
    (
        fld_fee CHAR(8),
        fld_fie INT,
        fld_foe VARCHAR(8),
        fld_fum TEXT,
        fld_moe DATE DEFAULT NOW(),
        /*
            The constraints usually follow the field definitions
            in the same order.
        */
        CONSTRAINT name_x PRIMARY KEY(fld_fee),
        CONSTRAINT name_y FOREIGN KEY(fld_fie) REFERENCES tbl_baz(fld_quux),
        CONSTRAINT name_z UNIQUE(fld_foe),
        CONSTRAINT name_p CHECK(fld_fum IS NOT NULL),
        CONSTRAINT name_q CHECK(fld_moe < '2025-04-01')
    );
    
    -- Constraint names are unique within a schema; i.e. two tables may not use the
    -- same constraint names.
    
/*
    There is a reason why we learn to use NAMED CONSTRAINTS.
    
    In the next topic, you will learn of transaction blocks and exception
    handlers:
*/
    DROP TABLE IF EXISTS tbl_figmo;
    
    CREATE TEMPORARY TABLE tbl_figmo
    (
        fld_fig CHAR(8),
        --
        CONSTRAINT valid_fig CHECK(fld_fig <> 'ERROR')
    );
    
    
    
    
    -- Now, I will create a compiled transaction with an EXCEPTION handler:
    
    DO $GO$
    DECLARE
        lv_constraint TEXT;
        lv_tblname TEXT;
    BEGIN
        INSERT INTO tbl_figmo(fld_fig) VALUES('ERROR'); -- hits constraint
        
    EXCEPTION -- error handler block
        WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS lv_tblname = TABLE_NAME, lv_constraint = CONSTRAINT_NAME;
   
            RAISE WARNING 
                E'\n\n\nException raised! table name: %, constraint name: %.\n\n', 
                            lv_tblname, lv_constraint;
    END $GO$;
    
/*
    The bottom line is that, with a named constraint, my code can pinpoint the source of an
    exception and take whatever action is needed (hopefully) to recover.  If you don't name
    the constraint, the system just gives them a long, arbirtary name.
    
    And, the *VERY* bottom line is that, if you insist on writing inline constraints, it will hurt
    your grade in the class.
*/

