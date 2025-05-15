/*
    Using the CAP database
    
    Each task is 25%.  #4 part a: 15%, part b: 10%  (Extra point possible.)
    
    Up to 20% deduction for no attention to format.  Fuss over format and it will
    be acceptable.  Look at my code for examples.

    #1  Write an SQL query compliant with the practices presented in the discussion that will:
        return all fields of tbl_orders AND an additional field calculated by fld_o_qty times the fld_o_dollars.  (I'm not sure what that *means* because I 
        think fld_o_dollars is the price for the order; thus multiplying that times
        the order quantity wouldn't make much sense
        ... just do it anyway.)

    #2  Write an SQL query compliant with the practices presented in the discussion that will
        return the fld_c_id_pk and fld_c_discnt/100 [name it: "new_disc" and ound it to two decimal places from the right: nnn.dd ] from tbl_customers, the fld_p_id_pk and fld_p_price from tbl_products, and the fld_o_id_pk, fld_o_qty, and fld_o_dollars from tbl_orders.
        Calculate a field: fld_p_price*[1-new_disc]*fld_o_qty. (I named mine calc_tot,
        you do not have to match my calculated field names.)

        Show the o_dollars right beside the calculated field so we can see any difference.

        Here is the output from my query (my field names are aliased to keep it from wrapping.
        If yours wraps, it isn't wrong.):

 c_id | new_disc | p_id | price | o_id | fld_o_qty | fld_o_dollars | calc_tot  
------+----------+------+-------+------+-----------+---------------+-----------
 c001 |     0.10 | p01  | $0.50 | 1011 |      1000 |       $450.00 |   $450.00
 c001 |     0.10 | p01  | $0.50 | 1012 |      1000 |       $450.00 |   $450.00
 c001 |     0.10 | p02  | $0.50 | 1019 |       400 |       $180.00 |   $180.00
 c001 |     0.10 | p03  | $1.00 | 1017 |       600 |       $540.00 |   $540.00
 c001 |     0.10 | p04  | $1.00 | 1018 |       600 |       $540.00 |   $540.00
 c001 |     0.10 | p05  | $1.00 | 1023 |       500 |       $450.00 |   $450.00
 c001 |     0.10 | p06  | $2.00 | 1022 |       400 |       $720.00 |   $720.00
 c001 |     0.10 | p07  | $1.00 | 1025 |       800 |       $720.00 |   $720.00
 c002 |     0.12 | p03  | $1.00 | 1013 |      1000 |       $880.00 |   $880.00
 c002 |     0.12 | p03  | $1.00 | 1026 |       800 |       $704.00 |   $704.00
 c003 |     0.08 | p05  | $1.00 | 1015 |      1200 |     $1,104.00 | $1,104.00
 c003 |     0.08 | p05  | $1.00 | 1014 |      1200 |     $1,104.00 | $1,104.00
 c004 |     0.08 | p01  | $0.50 | 1021 |      1000 |       $460.00 |   $460.00
 c006 |     0.00 | p01  | $0.50 | 1016 |      1000 |       $500.00 |   $500.00
 c006 |     0.00 | p07  | $1.00 | 1020 |       600 |       $600.00 |   $600.00
 c006 |     0.00 | p01  | $0.50 | 1024 |       800 |       $400.00 |   $400.00
(16 rows)

    My calculated field is named calctot (but your name doesn't have to match).
    I see they are the same for all records, indicating that the author of
    the CAP database used the same algorithm.

    Just a database design point that'll come up later: we should never
    store a value (like dollars) that can be derived from other data.
    What if the o_qty were to change?  The calculated field would be
    accurate, but o_dollars would be wrong!


    #3  We will assume that tbl_products.fld_p_qty is the quantity on hand at a
        given location.

        Write a query that will return the cities followed by the number of entries
        for that city in tbl_products and the SUM of the quantities.
        (I know: 3 combs + 4 pencils gives us 7 "things".  That's OK.)
        
        Hint: first field: GROUP BY the city, second: COUNT(*), third SUM(quantity)

        Here are my numbers:

--------+-------+--------
 Newark |     2 | 303500
 Dallas |     3 | 455900
 Duluth |     2 | 275900
 Tulsa  |     1 | 150995



    #4  We will assume that tbl_orders.fld_o_month applies to a single year.  Given that
    assumption, write a query that will return the o_month, followed by the greatest
    single o_dollars for that month, followed by the average o_dollars, again by month.
    (Hint: You'll have to cast o_dollars to NUMERIC for AVG.  Round the result to 2
    decimal places right.)  Order by the monthly average.
    
    Extra point: Cast the average back to MONEY... no deduction if you don't.
    
    Here is my output for part a.
    
 fld_o_month |  my_max   | my_avg 
-------------+-----------+--------
 feb         |   $720.00 | 506.67
 mar         |   $720.00 | 523.33
 may         |   $704.00 | 704.00
 apr         |   $720.00 | 720.00
 jan         | $1,104.00 | 748.00
(5 rows)
 
    #4, Part b: Restrict the output to only rows where the average is greater than $700

*/
