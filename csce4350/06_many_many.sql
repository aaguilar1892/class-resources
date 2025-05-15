/*
    What we know about the One-Many table join may extend to several generations:
*/

   SET SEARCH_PATH TO demo_29; 

    -- Drop foreign key first (before the parent (primary) key
    DROP TABLE IF EXISTS tbl_child;
    DROP TABLE IF EXISTS tbl_parent;
    DROP TABLE IF EXISTS tbl_grand_parent;
    
    -- Create in opposite order!
    CREATE TABLE tbl_grand_parent
    (
        fld_g_name_pk CHAR(16),
        --
        CONSTRAINT grand_parent_pk PRIMARY KEY(fld_g_name_pk)
    );

    CREATE TABLE tbl_parent
    (
        fld_p_name_pk CHAR(16),
        fld_g_name_fk CHAR(16),
        --
        CONSTRAINT parent_pk PRIMARY KEY(fld_p_name_pk),
        CONSTRAINT grand_parent_fk FOREIGN KEY(fld_g_name_fk) 
                                REFERENCES tbl_grand_parent(fld_g_name_pk)
    );

    CREATE TABLE tbl_child
    (
        fld_c_name_pk CHAR(16),
        fld_p_name_fk CHAR(16),
        --
        CONSTRAINT child_pk PRIMARY KEY(fld_c_name_pk),
        CONSTRAINT parent_fk FOREIGN KEY(fld_p_name_fk) 
                                REFERENCES tbl_parent(fld_p_name_pk)
    );
    
-- Populate primary key before foreign key:

    INSERT INTO tbl_grand_parent(fld_g_name_pk)
    VALUES('g_al'), ('g_bob'), ('g_chas');
    
    INSERT INTO tbl_parent(fld_p_name_pk, fld_g_name_fk)
    VALUES('p_arron', 'g_al'),('p_alice', 'g_al'),('p_arthur', 'g_al'),
    ('p_bill', 'g_bob'), ('p_bozo', 'g_bob'), ('p_betty', 'g_bob'), ('p_bono', 'g_bob'), 
    ('p_chuck', 'g_chas'), ('p_cindi', 'g_chas');
    
    INSERT INTO tbl_child(fld_c_name_pk, fld_p_name_fk)
    VALUES('c_alvin', 'p_arron'), ('c_al 2nd', 'p_alice'),('c_arial', 'p_arron'),
    ('c_bevis', 'p_bozo'), ('c_cathy', 'p_cindi'), ('annie', NULL);
    
    -- Show the children & grandchildren of 'g_al'
    
    SELECT fld_p_name_pk, fld_c_name_pk 
    FROM tbl_grand_parent INNER JOIN tbl_parent
        ON fld_g_name_pk = fld_g_name_fk
        INNER JOIN tbl_child
            ON fld_p_name_pk = fld_p_name_fk
    WHERE fld_g_name_pk = 'g_al';
    
    -- Who is the grand-parent of 'c_cathy'?
    SELECT fld_g_name_pk 
    FROM tbl_grand_parent INNER JOIN tbl_parent
        ON fld_g_name_pk = fld_g_name_fk
        INNER JOIN tbl_child
            ON fld_p_name_pk = fld_p_name_fk
    WHERE fld_c_name_pk = 'c_cathy';
    
    
    
    
    
    
    -- The MANY to MANY relationship
    
    DROP TABLE IF EXISTS tbl_dog_tricks; -- first
    DROP TABLE IF EXISTS tbl_dogs;      -- second (after dog_tricks)
    DROP TABLE IF EXISTS tbl_tricks;    -- second (after dog_tricks)
    DROP TABLE IF EXISTS tbl_owners;    -- last (after dogs)
    
    CREATE TABLE tbl_owners
    (
        o_id    INT,
        o_name  CHAR(8),
        --
        CONSTRAINT o_pk PRIMARY KEY(o_id)
    );
    
    
    CREATE TABLE tbl_dogs
    (
        d_id    INT,
        o_id    INT,
        d_name  CHAR(8),
        --
        CONSTRAINT d_pk PRIMARY KEY(d_id),
        CONSTRAINT d_fk FOREIGN KEY(o_id) REFERENCES tbl_owners(o_id)
    );
    
    
    CREATE TABLE tbl_tricks
    (
        t_id    INT,
        t_name  CHAR(16),
        --
        CONSTRAINT t_pk PRIMARY KEY(t_id)
    );
    
    -- the "bridge table" (many to many relationship)
    CREATE TABLE tbl_dog_tricks
    (
        d_id    INT,
        t_id    INT,
        --
        CONSTRAINT dt_pk PRIMARY KEY(d_id, t_id),
        CONSTRAINT dt_fkd FOREIGN KEY(d_id) REFERENCES tbl_dogs(d_id),
        CONSTRAINT dt_fkt FOREIGN KEY(t_id) REFERENCES tbl_tricks(t_id)
    );
        
    
    
INSERT INTO tbl_owners(o_id, o_name)
VALUES(1, 'Al'),(2, 'Bob'), (3, 'Chas');

INSERT INTO tbl_dogs(d_id, d_name, o_id)
VALUES(10, 'Spot', 1),(11, 'Phang', 1), (12, 'Phydeaux', 3);

INSERT INTO tbl_tricks(t_id, t_name)
VALUES(100, 'Roll over'),(101, 'Shake'), (102, 'play dead');

INSERT INTO tbl_dog_tricks(d_id, t_id)
VALUES
    (10, 101), -- Spot performs "shake"
    (10, 102), -- Spot can also play dead
    (12, 101); -- Phydeaux can shake.
    
-- List the trick names performed by 'Spot';

    SELECT t_name
    FROM tbl_dogs AS d INNER JOIN tbl_dog_tricks AS dt
        ON d.d_id = dt.d_id
        INNER JOIN tbl_tricks AS t
            ON dt.t_id = t.t_id
    WHERE d_name = 'Spot';
            
-- What tricks can Chas' dogs perform?
   SELECT t_name
    FROM tbl_tricks AS t INNER JOIN tbl_dog_tricks AS dt
        ON t.t_id = dt.t_id
        INNER JOIN tbl_dogs AS d
            ON dt.d_id = d.d_id
            INNER JOIN tbl_owners AS o
                ON d.o_id = o.o_id
    WHERE o_name = 'Chas';
    
    
-- Consider the diagram in module: "Foreign Keys and Inner Join"
-- page: Graphical Representation of CAP Database

-- Do you see any many-many relationships?