/*
    In the class setup, we created the CAP (Customers/Agents/Products) database.
*/

    SET SEARCH_PATH TO cap;
    
    -- Look at your tables:
    \dt
    
    -- If it says: "no reletions found", then review the module: 
    -- "Install & Configure PSQL Environment" and create the CAP schema.
    
    -- Look at tbl_customers:
    
    SELECT * FROM tbl_customers;
/*
 fld_c_id_pk  | fld_c_name  |  fld_c_city  | c_discnt 
------+--------+--------+---------
 c001 | Tiptop | Duluth |   10.00
 c002 | Basics | Dallas |   12.00
 c003 | Allied | Dallas |    8.00
 c004 | ACME   | Duluth |    8.00
 c005 | Ace    | Denton |   10.00
 c006 | ACME   | Kyoto  |    0.00
(6 rows)


List all id & name from tbl_customers for city = 'Duluth'
*/

    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_city = 'Duluth';
    
/*
 fld_c_id_pk  | cname  
------+--------
 c001 | Tiptop
 c004 | ACME
(2 rows)


List all city where customer name = 'ACME'
*/
    SELECT fld_c_city
    FROM tbl_customers
    WHERE fld_c_name = 'ACME';
/*
  fld_c_city_pk  
--------
 Duluth
 Kyoto
(2 rows)

Optional clause: ORDER BY

Show fld_c_id_pk & cname ordered by cname where cdiscnt > 0
*/
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt > 0
    ORDER BY fld_c_name ASC; -- Ascending
/*
 fld_c_id_pk  | fld_c_name  
------+--------
 c004 | ACME
 c005 | Ace
 c003 | Allied
 c002 | Basics
 c001 | Tiptop
(5 rows)

Ascending is default & usually isn't specified.
If we want them in descending order:
*/  
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt > 0
    ORDER BY fld_c_name DESC;
/*
 fld_c_id_pk  | cname  
------+--------
 c001 | Tiptop
 c002 | Basics
 c003 | Allied
 c005 | Ace
 c004 | ACME
(5 rows)

The output fields may be renamed (but usually aren't)
Spaces *may* be used if the alias is in double quotes.
(This is seldom done.)
*/
    SELECT fld_c_id_pk AS "Customer Number", fld_c_name AS "Customer Name"
    FROM tbl_customers
    WHERE fld_c_discnt > 0
    ORDER BY fld_c_name DESC;
/*
 Customer Number | Customer Name 
-----------------+---------------
 c001            | Tiptop
 c002            | Basics
 c003            | Allied
 c005            | Ace
 c004            | ACME
(5 rows)
*/


/*
    The relational operators are what you'd expect:
*/    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt > 0
    ORDER BY fld_c_name DESC;
    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt <= 0
    ORDER BY fld_c_name DESC;
    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt < 0
    ORDER BY fld_c_name DESC;
    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt >= 0
    ORDER BY fld_c_name DESC;
    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt = 0
    ORDER BY fld_c_name DESC;
    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt <> 0
    ORDER BY fld_c_name DESC;
/*    
    This one is a little different.  We call it "the diamond inequality".  Read it as "not equal to".  (BTW, != also works; however, <> is preferred.)
    
    NULL values:
    
    You cannot use relational operators for NULL values; they are undefined.  NULL means "nothing", and "equal" means "is the same [thing] as", and "nothing" isn't a "thing"!
    
    NULL = NULL is undefined.  It is neither TRUE nor FALSE.
   
    For NULL, we use: fld_name IS NULL
    
    "fld_name IS NOT NULL" and "NOT fld_name IS NULL" are both valid negations.
*/

    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt IS NULL
    ORDER BY fld_c_name DESC;
    
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt IS NOT NULL
    ORDER BY fld_c_name DESC;
/*
    NOT, AND, OR work as you'd expect & in that order:
*/
    SELECT fld_c_id_pk, fld_c_name
    FROM tbl_customers
    WHERE fld_c_discnt > 0 AND fld_c_name = 'ACME'
    ORDER BY fld_c_name DESC;
/*
 fld_c_id_pk | fld_c_name 
-------------+------------
 c004        | ACME
(1 row)
*/