/*
    The OUTER JOIN

    Example tables:
*/

    -- Database: db50
    -- schema: demo_29

    SET SEARCH_PATH TO demo_29;
    
    DROP TABLE IF EXISTS tbl_child;
    DROP TABLE IF EXISTS tbl_parent;
    
    CREATE TABLE tbl_parent
    (
        fld_p_id_pk  INT,
        fld_p_name   CHAR(8),
        CONSTRAINT p_pk PRIMARY KEY(fld_p_id_pk)
    );

    CREATE TABLE tbl_child
    (
        fld_c_id_pk  INT,
        fld_c_name   CHAR(8),
        fld_p_id_fk  INT,
        CONSTRAINT c_pk PRIMARY KEY(fld_c_id_pk)
        -- CONSTRAINT c_fk FOREIGN KEY(fld_p_id_fk) REFERENCES tbl_parent(fld_p_id_pk)
        --
        -- That's the idea; however, we won't turn on the constraint.  It will still  work;
        -- however, it won't be protected against invalid foreign keys... which is what we
        -- want for demonstrating the OUTER JOIN.
    );



    INSERT INTO tbl_parent(fld_p_id_pk, fld_p_name)
    VALUES  (1, 'Al'), (2, 'Betty'), (3, 'Chas'), (4, 'Debbie');

    INSERT INTO tbl_child(fld_c_id_pk, fld_c_name, fld_p_id_fk)
    VALUES (101,'Ralph',2), -- child of Betty
            (102,'Connie', 2), -- child of Betty
            (103,'Steph', 4), -- child of Debbie
            (104,'Peggy', 1), -- child of Al
            (105,'Tom',  -1), -- Invalid parent
            (106, 'Annie', NULL); -- orphan
            -- 'Chas' is a childless parent
            
    -- first, let's review the INNER JOIN.
    
    SELECT * 
    FROM tbl_parent INNER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk;
/*
 fld_p_id_pk | fld_p_name | fld_c_id_pk | fld_c_name | fld_p_id_fk 
-------------+------------+-------------+------------+-------------
           2 | Betty      |         101 | Ralph      |           2
           2 | Betty      |         102 | Connie     |           2
           4 | Debbie     |         103 | Steph      |           4
           1 | Al         |         104 | Peggy      |           1
(4 rows)

    Herein, we see all parents *AND* their respective children.  We do not see:
    --> Childless parents
    --> Childern with invalid parents (i.e.: 'Tom')
    --> Orphans
    
    The INNER JOIN only displays rows that participate in the relationship.
    
    Remember the obsolete format (which is still logically very valid.):
*/
    SELECT * 
    FROM tbl_parent, tbl_child
    WHERE fld_p_id_pk = fld_p_id_fk;
/*
    The equality in the WHERE clause is not true except for participating rows.
    
    The OUTER JOIN:
    
    Consider the join given above (they are identical):  As you read, tbl_parent is on the right and tbl_child is on the left.  In the INNER JOIN, it makes no difference; however, it does in the OUTER JOIN.
    
    We will consider two forms of the OUTER JOIN:
*/
    SELECT * 
    FROM tbl_parent RIGHT OUTER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk
    ORDER BY fld_c_id_pk;
/*
 fld_p_id_pk | fld_p_name | fld_c_id_pk | fld_c_name | fld_p_id_fk 
-------------+------------+-------------+------------+-------------
           2 | Betty      |         101 | Ralph      |           2
           2 | Betty      |         102 | Connie     |           2
           4 | Debbie     |         103 | Steph      |           4
           1 | Al         |         104 | Peggy      |           1
             |            |         105 | Tom        |          -1
             |            |         106 | Annie      |            
(6 rows)

    Some admins say: "It points right."  Whatever you say, a RIGHT OUTER JOIN returns all rows that participate in the relationship *and* all rows from the RIGHT table.  Primary keys 101..104 are the same as the INNER JOIN, but we also see 105 (which has the invalid foreign key of -1.  What is special about child PK 105? (A: the parent PK is NULL!)
    
    To find *invald foreign keys*, the OUTER JOIN points to the child table.  *I* put the parent table on the left by convention; it isn't required to be thus:
*/
    SELECT * 
    FROM tbl_child RIGHT OUTER JOIN tbl_parent
        ON fld_p_id_fk = fld_p_id_pk
    ORDER BY fld_c_id_pk;
/*
    produces exactly the same output.  To find invalid child FKs, the information we need is in the child table, thus the OUTER JOIN points in that direction, whichever side it's on.
    
    To restrict the output to only the unmatched rows, use: WHERE the_pk IS NULL
*/
    SELECT * 
    FROM tbl_parent RIGHT OUTER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk
    WHERE fld_p_id_pk IS NULL
    ORDER BY fld_c_id_pk;
/*
 fld_p_id_pk | fld_p_name | fld_c_id_pk | fld_c_name | fld_p_id_fk 
-------------+------------+-------------+------------+-------------
             |            |         105 | Tom        |          -1
             |            |         106 | Annie      |            
(2 rows)

    Notice that this query also shows orphans.  When you think about it, isn't the NULL FK of the orphan also an invalid parent key?  The query immediately above returns unmatched child records.
    
    Usually, orphans aren't an issue... not from a database integrity perspective, anyway.  We don't need a table join to find orphans,if that is our objective:
*/
    SELECT * 
    FROM tbl_child
    WHERE fld_p_id_fk IS NULL;
/*
    will find all orphans without a join.  If you need invalid child FKs and only those, the orphans may be excluded by:
*/
    SELECT * 
    FROM tbl_parent RIGHT OUTER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk
    WHERE fld_p_id_pk IS NULL AND fld_p_id_fk IS NOT NULL -- for orphans, both would be NULL
    ORDER BY fld_c_id_pk;
/*
 fld_p_id_pk | fld_p_name | fld_c_id_pk | fld_c_name | fld_p_id_fk 
-------------+------------+-------------+------------+-------------
             |            |         105 | Tom        |          -1
(1 row)





    The other common task for the OUTER JOIN is finding childless parents.  It's a similar task; however, in this case, the information we want comes from the parent table.  To find childless parents, the OUTER JOIN points to the parent table!
    
    Since *I* always put the parent on the left (your practice may vary; whichever side the parent is on, that's the way the OUTER JOIN points.  Let's look at the output of a LEFT OUTER JOIN (using my convention of parent on the left.)  In the last example, we were interested in child records, thus I did ORDER BY the child PK; in this case, I'll order by the parent PK because that's where we're looking.
*/

    -- shows childless parents
    SELECT * 
    FROM tbl_parent LEFT OUTER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk
    ORDER BY fld_p_id_pk; 
/*
 fld_p_id_pk | fld_p_name | fld_c_id_pk | fld_c_name | fld_p_id_fk 
-------------+------------+-------------+------------+-------------
           1 | Al         |         104 | Peggy      |           1
           2 | Betty      |         101 | Ralph      |           2
           2 | Betty      |         102 | Connie     |           2
           3 | Chas       |             |            |            
           4 | Debbie     |         103 | Steph      |           4
(5 rows)

    We do *not* see Tom (invalid FK) and we don't see Orphan Annie, either.  They're in the RIGHT (child) table & this one is pointed LEFT.  We see all records from the left table including unmatched (childless) parents.
    
    How can we pick out the childless parents?  Simple: the referencing FK is NULL.  (Wouldn't that also be true of orphans?  A: Yes, but they're in the right table, so we don't get them.)
*/
    -- find childless parents:
    SELECT * 
    FROM tbl_parent LEFT OUTER JOIN tbl_child
        ON fld_p_id_pk = fld_p_id_fk
    WHERE fld_p_id_fk IS NULL
    ORDER BY fld_p_id_pk;
/*
 fld_p_id_pk | fld_p_name | fld_c_id_pk | fld_c_name | fld_p_id_fk 
-------------+------------+-------------+------------+-------------
           3 | Chas       |             |            |            
(1 row)

    If you care, and sometimes you do, you can clean up the output.  Since you know that all of the child fields will be NULL, you can restrict the output to the parent fields only:
*/
    SELECT p.* 
    FROM tbl_parent AS p LEFT OUTER JOIN tbl_child -- parent aliased
        ON fld_p_id_pk = fld_p_id_fk
    WHERE fld_p_id_fk IS NULL
    ORDER BY fld_p_id_pk;
    
    
    -- This same clean up may be applied to invalid FK where the parent fields are NULL:
    SELECT c.* 
    FROM tbl_parent RIGHT OUTER JOIN tbl_child AS c -- child aliased
        ON fld_p_id_pk = fld_p_id_fk
    WHERE fld_p_id_pk IS NULL
    ORDER BY fld_c_id_pk;
/*
    
        MATTERS OF STYLE
        
    Someone will read the blogs and notice that, instead of "LEFT OUTER JOIN", they will simply write "LEFT JOIN" (and, similarly: "RIGHT JOIN" instead of "RIGHT OUTER JOIN".)
    
    In this class, we will use the full syntax... mainly because the AI generators will shorten it.  It isn't intrinsically wrong to write
    
    "tbl_a JOIN tbl_b"  instead of  "tbl_a INNER JOIN tbl_b"
    "tbl_a RIGHT JOIN tbl_b"  instead of  "tbl_a RIGHT OUTER JOIN tbl_b"
    "tbl_a LEFT JOIN tbl_b"  instead of  "tbl_a LEFT OUTER JOIN tbl_b"
    
    However, doing so in *this* class will cost gradeing points!
    
    In the advanced class, we aren't as vulnerable to AI generation as we are in this one, so you may shorten the syntax in there.
    
    
        FULL OUTER JOIN (or "FULL JOIN")
        
    Some students will also notice that the "FULL OUTER JOIN" covers both the LEFT & RIGHT outer joins, and, yes, it does.  WE WILL NOT USE FULL OUTER JOIN because it puts as much work onto the system as doing both joins, then it simply throws away half of it.  The prohibition on shortening the syntax applies only to CSCE 4350.  Using "FULL JOIN" to find invalid FK or childless parents is sloppy programming anyplace.
    
    
    
    
        Order of Execution:
      
    You may have noticed that in:
        
                SELECT p.* 
                FROM tbl_parent AS p LEFT OUTER JOIN tbl_child -- parent aliased
                    ON fld_p_id_pk = fld_p_id_fk
                WHERE fld_p_id_fk IS NULL
                ORDER BY fld_p_id_pk;
                
    In a SELECT/FROM/WHERE, the order is:  1) FROM (get tables first)
                                           2) WHERE (resolve the rows)
                                           3) SELECT (get the fields)
                                              ORDER BY is last.
                                              
    Thus, if you alias a table on the WHERE line, the alias is used throughout the query.
    
    However, if you alias a field on the SELECT line, the alias won't exist in the WHERE clause.  (It will in the ORDER BT, though.)
                                              
                                         
                
                







