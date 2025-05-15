/*
    Consider two related tables: tbl_parent and tbl_child
    
    A *parent* has an id and a name... that's enough for the demo.
    
    A *child* also has an id and a name.
*/

    CREATE SCHEMA IF NOT EXISTS demo_29;
    SET SEARCH_PATH TO demo_29;

    DROP TABLE IF EXISTS tbl_child;  -- Drop the child first!!!
    DROP TABLE IF EXISTS tbl_parent;
    
    CREATE TABLE tbl_parent          -- Create the parent first!!!
    (
        fld_p_id_pk INT,
        fld_p_name  CHAR(16),
        --
        CONSTRAINT parent_pk PRIMARY KEY(fld_p_id_pk)
    );
    
    CREATE TABLE tbl_child
    (
        fld_c_id_pk INT,
        fld_c_name  CHAR(16),
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id_pk)
    );
    
    
    INSERT INTO tbl_parent(fld_p_id_pk, fld_p_name)
    VALUES  ( 1, 'Al'),
            ( 2, 'Bob'),
            ( 3, 'Cindi'),
            ( 4, 'Debbie');
            
    INSERT INTO tbl_child(fld_c_id_pk, fld_c_name)
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

            
    CREATE SCHEMA IF NOT EXISTS demo_29;        
    SET SEARCH_PATH TO demo_29;
    
    DROP TABLE IF EXISTS tbl_child;  -- Drop the child first!!!
    DROP TABLE IF EXISTS tbl_parent;
    
    CREATE TABLE tbl_parent          -- Create the parent first!!!
    (
        fld_p_id_pk INT,
        fld_p_name  CHAR(24),
        --
        CONSTRAINT parent_pk PRIMARY KEY(fld_p_id_pk)
    );
    
    CREATE TABLE tbl_child
    (
        fld_c_id_pk INT,
        fld_c_name  CHAR(24),
        fld_p_id_fk INT, -- here is the FOREIGN KEY
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id_pk),
        --
        CONSTRAINT child_fk FOREIGN KEY(fld_p_id_fk)
            REFERENCES tbl_parent(fld_p_id_pk)
    ); 

    INSERT INTO tbl_parent(fld_p_id_pk, fld_p_name)
    VALUES  ( 1, 'Al'),
            ( 2, 'Bob'),
            ( 3, 'Cindi'),
            ( 4, 'Debbie');
            
    INSERT INTO tbl_child(fld_c_id_pk, fld_c_name, fld_p_id_fk)
    VALUES  ( 100, 'Aaron', 1),
            ( 200, 'Anthony', 1),
            ( 300, 'Brenda', 2),
            ( 400, 'Dale', 4),
            ( 500, 'Dean', 4);    
            
    -- fails:
    INSERT INTO tbl_child(fld_c_id_pk, fld_c_name, fld_p_id_fk)
    VALUES  ( 600, 'Bogus Bob', -13);
    
    -- At this point, there is nothing to prevent a NULL foreign key:
    
    INSERT INTO tbl_child(fld_c_id_pk, fld_c_name, fld_p_id_fk)
    VALUES  ( 700, 'Orphan Annie', NULL);
    
    /*
        Orphans are not bad for the database; however, your application
        might not want to allow child records with no parent.
    
    CREATE TABLE tbl_child
    (
        fld_c_id_pk INT,
        fld_c_name  CHAR(16),
        fld_p_id_fk INT,
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id_pk),
        --
        CONSTRAINT child_fk FOREIGN KEY(fld_p_id_fk)
            REFERENCES tbl_parent(fld_p_id_pk),
        --
        CONSTRAINT child_no_orphans CHECK( fld_p_id_fk IS NOT NULL)
    );
    
    
    -- This can be done; however, it's better practice to write the
    -- constraints when the table is created.
    */
    
    ALTER TABLE tbl_child ADD
        CONSTRAINT child_no_orphans CHECK( fld_p_id_fk IS NOT NULL);
    
        
    SELECT * FROM tbl_child;
    
    /*
   
    So, we have a problem!  We don't want orphan records (NULL FOREIGN KEY),
    but we already have them!  (Be advised that many DBs don't check existing
    records!
    
    What can we do?  Delete the orphan records?  (This isn't recommended.)
    
    If I can, I will create a record in the parent table named "Parent of Orphans"
    
    */
    
    INSERT INTO tbl_parent(fld_p_id_pk, fld_p_name)
    VALUES  ( 0, 'Parent of Orphans');
    
    -- Now, 
    UPDATE tbl_child 
    SET fld_p_id_fk = 0
    WHERE fld_p_id_fk IS NULL;
    
    /*
        Finding invalid parents is more difficult.  We'll take that one later.
        
        We would only get invalid parents if we tried to add the FOREIGN KEY
        constraint after we already had data in the table.
    */
        
    
    
    
    RESET SEARCH_PATH;
    DROP SCHEMA demo_29 CASCADE;
    
    




