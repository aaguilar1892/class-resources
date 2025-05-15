/*
    Selecting Calculated Fields:
    
    Consider a query returning tbl_customers and their related rows from tbl_products.
    For now, we will only consider fld_c_id_pk, fld_p_id_pk in the relation: (We will need a three-table
    join: tbl_customers, tblOrders, and tbl_products:
    (I'll ORDER BY fld_c_id_pk for consistency.)
*/

    SELECT fld_c_id_pk, fld_p_id_pk
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk=fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk=fld_p_id_pk
    ORDER BY fld_c_id_pk;
    
/*
 fld_c_id_pk | fld_p_id_pk 
-------------+-------------
 c001        | p01
 c001        | p01
 c001        | p02
 c001        | p03
 c001        | p04
 c001        | p05
 c001        | p06
 c001        | p07
 c002        | p03
 c002        | p03
 c003        | p05
 c003        | p05
 c004        | p01
 c006        | p01
 c006        | p07
 c006        | p01
(16 rows)

    As you can see, we have duplicate rows because a customer may have multiple orders for the same product.  To show this, we will include the ordNo in the output. 
    
    It will make it easier to read if I list the fields vertically.  Ordinarily, I wouldn't write the query like that.
*/

    SELECT  fld_c_id_pk AS c_id, 
            fld_p_id_pk AS p_id, 
            fld_o_id_pk AS o_id -- aliased for clarity
            --
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk=fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk=fld_p_id_pk
    ORDER BY fld_c_id_pk;
/*
 c_id | p_id | o_id 
------+------+------
 c001 | p01  | 1011
 c001 | p01  | 1012
 c001 | p02  | 1019
 c001 | p03  | 1017
 c001 | p04  | 1018
 c001 | p05  | 1023
 c001 | p06  | 1022
 c001 | p07  | 1025
 c002 | p03  | 1013
 c002 | p03  | 1026
 c003 | p05  | 1015
 c003 | p05  | 1014
 c004 | p01  | 1021
 c006 | p01  | 1016
 c006 | p07  | 1020
 c006 | p01  | 1024
(16 rows)

    For each row, we have (from tbl_products) fld_p_quantity (int) and fld_p_price (money).
    Let's add that to the output. (Again, I will alias to keep from wraping.)
*/
   
    SELECT  fld_c_id_pk     AS c_id, 
            fld_p_id_pk     AS p_id, 
            fld_o_id_pk     AS o_id,
            fld_p_quantity  AS qty, 
            fld_p_price     AS price
            --
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk=fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk=fld_p_id_pk
    ORDER BY fld_c_id_pk;
/*
 c_id | p_id | o_id |  qty   | price 
------+------+------+--------+-------
 c001 | p01  | 1011 | 111400 | $0.50
 c001 | p01  | 1012 | 111400 | $0.50
 c001 | p02  | 1019 | 203000 | $0.50
 c001 | p03  | 1017 | 150600 | $1.00
 c001 | p04  | 1018 | 125300 | $1.00
 c001 | p05  | 1023 | 221400 | $1.00
 c001 | p06  | 1022 | 123100 | $2.00
 c001 | p07  | 1025 | 100500 | $1.00
 c002 | p03  | 1013 | 150600 | $1.00
 c002 | p03  | 1026 | 150600 | $1.00
 c003 | p05  | 1015 | 221400 | $1.00
 c003 | p05  | 1014 | 221400 | $1.00
 c004 | p01  | 1021 | 111400 | $0.50
 c006 | p01  | 1016 | 111400 | $0.50
 c006 | p07  | 1020 | 100500 | $1.00
 c006 | p01  | 1024 | 111400 | $0.50
(16 rows)

    From here, we can calculate the subTotal using qty*price.  If we multiply money times an int, the result will be type money; however, since money always has four decimal places (typically across all D.B. platforms), if you multiply by numeric, it will promote to MONEY.
    
    Further, when we return a calculated field, we will *ALWAYS* alias the field.  This is important because PostgreSQL will leave it unnamed... and it's important to your professor! (Other platforms will do strange things with its name,)
*/    
 
    SELECT  fld_c_id_pk     AS c_id, 
            fld_p_id_pk     AS p_id, 
            fld_o_id_pk     AS o_id,
            fld_p_quantity  AS qty, 
            fld_p_price     AS price,
            fld_p_quantity * fld_p_price AS sub_tot -- ALWAYS alias calculated fields!
            --
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk=fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk=fld_p_id_pk
    ORDER BY fld_c_id_pk;
    
/*
 c_id | p_id | o_id |  qty   | price |   sub_tot   
------+------+------+--------+-------+-------------
 c001 | p01  | 1011 | 111400 | $0.50 |  $55,700.00
 c001 | p01  | 1012 | 111400 | $0.50 |  $55,700.00
 c001 | p02  | 1019 | 203000 | $0.50 | $101,500.00
 c001 | p03  | 1017 | 150600 | $1.00 | $150,600.00
 c001 | p04  | 1018 | 125300 | $1.00 | $125,300.00
 c001 | p05  | 1023 | 221400 | $1.00 | $221,400.00
 c001 | p06  | 1022 | 123100 | $2.00 | $246,200.00
 c001 | p07  | 1025 | 100500 | $1.00 | $100,500.00
 c002 | p03  | 1013 | 150600 | $1.00 | $150,600.00
 c002 | p03  | 1026 | 150600 | $1.00 | $150,600.00
 c003 | p05  | 1015 | 221400 | $1.00 | $221,400.00
 c003 | p05  | 1014 | 221400 | $1.00 | $221,400.00
 c004 | p01  | 1021 | 111400 | $0.50 |  $55,700.00
 c006 | p01  | 1016 | 111400 | $0.50 |  $55,700.00
 c006 | p07  | 1020 | 100500 | $1.00 | $100,500.00
 c006 | p01  | 1024 | 111400 | $0.50 |  $55,700.00
(16 rows)    

    Now, the fld_c_discnt (customer's discount) is stored as NUMERIC(4,2) in tbl_customers.  A 10% discount would be stored as 10.00.  To convert it to a usable number, we must divide by 100.  (When we divide, we will end up with more than 2 decimal places, thus, we will round to two decimal places to make it readable.)  We will display the decimal percent after the c_id and, as always with a calculated field, I will alias (rename) the column.
    
*/
    SELECT  fld_c_id_pk     AS c_id, 
            ROUND(fld_c_discnt/100, 2) AS discnt, 
            fld_p_id_pk     AS p_id, 
            fld_o_id_pk     AS o_id, 
            fld_p_quantity  AS qty, 
            fld_p_price     AS price,
            fld_p_quantity * fld_p_price AS sub_tot 
            --
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk=fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk=fld_p_id_pk
    ORDER BY fld_c_id_pk;
/*
 c_id | discnt | p_id | o_id |  qty   | price |   sub_tot   
------+--------+------+------+--------+-------+-------------
 c001 |   0.10 | p01  | 1011 | 111400 | $0.50 |  $55,700.00
 c001 |   0.10 | p01  | 1012 | 111400 | $0.50 |  $55,700.00
 c001 |   0.10 | p02  | 1019 | 203000 | $0.50 | $101,500.00
 c001 |   0.10 | p03  | 1017 | 150600 | $1.00 | $150,600.00
 c001 |   0.10 | p04  | 1018 | 125300 | $1.00 | $125,300.00
 c001 |   0.10 | p05  | 1023 | 221400 | $1.00 | $221,400.00
 c001 |   0.10 | p06  | 1022 | 123100 | $2.00 | $246,200.00
 c001 |   0.10 | p07  | 1025 | 100500 | $1.00 | $100,500.00
 c002 |   0.12 | p03  | 1013 | 150600 | $1.00 | $150,600.00
 c002 |   0.12 | p03  | 1026 | 150600 | $1.00 | $150,600.00
 c003 |   0.08 | p05  | 1015 | 221400 | $1.00 | $221,400.00
 c003 |   0.08 | p05  | 1014 | 221400 | $1.00 | $221,400.00
 c004 |   0.08 | p01  | 1021 | 111400 | $0.50 |  $55,700.00
 c006 |   0.00 | p01  | 1016 | 111400 | $0.50 |  $55,700.00
 c006 |   0.00 | p07  | 1020 | 100500 | $1.00 | $100,500.00
 c006 |   0.00 | p01  | 1024 | 111400 | $0.50 |  $55,700.00
(16 rows)

    Thus, the final price would be [price - price * discnt]  (Brackets are added to
    make it readable.)  The issue is that in SQL, the alias ("myDiscount") does not exist
    on the same line where it's defined; therefore, the price will be:
    
    fld_p_price - fld_p_price * fld_c_discnt/100
    
    And the full calculation of the invoice total(in all its glory) will be:
    
    fld_p_quantity*(fld_p_price - fld_p_price * fld_c_discnt/100) AS invoice_total -- any alias works.
*/    

    SELECT  fld_c_id_pk     AS c_id, 
            ROUND(fld_c_discnt/100, 2) AS discnt, 
            fld_p_id_pk     AS p_id, 
            fld_o_id_pk     AS o_id, 
            fld_p_quantity  AS qty, 
            fld_p_price     AS price,
            fld_p_quantity * fld_p_price AS sub_tot,
            fld_p_quantity*(fld_p_price - fld_p_price * fld_c_discnt/100) AS invoice_total
            --
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk=fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk=fld_p_id_pk
    ORDER BY fld_c_id_pk;
    
/*
 c_id | discnt | p_id | o_id |  qty   | price |   sub_tot   | invoice_total 
------+--------+------+------+--------+-------+-------------+---------------
 c001 |   0.10 | p01  | 1011 | 111400 | $0.50 |  $55,700.00 |    $50,130.00
 c001 |   0.10 | p01  | 1012 | 111400 | $0.50 |  $55,700.00 |    $50,130.00
 c001 |   0.10 | p02  | 1019 | 203000 | $0.50 | $101,500.00 |    $91,350.00
 c001 |   0.10 | p03  | 1017 | 150600 | $1.00 | $150,600.00 |   $135,540.00
 c001 |   0.10 | p04  | 1018 | 125300 | $1.00 | $125,300.00 |   $112,770.00
 c001 |   0.10 | p05  | 1023 | 221400 | $1.00 | $221,400.00 |   $199,260.00
 c001 |   0.10 | p06  | 1022 | 123100 | $2.00 | $246,200.00 |   $221,580.00
 c001 |   0.10 | p07  | 1025 | 100500 | $1.00 | $100,500.00 |    $90,450.00
 c002 |   0.12 | p03  | 1013 | 150600 | $1.00 | $150,600.00 |   $132,528.00
 c002 |   0.12 | p03  | 1026 | 150600 | $1.00 | $150,600.00 |   $132,528.00
 c003 |   0.08 | p05  | 1015 | 221400 | $1.00 | $221,400.00 |   $203,688.00
 c003 |   0.08 | p05  | 1014 | 221400 | $1.00 | $221,400.00 |   $203,688.00
 c004 |   0.08 | p01  | 1021 | 111400 | $0.50 |  $55,700.00 |    $51,244.00
 c006 |   0.00 | p01  | 1016 | 111400 | $0.50 |  $55,700.00 |    $55,700.00
 c006 |   0.00 | p07  | 1020 | 100500 | $1.00 | $100,500.00 |   $100,500.00
 c006 |   0.00 | p01  | 1024 | 111400 | $0.50 |  $55,700.00 |    $55,700.00
(16 rows)

    If your terminal window word wraps, that's just how they are... enlarge the window or get over it.






    AGGREGATE FUNCTIONS   https://www.postgresql.org/docs/9.5/functions-aggregate.html
    
        AVG( numericExpression )  [in some platforms "AVERAGE( numericExpression )" ]
        
        COUNT(*)    Returns the number of rows
        
        COUNT( expression ) Returns the number of input rows for which the value of 
                            expression is not null
                            
        MAX( expression )
        MIN( expression )
        
        SUM( numericExpression )
    
    Other common aggregate functions:
    
        stddev( numericExpression )     sample standard deviation of the input values
        
        variance( numerixExpression )   sample variance of the input values (square of 
                                        the sample standard deviation)
                                        
    Database textbooks commonly introduce the first five; however, as you can see from the
    documentation, there are many examples of aggregate functions.
    
    Commonly Used NUMERIC FUNCTIONS
    
        ROUND( v NUMERIC, s INT )   Rounds v to s places. s may be negative and defaults to zero.
        
    Example: What is the average fld_o_qty INT from tbl_orders in the "cap" database?
*/


    SELECT AVG(fld_o_qty) AS my_avg
    FROM tbl_orders;
/*
        my_avg         
----------------------
 805.8823529411764706
(1 row) 

        Discussion:
            Whenever we return a calculated field, we will *always* name our new field!
            
            Sometimes you want to ROUND to an INT:
*/
    SELECT ROUND(AVG(fld_o_qty)) AS my_avg
    FROM tbl_orders;            
/*
 my_avg 
-------
   806
(1 row)

            or, perhaps to two decimal places:
*/
    SELECT ROUND(AVG(fld_o_qty), 2) AS my_avg
    FROM tbl_orders;  
/*    

 my_avg  
--------
 805.88
(1 row)
            It also accepts negative values to round to the left of the decimal.
*/
    SELECT ROUND(AVG(fld_o_qty), -2) AS my_avg
    FROM tbl_orders;            
/*
 myavg 
-------
   800
(1 row)

    There are other considerations when you try to take an AVG of MONEY.
    E.g.:
*/  

    SELECT AVG(fld_p_price) AS avg_price -- bombs!!!
    FROM tbl_products;
    
/* 
ERROR:  function avg(money) does not exist
LINE 1: SELECT AVG(price)
               ^
HINT:  No function matches the given name and argument types. You might need
to add explicit type casts.

    MONEY always has 4 decimal places (by international agreement).  If we could average money, the result would have too many decimal places.
    
    Which brings up the idea of type casting.  In SQL, it is a static cast and,
    in its simple form, looks like:
    
    CAST( expression TO targetType )
    
    Thus, the query:
*/   

    SELECT AVG( CAST( fld_p_price AS NUMERIC ) ) AS avg_price
    FROM tbl_products;
    
    -- If you have an issue with the trailing zeros, round it (or get over it, which is what I do!)
    
    SELECT ROUND( AVG( CAST( fld_p_price AS NUMERIC ) ), 2) AS avg_price
    FROM tbl_products;
    
/*
    will work; the average is $1.  
    
    The above example of the CAST function is the SQL standard and works on all
    platforms.  *Most* platforms (including PostgreSQL) provide a shorter version
    of this commonly-used function:
*/    

    SELECT AVG( fld_p_price::NUMERIC ) AS avg_price
    FROM tbl_products;
    -- You may use this shorter version of type casting.

-- Other examples:  (How many orders does customer c001 have?

    SELECT COUNT(*) AS my_cnt
    FROM tbl_orders
    WHERE fld_c_id_fk='c001';
/*    
 mycnt 
-------
     8
(1 row)


    Now, as you read the blogs and listen to people who think they know how to program SQL, you will see this version:
*/

--   WRONG!   WRONG!   WRONG!   WRONG!   WRONG!   WRONG!   WRONG!
    SELECT COUNT(1) AS x
    FROM tbl_orders
    WHERE fld_c_id_fk='c001';
    
-- And it gives you the same answer.

-- Try this:
    SELECT 1 AS buncha_ones
    FROM tbl_orders
    WHERE fld_c_id_fk='c001';
    
-- Or this:
    SELECT PI() AS why_am_I_doing_this  -- PI() is the irrational value (approx) if pi
    FROM tbl_orders
    WHERE fld_c_id_fk='c001';
    
-- So, if you wrote:
    SELECT COUNT(PI()) AS my_cnt
    FROM tbl_orders
    WHERE fld_c_id_fk='c001';
    
-- you'd get 8 because you'd have 8 values, but it's expensive!  COUNT(*) counts ANYTHING!

-- When your objective is how many rows, it's COUNT(*).


*/
    SELECT MAX(fld_p_price) AS my_max
    FROM tbl_products;
    
    SELECT MIN(fld_p_price) AS myMin
    FROM tbl_products;
    
    SELECT SUM(fld_p_price) AS mySum
    FROM tbl_products;    
    
    
    
    
-- NEW MATERIAL    
/*
    Show the fld_c_id_pk from tbl_customers and the maximum price for each customer.
    
    You may be tempted to write something like:
    
    SELECT fld_c_id_pk, MAX(fld_p_price) AS my_max
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk= fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk= fld_p_id_pk;
            
    And, for your reading pleasure, you receive an error message:
    
ERROR:  column "c.fld_c_id_" must appear in the GROUP BY clause or be used in an aggregate function
LINE 1: SELECT c.fld_c_id_, MAX(price)





    The GROUP BY clause:
    When we GROUP BY a field, we take all duplicates of that field and collapse them into 
    one row.  Then, any aggregate functions are applied to that group.  This shows well
    using a COUNT(*) aggregate function on tbl_orders:
*/
    SELECT fld_c_id_fk, COUNT(*) AS my_cnt
    FROM tbl_orders
    GROUP BY fld_c_id_fk
    ORDER BY fld_c_id_fk;
/*
 fld_c_id_fk | my_cnt 
-------------+--------
 c001        |      8
 c002        |      2
 c003        |      2
 c004        |      1
 c006        |      3
 cxx         |      1
(6 rows)

The output has the invalid FK because I never removed it.



    Thus, in tblOrders, we have 8 rows where fld_c_id_='c001', two rows where fld_c_id_='c004' and so on.
    
    NEW RULE!  WHENEVER WE HAVE AGGREGATE FUNCTIONS (e.g.: COUNT(*) ) AND SCALAR VALUES
    (like fld_c_id_)... ONE OR MORE OF EACH, THEN ALL OF THE SCALAR VALUES MUST BE IN A "GROUP BY" STATEMENT!
    
    No exceptions, and it won't change just because you move to a different D.B. platform.
    
    Back to: Show the fld_c_id_pk from tbl_customers and the maximum price of that customer's orders.
*/
    SELECT fld_c_id_pk, MAX(fld_p_price) AS my_max
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk= fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk= fld_p_id_pk
    GROUP BY fld_c_id_pk
    ORDER BY fld_c_id_pk;
    
/*
 fld_c_id_pk | my_max 
-------------+-------
 c001        | $2.00
 c002        | $1.00
 c003        | $1.00
 c004        | $0.50
 c006        | $1.00

    Another example:  Average price for each customer?
*/


-- note the shorthand CAST! (I'd usually ROUND)
    SELECT fld_c_id_pk, AVG(fld_p_price::NUMERIC) AS my_avg
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk= fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk= fld_p_id_pk
    GROUP BY fld_c_id_pk
    ORDER BY fld_c_id_pk;
/*
 fld_c_id_pk |         my_avg          
-------------+------------------------
 c001        | 0.93750000000000000000
 c002        | 1.00000000000000000000
 c003        | 1.00000000000000000000
 c004        | 0.50000000000000000000
 c006        | 0.66666666666666666667
(5 rows)

    Suppose I only want rows in this query where the AVG > 0.5.  I.e.: I do *not* want c004
    but I do want the rest.  I might try:
*/
    SELECT fld_c_id_pk, AVG(fld_p_price::NUMERIC) AS my_avg
    FROM tbl_customers INNER JOIN tbl_orders
        ON fld_c_id_pk= fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk= fld_p_id_pk
    WHERE fld_p_price::NUMERIC>0.5 -- I must CAST the MONEY to compare it
    GROUP BY fld_c_id_pk;
/*    

 fld_c_id_pk |         my_avg         
-------------+------------------------
 c003        | 1.00000000000000000000
 c001        |     1.2000000000000000
 c006        | 1.00000000000000000000
 c002        | 1.00000000000000000000
(4 rows)


    *That* just didn't work well at all!  It changed the averages!
    The WHERE clause applies to individual rows.  When I wrote
    "WHERE price::NUMERIC>0.5", it only used rows meeting that criterion
    in the AVG, thus changing it for other rows!
    
    Because of the above: "WHERE AVG(price::NUMERIC)>0.5" is illegal in SQL.
    
    Here is the fix:
*/
    
     SELECT fld_c_id_pk, AVG(fld_p_price::NUMERIC) AS my_avg   -- note the shorthand CAST!
     FROM tbl_customers INNER JOIN tbl_orders
       ON fld_c_id_pk = fld_c_id_fk
        INNER JOIN tbl_products
            ON fld_p_id_fk = fld_p_id_pk
    GROUP BY fld_c_id_pk HAVING AVG(fld_p_price::NUMERIC)>0.5;
/*

 fld_c_id_pk |         my_avg         
-------------+------------------------
 c003        | 1.00000000000000000000
 c006        | 0.66666666666666666667
 c001        | 0.93750000000000000000
 c002        | 1.00000000000000000000
(4 rows)



    ***** So: WHERE applies to individual table rows; HAVING applies to *groups*.

    I usually format it as above.  Some people write it:
    
    GROUP BY fld_c_id_pk
    HAVING AVG(fld_p_price::NUMERIC)>0.5;
    
    Or:
    
    GROUP BY fld_c_id_pk
        HAVING AVG(fld_p_price::NUMERIC)>0.5;
        
    I will leave that to your discretion.
    
    Like the WHERE clause, HAVING is optional.
*/
