/*
    Mid-term test and review sheet
    


    Write the code to accomplish the following:

    Create a schema named mt1

    Set the search path to mt1

    Using the conventions we have established regarding field names, create a table named tbl_employees
    that has appropriate data types for the following fields:
    
    You may choose whether or not to append "_pk_ and "_fk" to the keys.  (This will make some differences later.)

    id          Unique and required; make it CHAR(4)
    fname       Employee's first name
    lname       Employee's last name
    dob         Date of birth,
    dept        Department
    salary      Use NUMERIC with two decimals, please.  (There is a type "MONEY"... coming later.)
    phone

    I expect some variation here.  Use reason and choose an appropriate type.  Assume
    that I'm looking for a way to count it right, not trying to count it wrong.

    Using named constraints (as *always*):
        make id be the PRIMARY KEY
        The last name cannot be NULL
*/



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
    A Dependent must have *EXACTLY ONE* Employee sponsor.  (Watch out here!!! It isn't "at most one".)

    Enforce the requirements with named FOREIGN KEY constraints.
*/
 


/*
    Insert the following five records into the tables (The order corresponds to the order
    in which the fields were given in the table specification.)  Demonstrate using a
    field list in the insert command!

    Employee: 1234, Al, Jones, 1999-07-31, Eng, 100, 1234567890
        Children of Al Jones:   8765 Robin Jones
                                9934 Roger Jones

    Employee: 2345, Bob, Smith, 1999-07-01, 200, 987654321
        Children of Bob Smith:  8875 Mary Smith
        
    -- here is where many students choke!!!
*/



/*
    Set the SEARCH_PATH to the cap schema.

    Write the SQL queries to answer the following:
*/



 -- Which customers (fld_c_id) are served by Agent "a06"?
 -- Single table query

-- Which customers (fld_c_id *and* fld_c_name) are served by Agent "a06"?
-- Adding cname requires tbl_customers



-- "HOW MANY" we haven't done yet.
-- How many customers does agent "a06" serve?  (The answer is an SQL query, *not* 3!)
-- *Must* name (alias) the aggregate function!

-- "HOW MANY" we haven't done yet.
-- How many customers does agent "Smith" from Dallas serve?

-- "HOW MANY" we haven't done yet.
-- How many customers does *each* agent (aid, aname) serve?
-- If a query has an aggregate and a scalar, then it must GROUP BY the scalar field(s)



-- List all products for which there are no orders.
-- Hint: childless parent query:




-- Here is where we are in the class!!!! ***************************
-- It's OK to stop here.






-- Demonstrate both an OUTER JOIN and a subselect





-- List all orders for invalid products. (child with invalid parent)


-- Find all orders where o_dollars is greater than 750  (Remember that you must
-- CAST 750 to MONEY or o_dollars to NUMERIC before you can compare.

-- No, it's a review... not really a mid-term test.

-- I lied... sue me!

