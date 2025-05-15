/*
    Example:
    
    Create a table that will be able to contain records of committee members.
    
    It should include:
        member ID  (required, unique)  -- (that means it's a primary key [PK])
        Member name (first, last)
        Position
        Salutation ("Dr", "Mr", etc)
        Address (street, city, State [2 char], zip))
        Phone
        Percent share: number with 5 digits, three of them right of the decimal
            (I don't know what this is, but I wanted a number)
        Number of years service (integer)
        
    Constrain name, address, and phone against NULL
    Position & salutation may be NULL, but not zero length.
    (Any NOT NULL constraint will also constrain zero length.)
    
    Use appropriate naming conventions and data types.
    
*/

    -- assume the schema "committees" exists abd that the database is db50.
    -- If not, create it
    \c db50
    
    CREATE SCHEMA IF NOT EXISTS committees;
    
    SET SEARCH_PATH TO committees;

    DROP TABLE IF EXISTS tbl_members;
    
    CREATE TABLE tbl_members
    (
        fld_id_pk   INTEGER, -- could be CHAR or VARCHAR
        fld_fname   VARCHAR(16),
        fld_lname   VARCHAR(32),
        fld_pos     TEXT, -- most database admins use VARCHAR
        fld_salut   CHAR(4),
        fld_street  VARCHAR(32),
        fld_city    CHAR(16),
        fld_state   CHAR(2), -- 2 char required
        fld_zip     VARCHAR(16),
        fld_phone   CHAR(9),
        fld_share   NUMERIC(5,3),
        fld_years   INTEGER DEFAULT 0, -- also "INT" works  ("DEFAULT" isn't a constraint)
        --
        CONSTRAINT m_pk PRIMARY KEY(fld_id_pk), -- requires UNIQUE & NOT NULL
                                                  -- allows zero length on character fields
        --
        CONSTRAINT valid_fname CHECK( NULLIF(fld_fname,'') IS NOT NULL),
        --
        CONSTRAINT valid_lname CHECK( NULLIF(fld_lname,'') IS NOT NULL),
        --
        CONSTRAINT valid_pos CHECK( LENGTH(fld_pos) <> 0), -- OK for NULL
        --
        CONSTRAINT valid_salut CHECK( LENGTH(fld_salut) <> 0),
        --
        CONSTRAINT valid_street CHECK( NULLIF(fld_street,'') IS NOT NULL),
        --
        CONSTRAINT valid_city CHECK( NULLIF(fld_city,'') IS NOT NULL),
        --
        CONSTRAINT valid_state CHECK( fld_state IS NOT NULL AND LENGTH(fld_state)=2 ),
        --
        CONSTRAINT valid_zip CHECK( NULLIF(fld_zip,'') IS NOT NULL),
        --
        CONSTRAINT valid_phone CHECK( NULLIF(fld_phone,'') IS NOT NULL),
        --
        CONSTRAINT valid_share CHECK(fld_share IS NOT NULL),
        --
        CONSTRAINT valid_years CHECK(fld_years IS NOT NULL)
    );
    
        /*
            Another commonly-seen constraint:
            CONSTRAINT example UNIQUE(fld_example),
        */
        
        
        
                                                  
/*
    Insert the following data:
    
    100, 'John', 'Doe', 'Secretary', 'Mr', '123 4th St', 'Denton', 'TX', '76209', 0, 0
    200, 'Jane', 'Roe', 'New Member', NULL, '234 5th St', 'Plano', 'TX', '76209', 0, 0
    300, 'Joe', 'Bloe', 'President', 'Dr', '345 6th St', 'Dallas', 'TX', '77012', 5, 3
*/

    INSERT INTO tbl_members(fld_id_pk, fld_fname, fld_lname, fld_pos, fld_salut, fld_street,
                            fld_city, fld_state, fld_zip, fld_phone, fld_share, fld_years)
    VALUES(100, 'John', 'Doe', 'Secretary', 'Mr', '123 4th St', 'Denton', 'TX', '76209', '1234', 0, 0);
    
    -- Another form:
    INSERT INTO tbl_members(fld_id_pk, fld_fname, fld_lname, fld_pos, fld_salut, fld_street,
                            fld_city, fld_state, fld_zip, fld_phone, fld_share, fld_years)
    VALUES
        (200, 'Jane', 'Roe', 'New Member', NULL, '234 5th St', 'Plano', 'TX', '76209', '2345', 0, 0),
        (300, 'Joe', 'Bloe', 'President', 'Dr', '345 6th St', 'Dallas', 'TX', '77012', '5678', 5, 3);
        
        
    SELECT fld_id_pk, fld_fname, fld_lname
    FROM tbl_members;


-- UPDATE the phone for member ID 200 to '5562'

    UPDATE tbl_members
    SET fld_phone = '5562'
    WHERE fld_id_pk = 200;
    
    -- let's make sure!
    SELECT fld_id_pk, fld_phone
    FROM tbl_members;
    
    -- notice that the order changed.  This is a PostgreSQL issue... we didn't
    -- ask for any particular order.
    
    SELECT fld_id_pk, fld_phone
    FROM tbl_members
    ORDER BY fld_id_pk;
    
-- delete the record(s) where fld_pos = 'New Member'.

    DELETE FROM tbl_members
    WHERE fld_pos = 'New Member';



DROP SCHEMA committees CASCADE; -- goodbye schema & tables in it!!!