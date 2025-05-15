SET SEARCH_PATH TO cap;

/*

    tbl_customers is the parent. The foreign key is in tbl_orders.
    One customer may have many orders.

    Find all orders (ordno) for customers (cid, cname) in Duluth.

    I always begin with what I know.  City = 'Duluth'

    Notice that, in this world, the PK and the FK have the same names!
*/

    SELECT c.cid, cname, ordno
    FROM tbl_customers AS c INNER JOIN tbl_orders AS o
        ON c.cid = o.cid
    WHERE city = 'Duluth'
    ORDER BY ordno;

/*
    For those same customers, what product (pid, pname) did they order?

    This will take 3 tables because, to get from customers to products,
    you must go through orders.
*/
    SELECT c.cid, cname, ordno, p.pid, pname
    FROM tbl_customers AS c INNER JOIN tbl_orders AS o
        ON c.cid = o.cid
        INNER JOIN tbl_products AS p
            ON o.pid = p.pid
    WHERE c.city = 'Duluth'
    ORDER BY ordno;

/*
    Why do we have one fewer row in the 3-way join?
    (This would get a database administrator's attention!)
*/



/*
    List the customer name and ID (cid) and the aid of their agents for
    customers from Dallas.

    What tables do we need to answer that?
    tbl_customers and tbl_orders.  (We don't need tbl_agents... yet!)
*/
    SELECT c.cname, c.cid, o.aid
    FROM tbl_customers AS c INNER JOIN tbl_orders AS o
        ON c.cid = o.cid
    WHERE c.city = 'Dallas';

    SELECT DISTINCT c.cname, c.cid, o.aid
    FROM tbl_customers AS c INNER JOIN tbl_orders AS o
        ON c.cid = o.cid
    WHERE c.city = 'Dallas';

    -- add the agent's name to that query's output:
    -- *Now* it needs tbl_agents.

    SELECT DISTINCT c.cname, c.cid, a.aid, a.aname
    FROM tbl_customers AS c INNER JOIN tbl_orders AS o
        ON c.cid = o.cid
        INNER JOIN tbl_agents AS a
            ON o.aid = a.aid
    WHERE c.city = 'Dallas';

/*
    List the products (pid, pname) ordered by customer #'c001'
*/
    SELECT DISTINCT p.pid, p.pname
    FROM tbl_products AS p INNER JOIN tbl_orders AS o
        ON p.pid = o.pid
    WHERE o.cid = 'c001';

    -- Add the agent info (aid, aname) placing the order

    SELECT DISTINCT p.pid, p.pname, a.aid, a.aname
    FROM tbl_products AS p INNER JOIN tbl_orders AS o
        ON p.pid = o.pid
        INNER JOIN tbl_agents AS a
            ON o.aid = a.aid
    WHERE o.cid = 'c001';



