/*
    Practice Mid-term test and review sheet: answer key
    
    
    
    Write the code to accomplish the following:

    Create a schema named mt1

    Set the search path to mt1

    Using the conventions we have established, create a table named tbl_employees
    that has appropriate data types for the following fields:

    id          Unique and required; make it CHAR(4)
    fname       Employee's first name
    lname       Employee's last name
    dob         Date of birth,
    dept        Department
    salary
    phone

    I expect some variation here.  Use reason and choose an appropriate type.  Assume
    that I'm looking for a way to count it right, not trying to count it wrong.

    Using named constraints (as *always*):
        make id be the PRIMARY KEY
        The last name cannot be NULL

*/

    RESET SEARCH_PATH;
    DROP SCHEMA IF EXISTS mt1 CASCADE;
    -- I'm designing it to run in *any* case.

    CREATE SCHEMA mt1;  -- "IF NOT EXISTS" OK
    SET SEARCH_PATH TO mt1;


    DROP TABLE IF EXISTS tbl_employees;

    CREATE TABLE tbl_employees
    (
        fld_e_id        CHAR(4),
        fld_e_fname     CHAR(16), -- Maybe VARCHAR
        fld_e_lname     CHAR(16),
        fld_e_dob       DATE,
        fld_e_dept      VARCHAR(16),
        fld_e_salary    INTEGER, -- or NUMERIC(7,2)  or MONEY
        fld_e_phone     CHAR(9),
        --
        CONSTRAINT employeesPK PRIMARY KEY(fld_e_id), -- *MUST* be named!
        --
        CONSTRAINT null_lname CHECK(fld_e_lname IS NOT NULL)
        
        -- or CONSTRAINT null_lname CHECK(NULLIF(fld_e_lname,'') IS NOT NULL)
    );


/*
    Back up!  Start from scratch and re-create tbl_employees
    Add a "child table" named tbl_dependents to the code.
    (Copy & Paste are your friends!)
    The fields are:

    id          Unique and required; make it CHAR(4)
    fname       Dependent's first name
    lname       Dependent's last name
    Parent ID   Dependent's parent/sponsor

    Choose an appropriate field from the list to be the Primary Key
    The Dependent's last name cannot be NULL
    An Employee may have zero or more Dependents.
    A Dependent must have *EXACTLY ONE* Employee sponsor.

    Enforce the requirements with a named FOREIGN KEY constraint.
*/
    DROP TABLE IF EXISTS tbl_dependents;
    DROP TABLE IF EXISTS tbl_employees;

    CREATE TABLE tbl_employees
    (
        fld_e_id_pk     CHAR(4),
        fld_e_fname     CHAR(16), -- Maybe VARCHAR
        fld_e_lname     CHAR(16),
        fld_e_dob       DATE,
        fld_e_dept      VARCHAR(16),
        fld_e_salary    INTEGER, -- or NUMERIC(7,2)  or MONEY
        fld_e_phone     CHAR(9),
        --
        CONSTRAINT employeesPK PRIMARY KEY(fld_e_id_pk), -- *MUST* be named!
        --
        CONSTRAINT null_e_lname CHECK(fld_e_lname IS NOT NULL)
    );


    CREATE TABLE tbl_dependents
    (
        fld_d_id_pk     CHAR(4),
        fld_d_fname     CHAR(16),
        fld_d_lname     CHAR(16),
        fld_e_id_fk     CHAR(4),   -- matches fld_e_id_pk in tbl_employees
        --
        CONSTRAINT dependentsPK PRIMARY KEY(fld_d_id_pk),
        --
        CONSTRAINT null_d_lname CHECK(fld_d_lname IS NOT NULL), -- "Exactly one" means not zero!
        --
        CONSTRAINT dependentsFK FOREIGN KEY(fld_e_id_fk) -- in tbl_dependents
        REFERENCES tbl_employees(fld_e_id_pk)
    );

/*
    Insert the following five records into the tables (The order corresponds to the order
    in which the fields were given in the table specification.)  Demonstrate using a
    field list in the insert command!

    Employee: 1234, Al, Jones, 1999-07-31, Eng, 100, 1234567890
        Children of Al Jones:   8765 Robin Jones
                                9934 Roger Jones

    Employee: 2345, Bob, Smith, 1999-07-01, 200, 987654321
        Children of Bob Smith:  8875 Mary Smith


*/
    INSERT INTO tbl_employees( fld_e_id_pk, fld_e_fname, fld_e_lname, fld_e_dob,
                                fld_e_dept, fld_e_salary, fld_e_phone)
    VALUES ( '1234', 'Al', 'Jones', '1999-07-31', 'Eng', 100, '123456789');


    INSERT INTO tbl_employees( fld_e_id_pk, fld_e_fname, fld_e_lname, fld_e_dob,
                                fld_e_dept, fld_e_salary, fld_e_phone)
    VALUES ( '2345', 'Bob', 'Smith', '1999-07-01', 'R&D', 200, '987654321');
/*
    -- Also acceptable:
    INSERT INTO tbl_employees( fld_e_id_pk, fld_e_fname, fld_e_lname, fld_e_dob,
                               fld_e_dept, fld_e_salary, fld_e_phone)
    VALUES ( '1234', 'Al', 'Jones', '1999-07-31', 'Eng', 100, '123456789'),
           ( '2345', 'Bob', 'Smith', '1999-07-01','R&D', 200, '987654321');
*/
    -- -----------------------------------------------
    INSERT INTO tbl_dependents(fld_d_id_pk, fld_d_fname, fld_d_lname, fld_e_id_fk)
    VALUES ('8765', 'Robin', 'Jones', '1234');

    INSERT INTO tbl_dependents(fld_d_id_pk, fld_d_fname, fld_d_lname, fld_e_id_fk)
    VALUES ('9934', 'Roger', 'Jones', '1234');

    INSERT INTO tbl_dependents(fld_d_id_pk, fld_d_fname, fld_d_lname, fld_e_id_fk)
    VALUES ('8875', 'Mary', 'Smith', '2345');
    
    -- may be "stacked" as above.


/*
    Set the SEARCH_PATH to the cap schema.

    Write the SQL queries to answer the following:
*/


-- There are some older field names in these tasks. 




 -- Which customers (cid) are served by Agent "a06"?
 -- Single table query

    SELECT cid
    FROM tbl_orders
    WHERE aid='a06';

-- Which customers (cid *and* cname) are served by Agent "a06"?
-- Adding cname requires tbl_customers

    SELECT c.cid, cname
    FROM tbl_orders AS o INNER JOIN tbl_customers AS c
        ON o.cid=c.cid
    WHERE aid='a06';

-- How many customers does agent "a06" serve?  (The answer is an SQL query, *not* 3!)
-- *Must* name (alias) the aggregate function!

    SELECT COUNT(*) AS myCnt
    FROM tbl_orders
    WHERE aid='a06';

-- How many customers does agent "Smith" from Dallas serve?

    SELECT COUNT(*) AS myCnt
    FROM tbl_orders AS o INNER JOIN tbl_agents AS a
        ON o.aid=a.aid
    WHERE aname='Smith' AND acity='Dallas';

-- How many customers does *each* agent (aid, aname) serve?
-- If a query has an aggregate and a scalar, then it must GROUP BY the scalar field(s)

    SELECT a.aid, aname, COUNT(*) AS custCnt
    FROM tbl_orders AS o INNER JOIN tbl_agents AS a
        ON o.aid=a.aid
    GROUP BY a.aid, aname;

-- If o_amount is calculated by:
    SELECT o_qty * o_dollars AS o_amount
    FROM tbl_orders
    WHERE ordNo=1011; -- Just to see *one* of them

-- find the ordNo or ordNos with the greatest o_amount.
-- Show o_amount and allow for ties.

    SELECT ordNo, o_qty * o_dollars AS o_amount
    FROM tbl_orders
    WHERE o_qty * o_dollars IN
    (
        SELECT MAX(o_qty * o_dollars)
        FROM tbl_orders
    );

-- List all products for which there are no orders.
-- Hint: childless parent query:

-- Demonstrate both an OUTER JOIN and a subselect

    SELECT p.*
    FROM tbl_products AS p LEFT OUTER JOIN tbl_orders AS o
        ON p.pid=o.pid
    WHERE o.pid IS NULL;

    SELECT *
    FROM tbl_products
    WHERE pid NOT IN
    (
        SELECT pid
        FROM tbl_orders
    );

    -- Note: In PostgreSQL, if tblProducts.pid isn't constrained for NULL,
    -- NULL pid must be filtered.

    SELECT *
    FROM tblProducts
    WHERE
    --
    pid IS NOT NULL AND -- line filters orphans
    --
    pid NOT IN
    (
        SELECT pid
        FROM tblOrders
    );




-- List all orders for invalid products. (child with invalid parent)

    SELECT o.*
    FROM tbl_products AS p RIGHT OUTER JOIN tbl_orders AS o
        ON p.pid=o.pid
    WHERE p.pid IS NULL;

    SELECT *
    FROM tbl_orders
    WHERE pid NOT IN
    (
        SELECT pid
        FROM tbl_products
    );
    -- Orphans don't hurt this query







-- Find all orders where o_dollars is greater than 750.      (Remember that you must
-- CAST 750 to MONEY or o_dollars to NUMERIC before you can compare.

    -- You'd think this would be easy:

    SELECT ordNo
    FROM tblOrders
    WHERE o_dollars>750;

    -- but it bombs!  The reason is that a numeric literal (i.e.: 750)
    -- is interpreted as a BIGINT (like a long int in C).  In PSQL, MONEY
    -- resolves to an int because it's a fixed decimal; however, MONEY and
    -- INTEGER aren't directly comparable.  You must CAST the int value
    -- to MONEY:

    SELECT ordNo
    FROM tblOrders
    WHERE o_dollars>CAST(750 AS MONEY);

    -- That SQL standard syntax is tedious, so PostgreSQL gives us a shortened
    -- syntax that you may use, but it might not work in all platforms:

    SELECT ordNo
    FROM tblOrders
    WHERE o_dollars>750::MONEY;



