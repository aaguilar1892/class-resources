/*

                    CSCE 4350  Lecture 1


    Creating a database: This is one of those "iceberg" ideas.  It seems simple, yet 
    there's a lot going on.  Here's the documentation:

    https://www.postgresql.org/docs/current/sql-createdatabase.html

    For now, we'll just acknowledge that you have a default database that we created when
    your login was created.  This is where you "land" when you login.  It is named the same
    as your user name.

    We will avoid creating databases.  They are *very* consumptive of resources.  We will
    create one class database:
*/

CREATE DATABASE db50;

/*
    If it already exists, that's OK... you'll just see a message to that effect.

    To connect to our class database:
*/

\c db50

/*
    A semicolon after commands beginning with '\' is optional.  Otherwise, they're required.
    Here is a tutorial on the "slash" commands:
    https://www.postgresql.org/docs/7.0/app-psql.htm
*/



/*
    Within a database, exist one (actually two) or more schema.  A schema is to a database as a folder is to a disk... sort of.  A schema may contain objects such as tables.  A
    table name must be unique in a schema.

    To create a schema:
    
    
*/

    CREATE SCHEMA sch_name;

/*
    We don't "connect" to a schema like a folder; we set the SEARCH_PATH.
*/

    SET SEARCH_PATH TO sch_name;
    

/*
    Now, any tables you reference or create will be in sch_name.

    You could create the table using the schema name:
*/

    CREATE TABLE sch_name.tbl_mytable
    (
        fee INTEGER,
        fie CHAR(8),
        foe VARCHAR(16),
        fum BOOLEAN
    );
    
    CREATE TABLE tbl_mytable
    (
        fee INTEGER,
        fie CHAR(8),
        foe VARCHAR(16),
        fum BOOLEAN
    );

/*
    To set the SEARCH_PATH back to default:
*/

    RESET SEARCH_PATH;  -- or logout.

/*
    To delete the schema:
*/

    DROP SCHEMA sch_name CASCADE;

/*
    Note on CASCADE: I do not like to use CASCADE because that can have
    unintended consequences!  It drops everything in the schema!  I will allow
    its use for schema and *only* for schema.

    To see a list of your schema, use:
*/

    \dn

/*
    We will use schema like quickie databases.  They help organize your tables
    without the overhead of creating multiple databases.
*/

-- -------------------------------------------------------------------------

/*
    CREATING TABLES

    The basic object of a database is the table.  Think of a table as a *set*
    of records.

    -> A set has no order.  Something is either in a set or it isn't.

    -> A record is accessed by its content *only*, never by its position.

    -> A field of a record has exactly one value.

    -> No duplicate records

    What is the smallest group of fields (hopefully *one*) that, by design,
    will identify at most one record?  (E.g.: a social security number???)

    this is called the PRIMARY KEY.

    An example of a table using our class naming convention.
*/

    CREATE SCHEMA sch_lect1;  -- This happens once

    SET SEARCH_PATH TO sch_lect1; -- happens each time I log in.
        -- To check your SEARCH_PATH:
    SHOW SEARCH_PATH;

    DROP TABLE IF EXISTS tbl_fish;
    DROP TABLE IF EXISTS tbl_aquaria;

    CREATE TABLE tbl_aquaria
    (
        fld_aq_id_pk    INTEGER,
        fld_aq_name     VARCHAR(64),
        fld_aq_upc      CHAR(32),
        --
        CONSTRAINT aquaria_pk PRIMARY KEY(fld_aq_id_pk) -- no comma after last one
    );


    CREATE TABLE tbl_fish
    (
        fld_f_fishid_pk VARCHAR(64),
        fld_f_qty       INTEGER,
        --
        CONSTRAINT fish_pk PRIMARY KEY(fld_f_fishid_pk)
    );

    RESET SEARCH_PATH;
    DROP SCHEMA sch_lect1; -- I usually clean up demonstration code.  It's your call.

    -- ------------------------------------------------------

    /*
        How you will see it in some textbooks... this is WRONG!

        CREATE TABLE tbl_aquaria
        (
            fld_aq_id_pk    INTEGER PRIMARY KEY, -- NO, NO!!!
            fld_aq_name     VARCHAR(64),
            fld_aq_upc      CHAR(32)
        );

        That is called an "in-line constraint".  the previous version
        is known as a "named constraint".

        When I say: "We will always use named constraints", this is what
        I mean.  I'm aware that many programmers use in-line constraints;
        however, these people aren't in Dr. Smith's intro class!
        
        (FYI: The use of in-line constraints is my first alert that you might
         be using a code generator.  If we ever see an in-line constraint,
         you will lose points at a minimum.)



        Thus, the PRIMARY KEY is that smallest set of fields (preferably one,
        but possibly more) that will specify at most *one* record.  When
        one specifies the PRIMARY KEY (PK, from now on), we are saying that
        field is required and that it must be unique.

        A PK is unique by design.  For example, all of the people in a table
        might have unique hair color; this does *not* mean that hair_color
        should be a PK!

        The best example of a good choice for the PK would be a person's SSN.
        It might also be an auto-generated integer or a time stamp.  Your
        e-mail is used many times.  Today, cell phone numbers are commonly
        used.
*/

    -- This happens once
    CREATE SCHEMA demo;
    SET SEARCH_PATH TO demo;


    DROP TABLE IF EXISTS tbl_demo;
    -- We will always code in the DROP because, when we're working
    -- on tables, we will re-run the creation code frequently.

    CREATE TABLE tbl_demo    
    (
        fld_d_id_pk     CHAR(16),
        fld_d_lname     VARCHAR(32),
        fld_d_fname     VARCHAR(32),
        fld_d_shoesize  INTEGER,
        fld_d_active    BOOLEAN DEFAULT TRUE,
        fld_d_doc       TIMESTAMP DEFAULT NOW(), -- Date of Creation
        --
        CONSTRAINT demo_pk PRIMARY KEY(fld_d_id_pk),
        CONSTRAINT demo_null_lname CHECK( fld_d_lname IS NOT NULL ),
        CONSTRAINT valid_shoe   CHECK( fld_d_shoesize > 0 AND fld_d_shoesize < 20 )
    );
/*
    Data Types:

        CHAR(n): an array of n characters.  It always uses that many.
        In a relatively small field, *I* prefer CHAR to VARCHAR (next)

        VARCHAR(n): a variable sized string of char up to n.  If n is
        omitted, it's size is usually 4096, but don't quote me because
        platforms vary.  It the field might be large and varies widely,
        them VARCHAR might be preferable.  If it's small or tends to
        be of a consistent size, using CHAR avoids some overhead.

        I *try* to make n be a power of 2... when I can do so.

        Character Data Types Documentation:
        https://www.postgresql.org/docs/current/datatype-character.html
        
        TEXT   (aka: MEMO in some platforms)





        INTEGER: a typical, 32-bit integer.  We also have BIGINT (usually
        64-bit but sometimes 128) and SMALLINT (16-bit).  Many platforms
        (but not PostgreSQL) support TINYINT that's 8-bit, unsigned.

        NUMERIC(m,n): a fixed decimal number with a *total* of m digits
        where n of these are to the right of the decimal.

        Example: fld_e_salary NUMERIC(7,2) --> 94350.99 (7 total,2 decimal)
        Anytime the decimal is fixed and *always* has M total and N decimal,
        it easily transforms to an integer.

        DECIMAL: Same as NUMERIC, but has depreciated; don't use it.

        Numeric Data Types Documentation:
        https://www.postgresql.org/docs/current/datatype-numeric.html





        BOOLEAN: TRUE/FALSE  The Boolean type isn't usually implemented
        in favor of TINYINT.  I can easily make a BOOLEAN using a one-byte
        integer




        TIMESTAMP: Databases tend to have a rich set of types to maitain
        dates and times.  We will discuss these in far more detail later.
        Most common is the TIMESTAMP which contains both date and time
        with a one microsecond resolution.

        Temporal Data Types Documentation:
        https://www.postgresql.org/docs/8.2/datatype-datetime.html




        PostgreSQL rules for identifiers: no surprises here; they're just like C
        (Well, Microsoft products, in their wisdom, allow spaces in identifiers;
        however, they must be in [square brackets]... just don't do it!)

        Our class convention for identifiers: As you progress in your study of
        database, you will gain many layers of scope.  You will have identifiers
        in your SQL objects, procedures, functions... each of which will have
        arguments or parameters, local variables, then these will get passed
        up to a web interface in PHP.

        WE MUST BE ABLE TO TELL WHAT SOMETHING IS BY IT'S NAME! (Yes, I'm shouting.)

        Reserved words (code) are rendered in ALL CAPS.  SQL is usually not case
        sensitive; however, later it gets passed up to PHP and/or JavaScript and
        those little gems *are* case sensitive.

        Table Names:    tbl_mytable Begin with "tbl_"
        Field names:    fld_m_id_pk "fld_" + enough_of_table_name + identifier + "pk" if PK
*/


-- Inserting data into a table:

-- Condsider tbl_demo (above and reproduced here)

    CREATE TABLE tbl_demo
    (
        fld_d_id_pk     CHAR(16),
        fld_d_lname     VARCHAR(32),
        fld_d_fname     VARCHAR(32),
        fld_d_shoesize  INTEGER,
        fld_d_active    BOOLEAN DEFAULT TRUE,
        fld_d_doc       TIMESTAMP DEFAULT NOW(), -- Date of Creation
        --
        CONSTRAINT demo_pk PRIMARY KEY(fld_d_id_pk),
        CONSTRAINT demo_null_lname CHECK( fld_d_lname IS NOT NULL ),
        CONSTRAINT valid_shoe   CHECK( fld_d_shoesize > 0 AND fld_d_shoesize < 20 )
    );



    INSERT INTO tbl_demo(fld_d_id_pk, fld_d_lname, fld_d_fname, fld_d_shoesize)
    VALUES  (   'K5MYF',    'Jones',    NULL,       9 ),
            (   'K34FM',    'Garcia',   'Roger',    12 ),
            (   'Z89Y',     '',         'Joe',      9 );
/*

    Let's take a close look at that last line: ( 'Z89Y', '', 'Joe', 9 )

        fld_d_id_pk <-- 'Z89Y'  OK, it's NOT NULL and UNIQUE
        fld_d_lname <-- ''  & here's a problem!  The last name field is constrained NOT NULL
            but '' is the character string containing zero characters!  This satisfies
            the NOT NULL constraint!

        Note: many platforms use *LEN* instead of *LENGTH*

        So, to clean up the example:
*/
    DROP TABLE IF EXISTS tbl_demo;

    CREATE TABLE tbl_demo
    (
        fld_d_id_pk     CHAR(16),
        fld_d_lname     VARCHAR(32),
        fld_d_fname     VARCHAR(32),
        fld_d_shoesize  INTEGER,
        fld_d_active    BOOLEAN DEFAULT TRUE,
        fld_d_doc       TIMESTAMP DEFAULT NOW(), -- Date of Creation
        --
        CONSTRAINT demo_pk PRIMARY KEY(fld_d_id_pk),
        CONSTRAINT zero_len_pk CHECK(LENGTH(fld_d_id_pk) > 0),
        CONSTRAINT demo_null_lname 
            CHECK( fld_d_lname IS NOT NULL AND LENGTH(fld_d_lname) > 0 ),
        CONSTRAINT valid_shoe   CHECK( fld_d_shoesize > 0 AND fld_d_shoesize < 20 )
    );

    INSERT INTO tbl_demo(fld_d_id_pk, fld_d_lname, fld_d_fname, fld_d_shoesize)
    VALUES  (   'K5MYF', 'Jones', NULL, 9 ),
            (   '3X5C', 'Smith', NULL , 8 ),
            (   'K34FM', 'Garcia', 'Roger', 12 ),
            (   'Z89Y', 'Last name unk', 'Joe', 9 );

--    Let's test our constraint on last name:

    INSERT INTO tbl_demo(fld_d_id_pk, fld_d_lname, fld_d_fname, fld_d_shoesize)
    VALUES  (   'xxxx', NULL, 'Bob', 9 ); -- I expected it to fail; however
    -- it did not!  I need to do further research on this!

    INSERT INTO tbl_demo(fld_d_id_pk, fld_d_lname, fld_d_fname, fld_d_shoesize)
    VALUES  (   'yyyy', '', 'Bob', 9 ); -- Expect to fail



--    Take a looky-loo:

    SELECT * FROM tbl_demo;

    RESET SEARCH_PATH;
    DROP SCHEMA demo CASCADE;


-- *****************************************


