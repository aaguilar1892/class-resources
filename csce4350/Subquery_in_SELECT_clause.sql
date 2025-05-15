/*
    List all customer IDs, names, and number of orders.  (Zero is a valid number of orders)

    There is an obscure subquery that is useful... sometimes.  I don't cover this one because
    I see no scenario where I would use it that I could not solve using a table join; however,
    I will mention it briefly.  (We won't have an assignment on it.)
*/


    SELECT  fld_c_id_pk, fld_c_name,
            (   SELECT COUNT(*)
                FROM tbl_orders
                WHERE tbl_orders.fld_c_id_fk = tbl_customers.fld_c_id_pk
            ) AS cnt_orders
    FROM tbl_customers
    ORDER BY fld_c_name, fld_c_id_pk; -- for consistency
/*
 fld_c_id_pk | fld_c_name | cnt_orders
-------------+------------+------------
 c004        | ACME       |          1
 c006        | ACME       |          3
 c005        | Ace        |          0
 c003        | Allied     |          2
 c002        | Basics     |          2
 c001        | Tiptop     |          8
(6 rows)
*/


    /*
        This query is interesting because the subquery appears in te SELECT
        clause and, notice that the subquery references the outer table.
        (I chose to qualify the field names; however, since they had unique
        names, this was optional.
        
        From the subquery (inner block), I can access fields in the outer query.
        From the outer query, I am *NOT* able to access the inner query!!!
        This consistent with the scoping rules of most languages such as C.
               
        This type of a subquery is useful for some tasks; however,
        I have never seen an application that could not be
        accomplished with a table join.  It is most interesting as a demonstration
        of scope in an SQL query.
    */




    SELECT  fld_c_id_pk, fld_c_name, COUNT(*) AS cnt_orders
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_fk = fld_c_id_pk
    GROUP BY fld_c_id_pk, fld_c_name
    ORDER BY fld_c_name, fld_c_id_pk; -- for consistency
/*
 fld_c_id_pk | fld_c_name | cnt_orders
-------------+------------+------------
 c004        | ACME       |          1
 c006        | ACME       |          3
 c003        | Allied     |          2
 c002        | Basics     |          2
 c001        | Tiptop     |          8
(5 rows)
*/

    /*
        The issue here is that customer 'c005' does not have any orders, and,
        therefore, does not appear in the output.

        This can be solved by using an OUTER JOIN:
    */



    SELECT  fld_c_id_pk, fld_c_name, COUNT(*) AS cnt_orders
    FROM tbl_customers LEFT OUTER JOIN tbl_orders
        ON fld_c_id_fk = fld_c_id_pk
    GROUP BY fld_c_id_pk, fld_c_name
    ORDER BY fld_c_name, fld_c_id_pk; -- for consistency
/*
 fld_c_id_pk | fld_c_name | cnt_orders
-------------+------------+------------
 c004        | ACME       |          1
 c006        | ACME       |          3
 c005        | Ace        |          1
 c003        | Allied     |          2
 c002        | Basics     |          2
 c001        | Tiptop     |          8
(6 rows)
*/

    /*
        Or so we had hoped!  The problem  here is that COUNT(*) is applied
        to all rows returned including the row for customer 'c005' where
        the order data are NULL.  This gives us what is known as an "OBO"
        ("off by one").  We can solve this by counting the FK instead of '*'.
    */




    SELECT  fld_c_id_pk, fld_c_name, COUNT(fld_c_id_fk) AS cnt_orders
    FROM tbl_customers LEFT OUTER JOIN tbl_orders
        ON fld_c_id_fk = fld_c_id_pk
    GROUP BY fld_c_id_pk, fld_c_name
    ORDER BY fld_c_name, fld_c_id_pk;
/*
 fld_c_id_pk | fld_c_name | cnt_orders
-------------+------------+------------
 c004        | ACME       |          1
 c006        | ACME       |          3
 c005        | Ace        |          0
 c003        | Allied     |          2
 c002        | Basics     |          2
 c001        | Tiptop     |          8
(6 rows)
*/