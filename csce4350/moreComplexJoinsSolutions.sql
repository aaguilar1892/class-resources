/*
    1) Find all Agent Names (and cities) serving Customer c006.
*/
    SELECT a.aid, aname
    FROM tblOrders AS o INNER JOIN tblAgents AS a
        ON o.aid=a.aid
    WHERE cid = 'c006';


/*
    2) Find all Agent Names (and aid) serving Customer "ACME, Kyoto"
*/
    SELECT a.aid, aname
    FROM tblCustomers AS c INNER JOIN tblOrders AS o
        ON c.cid = o.cid
        INNER JOIN tblAgents AS a
            ON o.aid=a.aid
    WHERE cname='ACME' AND city='Kyoto';


/*
    3) Find all order numbers, product names where the customer's name is "Tiptop"
    and the Agent's name is "Smith"; order the output by product name.
*/

SELECT ordno, pname
FROM tblCustomers AS c INNER JOIN tblOrders AS o
    ON c.cid=o.cid
    INNER JOIN tblProducts AS p
        ON o.pid=p.pid
        INNER JOIN tblAgents AS a
            ON o.aid=a.aid
WHERE cname='Tiptop' AND aname='Smith'
ORDER BY pname;

/*
    4) Find all customer name/agent name pairs who share an order and have the same city name.
*/

SELECT cname, aname
FROM tblCustomers AS c INNER JOIN tblOrders AS o
    ON c.cid=o.cid
    INNER JOIN tblAgents AS a
        ON o.aid=a.aid
WHERE c.city=a.acity;

-- There are two records with the same two customer/agent pair
-- We can see this by:
SELECT ordno, cname, aname
FROM tblCustomers AS c INNER JOIN tblOrders AS o
    ON c.cid=o.cid
    INNER JOIN tblAgents AS a
        ON o.aid=a.aid
WHERE c.city=a.acity;

-- To suppress duplicate rows:
SELECT DISTINCT cname, aname
FROM tblCustomers AS c INNER JOIN tblOrders AS o
    ON c.cid=o.cid
    INNER JOIN tblAgents AS a
        ON o.aid=a.aid
WHERE c.city=a.acity;
-- Also, "WHERE city=acity" would have worked.

 

/*
    5) List all suppliers (sid, sname) of products ordered by customers in Duluth.
    Suppress duplicate rows.

*/

SELECT DISTINCT s.sid, sname
FROM tblCustomers AS c INNER JOIN tblOrders AS o
    ON c.cid=o.cid
    INNER JOIN tblProducts AS p
        ON o.pid=p.pid
            INNER JOIN tblProductSupplier AS ps
            ON p.pid=ps.pid
                INNER JOIN tblSuppliers AS s
                ON ps.sid=s.sid
WHERE c.city = 'Duluth';


