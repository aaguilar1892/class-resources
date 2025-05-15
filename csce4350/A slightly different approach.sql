-- A simple example of a derived table:

    SET SEARCH_PATH TO edu;

    -- Assume that the population (001) minus the count with no school (002)
    -- is the count with *some* school.  Geo_QName is the county & state.
    -- (Actually, it's the census tract.)
    
    SELECT Geo_QName, ACS18_5yr_B15003001 - ACS18_5yr_B15003002 AS some_school
    FROM b15003
    WHERE ACS18_5yr_B15003001 - ACS18_5yr_B15003002 > 1000000
    ORDER BY some_school;
    
    /*
        I want to write:
        
        SELECT Geo_QName, ACS18_5yr_B15003001 - ACS18_5yr_B15003002 AS some_school
        FROM b15003
        WHERE some_school > 1000000
        ORDER BY some_school;
        
        but I can't because of the sequence of evaluation.  The SELECT
        line is evaluated *after* the WHERE line, so that alias is not
        defined.
        
        I don't know why I'm determined to do that, but, given that I am,
        I can use a derived table:
    */
    
    SELECT Geo_QName, some_school
    FROM
    (
        SELECT Geo_QName, ACS18_5yr_B15003001 - ACS18_5yr_B15003002 AS some_school
        FROM b15003
    ) AS dt -- derived table
    WHERE some_school > 1000000
    ORDER BY some_school;
    
    /*
        I just wanted a trivial example of a derived table.  I wouldn't use
        one *just* to avoid some typing.
        
        There is another way to write a derived table where the definition
        of the derived table goes before the query in which it is used:
    */
    
    WITH cte(Geo_QName, some_school) AS
    (
        SELECT Geo_QName, ACS18_5yr_B15003001 - ACS18_5yr_B15003002
        FROM b15003
    )
    SELECT Geo_QName, some_school
    FROM cte -- common table expression
    WHERE some_school > 1000000
    ORDER BY some_school;
    
    /*
        This approach is called a "Common Table Expression".  Think of it
        like creating a view that only exists within that particular query...
        which is also what a derived table is.
    */
    
    
    

-- A slightly more complex example:    
    
/*
    Example: Find the state(s) with the maximum number of associate degrees.
    
    This is one we had as an example.  To get the associate degrees by state,
    we must SUM 021, then take a MAX of that.  Thus, we have a nested
    aggregate, and this calls for a derived table approach.
    
    
    Solution with derived table (dt):        */
    SELECT geo_stusab, num_associates
    FROM 
    (
        SELECT geo_stusab, SUM(ACS18_5yr_B15003021) AS num_associates
        FROM b15003
        GROUP BY geo_stusab
    ) AS dt
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM
        (
            SELECT geo_stusab, SUM(ACS18_5yr_B15003021) AS num_associates
            FROM b15003
            GROUP BY geo_stusab
        ) AS dt
    );
    
/*
    I might be tempted to try something like:
    
    SELECT geo_stusab, SUM(ACS18_5yr_B15003021) AS num_associates
    FROM b15003
    GROUP BY geo_stusab
    WHERE SUM(ACS18_5yr_B15003021) IN
    (
        SELECT MAX(num_associates)
        FROM
        (
            SELECT geo_stusab, SUM(ACS18_5yr_B15003021) AS num_associates
            FROM b15003
            GROUP BY geo_stusab
        ) AS dt
    );
    
    but I run into the fact that I cannot have an aggregate in the
    WHERE clause.
*/



     
--  Identical solution using a Common Table Expression (cte):
    WITH cte(geo_stusab, num_associates) AS
    (
        SELECT geo_stusab, SUM(ACS18_5yr_B15003021)
        FROM b15003
        GROUP BY geo_stusab
    )
    SELECT geo_stusab, num_associates
    FROM cte
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM cte
    );
    
    
    
    
--  Finally, the same problem solved with a temporary view (tv):
    CREATE TEMPORARY VIEW tv AS
        SELECT geo_stusab, SUM(ACS18_5yr_B15003021) AS num_associates
        FROM b15003
        GROUP BY geo_stusab;
    -- ------------------------------ two statements!
    SELECT geo_stusab, num_associates
    FROM tv
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM tv
    );
    