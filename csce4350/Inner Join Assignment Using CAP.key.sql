/*
    Write SQL queries to answer the following questions.  Save as an SQL file and attach.  When the task requires a table join: demonstrate a correctly formatted INNER JOIN. Do not use any other SQL statements (such as a subselect, which we cover later).
    Number your problems as a comment.

    1) What customers (fld_o_id_pk, fld_c_id (either pk or fk) and fld_c_name) ordered a product from Duluth ("fld_p_city" in tbl_products)?  Notice that you must get information from the products table; thus, it must be in the join!

    I will paste my output so that you may compare it with yours.

 fld_o_id_pk | fld_c_id_pk | fld_c_name
-------------+-------------+------------
        1017 | c001        | Tiptop
        1018 | c001        | Tiptop
        1013 | c002        | Basics
        1026 | c002        | Basics
(4 rows)
*/

    SELECT fld_o_id_pk, fld_c_id_pk, fld_c_name
    FROM tbl_products INNER JOIN tbl_orders
        ON fld_p_id_pk = fld_p_id_fk
        INNER JOIN tbl_customers
            ON fld_c_id_fk =fld_c_id_pk
    WHERE fld_p_city = 'Duluth';

/*

    2) What agents (fld_a_id_pk, fld_a_name) placed an order (or orders) for "razor" (fld_p_name)?

 fld_a_id_pk | fld_a_name
-------------+------------
 a06         | Smith
 a03         | Brown
 a05         | Otasi
(3 rows)
*/

    SELECT fld_a_id_pk, fld_a_name
    FROM tbl_products INNER JOIN tbl_orders
        ON fld_p_id_pk = fld_p_id_fk
        INNER JOIN tbl_agents
            ON fld_a_id_fk = fld_a_id_pk
    WHERE fld_p_name = 'razor';


/*
    3) What products (fld_p_id_pk, fld_p_name) are supplied by "Lambda Supply"? (Hint: tbl_suppliers, tbl_product_supplier, and tbl_products.  You do not need tbl_orders.)

    I suggest starting with suppliers, joining to the bridge (tbl_product_supplier), then to products, but I start with what I know (Lambds Supply) and work down to the information I want to find.)

 fld_p_id_pk | fld_p_name
-------------+------------
 p04         | pen
 p02         | brush
 (2 rows)
*/
    SELECT fld_p_id_pk, fld_p_name
    FROM tbl_suppliers INNER JOIN tbl_product_supplier
        ON fld_s_id_pk = fld_s_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk = fld_p_id_pk
    WHERE fld_s_name = 'Lambda Supply';

/*

    4) For #4, you will need the logic from #3:

        What agents (fld_a_id_pk, fld_a_name) handle a product supplied by "Lambda Supply"?

       Now, think!  You have the code (in #3, above) that gets the p_id for products from Lambda.  To that, you will add tbl_orders and tbl_agents.

       If you followed my  advice in #3, you're already up to tbl_products... join that to tbl_orders, then to tbl_agents.

       So, you would now have:


       (what I know)                                                                (what I want)
       suppliers('Lambda Supply') --> product_suppliers --> products --> orders --> agents(a_id, name)

       Piece of cake!!!  Well, not so fast.  (Look for a troll under the bridge.)  Look carefully at the two bridge tables (product_suppliers and orders)... these contain a duplicate foreign key name (fld_p_id_fk)  Thus, whenever we use that identifier, we will have to qualify it with the table name.  (I would alias both tbl_orders and tbl_product_suppliers with a shorter name.)

       You may start with agents and work to suppliers if you like that better.  The primary key/foreign key linkage is the same and you'll still have to qualify the duplicate FK name.  Either way, you will have five tables participating in the join


 fld_a_id_pk | fld_a_name
-------------+------------
 a02         | Jones
 a03         | Brown
(2 rows)

*/

    SELECT fld_a_id_pk, fld_a_name
    FROM tbl_suppliers INNER JOIN tbl_product_supplier AS ps
        ON fld_s_id_pk = fld_s_id_fk
        INNER JOIN tbl_products
            ON ps.fld_p_id_fk = fld_p_id_pk
            INNER JOIN tbl_orders AS o
                ON o.fld_p_id_fk = fld_p_id_pk
                INNER JOIN tbl_agents
                    ON fld_a_id_fk = fld_a_id_pk
    WHERE fld_s_name = 'Lambda Supply';
