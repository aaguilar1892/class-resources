
/*
                    OUTER JOIN ASSIGNMENT
                    
    For all parts, do not use sub-select queries.  (If you don't know what that is, we haven't discussed these yet.)  All of these that need a join will use OUTER JOIN.  If the task does not require a join, use a simple select.  (Hint: there is one of these.)
    
    We will always write "LEFT OUTER JOIN" or "RIGHT OUTER JOIN" (even though you might see the blogs writing "RIGHT JOIN" & "LEFT JOIN".)
*/

/*
    1) What products (fld_p_id_pk, fld_p_name), if any, have no orders? (Childless Parent query from tbl_products)

 fld_p_id_pk | fld_p_name 
-------------+------------
 p08         | floppy
(1 row)

*/



/*
    2) Write a query that will return all invalid foreign keys (fld_p_if_fk, fld_o_id_pk) in tbl_orders that reference tbl_products. table.  (There may or may not be any rows returned.)
    
 fld_p_id_fk | fld_o_id_pk 
-------------+-------------
 p99         |        1027
(1 row)

*/


/*
    3) What Customers (fld_c_id_pk, fld_c_name), if any, have no orders?
    
 fld_c_id_pk | fld_c_name 
-------------+------------
 c005        | Ace
(1 row)
    
*/





/*
    4) Write a query that will return all invalid foreign keys in tbl_orders referencing tbl_customers.  (There may or may not be any rows returned.)
    
    As I write the key, I see that there are no invalid foreign keys in tbl_orders into tbl_customers.
    
 fld_c_id_fk | fld_o_id_pk 
-------------+-------------
(0 rows)    
    
    I think I'll create an invalid one.  Since fld_o_id_pk = 1027 has an invalid product fk, he may as well have an invalid customer ID, also.
    
    You do *not* have to execute this code... it's entirely your call!  I'd try your query first without any invalid FK, then again afterwards.  (The data in the table have nothing to do with whether or not the query is correct.
    
    -- First, I'll disable the constraints on tbl_orders
    ALTER TABLE tbl_orders DISABLE TRIGGER ALL;
    -- Then give it an invalid fld_c_id_fk (and an invalid fld_a_id_fk while we're here.)
    UPDATE tbl_orders SET fld_c_id_fk = 'cxx', fld_a_id_fk = 'axx'  WHERE fld_o_id_pk = 1027;
    -- Turn the constraints back on
    ALTER TABLE tbl_orders ENABLE TRIGGER ALL;
    
    Now (if you chose to put it there) you would find an invalid FK.
*/
    
 
/*
    
 fld_c_id_fk | fld_o_id_pk 
-------------+-------------
 cxx         |        1027
(1 row)    
*/


/*
    5) Which agents (fld_a_id_pk, fld_a_name), if any, have placed no orders?  (Childless parent)
    
    There are none as we created the table.  If you INSERT a row into tbl_agents, the query will return that record... because it will have no orders.
    
    INSERT INTO tbl_agents(fld_a_id_pk, fld_a_name,  fld_a_city,  fld_a_percent)
    VALUES  (   'a99','Rogers','Denton',0  );
    
    Your query may be perfectly valid and return no rows if there aren't any.
*/



/*
    6) Write a query that will return all invalid foreign keys in tbl_orders referencing the agents table.  (There may or may not be any rows returned.)
    
    If you chose to make the order with fld_o_id_pk = 1027 have an invalid a_id, then you'll see:
    
 fld_a_id_fk 
-------------
 axx
(1 row)

        Otherwise, it'll be empty; however, that doesn't make it wrong.
*/
    


/*
    7) Considering the tblCustomers / tblOrders relationship, are there any orphan orders?  (Orders with no associated customer)  Ask: what is an "orphan record"?  Do you need a table join to answer that?
    
    There are none; however, you may make one out of the fld_o_id_pk = 1027 record we've been abusing:
    
    UPDATE tbl_orders SET fld_c_id_fk = NULL WHERE fld_o_id_pk = 1027;
    -- In this case, the "=" means "assignment", not "the same thing as".
    
    Notice that, if you ran the code from #4 (above), it would also return the orphan.  (Try it, and then explain why it does so.)
*/
    
