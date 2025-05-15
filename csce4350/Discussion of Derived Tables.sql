/*
    Identify a problem requiring a "Derived Table" approach:

    You are in a derived table world when the problem requires a nested aggregate function.

    e.g.:   The MAX of SUMs
            The AVG of SUM
            The Sum of COUNTs
            The COUNT of SUM

    Example:
        The field ACS18_5yr_B15003001 in table B15003 contains county populations within a state.

        What state has the greatest population?

        SELECT MAX( SUM(ACS18_5yr_B15003001) )   ... no can do!

        Many database questions boil down to these:

        Look at the inner aggregate, in this case SUM(ACS18_5yr_B15003001)



        You have several options:

        Option One: use a tempory table:

        A temporary table goes away when the session ends.  The downside is
        that it uses disk space and might need more than you have!  Also, you
        cannot have a foreign key into a temp table.

        It is a good idea to DROP before you CREATE... as usual.
*/

    DROP TABLE IF EXISTS tmp_state_pops;

    CREATE TEMPORARY TABLE tmp_state_pops AS
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
        FROM B15003
        GROUP BY Geo_STUSAB
    );

/*
    The parenthese are optional, *I* use them, but they're your call.

    CREATE TEMP TABLE ... also works.

    CREATE TEMP TABLE tmp_state_pops AS
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
        FROM B15003
        GROUP BY Geo_STUSAB;

    Now, you simply find the maximum value of my_sum in the temp table with a subquery:
*/

    SELECT Geo_STUSAB, my_sum
    FROM tmp_state_pops
    WHERE my_sum IN
    (
        SELECT MAX(my_sum)
        FROM tmp_state_pops
    );

    -- I will drop the temp table just to clean up.
    DROP TABLE IF EXISTS tmp_state_pops;

/*
    Option Two: Create a View:

    A view is like a temporary table in practice; however, it does *not* use
    any disk space, and it persists.  A view saves the SQL that created it and,
    any time you select from the view, it runs the SQL.

    Again, it is a good idea to DROP before you CREATE... as usual.
*/

    DROP VIEW IF EXISTS view_state_pops;

    CREATE VIEW view_state_pops AS
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
        FROM B15003
        GROUP BY Geo_STUSAB
    );

/*
    This approach has the advantage that it does not use disk space,
    however, it runs more slowly than a temp table for obvious reasons.
    Another downside is that it creates a dependency on the base table
    (in this case B15003).  For this reason, you usualy cannot create a
    view on tables you do not own even if you have SELECT privileges.

    Some platforms require the parenthese and some don't.  I think PostgreSQL
    does not.

    Other than that, the outer query is the same:
*/

    SELECT Geo_STUSAB, my_sum
    FROM view_state_pops
    WHERE my_sum IN
    (
        SELECT MAX(my_sum)
        FROM view_state_pops
    );



    -- I will drop the view just to clean up.
    DROP VIEW IF EXISTS view_state_pops;


/*
    Option Three: Use a Derived Table subquery:

    In this approach, we copy the SQL we used to create the tmp table or
    the view into the FROM clause of the query.  The SQL replaces the name
    "tmp_state_pops" or "view_state_pops" and becomes a table in the query,
    hence, its name:
*/

    SELECT Geo_STUSAB, my_sum
    FROM
        --
        (
            SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
            FROM B15003
            GROUP BY Geo_STUSAB
        ) AS dt_state_pops
        --
    WHERE my_sum IN
    (
        SELECT MAX(my_sum)
        FROM
            --
            (
                SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS my_sum
                FROM B15003
                GROUP BY Geo_STUSAB
            ) AS dt_state_pops
            --
    );

/*
    The derived table approach is by far the best of both worlds in that it does not
    use disk space, and it does not create dependencies.  When you look carefully, you
    should see that all three use *exactly* the same logic.

    In the derived table (D.T.) example, the names for the two DTs do *not* have to match,
    but both must have names!  (I always make mine match.)
*/


/*
    Another example: Find all states where the number of counties (or "tracts") is
    above the average number for all states.

    SELECT Geo_STUSAB, COUNT(Geo_NAME) AS num_tracts
    FROM B15003
    WHERE COUNT(Geo_NAME) > ALL
    (
        SELECT AVG( COUNT(Geo_NAME) )
        FROM B15003
    );

    We have a nested aggregate in the subquery!
*/


    --  Option One: the temp table:

    DROP TABLE IF EXISTS tmp_tract_cnts;

    CREATE TEMP TABLE tmp_tract_cnts AS
    (
        SELECT Geo_STUSAB, COUNT(Geo_NAME) AS num_tracts
        FROM B15003
        GROUP BY Geo_STUSAB
    );


    SELECT Geo_STUSAB, num_tracts
    FROM tmp_tract_cnts
    WHERE num_tracts > ALL
    (
        SELECT AVG(num_tracts)
        FROM tmp_tract_cnts
    )
    ORDER BY num_tracts DESC; -- Add the ORDER BY for consistency

    DROP TABLE IF EXISTS tmp_tract_cnts;






    -- Option Two: create a view:

    DROP VIEW IF EXISTS view_num_tracts;

    CREATE VIEW view_tract_cnts AS
    (
        SELECT Geo_STUSAB, COUNT(Geo_NAME) AS num_tracts
        FROM B15003
        GROUP BY Geo_STUSAB
    );

    SELECT Geo_STUSAB, num_tracts
    FROM view_tract_cnts
    WHERE num_tracts > ALL
    (
        SELECT AVG(num_tracts)
        FROM view_tract_cnts
    )
    ORDER BY num_tracts DESC; -- Add the ORDER BY for consistency

    DROP VIEW IF EXISTS view_num_tracts;




    -- Option Three: the Derived Table

    SELECT Geo_STUSAB, num_tracts
    FROM
        --
        (
            SELECT Geo_STUSAB, COUNT(Geo_NAME) AS num_tracts
            FROM B15003
            GROUP BY Geo_STUSAB
        )
        --
    WHERE num_tracts > ALL
    (
        SELECT AVG(num_tracts)
        FROM
        --
        (

        )
        --
    )
    ORDER BY num_tracts DESC; -- Add the ORDER BY for consistency