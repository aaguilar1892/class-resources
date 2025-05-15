

/*
    Consider two related tables: tbl_parent and tbl_child
    
    A *parent* has an id and a name... that's enough for the demo.
    
    A *child* also has an id and a name.
    
    Now, a parent has zero or more children; a child has at most one parent (orphans have no parent.)  This is also known as a *ONE TO MANY* relationship.
*/

    CREATE SCHEMA IF NOT EXISTS demo_29;
    SET SEARCH_PATH TO demo_29;

    DROP TABLE IF EXISTS tbl_child;  -- Drop the child first!!!
    DROP TABLE IF EXISTS tbl_parent;
    
    CREATE TEMP TABLE tbl_parent          -- Create the parent first!!!
    (
        fld_p_id INT,
        fld_p_name  CHAR(16),
        --
        CONSTRAINT parent_pk PRIMARY KEY(fld_p_id)
    );
    
    CREATE TEMP TABLE tbl_child
    (
        fld_c_id INT,
        fld_c_name  CHAR(16),
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id)
    );
    
    
    INSERT INTO tbl_parent(fld_p_id, fld_p_name)
    VALUES  ( 1, 'Al'),
            ( 2, 'Bob'),
            ( 3, 'Cindi'),
            ( 4, 'Debbie');
            
    INSERT INTO tbl_child(fld_c_id, fld_c_name)
    VALUES  ( 100, 'Aaron'),
            ( 200, 'Anthony'),
            ( 300, 'Brenda'),
            ( 400, 'Dale'),
            ( 500, 'Dean');
            
-- How do I *know* that Aaron is Al's child?

-- A child has only one parent.
-- A parent has zero or more children.

-- A one-many relationship
-- The primary key of the "one" side is copied into the "many" side
-- where it becomes known as a FOREIGN KEY.

            
    -- Still using previous SCHEMA 
    
    DROP TABLE IF EXISTS tbl_child;  -- Drop the child first!!!
    DROP TABLE IF EXISTS tbl_parent;
    -- DO NOT USE "CASCADE" to avoid dropping in order.
    -- That is sloppy programming.
    
    CREATE TEMP TABLE tbl_parent          -- Create the parent first!!!
    (
        fld_p_id INT,
        fld_p_name  CHAR(24),
        --
        CONSTRAINT parent_pk PRIMARY KEY(fld_p_id)
    );
    
    CREATE TEMP TABLE tbl_child
    (
        fld_c_id INT,
        fld_c_name  CHAR(24),
        fld_p_id INT, -- here is the FOREIGN KEY
        
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id),
        --
        CONSTRAINT child_fk FOREIGN KEY(fld_p_id) -- here is the FOREIGN KEY 
            REFERENCES tbl_parent(fld_p_id)       -- constraint.
    ); 
    
/*
    Notice that the primary key in tbl_parent and the foreign key in tbl_child have identical names.  There is some debate in the database community on this matter.  In my next example (below), I will demonstrate naming them differently.  Either method has its advantages and its disadvantages.
*/

    INSERT INTO tbl_parent(fld_p_id, fld_p_name)
    VALUES  ( 1, 'Al'),
            ( 2, 'Bob'),
            ( 3, 'Cindi'),
            ( 4, 'Debbie');
            
    INSERT INTO tbl_child(fld_c_id, fld_c_name, fld_p_id)
    VALUES  ( 100, 'Aaron', 1),
            ( 200, 'Anthony', 1),
            ( 300, 'Brenda', 2),
            ( 400, 'Dale', 4),
            ( 500, 'Dean', 4);    
/*
    "Aaron" and "Anthony" both have parent "Al" because they have Al's id (1) in their foreign key (fld_p_id) field.
    
    The restriction on a foreign key is: *IF* the record has a foreign key, THEN
    that key *must* be in the parent table!

    For example, the following insert would fail because the related value (-13) does not appear as the primary key of a record in the parent table.
*/          
    -- fails:
    INSERT INTO tbl_child(fld_c_id, fld_c_name, fld_p_id)
    VALUES  ( 600, 'Bogus Bob', -13);
/*
    A foreign key may be NULL.  In this case, we say that it's an "orphan record"
*/
    INSERT INTO tbl_child(fld_c_id, fld_c_name, fld_p_id)
    VALUES  ( 700, 'Orphan Annie', NULL); -- legal record
    
/*
    Orphans are not bad for the database; however, your application might not want to allow child records with no parent.  (Would you really want to have a dependent in your HR database if he or she had no sponsor?)
    
    We would block orphans when we created the tbl_child table:
*/

    DROP TABLE IF EXISTS tbl_child;
    
    CREATE TEMP TABLE tbl_child
    (
        fld_c_id INT,
        fld_c_name  CHAR(16),
        fld_p_id INT,
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id),
        --
        CONSTRAINT child_fk FOREIGN KEY(fld_p_id)
            REFERENCES tbl_parent(fld_p_id),
        --
        CONSTRAINT child_no_orphans CHECK( fld_p_id IS NOT NULL)
    );
        
/*    
    Alternatively, we could add the constraint after the fact, thus:
*/ 
    ALTER TABLE tbl_child ADD
        CONSTRAINT child_no_orphans CHECK( fld_p_id IS NOT NULL);
/*
    It is better practice to include the constraint when the table is created because, if there were existing NULL values, it would cause problems in that we would have non-compliant data in the table.
        
    I could check for orphans before I tried to add the constraint:
*/
    SELECT * FROM tbl_child
    WHERE fld_p_id IS NULL;
/*
   
    So, if there are any,we have a problem!  We don't want orphan records (NULL FOREIGN KEY), but we already have them!  (Be advised that many DBs don't check existing records!
    
    What can we do?  Delete the orphan records?  (This isn't recommended.)
    
    *If I can*, I will create a record in the parent table named "Parent of Orphans"
*/
    
    INSERT INTO tbl_parent(fld_p_id, fld_p_name)
    VALUES  ( 0, 'Parent of Orphans');
/*
    "If I can..." means that I have an unused value for the PK of tbl_parent.  In this case, I assume that I can use 0.  If you have that, it's an easy way out. (You won't always be so lucky to have such a value, though.)   
*/    
    -- Now, 
    UPDATE tbl_child 
    SET fld_p_id = 0
    WHERE fld_p_id IS NULL;
/*
    This works fairly well.  With this method, I no longer have NULL values for the foreign key; however, I can still allow orphans... they simply have a value of 0 instead of NULL... and having a value is always better than NULL!
    
    In this case, I would rewrite tbl_child thus:
*/
    CREATE TEMP TABLE tbl_child
    (
        fld_c_id INT,
        fld_c_name  CHAR(16),
        fld_p_id INT DEFAULT 0, -- notice the DEFAULT value.
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id),
        --
        CONSTRAINT child_fk FOREIGN KEY(fld_p_id)
            REFERENCES tbl_parent(fld_p_id),
        --
        CONSTRAINT child_no_orphans CHECK( fld_p_id IS NOT NULL)
    );
/*
    The DEFAULT looks like an inline constraint, but it isn't a constraint. 
    
    Assuming that ( 0, 'Parent of Orphans') exists in tbl_parent, then the following is a valid insert into tbl_child:
*/
    INSERT INTO tbl_child(fld_c_id, fld_c_name)
    VALUES  ( 600, 'Orphan Annie');
/*
    Annie would default to zero for her parent... which is a valid parent record!  You could *not* insert NULL because that would violate the constraint.  In this case, a value of zero actually *means* NULL to the human reader; however, NULL values in the DB are generally undesirable.
*/


/*
    Here is how you'll see it on the test:
    
    Create a one-to-many relationship of owners to pets where:
    
    An owner has zero or more pets and a pet has [at most/exactly] one owner.
    "at most" allows NULL, "exactly" constrains against NULL
    
    
    Try it before you peek:
    
    
    
    
    
    
    
    
    Solution
*/    
    DROP TABLE IF EXISTS tbl_pet;  -- always drop child first; do not CASCADE
    DROP TABLE IF EXISTS tbl_owner;
    
    CREATE TABLE tbl_owner
    (
        fld_o_id_pk     INTEGER,     
        fld_o_name      CHAR(8), -- may vary
        --
        CONSTRAINT owner_pk PRIMARY KEY(fld_o_id_pk)
    );
    
    -- Assume "exactly one owner"
    CREATE TABLE tbl_pet
    (
        fld_p_id_pk     INTEGER,
        fld_p_name      CHAR(8),
        
        fld_o_id_fk     INT, -- OK to abbreviate
        --
        CONSTRAINT pet_pk PRIMARY KEY(fld_p_id_pk),
        CONSTRAINT pet_fk FOREIGN KEY(fld_o_id_fk)
            REFERENCES tbl_owner(fld_o_id_pk),
        CONSTRAINT no_orphans CHECK(fld_o_id_fk IS NOT NULL)
    );
    
    -- Notice that I have chosen to make the foreign key's spelling different!
    -- There are advantages and disadvantages either way.
/*   
    Insert owners: Al, Bob, Chas
    
    Insert pets: Phydeaux owned by Chas, Phang and Tiger owned by Al; Bob has no pets
*/
    INSERT INTO tbl_owner(fld_o_id_pk, fld_o_name)
    VALUES (1, 'Al'), (2, 'Bob'), (3, 'Chas');
    
    INSERT INTO tbl_pet(fld_p_id_pk, fld_p_name, fld_o_id_fk)
    VALUES (100, 'Phydeaux', 3), (200, 'Phang', 1), (300, 'Tiger', 1);
    
/*
    So, when you inserted 'Phydeaux', you had to look up Chas' primary key!!!
 
    You *will* see that kind of thing in the test.  Get used to it now!
*/

-- I suppose I'll clean up after myself:
   DROP SCHEMA IF EXISTS demo_29 CASCADE; -- we CASCADE schema drops



