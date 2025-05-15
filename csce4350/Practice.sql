-- Practice

/*
    For all states, list the counties within that state (Geo_QName) where the
    number of high-school diplomas (ACS18_5yr_B15003017) is less than the
    average *for that state*.
    
    So, we need to act within each group.  First, let's see what the data will
    look like within an easy state to check.  I like New Hampshire because it 
    only has 10 counties:
*/        
    SELECT Geo_QName, ACS18_5yr_B15003017 AS hsd
    FROM b15003 -- This becomes the outer query.
    --
    WHERE Geo_STUSAB = 'nh'
    ORDER BY Geo_STUSAB, hsd;      
/*
             geo_qname              |  hsd  
------------------------------------+-------
 Coos County, New Hampshire         |  7905
 Carroll County, New Hampshire      |  9609
 Sullivan County, New Hampshire     |  9773
 Belknap County, New Hampshire      | 11064
 Cheshire County, New Hampshire     | 14327
 Grafton County, New Hampshire      | 14431
 Strafford County, New Hampshire    | 19349
 Merrimack County, New Hampshire    | 24357
 Rockingham County, New Hampshire   | 47909
 Hillsborough County, New Hampshire | 64616
(10 rows)




    The next piece I need is the state average:
*/
    SELECT AVG(ACS18_5yr_B15003017) AS my_avg
    FROM b15003 -- this becomes the inner query
    --
    WHERE Geo_STUSAB = 'nh'
    ;      
/*
       my_avg (rounded)     
--------------------
 22334
(1 row)

Thus, we can easily see our result for New Hampshire:

 Coos County, New Hampshire         |  7905
 Carroll County, New Hampshire      |  9609
 Sullivan County, New Hampshire     |  9773
 Belknap County, New Hampshire      | 11064
 Cheshire County, New Hampshire     | 14327
 Grafton County, New Hampshire      | 14431
 Strafford County, New Hampshire    | 19349
 ---------- 22334 (average) ---------------
 Merrimack County, New Hampshire    | 24357
 Rockingham County, New Hampshire   | 47909
 Hillsborough County, New Hampshire | 64616

We want the top seven rows (that lets us check
our result easily).
*/
    SELECT Geo_QName, ACS18_5yr_B15003017 AS hsd
    FROM b15003 AS outside_table
    WHERE ACS18_5yr_B15003017 < ALL
    (
        SELECT AVG(ACS18_5yr_B15003017)
        FROM b15003 
        WHERE outside_table.Geo_STUSAB = Geo_STUSAB
    )
        --
    AND Geo_STUSAB = 'nh'
    ORDER BY Geo_STUSAB, hsd;      
/*
            geo_qname            |  hsd  
---------------------------------+-------
 Coos County, New Hampshire      |  7905
 Carroll County, New Hampshire   |  9609
 Sullivan County, New Hampshire  |  9773
 Belknap County, New Hampshire   | 11064
 Cheshire County, New Hampshire  | 14327
 Grafton County, New Hampshire   | 14431
 Strafford County, New Hampshire | 19349
(7 rows)

And we see that our correlated subquery matches
our test case; thus, we remove the "AND Geo_STUSAB = 'nh'"
and have our answer:
*/
    SELECT Geo_QName, ACS18_5yr_B15003017 AS hsd
    FROM b15003 AS outside_table
    WHERE ACS18_5yr_B15003017 < ALL
    (
        SELECT AVG(ACS18_5yr_B15003017) -- no alias needed here
        FROM b15003 
        WHERE outside_table.Geo_STUSAB = Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, hsd;
/*
Some programmers will alias both tables.  There is nothing
at all wrong with that.
*/
    SELECT Geo_QName, ACS18_5yr_B15003017 AS hsd
    FROM b15003 AS outside_table
    WHERE ACS18_5yr_B15003017 < ALL
    (
        SELECT AVG(ACS18_5yr_B15003017)
        FROM b15003 AS inside_table
        WHERE outside_table.Geo_STUSAB = inside_table.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, hsd;
/*
It is possible to alias just the inside table, leaving the
outside table's default name.
*/
    SELECT Geo_QName, ACS18_5yr_B15003017 AS hsd
    FROM b15003
    WHERE ACS18_5yr_B15003017 < ALL
    (
        SELECT AVG(ACS18_5yr_B15003017)
        FROM b15003 AS inside_table
        WHERE Geo_STUSAB = inside_table.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, hsd;

/*
Logically, that works; however,
IMHO, I think it's best to take the default on the inner table...
or alias both tables.  
*/

--------------------------------------------------------------------------

/*
    Same as #1, but, for all states, list the counties within that state
    (Geo_QName) where the number of high-school diplomas 
    (ACS18_5yr_B15003017 AS hsd) is less than the ratio of state's hsd to the 
    population of each state.
    
    We will take the same approach: what are all ratios within NH? (We
    expect 10.)
*/
    SELECT Geo_QName, ACS18_5yr_B15003017::NUMERIC/ACS18_5yr_B15003001 AS hsd
    FROM b15003 -- Don't forget to cast to numeric or they'll all be zero!
                -- This becomes the outer query.
    --
    WHERE Geo_STUSAB = 'nh'
    ORDER BY Geo_STUSAB, hsd; 
/*
    Rounding to four decimal places (rounding not shown)
    
             geo_qname              |  hsd   
------------------------------------+--------
 Rockingham County, New Hampshire   | 0.2171
 Hillsborough County, New Hampshire | 0.2241
 Grafton County, New Hampshire      | 0.2295
 Merrimack County, New Hampshire    | 0.2300
 Strafford County, New Hampshire    | 0.2324
 ------ break added
 Belknap County, New Hampshire      | 0.2470
 Carroll County, New Hampshire      | 0.2596
 Cheshire County, New Hampshire     | 0.2702
 Sullivan County, New Hampshire     | 0.3073
 Coos County, New Hampshire         | 0.3234
(10 rows)
 
 Now, we get the ratio of hsd to the state's population:
 */
    SELECT SUM(ACS18_5yr_B15003017)::NUMERIC/SUM(ACS18_5yr_B15003001) AS hsd
    FROM b15003 -- This becomes the inner query
    --
    WHERE Geo_STUSAB = 'nh';
/*
          hsd           
------------------------
 0.2346
(1 row)

You can see that we expect 5 rows in the outout for NH.
*/
    SELECT Geo_QName, ACS18_5yr_B15003017::NUMERIC/ACS18_5yr_B15003001 AS hsd
    FROM b15003 AS outside
    WHERE ACS18_5yr_B15003017::NUMERIC/ACS18_5yr_B15003001 < ALL
    (
        SELECT SUM(ACS18_5yr_B15003017)::NUMERIC/SUM(ACS18_5yr_B15003001) AS hsd
        FROM b15003
        WHERE Geo_STUSAB = outside.Geo_STUSAB
    )
    AND Geo_STUSAB = 'nh'
    ORDER BY Geo_STUSAB, hsd;
/*
After I have checked it for NH, I simply remove the line:
    "AND Geo_STUSAB = 'nh'" and that's it!
*/




-- One more like that:  Later, in this class, we will learn how to declare
-- a local variable and give it a name:

    DECLARE
        lv_delta NUMERIC(3,0):=500;
-- It won't work yet, but that's the idea.

/*
    Find all counties in each state that are within +- lv_delta of
    average number of doctorates (025) for that state.  (We will have to 
    use the numeric value for now.)
*/   

    SELECT Geo_QNAME, ACS18_5yr_B15003025
    FROM b15003 AS outside
    WHERE 
        ACS18_5yr_B15003025 >= ALL
        (
            SELECT AVG(ACS18_5yr_B15003025) - 500 AS low
            FROM b15003
            WHERE outside.Geo_STUSAB = Geo_STUSAB
        )
            AND
        ACS18_5yr_B15003025 <= ALL
        (
            SELECT AVG(ACS18_5yr_B15003025) + 500 AS low
            FROM b15003
            WHERE outside.Geo_STUSAB = Geo_STUSAB
        )
        AND Geo_STUSAB = 'tx'
    ORDER BY Geo_STUSAB, ACS18_5yr_B15003025;
    
    
    SELECT Geo_QNAME, ACS18_5yr_B15003025
    FROM b15003
    WHERE Geo_STUSAB = 'tx'
    ORDER BY ACS18_5yr_B15003025;
    
    
    -- Let's test it on Texas:
    SELECT ROUND(AVG(ACS18_5yr_B15003025))
    FROM b15003
    WHERE Geo_STUSAB = 'tx';
 
    
    
    
    








-- #3
/*
    Here's a tricky problem: what states have above average populations...
    meaning in the US, of course.
*/

-- Get the population of all states.  This will be the outer query
    SELECT Geo_STUSAB, my_sum
    FROM
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
        FROM b15003
        GROUP BY Geo_STUSAB
    );
    
/*
    Discussion, I don't need to push that into a derived table.
    Simply:
*/
    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
    FROM b15003
    GROUP BY Geo_STUSAB;
/*
    ... will run just fine (for now).
    
    
        
    -- What is the average state population, anyway?

    SELECT AVG(SUM(ACS18_5yr_B15003001))
    ...
    -- Uuuuh, oops!  I can't do that.  It's a nested aggregate; thus
    -- I gotta do the derived table thingy.
*/
    SELECT AVG(my_sum) AS st_avg
    FROM
    (
        SELECT SUM(ACS18_5yr_B15003001) AS my_sum
        FROM b15003
        GROUP BY Geo_STUSAB
    );
    -- 4246355... now you know what it was in 2018, anyway!
    -- That gives us the average state population.
    -- This will be the inner query.
    
/*
    Now, I will try to build the outer query without the
    derived table:
    
    

    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS a_sum
    FROM b15003 AS outside
    WHERE a_sum >= ALL
    (
        SELECT AVG(b_sum) AS st_avg
        FROM
        (
            SELECT SUM(ACS18_5yr_B15003001) AS b_sum
            FROM b15003
            GROUP BY Geo_STUSAB
        ) AS dt
        
        WHERE outside.Geo_STUSAB = Geo_STUSAB
    ) 
    GROUP BY Geo_STUSAB
    ORDER BY a_sum;
    
    
    Attempting to compile, we will run into the issue that
    "a_sum" (line #3) does not exist in the WHERE clause
    because the identifier is defined in the SELECT clause.
    
    So, we try to replace it with:
    
    
    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS a_sum
    FROM b15003 AS outside
    WHERE SUM(ACS18_5yr_B15003001) >= ALL
    (
        SELECT AVG(b_sum) AS st_avg
        FROM
        (
            SELECT SUM(ACS18_5yr_B15003001) AS b_sum
            FROM b15003
            GROUP BY Geo_STUSAB
        ) AS dt
        
        WHERE outside.Geo_STUSAB = Geo_STUSAB
    ) 
    GROUP BY Geo_STUSAB
    ORDER BY a_sum;
    
    
    Which doesn't help us:
    ERROR Line 3:  aggregate functions are not allowed in WHERE
    
    
    And, so, we're back to the original outer query:
*/
    

    
    SELECT Geo_STUSAB, my_sum
    FROM
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
        FROM b15003
        GROUP BY Geo_STUSAB
    ) AS outside
    WHERE my_sum >= ALL
    (
        SELECT AVG(my_sum) AS st_avg
        FROM
        (
            SELECT SUM(ACS18_5yr_B15003001) AS my_sum
            FROM b15003
            GROUP BY Geo_STUSAB
        ) AS dt -- generic name... not referenced
        WHERE outside.Geo_STUSAB = Geo_STUSAB
    )
    ORDER BY my_sum;
    
    -- The curious question here is: which table does
    -- "WHERE outside.Geo_STUSAB = Geo_STUSAB" the unqualified
    -- Geo_STUSAB reference?  I don't think it's explicit.
    -- Meaning, I don't think the inner table can be renamed.
    
    -- Here is a slight variation:
    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS a_sum
    FROM b15003 AS outside
    GROUP BY Geo_STUSAB
        HAVING SUM(ACS18_5yr_B15003001) >= ALL
        (
            SELECT AVG(b_sum) AS st_avg
            FROM
            (
                SELECT SUM(ACS18_5yr_B15003001) AS b_sum
                FROM b15003
                GROUP BY Geo_STUSAB
            ) AS dt -- generic name... not referenced
            WHERE outside.Geo_STUSAB = Geo_STUSAB
        ) 
        ORDER BY a_sum;

/*
    The variation replaces the WHERE clause with HAVING thereby
    allowing the aggregate.  Of the two, I prefer the second version;
    however, the first is consistent with the way I have been developing
    these ideas.

-- ---------------------------------------------------------------------


    The standard deviation (SD) is a measure of how closely grouped a the data are 
    about their mean.  A greater SD indicates data that tend to be spread out; a 
    lesser SD indicates that the data are clustered more tightly around their mean.  About 68% of the data points are expected to fall within one SD of the mean
    
    https://www.nlm.nih.gov/oet/ed/stats/02-900.html#:~:text=A%20standard%20deviation%20(or%20%CF%83,data%20are%20more%20spread%20out.
    
    Example: for each state, list the counties whose populations are within 
    one SD of that state's mean:
*/






    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003 AS outside
    WHERE 
        ACS18_5yr_B15003001 <= ALL 
        (
            SELECT AVG(ACS18_5yr_B15003001)+STDDEV(ACS18_5yr_B15003001)
            FROM b15003
            WHERE outside.Geo_STUSAB=Geo_STUSAB
        )
        AND
        ACS18_5yr_B15003001 >= ALL 
        (
            SELECT AVG(ACS18_5yr_B15003001)-STDDEV(ACS18_5yr_B15003001)
            FROM b15003
            WHERE outside.Geo_STUSAB=Geo_STUSAB
        )
        --AND Geo_STUSAB = 'nh'
    ORDER BY Geo_STUSAB;
    
    







SELECT SUM(ACS18_5yr_B15003024)::NUMERIC/SUM(ACS18_5yr_B15003001) AS ratio
    FROM b15003
    WHERE Geo_STUSAB = 'nh';
    
    

    SELECT Geo_QName, ACS18_5yr_B15003024::NUMERIC/ACS18_5yr_B15003001 AS ratios
    FROM b15003
    WHERE ACS18_5yr_B15003024::NUMERIC/ACS18_5yr_B15003001 < ALL
    (
        SELECT SUM(ACS18_5yr_B15003024)::NUMERIC/SUM(ACS18_5yr_B15003001)
        FROM b15003 AS tblInside
        WHERE tblInside.Geo_STUSAB = Geo_STUSAB
    )
    --
        AND Geo_STUSAB = 'nh'
    --
    ORDER BY Geo_STUSAB, Geo_QName
    ;