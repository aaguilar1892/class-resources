/*

    1) What customers (fld_o_id_pk, fld_c_id) ordered a product from Duluth ("fld_p_city" in tbl_products)?  Notice that you must get information from the products table; thus, it must be in the join!
*/

    SELECT fld_o_id_pk, fld_c_id_fk
    FROM tbl_orders INNER JOIN tbl_products
        ON fld_p_id_fk = fld_p_id_pk
    WHERE fld_p_city = 'Duluth'
    ORDER BY fld_o_id_pk;

/*
    Notice that all of the output comes from one table,  When we have this,
    a subselect is an option:
*/

    SELECT fld_o_id_pk, fld_c_id_fk
    FROM tbl_orders
    WHERE fld_p_id_fk IN
    (
        SELECT fld_p_id_pk
        FROM tbl_products
        WHERE fld_p_city = 'Duluth'
    )
    ORDER BY fld_o_id_pk;

/*
    2) What agents (fld_a_id_pk, fld_a_name) placed an order (or orders) for "razor" (fld_p_name)?
*/

    SELECT fld_a_id_pk, fld_a_name
    FROM tbl_products INNER JOIN tbl_orders
        ON fld_p_id_pk = fld_p_id_fk
        INNER JOIN tbl_agents
            ON fld_a_id_fk = fld_a_id_pk
    WHERE fld_p_name = 'razor'
    ORDER BY fld_a_id_pk;


    -- as a subselect
    SELECT fld_a_id_pk, fld_a_name
    FROM tbl_agents
    WHERE fld_a_id_pk IN
    (
        SELECT fld_a_id_fk
        FROM tbl_orders
        WHERE fld_p_id_fk IN
        (
            SELECT fld_p_id_pk
            FROM tbl_products
            WHERE fld_p_name = 'razor'
        )
    )
    ORDER BY fld_a_id_pk;

/*
    3) What products (fld_p_id_pk, fld_p_name) are supplied by "Lambda Supply"? (Hint: tbl_suppliers, tbl_product_supplier, and tbl_products.  You do not need tbl_orders.)
*/
    SELECT fld_p_id_pk, fld_p_name
    FROM tbl_suppliers INNER JOIN tbl_product_supplier
        ON fld_s_id_pk = fld_s_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk = fld_p_id_pk
    WHERE fld_s_name = 'Lambda Supply'
    ORDER BY fld_p_id_pk;


--    As a subselect:

    SELECT fld_p_id_pk, fld_p_name
    FROM tbl_products
    WHERE fld_p_id_pk IN
    (
        SELECT fld_p_id_fk
        FROM tbl_product_supplier
        WHERE fld_s_id_fk IN
        (
            SELECT fld_s_id_pk
            FROM tbl_suppliers
            WHERE fld_s_name = 'Lambda Supply'
        )
    )
    ORDER BY fld_p_id_pk;

/*
    All of these came from the INNER JOIN assignment... sort of.  If you read the first one carefully, you will notice that it's edited: I remover the customers' names from the output (tbl_customers) such that all of the output came from tbl_orders.

    In general, a query where all of the output fields come from a single table may be written as a subselect.

    In an OUTER JOIN, all of the output frequently comes from a single table; therefore, *most* OUTER JOIN queries may be written as a subquery (also known as a "subselect"):

    THE OUTER JOIN ASSIGNMENT SAYS *NOT* TO WRITE SUBQUERIES!  (Sorry; didn't mean to shout.)
*/

-- Examples using OUTER JOIN

/*
    1) What products (fld_p_id_pk, fld_p_name), if any, have no orders? (Childless Parent query from tbl_products)

 fld_p_id_pk | fld_p_name
-------------+------------
 p08         | floppy
(1 row)

*/

-- As an OUTER JOIN:  see key that will be published


-- As a subquery (and this is how *I* would always write it... mostly.

    SELECT fld_p_id_pk, fld_p_name
    FROM tbl_products
    WHERE fld_p_id_pk NOT IN
    (
        SELECT fld_p_id_fk
        FROM tbl_orders
    )
    ORDER BY fld_p_id_pk;

-- -----------------------------------------------------


/*
    2) Write a query that will return all invalid foreign keys (fld_p_if_fk, fld_o_id_pk) in tbl_orders that reference tbl_products. table.  (There may or may not be any rows returned.)

 fld_p_id_fk | fld_o_id_pk
-------------+-------------
 p99         |        1027
(1 row)

*/

-- As an OUTER JOIN:  see key that will be published


    -- As a subquery:
    SELECT fld_p_id_fk, fld_o_id_pk
    FROM tbl_orders
    WHERE fld_p_id_fk NOT IN
    (
        SELECT fld_p_id_pk
        FROM tbl_products
    )
    ORDER BY fld_o_id_pk;

-- -----------------------------------------

/*
    3) What Customers (fld_c_id_pk, fld_c_name), if any, have no orders?

 fld_c_id_pk | fld_c_name
-------------+------------
 c005        | Ace
(1 row)

*/

 -- As an OUTER JOIN:  see key that will be published

    -- As a subquery

    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_id_pk NOT IN
    (
        SELECT fld_c_id_fk
        FROM tbl_orders
    )
    ORDER BY fld_c_id_pk;

-- -------------------------------------

/*
    4) Write a query that will return all invalid foreign keys in tbl_orders referencing tbl_customers.  (There may or may not be any rows returned.)
*/

-- As an OUTER JOIN:  see key that will be published

    -- As an OUTER JOIN

    SELECT fld_c_id_fk, fld_o_id_pk
    FROM tbl_orders
    WHERE fld_c_id_fk NOT IN
    (
        SELECT fld_c_id_pk
        FROM tbl_customers
    )
    ORDER BY fld_o_id_pk;

/*
    Notice that the logic of the subquery's WHERE clause was "IN" for INNER JOIN annd "NOT IN" for the OUTER JOIN.  that's *usually* the case.

    This type of subquery is written in the WHERE clause of the outside (or top) query.  The WHERE clause is called the "conditional clause" of the query, leading some writers to call this kind a "conditional subquery".  (We will see other types later in the class.)

    Some other platforms allow:

    SELECT fld_fname, fld_lname
    FROM tbl_made_up
    WHERE fld_fname, fld_lname IN
    (
        SELECT fld_fn, fld_ln
        FROM tbl_another_one
    );

    ... but not Postgres (also not MySQL, BTW)  "IN" only works on a single value.

    You can kludge around this with:

    SELECT fld_fname, fld_lname
    FROM tbl_made_up
    WHERE fld_fname||fld_lname IN -- "||" is the concatenation operator.
    (
        SELECT fld_fn||fld_ln
        FROM tbl_another_one
    );
*/
