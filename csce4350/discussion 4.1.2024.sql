
SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003024) AS _024
FROM B15003
GROUP BY Geo_STUSAB;


DROP VIEW IF EXISTS dv;

CREATE VIEW dv AS
(
    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003024) AS _024
    FROM B15003
    GROUP BY Geo_STUSAB
);
/*
    A view *is* a table and tables are, by definition, sets, and a set
    is unordered; therefore, in most databases, a view cannot be based 
    in a query containing an "ORDER BY" clause.  PostgreSQL, however,
    will allow this, but, since it's prohibited in most platforms,
    we will not create views with "ORDER BY".
*/

SELECT *
FROM dv
ORDER BY _024;

/*
    If we have a table containing pairs of the form:
    
        identifier, value
    
    Find the pair containing the least (or greatest) value:
    
    (From our discussion of sub-selects)
    
        SELECT identifier, value
        FROM myTable
        WHERE value IN
        (
            SELECT MIN(value)
            FROM myTable
        );
        
    Get used to this guy!  It works the same way in any database
    product you pick up!  (Also, that *will* be on the final.)
    
    The beauty in this logic (besides the fact that it's clean) is
    that it returns ties for the min (or max).
        
    Apply that same logic to find the row in the view: dv
    containing the least value in the field _024.
*/

    SELECT Geo_STUSAB, _024
    FROM dv
    WHERE _024 IN
    (
        SELECT MIN(_024)
        FROM dv
    );
    
    DROP VIEW dv;
    
/* 
    Now, is that so difficult to understand?

    Notice that you have dv in two places.  Where you have
    dv, replace it with the sql code that created dv, put
    the code in parenthese, and give it a name.  (I usually
    name it "d", but you may name it "teetoadllyhum_swaggled"
    if it pleases you.
*/

    SELECT Geo_STUSAB, _024
    FROM 
    ( 
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003024) AS _024
        FROM B15003
        GROUP BY Geo_STUSAB 
    ) AS d
    WHERE _024 IN
    (
        SELECT MIN(_024)
        FROM 
        ( 
            SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003024) AS _024
            FROM B15003
            GROUP BY Geo_STUSAB 
        ) AS d
    );
/*
    And *that* is a derived table.  They have other uses; however,
    they're most commonly used for finding the min/max of an aggregate
    function.  I can't say that I want  MAX( SUM(value) ) because aggregates
    cannot be nested.
*/



-- What state has the greatest ratio of doctorate degrees (B15003025) to the 
-- population (B15003001)

-- Step one: find the data to minimize/maximize:

SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003025)::NUMERIC/SUM(ACS18_5yr_B15003001) AS _025
FROM B15003
GROUP BY Geo_STUSAB
-- 
ORDER BY _025 DESC;

/*
    -- Pretend:
    CREATE VIEW dt AS
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003025)::NUMERIC/SUM(ACS18_5yr_B15003001) AS _025
        FROM B15003
        GROUP BY Geo_STUSAB
    );
    
    Find the row with MAX _025
    
    SELECT Geo_STUSAB, _025
    FROM dt
    WHERE _025 IN
    (
        SELECT MAX(_025)
        FROM dt
    );
    
    Now, replace dt with the query and name it:
*/

    SELECT Geo_STUSAB, _025
    FROM
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003025)::NUMERIC/SUM(ACS18_5yr_B15003001) AS _025
        FROM B15003
        GROUP BY Geo_STUSAB
    ) AS dt
    WHERE _025 IN
    (
        SELECT MAX(_025)
        FROM 
        (
            SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003025)::NUMERIC/SUM(ACS18_5yr_B15003001) AS _025
            FROM B15003
            GROUP BY Geo_STUSAB
        ) AS dt
    );
    










/*   
    In PostgreSQL, STDDEV(num_val) returns the standard deviation (SD) of a set of
    values.  Recall from your math classes that the SD is a measurement of how
    closely data are grouped about the mean (average).  If we were looking at
    a dart target, we would find lots of holes close to the bull's eye; farther
    away, we'd find fewer holes.  A low SD means that the darts were more accurate
    than a greater SD.
    
    The *Empirical Rule* of statistics tells us that around 68% of the data will 
    fall within one standard deviation of the mean.
    
    Which states' ACS18_5yr_B15003024 data are within one standard deviation of the mean?
*/
    SELECT AVG(ACS18_5yr_B15003024) + STDDEV(ACS18_5yr_B15003024) AS u_bound


    SELECT Geo_STUSAB, _024
    FROM 
    ( 
        SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003024) AS _024
        FROM B15003
        GROUP BY Geo_STUSAB 
    ) AS d
    WHERE 
        _024 < ALL
        (
            SELECT AVG(ACS18_5yr_B15003024) + 
                        STDDEV(ACS18_5yr_B15003024)
            FROM B15003
        )
            AND
        _024 > ALL
        (
            SELECT AVG(ACS18_5yr_B15003024) - 
                        STDDEV(ACS18_5yr_B15003024)
            FROM B15003
        )
    -- Add an ORDER BY to see it better
    ORDER BY Geo_STUSAB, _024;
    
    
    
    
    SELECT  ROUND(47.0/52*100,2) AS percent_in_one_sd;
    
    
    SELECT ROUND(AVG(ACS18_5yr_B15003024),2) AS mean,
            ROUND(STDDEV(ACS18_5yr_B15003024),2) AS sd
    FROM B15003;
    
/* ----------------------------------------------------
    From Module
*/
    DROP TABLE IF EXISTS myTable;
    CREATE TEMPORARY TABLE myTable
    (
        fld_group CHAR(8),
        fld_store CHAR(8),
        fld_sales INT
    );
    
    INSERT INTO myTable(fld_group, fld_store, fld_sales)
    VALUES  ( 'Denton', 'Main', 18 ),
            ('Denton', 'South', 23 ),
            ('Denton', 'North', 12 ),
            ('Dallas', 'Main', 34 ),
            ('Dallas', 'North', 31 ),
            ('Dallas', 'South', 12 ),
            ('Meridian', 'East', 17 ),
            ('Meridian', 'Main', 21 ),
            ('Meridian', 'South', 15 ),
            ('Meridian', 'West', 20  );
            
-- This is a "CORROLATED SUBQUERY".  It is identified by the fact that
-- the outer query renames the table used in the subquery
    
    SELECT fld_group, fld_store, fld_sales
    FROM myTable AS myTable_out
    WHERE fld_sales >= ALL
    (
        SELECT fld_sales
        FROM myTable AS myTable_in
        WHERE myTable_out.fld_group = myTable_in.fld_group
    );
    
/*
    Corrolated subqueries are a technique used to answer:
    
    *For each grouping*, which record fields are:
        ( greatest, least, above or below average, top n percent, etc)
    *for their group*.
    
    Example:  Which counties (Geo_QName) are above their respective state's
    average for Professional School Degree (B15003024)?
    
*/

    SELECT Geo_STUSAB AS st, Geo_QName AS cnty, ACS18_5yr_B15003024 AS _024
    FROM B15003 AS outside
    WHERE ACS18_5yr_B15003024 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003024)
        FROM B15003
        WHERE Geo_STUSAB = outside.Geo_STUSAB
    )
    -- for readability, I will order the output:
    ORDER BY Geo_STUSAB, _024;
/*
    Well, that's a cool-looking 563 rows, but, how
    do I know they're right?
    
    Let's spot check it:
    
    I'll pick a state, any state... Vermont is a small set,
    but it doesn't matter.  I'll limit the query to
    WHERE Geo_STUSAB = 'vt', 
*/
    SELECT Geo_STUSAB AS st, Geo_QName AS cnty, ACS18_5yr_B15003024 AS _024
    FROM B15003 AS outside
    WHERE ACS18_5yr_B15003024 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003024)
        FROM B15003
        WHERE Geo_STUSAB = outside.Geo_STUSAB
    ) AND Geo_STUSAB = 'vt'
    ORDER BY Geo_STUSAB, _024;
    
--  then I'll look at:

    SELECT ROUND(AVG(ACS18_5yr_B15003024))
    FROM B15003
    WHERE Geo_STUSAB = 'vt';
    
-- and check it manually







