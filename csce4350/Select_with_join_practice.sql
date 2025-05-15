/*

    What Customers (cid) ordered product id (pid) 'p03'?
    
    This one is straight-forward because everything you need is in
    tbl_orders

*/

SELECT cid
FROM tbl_orders
WHERE pid = 'p03';

-- Note that you see one cid repeated.  To suppress that:

SELECT DISTINCT cid
FROM tbl_orders
WHERE pid='p03';

/*
    Customers from which cities ordered pid 'p03'?
    
    These data are in two tables.  You will need tbl_customers
    and tbl_orders.
*/

SELECT DISTINCT city
FROM tbl_customers AS c INNER JOIN tbl_orders AS o
    ON c.cid=o.cid
WHERE pid = 'p03';

/*
    Customers from which cities placed an order with an agent 'a01'?
    
    We still only need two tables: customers and orders because all I need
    is the aid.
*/

SELECT DISTINCT city
FROM tbl_customers AS c INNER JOIN tbl_orders AS o
    ON c.cid=o.cid
WHERE aid = 'a01';

/*
    Customers from which cities placed an order with an agent named 'Smith'?
    
    Now, the customer cities are in the customers table and the agents' names
    are in the agents table, joined by the orders table.  We will require three tables.
    Also, notice that we have two agents named 'Smith'; therefore, we should include
    the aid to tell them apart.
*/

SELECT city, a.aid
FROM tbl_customers AS c INNER JOIN tbl_orders AS o
    ON c.cid = o.cid INNER JOIN tbl_agents AS a
                     ON o.aid = a.aid
WHERE aname = 'Smith';

/*
    A couple of things to notice here: first, we had to qualify the aid field
    in the SELECT line because it appeared in two tables.  If we don't use DISTINCT,
    we return six rows, but adding a DISTINCT qualifier reduced it to four.  How
    do you explain that?
