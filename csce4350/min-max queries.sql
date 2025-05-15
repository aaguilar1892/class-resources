
    -- lets look at the sums of all orders for products
    -- calls for a sum of qty, grouped by p_id
    
    SELECT fld_p_id_fk, SUM(fld_o_qty) as my_sum
    FROM tbl_orders
    GROUP BY fld_p_id_fk
    ORDER BY SUM(fld_o_qty) DESC;
    
    -- Find the order id, product id, and qty that have the greatest quantity.
    -- allow for ties
    -- Do not use "LIMIT"
    
    SELECT fld_o_id_pk, fld_p_id_fk, fld_o_qty
    FROM tbl_orders
    WHERE fld_o_qty IN
    (
        SELECT MAX(fld_o_qty)
        FROM tbl_orders
    )
    ORDER BY fld_o_id_pk;
    
    
/*
    WRONG *** WRONG *** WRONG *** WRONG *** WRONG *** WRONG *** WRONG *** WRONG
    
    SELECT fld_o_id_pk, fld_p_id_fk, fld_o_qty
    FROM tbl_orders
    ORDER BY fld_o_qty DESC
    --
    LIMIT 2;   -- big NO-NO!
    
    LIMIT is only used when you have a huge data set and want to sample the data but don't want to watch it scroll for five minutes.  Other platforms will use "TOP" instead... same thing.
    
    Using it in the logic violates the rule that states that the data are not ordered.
*/  
    
    
    
   -- add the product name tp that
   
    SELECT fld_o_id_pk, fld_p_id_fk, fld_p_name, fld_o_qty
    FROM tbl_orders INNER JOIN tbl_products
        ON fld_p_id_fk = fld_p_id_pk
    WHERE fld_o_qty IN
    (
        SELECT MAX(fld_o_qty)
        FROM tbl_orders
    )
    ORDER BY fld_o_id_pk;
    
    -- Back up to the single table query on tbl_orders:
    -- What would happen if we replaced "IN" with "="?
    -- Like this:
    
    SELECT fld_o_id_pk, fld_p_id_fk, fld_o_qty
    FROM tbl_orders
    WHERE fld_o_qty =
    (
        SELECT MAX(fld_o_qty)
        FROM tbl_orders
    )
    ORDER BY fld_o_id_pk;
/*
    Wow!  That's weird!  It works!!!
    
    Yes, it works, but let's take a closer look at the WHERE clause:
        
        fld_o_qty = SELECT MAX(fld_o_qty) FROM tbl_orders
        
    What type is on the left (LHS) of the equality?  (Answer: INTEGER)
    
    What type is on the right (RHS) of the equality?  (Answer: a *table* of INTEGER containing one column and one row)
    
    We have a type mismatch!  Since programmers mess that up so frequently, in 1992, the SQL standard will coerce the type of a table with *ONE* column and *ONE* row into the type of its content... but we won't do it in *this* class!  We will use "IN" to compare a value to a set (table).
    
    Another point is that the "=" will only work if there exists exactly one value in the table, where as the "IN" works across multiple rows
    
    
    
    
    Find the order id, product id, and qty that have the a quantity greater than the average for the table.
    
    This is a very similar query to finding the max.  We compare everything to the average:
*/
    
--  I'm curious: what *is* the average quantity?
    
    SELECT ROUND(AVG(fld_o_qty)) AS my_avg
    FROM tbl_orders;
    
-- It's a lot like finding the MAX... take a look

    SELECT fld_o_id_pk, fld_p_id_fk, fld_o_qty
    FROM tbl_orders
    WHERE fld_o_qty > ALL
    (
        SELECT AVG(fld_o_qty)
        FROM tbl_orders
    )
    ORDER BY fld_o_qty;
/*
    Notice the use of "> ALL".  The fact is that simple ">" would have worked for the same reason that "=" works in place of "IN"... and you should use "> ALL" for the same reason we use "IN".
    
        fld_o_qty > SELECT AVG(fld_o_qty) FROM tbl_orders
        
    is a type mismatch; however:
   
        fld_o_qty > ALL SELECT AVG(fld_o_qty) FROM tbl_orders
        
    says that the RHS is greater than *ALL VALUES* in the table, which compares INT to INT.
    
    
    
    
    
    
    
    
    
    Here is where we're going next:
    
    Remember the initial example?
*/

    SELECT fld_p_id_fk, SUM(fld_o_qty) as my_sum
    FROM tbl_orders
    GROUP BY fld_p_id_fk
    ORDER BY SUM(fld_o_qty) DESC;
/*
    OK, find the p_id with the greatest SUM(qty)
    
    You might try this:

    SELECT fld_p_id_fk, SUM(fld_o_qty) as my_sum
    FROM tbl_orders
    GROUP BY fld_p_id_fk
    WHERE SUM(fld_o_qty) IN ...
    
    but it dies a horrible death because an aggregate cannot appear in the WHERE clause.
    
    So, you try putting it in the HAVING clause
    
    SELECT fld_p_id_fk, SUM(fld_o_qty) as my_sum
    FROM tbl_orders
    GROUP BY fld_p_id_fk
        HAVING SUM(fld_o_qty) IN  -- so far, so good
        (
            SELECT MAX( SUM(fld_o_qty) ) -- and it dies here.  Aggregates cannot be nested!
    
    
    What we will do is wait until after the mid-term test because that won't be on it!
    It will, however, be our next topic.