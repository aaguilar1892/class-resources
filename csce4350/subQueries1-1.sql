/*
    Today we will discuss self joins (tables joined with themselves)
    and I will introduct the idea of a subselect.





    An INNER JOIN on a different field than the PK/FK
    
    Example: Find all product pairs (pid) that share a common
    city.
    
    In this case, our join field will be "city" in tblProducts
    and the table is joined with itself!
*/
    SELECT p1.pid AS p1_pid, p1.city AS p1_city,
            p2.pid AS p2_pid, p2.city AS p2_city
    FROM tblProducts AS p1 INNER JOIN tblProducts AS p2
        ON p1.city = p2.city;
/*
 p1_pid | p1_city | p2_pid | p2_city 
--------+---------+--------+---------
 p01    | Dallas  | p06    | Dallas
 p01    | Dallas  | p05    | Dallas
 p01    | Dallas  | p01    | Dallas  <--
 p02    | Newark  | p07    | Newark
 p02    | Newark  | p02    | Newark
 p03    | Duluth  | p04    | Duluth
 p03    | Duluth  | p03    | Duluth
 p04    | Duluth  | p04    | Duluth
 p04    | Duluth  | p03    | Duluth
 p05    | Dallas  | p06    | Dallas
 p05    | Dallas  | p05    | Dallas
 p05    | Dallas  | p01    | Dallas
 p06    | Dallas  | p06    | Dallas
 p06    | Dallas  | p05    | Dallas
 p06    | Dallas  | p01    | Dallas
 p07    | Newark  | p07    | Newark
 p07    | Newark  | p02    | Newark
 p08    | Tulsa   | p08    | Tulsa
(18 rows)

    This shows city pairs; however, as in the flagged row,
    p01 lives in the same city as himself.  We can eliminate
    these pairs in the WHERE clause:
*/
    SELECT p1.pid AS p1_pid, p1.city AS p1_city,
            p2.pid AS p2_pid, p2.city AS p2_city
    FROM tblProducts AS p1 INNER JOIN tblProducts AS p2
        ON p1.city = p2.city
    WHERE p1.pid<>p2.pid;
/*
 p1_pid | p1_city | p2_pid | p2_city 
--------+---------+--------+---------
 p01    | Dallas  | p06    | Dallas  <--
 p01    | Dallas  | p05    | Dallas
 p02    | Newark  | p07    | Newark
 p03    | Duluth  | p04    | Duluth
 p04    | Duluth  | p03    | Duluth
 p05    | Dallas  | p06    | Dallas
 p05    | Dallas  | p01    | Dallas
 p06    | Dallas  | p05    | Dallas
 p06    | Dallas  | p01    | Dallas  <--
 p07    | Newark  | p02    | Newark
(10 rows)

    That's better; however, notice the flagged rows.
    If p01 shares a city with p06, then p06 will share
    a city with p01.  This is easily fixed with a
    less-than (or greater-than).
*/
    SELECT p1.pid AS p1_pid, p1.city AS p1_city,
            p2.pid AS p2_pid, p2.city AS p2_city
    FROM tblProducts AS p1 INNER JOIN tblProducts AS p2
        ON p1.city = p2.city
    WHERE p1.pid < p2.pid;
    
/*
    
    It is possible for a foreign key in table 't' to reference 
    table 't'.
    
    For example:
*/
    CREATE TEMPORARY TABLE tbl_employees
    (
        fld_e_id_pk INTEGER, -- or "INT" is OK
        fld_e_name CHAR(16),
        fld_e_supervisor_fk INTEGER,
        --
        CONSTRAINT e_pk PRIMARY KEY(fld_e_id_pk),
        CONSTRAINT e_fk FOREIGN KEY(fld_e_supervisor_fk)
            REFERENCES tbl_employees(fld_e_id_pk)
    );
/*
    This is tricky.  We cannot constrain fld_e_supervisor_fk
    as NOT NULL because we couldn't insert the first record...
    assumably, this would be the president.  If we tried:
    
    INSERT INTO tbl_employees(fld_e_id_pk, fld_e_name, fld_e_supervisor_fk)
    VALUES (1, 'Al', 1);
    
    It would fail on an invalid FK because it checks that before
    the insert happens.  I would have to do:
*/
    INSERT INTO tbl_employees(fld_e_id_pk, fld_e_name)
    VALUES (1, 'Al');
    
    UPDATE tbl_employees
    SET fld_e_supervisor_fk = 1
    WHERE fld_e_id_pk = 1;
    
    -- This is new!
    ALTER TABLE tbl_employees ADD
        CONSTRAINT null_super 
        CHECK(fld_e_supervisor_fk IS NOT NULL);

-- Now, I can insert normally
    INSERT INTO tbl_employees(fld_e_id_pk, fld_e_name, fld_e_supervisor_fk)
    VALUES (2, 'Bob', 1),
            (3, 'Connie', 1),
            (4, 'Dale', 3),
            (5, 'Edith', 3);
/*
    To see a list of employees and their respective supervisors
    calls for a self join on the FK --> PK
*/
    SELECT e1.fld_e_id_pk AS emp, e1.fld_e_name,
            e2.fld_e_id_pk, e2.fld_e_name
    FROM tbl_employees AS e1 INNER JOIN tbl_employees AS e2
        ON e1.fld_e_id_pk = e2.fld_e_supervisor_fk;









/*
                        SubQueries
                        
                        
    Find the cid and ordNo for all customers who purchased a product 
    from Duluth.
    
    We have the cid and ordNo in tblOrders and city in tblProducts.  
    Thus we would now use  an INNER JOIN:
*/
    
    SELECT cid, ordNo
    FROM tblOrders AS o INNER JOIN tblProducts AS p
        ON o.pid=p.pid
    WHERE city='Duluth'
    ORDER BY cid, ordNo;
/*
        
    SELECT o.pid AS orders_pid, p.pid AS products_pid, cid, ordNo, city
    FROM tblOrders AS o, tblProducts AS p
    ORDER BY o.pid, p.pid; -- that makes it easier to see
    
    
    
 orders_pid | products_pid | cid  | ordno |  city  
------------+--------------+------+-------+--------
 p01        | p01          | c004 |  1021 | Dallas  <--
 p01        | p01          | c006 |  1016 | Dallas  <--
 p01        | p01          | c001 |  1011 | Dallas  <--
 p01        | p01          | c001 |  1012 | Dallas  <--
 p01        | p01          | c006 |  1024 | Dallas  <--
 p01        | p02          | c006 |  1016 | Newark
 p01        | p02          | c001 |  1012 | Newark
 p01        | p02          | c001 |  1011 | Newark
 p01        | p02          | c004 |  1021 | Newark
 p01        | p02          | c006 |  1024 | Newark
 p01        | p03          | c001 |  1012 | Duluth
 p01        | p03          | c006 |  1016 | Duluth
 p01        | p03          | c006 |  1024 | Duluth
 p01        | p03          | c001 |  1011 | Duluth
 p01        | p03          | c004 |  1021 | Duluth
 p01        | p04          | c001 |  1011 | Duluth
 p01        | p04          | c001 |  1012 | Duluth
 p01        | p04          | c006 |  1024 | Duluth
 p01        | p04          | c004 |  1021 | Duluth
 p01        | p04          | c006 |  1016 | Duluth
 p01        | p05          | c006 |  1024 | Dallas
 p01        | p05          | c001 |  1011 | Dallas
 p01        | p05          | c001 |  1012 | Dallas
 p01        | p05          | c004 |  1021 | Dallas
 p01        | p05          | c006 |  1016 | Dallas
 p01        | p06          | c006 |  1016 | Dallas
 p01        | p06          | c004 |  1021 | Dallas
 p01        | p06          | c001 |  1012 | Dallas
 p01        | p06          | c001 |  1011 | Dallas
 p01        | p06          | c006 |  1024 | Dallas
 p01        | p07          | c006 |  1024 | Newark
 p01        | p07          | c001 |  1011 | Newark
 p01        | p07          | c001 |  1012 | Newark
 p01        | p07          | c006 |  1016 | Newark
 p01        | p07          | c004 |  1021 | Newark
 p01        | p08          | c006 |  1016 | Tulsa
 p01        | p08          | c001 |  1011 | Tulsa
 p01        | p08          | c004 |  1021 | Tulsa
 p01        | p08          | c006 |  1024 | Tulsa
 p01        | p08          | c001 |  1012 | Tulsa
 p02        | p01          | c001 |  1019 | Dallas
 p02        | p02          | c001 |  1019 | Newark  <--
 p02        | p03          | c001 |  1019 | Duluth
 p02        | p04          | c001 |  1019 | Duluth
 p02        | p05          | c001 |  1019 | Dallas
 p02        | p06          | c001 |  1019 | Dallas
 p02        | p07          | c001 |  1019 | Newark
 p02        | p08          | c001 |  1019 | Tulsa
 p03        | p01          | c001 |  1017 | Dallas
 p03        | p01          | c002 |  1026 | Dallas
 p03        | p01          | c002 |  1013 | Dallas
 p03        | p02          | c002 |  1026 | Newark
 p03        | p02          | c001 |  1017 | Newark
 p03        | p02          | c002 |  1013 | Newark
 p03        | p03          | c002 |  1013 | Duluth  <--
 p03        | p03          | c002 |  1026 | Duluth  <--
 p03        | p03          | c001 |  1017 | Duluth  <--
 p03        | p04          | c002 |  1026 | Duluth
 p03        | p04          | c001 |  1017 | Duluth
 p03        | p04          | c002 |  1013 | Duluth
 p03        | p05          | c002 |  1013 | Dallas
 p03        | p05          | c001 |  1017 | Dallas
 p03        | p05          | c002 |  1026 | Dallas
 p03        | p06          | c002 |  1026 | Dallas
 p03        | p06          | c001 |  1017 | Dallas
 p03        | p06          | c002 |  1013 | Dallas
 p03        | p07          | c002 |  1026 | Newark
 p03        | p07          | c001 |  1017 | Newark
 p03        | p07          | c002 |  1013 | Newark
 p03        | p08          | c002 |  1026 | Tulsa
 p03        | p08          | c001 |  1017 | Tulsa
 p03        | p08          | c002 |  1013 | Tulsa
 p04        | p01          | c001 |  1018 | Dallas
 p04        | p02          | c001 |  1018 | Newark
 p04        | p03          | c001 |  1018 | Duluth
 p04        | p04          | c001 |  1018 | Duluth  <--
 p04        | p05          | c001 |  1018 | Dallas
 p04        | p06          | c001 |  1018 | Dallas
 p04        | p07          | c001 |  1018 | Newark
 p04        | p08          | c001 |  1018 | Tulsa
 p05        | p01          | c003 |  1015 | Dallas
 p05        | p01          | c001 |  1023 | Dallas
 p05        | p01          | c003 |  1014 | Dallas
 p05        | p02          | c001 |  1023 | Newark
 p05        | p02          | c003 |  1015 | Newark
 p05        | p02          | c003 |  1014 | Newark
 p05        | p03          | c001 |  1023 | Duluth
 p05        | p03          | c003 |  1015 | Duluth
 p05        | p03          | c003 |  1014 | Duluth
 p05        | p04          | c003 |  1015 | Duluth
 p05        | p04          | c001 |  1023 | Duluth
 p05        | p04          | c003 |  1014 | Duluth
 p05        | p05          | c001 |  1023 | Dallas  <--
 p05        | p05          | c003 |  1014 | Dallas  <--
 p05        | p05          | c003 |  1015 | Dallas  <--
 p05        | p06          | c003 |  1015 | Dallas
 p05        | p06          | c001 |  1023 | Dallas
 p05        | p06          | c003 |  1014 | Dallas
 p05        | p07          | c003 |  1015 | Newark
 p05        | p07          | c001 |  1023 | Newark
 p05        | p07          | c003 |  1014 | Newark
 p05        | p08          | c003 |  1014 | Tulsa
 p05        | p08          | c003 |  1015 | Tulsa
 p05        | p08          | c001 |  1023 | Tulsa
 p06        | p01          | c001 |  1022 | Dallas
 p06        | p02          | c001 |  1022 | Newark
 p06        | p03          | c001 |  1022 | Duluth
 p06        | p04          | c001 |  1022 | Duluth
 p06        | p05          | c001 |  1022 | Dallas
 p06        | p06          | c001 |  1022 | Dallas  <--
 p06        | p07          | c001 |  1022 | Newark
 p06        | p08          | c001 |  1022 | Tulsa
 p07        | p01          | c001 |  1025 | Dallas
 p07        | p01          | c006 |  1020 | Dallas
 p07        | p02          | c001 |  1025 | Newark
 p07        | p02          | c006 |  1020 | Newark
 p07        | p03          | c006 |  1020 | Duluth
 p07        | p03          | c001 |  1025 | Duluth
 p07        | p04          | c006 |  1020 | Duluth
 p07        | p04          | c001 |  1025 | Duluth
 p07        | p05          | c006 |  1020 | Dallas
 p07        | p05          | c001 |  1025 | Dallas
 p07        | p06          | c006 |  1020 | Dallas
 p07        | p06          | c001 |  1025 | Dallas
 p07        | p07          | c006 |  1020 | Newark  <--
 p07        | p07          | c001 |  1025 | Newark  <--
 p07        | p08          | c006 |  1020 | Tulsa
 p07        | p08          | c001 |  1025 | Tulsa
 p99        | p01          | c004 |  1027 | Dallas
 p99        | p02          | c004 |  1027 | Newark
 p99        | p03          | c004 |  1027 | Duluth
 p99        | p04          | c004 |  1027 | Duluth
 p99        | p05          | c004 |  1027 | Dallas
 p99        | p06          | c004 |  1027 | Dallas
 p99        | p07          | c004 |  1027 | Newark
 p99        | p08          | c004 |  1027 | Tulsa
(136 rows)                                            <--(16 matches)
    
   
Now, *that* is ugly, but that's the Cartesian product that
the INNER JOIN produces.  Let's apply the join field using
the old implicit join syntax.  



    SELECT o.pid AS orders_pid, p.pid AS products_pid, cid, ordNo, city
    FROM tblOrders AS o, tblProducts AS p
    WHERE o.pid=p.pid
    ORDER BY o.pid, p.pid; -- that makes it easier to see    
    
 orders_pid | products_pid | cid  | ordno |  city  
------------+--------------+------+-------+--------
 p01        | p01          | c001 |  1011 | Dallas
 p01        | p01          | c001 |  1012 | Dallas
 p01        | p01          | c004 |  1021 | Dallas
 p01        | p01          | c006 |  1016 | Dallas
 p01        | p01          | c006 |  1024 | Dallas
 p02        | p02          | c001 |  1019 | Newark
 p03        | p03          | c001 |  1017 | Duluth  <--
 p03        | p03          | c002 |  1013 | Duluth  <--
 p03        | p03          | c002 |  1026 | Duluth  <--
 p04        | p04          | c001 |  1018 | Duluth  <--
 p05        | p05          | c003 |  1015 | Dallas
 p05        | p05          | c001 |  1023 | Dallas
 p05        | p05          | c003 |  1014 | Dallas
 p06        | p06          | c001 |  1022 | Dallas
 p07        | p07          | c006 |  1020 | Newark
 p07        | p07          | c001 |  1025 | Newark
(16 rows)

OK, looking better.  Now, we paint in the city
and convert it to the modern syntax for the INNER JOIN:
(Also, we don't want to see the pid(s) any longer.)
*/

    SELECT cid, ordNo
    FROM tblOrders AS o INNER JOIN tblProducts AS p
        ON o.pid=p.pid
    WHERE city='Duluth'
    ORDER BY cid, ordNo;
/*

 cid  | ordno 
------+-------
 c001 |  1017
 c001 |  1018
 c002 |  1013
 c002 |  1026
(4 rows)


-- ------------------------------------------

Is there another way to think?

What product IDs do we need? ... well, the ones where the
city is "Duluth".

    SELECT pid
    FROM tblProducts
    WHERE city='Duluth';

 pid 
-----
 p03
 p04
(2 rows)

Hold that thought!  Lets go to the orders table:

    SELECT pid, cid, ordNo
    FROM tblOrders
    ORDER BY pid; -- that makes it easier to see

 pid | cid  | ordno 
-----+------+-------
 p01 | c004 |  1021
 p01 | c001 |  1011
 p01 | c001 |  1012
 p01 | c006 |  1024
 p01 | c006 |  1016
 p02 | c001 |  1019
 p03 | c002 |  1013  <--
 p03 | c001 |  1017  <--
 p03 | c002 |  1026  <--
 p04 | c001 |  1018  <--
 p05 | c003 |  1015
 p05 | c003 |  1014
 p05 | c001 |  1023
 p06 | c001 |  1022
 p07 | c001 |  1025
 p07 | c006 |  1020
 p99 | c004 |  1027
(17 rows)
    
This takes us to:
    
    The Subquery
*/

    SELECT cid, ordNo
    FROM tblOrders
    WHERE pid IN
    (
        SELECT pid
        FROM tblProducts
        WHERE city='Duluth'
    )
    ORDER BY cid, ordNo;
    
/*
    The first one:
        "SELECT cid, ordNo
         FROM tblOrders"
    is called the "outer query" and the one in the WHERE 
    clause is known as the "inner query".  In order to use
    this form of joining tables, ALL OF THE OUTPUT MUST
    COME FROM THE OUTER QUERY!
    
    We could easily add the product name (from tblProducts)
    to the explicit INNER JOIN; however, we cannot do so with
    the subquery because tblProducts is in the inner query.
    
    It isn't uncommon for a query's output to come from one
    table and be validated against another table or tables.
    Many people (your professor included) think a subquery
    is more intuitive than an explicit table join.  (There
    is no difference in effciency because the database may
    optimize a query you write into the most efficient form.






    
    

    Another example:
    
    Find the agent's name (or agents' names) and ordNo serving cid = 'c001'
    
    Again, all output is from a single table; however, in the previous
    example, the output came from the parent table.  In this case, it comes
    from the child.
    
    As an INNER JOIN:
*/

    SELECT aname, a.aid, ordNo
    FROM tblOrders AS o INNER JOIN tblAgents AS a
        ON o.aid=a.aid
    WHERE cid='c001';
    /*
        Now, in an INNER JOIN, I can easily add ordNo to show that
        there are eight orders from cid 'c001'.  With a subquery, I
        cannot add ordNo to the output because, when I'm using a subquery,
        all of my output has to be from a single table.  (That's not *always*
        so, but we'll say it is for now.)
        
        I can add aid (it is in the outside table) to show that we have two
        agents named 'Smith'.  Notice that the subSelect did not return duplicate
        agent names unless they were different records.
    */
    
    SELECT aname, aid
    FROM tblAgents
    WHERE aid IN
    (
        SELECT aid
        FROM tblOrders
        WHERE cid='c001'
    );


