-- The best way to view a table join is to consider two related tables.

CREATE SCHEMA IF NOT EXISTS sch_join;
SET SEARCH_PATH TO sch_join;

DROP TABLE IF EXISTS tbl_child; -- Drop the child First, then the parent
DROP TABLE IF EXISTS tbl_parent;

-- ------------------------------------------------------

CREATE TABLE tbl_parent -- Create the parent first
(
    fld_p_id_pk INTEGER,
    fld_p_name  CHAR(8),
    CONSTRAINT parent_PK PRIMARY KEY(fld_p_id_pk)
);

CREATE TABLE tbl_child
(
    fld_c_id_pk INTEGER,
    fld_c_name  CHAR(8),
    fld_p_id_fk   INTEGER,
    CONSTRAINT child_pk PRIMARY KEY(fld_c_id_pk),
    CONSTRAINT parent_fk FOREIGN KEY(fld_p_id_fk) REFERENCES tbl_parent(fld_p_id_pk)
);

INSERT INTO tbl_parent(fld_p_id_pk, fld_p_name)
VALUES (1, 'Al'),
        (2, 'Betty'),
        (3, 'Chas');


-- First, insert the parent, then the child

INSERT INTO tbl_child(fld_c_id_pk, fld_c_name, fld_p_id_fk)
VALUES (100, 'Jack', 3), -- Jack's parent is Chas
        (200, 'Jill', 3), -- Jill's parent is also Chas
        (300, 'Al Jr', 1), -- Al Jr's parent Al -- Sally's parent Debbie
        (400, 'Annie', NULL); -- Annie is an orphan (no parent)
        -- Betty is a childless parent

/*
    Al    -->  Al Jr
    Betty --> No children
    Chas  --> Jack, Jill
              Annie is an orphan

-- First, I will use the old, implicit join because it's easier to see
*/

SELECT  fld_p_name, fld_p_id_pk, fld_p_id_fk, fld_c_name
FROM tbl_parent, tbl_child;

/*
 fld_p_name | fld_p_id_pk | fld_p_id_fk | fld_c_name
------------+-------------+-------------+------------
 Al         |           1 |           3 | Jack
 Al         |           1 |           3 | Jill
 Al         |           1 |           1 | Al Jr
 Al         |           1 |             | Annie
 Betty      |           2 |           3 | Jack
 Betty      |           2 |           3 | Jill
 Betty      |           2 |           1 | Al Jr
 Betty      |           2 |             | Annie
 Chas       |           3 |           3 | Jack
 Chas       |           3 |           3 | Jill
 Chas       |           3 |           1 | Al Jr
 Chas       |           3 |             | Annie

How many rows?

Which ones do we want?
*/

-- Now, I will paint in the condition:
SELECT  fld_p_name, fld_p_id_pk, fld_p_id_fk, fld_c_name
FROM tbl_parent, tbl_child
WHERE fld_p_id_pk = fld_p_id_fk; -- Where the primary key is equal to the foreign key








/*
    This is known as the INNER JOIN.  Notice its properties:  It only returns rows that
    participate in the relationship.  It does not return orphans or childless parents
    because the condition *fld_p_id_pk = fld_p_id_fk* is never satisfied.  Remember that
    NULL = anything (including NULL) is FALSE!  We have another tool for returning
    orphans and childless parents; more on that later.

    Many SQL programmers will keep the same name of the PK when they write the FK.
    People of that belief would create the tables thus:
*/
    DROP TABLE IF EXISTS tbl_child; -- Drop the child First, then the parent
    DROP TABLE IF EXISTS tbl_parent;

    CREATE TABLE tbl_parent -- Create the parent first
    (
        fld_p_id INTEGER,
        fld_p_name  CHAR(8),
        CONSTRAINT parent_PK PRIMARY KEY(fld_p_id)
    );

    CREATE TABLE tbl_child
    (
        fld_c_id INTEGER,
        fld_c_name  CHAR(8),
        fld_p_id   INTEGER, -- foreign key named the same as the primary key
        CONSTRAINT child_pk PRIMARY KEY(fld_c_id),
        CONSTRAINT parent_fk FOREIGN KEY(fld_p_id) REFERENCES tbl_parent(fld_p_id)
    );

    INSERT INTO tbl_parent(fld_p_id, fld_p_name)
    VALUES (1, 'Al'),
            (2, 'Betty'),
            (3, 'Chas');

    INSERT INTO tbl_child(fld_c_id, fld_c_name, fld_p_id)
    VALUES (100, 'Jack', 3), -- Jack's parent is Chas
            (200, 'Jill', 3), -- Jill's parent is also Chas
            (300, 'Al Jr', 1), -- Al Jr's parent Al -- Sally's parent Debbie
            (400, 'Annie', NULL);
/*
    Everything is fine; however, I get an error when I write:

    SELECT  fld_p_name, fld_p_id, fld_p_id, fld_c_name
    FROM tbl_parent, tbl_child
    WHERE fld_p_id = fld_p_id;

    because fld_p_id is in both tables, creating a duplicate identifier.

    We must qualify the duplicate field names with the table names:
*/
    SELECT  fld_p_name, tbl_parent.fld_p_id, tbl_child.fld_p_id, fld_c_name
    FROM tbl_parent, tbl_child
    WHERE tbl_parent.fld_p_id = tbl_child.fld_p_id;

    -- we can reduce our typing by renaming the tables:
    SELECT  fld_p_name, p.fld_p_id, c.fld_p_id, fld_c_name
    FROM tbl_parent AS p, tbl_child AS c
    WHERE p.fld_p_id = c.fld_p_id;

    -- And, sometimes, I will alias the fields if it helps understanding:
    SELECT  fld_p_name AS "Parent Name", p.fld_p_id AS PK,
            c.fld_p_id AS FK, fld_c_name AS "Child Name"
    FROM tbl_parent AS p, tbl_child AS c
    WHERE p.fld_p_id = c.fld_p_id;
/*
    It is my preference to have unique field names within a schema; however,
    I can also understand the argument in favor of naming the FK the same as
    the PK.  In *my* convention, the only difference is "_pk" and "_fk".

    If you believe that foreign keys should be named the sale as the primary key,
    then I will accommodate, even though I disagree... so long as you follow all
    other class coding conventions.

    I will now revert to unique field names for the discussion.
*/



/*
    Since about 1992 (or so) the INNER JOIN has adopted a new syntax that we will
    use in this class.  Take a look"
*/

    SELECT  fld_p_name, fld_p_id_pk, fld_p_id_fk, fld_c_name
    FROM tbl_parent INNER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk;


    -- I don't know whether or not to mention this; however, you'll see it
    -- in the blogs.  It is possible, even common, to see this written as:

        SELECT  fld_p_name, fld_p_id_pk, fld_p_id_fk, fld_c_name
        FROM tbl_parent JOIN tbl_child -- don't do this
            ON fld_p_id_pk = fld_p_id_fk;

    -- Notice that "INNER JOIN" was truncated to "JOIN"... and, yes, it will
    -- work... and, yes, you may write it thus... AFTER YOU HAVE PASSED CSCE 4350!!!
    -- Until that happens, we will use the full syntax.  (Similarly, "AS" may be
    -- dropped, but don't!)










/*
    It is possible to alias the output fields.  I cover this because it's there.
    The database programmer is usually passing the output up to a web application
    and will usually the the web app deal with renaming stuff.

    But, here's an example.  (Real programmers *never* put spaces in identifiers!)
    We no longer need to see the primary and foreign keys once we know how they work.
*/

SELECT  fld_p_name AS "Parent Name",
        fld_c_name AS "Child Name"
FROM tbl_parent INNER JOIN tbl_child
    ON fld_p_id_pk = fld_p_id_fk
ORDER BY "Parent Name";

/*
    Aliasing the output will never be on a test because we don't do it very often.  Note
    that PostgreSQL uses "double quotes".  Some platforms use [square brackets]
*/




-- Here is another variation on that same theme:

DROP TABLE IF EXISTS tbl_child; -- Drop the child First, then the parent
DROP TABLE IF EXISTS tbl_parent;

-- ------------------------------------------------------

CREATE TABLE tbl_parent -- Create the parent first
(
    fld_p_id INTEGER,
    fld_p_name  CHAR(8),
    CONSTRAINT parent_PK PRIMARY KEY(fld_p_id)
);

CREATE TABLE tbl_child
(
    fld_c_id INTEGER,
    fld_c_name  CHAR(8),
    fld_p_id   INTEGER,
    -- Some programmers argue that one should keep the same name for the foreign key
    -- as the primary key it references.  I can see their point.
    CONSTRAINT child_pk PRIMARY KEY(fld_c_id),
    CONSTRAINT parent_fk FOREIGN KEY(fld_p_id) REFERENCES tbl_parent(fld_p_id)
    -- So the primary key in the parent table is named the same as the foreign key
    -- in the child table. (When they use this approach, they usually drop the "_pk")
);


INSERT INTO tbl_parent(fld_p_id, fld_p_name)
VALUES (1, 'Al'),
        (2, 'Betty'),
        (3, 'Chas'),
        (4, 'Debbie'),
        (5, 'Ed');

-- First, insert the parent, then the child

INSERT INTO tbl_child(fld_c_id, fld_c_name, fld_p_id)
VALUES (100, 'Jack', 3), -- Jack's parent is Chas
        (200, 'Jill', 3), -- Jill's parent is also Chas
        (300, 'Ted', 5), -- Ted's parent is Ed
        (400, 'Al Jr', 1), -- Al Jr's parent Al
        (500, 'Sally', 4), -- Sally's parent Debbie
        (600, 'Annie', NULL); -- Annie is an orphan (no parent)
        -- Betty is a childless parent


-- So... let's do the implicit join:

SELECT  fld_p_name, fld_p_id, fld_p_id, fld_c_name
FROM tbl_parent, tbl_child
WHERE fld_p_id = fld_p_id;

-- And our system throws a fit!  We have to qualify the duplicate names:
SELECT  fld_p_name, tbl_parent.fld_p_id, tbl_child.fld_p_id, fld_c_name
FROM tbl_parent, tbl_child
WHERE tbl_parent.fld_p_id = tbl_child.fld_p_id;

-- Now it works, but it's tedious to type.  Programmers will usually alias the table names:
SELECT  fld_p_name, p.fld_p_id, c.fld_p_id, fld_c_name
FROM tbl_parent AS p, tbl_child AS c
WHERE p.fld_p_id = c.fld_p_id;

-- And, in the explicit syntax, (dropping the keys from the output) it becomes:
SELECT  fld_p_name, fld_c_name
FROM tbl_parent AS p INNER JOIN tbl_child AS c
    ON p.fld_p_id = c.fld_p_id;
-- ORDER BY goes here, if you want it

-- -------------------------------------------------------

-- In this class, we will use the full syntax.  Do not shorten the syntax!
-- For example, this:

SELECT  fld_p_name, fld_c_name
FROM tbl_parent p JOIN tbl_child c
    ON p.fld_p_id = c.fld_p_id;

-- will lose points.  Yes, I know: lots of blogs do it that way, but we will
-- use the "AS" and will write "INNER JOIN"  Later, if you take the advanced class,
-- you may truncate the syntax.  Until then, humor me!

--I may drop the schema if I choose to.


    RESET SEARCH_PATH;
    DROP SCHEMA IF EXISTS sch_join CASCADE;


