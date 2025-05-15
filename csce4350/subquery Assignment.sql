/*
    Assignment for SubQueries and Aggregate Functions
    
    Subqueries: note that all output is derived from a single table.
    In all cases, ORDER BY the PK in the outside table... if there is one.
    (If not then make a decision.)
    
    
    1) Using a subquery, list the ID (fld_c_id_pk) and name (fld_c_name) and city for the customer associated with order ID (fld_o_id_pk) 1021.
    
 fld_c_id_pk | fld_c_name | fld_c_city 
-------------+------------+------------
 c004        | ACME       | Duluth
(1 row)



   
    2)  Using a subquery, list the order number and agent ID[s] from all current orders for 'pencil'. Alias the order number AS 'order_num' and agent ID AS 'agent_id'.  (Hint: outside query is orcers, subquery: products)
    
     order_num | agent_id 
-----------+----------
      1015 | a03
      1014 | a03
      1023 | a04
(3 rows)




    3)  Using a subquery, list the product ID and name of all products supplied by supplier ID 's06'.  (Hint: the information is in tbl_products and tbl_product_supplier.
    
 fld_p_id_pk | fld_p_name 
-------------+------------
 p02         | brush
 p04         | pen
(2 rows)





    4)  Using a subquery, list the product ID and name of all products supplied by supplier named "Gamma Supply".  (Hint: this one is similar to #3 in that you start with tbl_products and then hit tbl_product_supplier.  The difference is that you continue to tbl_suppliers where fld_s_name is located.
    
fld_p_id_pk | fld_p_name 
-------------+------------
 p02         | brush
 p07         | case
 p08         | floppy
(3 rows)
    




    Using Aggregate Functions  (The output will be single row, thus no need for ORDER BY.)
 


 
    5) How many orders do we have placed by agents from "New York"?  (Discussion, you need information from both agents and orders; however, the output is derived from only one of these; therefore, you may use *either* an INNER JOIN or a subselect.)
    
    Don't forget to alias the aggregate function... I didn't tell you what to name it.
    
my_cnt 
--------
      4
(1 row)





    6) What is the total value of *all* products from "Dallas"?  Hunt: SUM(quantity * price)  Discussion: When we took an average of money, we had to CAST the MONEY field AS NUMERIC because MONEY always has 4 decimal places; however, the average might not.  We won't need to CAST when we multiply by an INT and add them up.
    
   my_tot    
-------------
 $523,300.00
(1 row)
    

   