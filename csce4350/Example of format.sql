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
-- Example of good format
    
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
    
 
-- Example of code ignoring format... minus 50%

CREATE TABLE tbl_members(
fld_id_pk INTEGER,
fld_fname VARCHAR(16),
fld_lname VARCHAR(32),
fld_pos TEXT,
fld_salut CHAR(4),
fld_street VARCHAR(32),
fld_city CHAR(16),
fld_state CHAR(2),
fld_zip VARCHAR(16),
fld_phone CHAR(9),
fld_share NUMERIC(5,3),
fld_years INTEGER DEFAULT 0,
CONSTRAINT m_pk PRIMARY KEY(fld_id_pk), 
CONSTRAINT valid_fname CHECK( NULLIF(fld_fname,'') IS NOT NULL),
CONSTRAINT valid_lname CHECK( NULLIF(fld_lname,'') IS NOT NULL),
CONSTRAINT valid_pos CHECK( LENGTH(fld_pos) <> 0), -- OK for NULL
CONSTRAINT valid_salut CHECK( LENGTH(fld_salut) <> 0),
CONSTRAINT valid_street CHECK( NULLIF(fld_street,'') IS NOT NULL),
CONSTRAINT valid_city CHECK( NULLIF(fld_city,'') IS NOT NULL),
CONSTRAINT valid_state CHECK( fld_state IS NOT NULL AND LENGTH(fld_state)=2 ),
CONSTRAINT valid_zip CHECK( NULLIF(fld_zip,'') IS NOT NULL),
CONSTRAINT valid_phone CHECK( NULLIF(fld_phone,'') IS NOT NULL),
CONSTRAINT valid_share CHECK(fld_share IS NOT NULL),
CONSTRAINT valid_years CHECK(fld_years IS NOT NULL));

-- Example of code that ignores conventions:  (Rejected... zero)

CREATE TABLE tbl_members(
fld_id_pk INTEGER PRIMARY KEY,
fld_fname VARCHAR(16) NOT NULL,
fld_lname VARCHAR(32) NOT NULL,
fld_pos TEXT NOT NULL,
fld_salut CHAR(4),
fld_streetVARCHAR(32) NOT NULL,
fld_city CHAR(16) NOT NULL,
fld_state CHAR(2) NOT NULL,
fld_zipVARCHAR(16) NOT NULL,
fld_phone CHAR(9) NOT NULL,
fld_share NUMERIC(5,3),
fld_years INTEGER  NOT NULL);