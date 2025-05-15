/*
    Develop a query that will return the state(s) with the greatest number of *Ged Or Alternative Credential*; include ties.
    
    Consulting: https://www.socialexplorer.com/data/ACS2018_5yr/metadata/?ds=ACS18_5yr&table=B15003,
    find the data we want are in the field: B15003018 (or ACS18_5yr_B15003018).
    
    Thus, our sub-query will be:
    
    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003018) AS ged_by_state
    FROM b15003
    GROUP BY geo_stusab;
    
    Test it!
    
    Derived Table (dt) solution:   */
    
    SELECT Geo_STUSAB, ged_by_state
    FROM
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003018) AS ged_by_state
        FROM b15003
        GROUP BY geo_stusab
    ) AS dt
    WHERE ged_by_state IN
    (
        SELECT MAX(ged_by_state)
        FROM
        (
            SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003018) AS ged_by_state
            FROM b15003
            GROUP BY geo_stusab
        ) AS dt
    );
    
    
    
    
--  Solution using Common Table Expression (cte):

    WITH cte(Geo_STUSAB, ged_by_state) AS
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003018) -- alias optional
        FROM b15003
        GROUP BY geo_stusab
    )
    SELECT Geo_STUSAB, ged_by_state
    FROM cte
    WHERE ged_by_state IN
    (
        SELECT MAX(ged_by_state)
        FROM cte
    );
    
    
    
    
--  Solution using Temporary View (tv):

    -- The solution barfs if the view exists.  Since it's temporary, this usually
    -- isn't an issue, but it persists until the session ends.  Many platforms
    -- (but not all) allow "CREATE OR REPLACE"; however, they're inconsistent
    -- as to how it works.  If you aren't sure, "DROP VIEW IF EXISTS ..." first.


    CREATE OR REPLACE TEMPORARY VIEW tv AS
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003018) AS ged_by_state
        FROM b15003
        GROUP BY geo_stusab
    ); -- parenthese optional
    --
    SELECT geo_stusab, ged_by_state
    FROM tv
    WHERE ged_by_state IN
    (
        SELECT MAX(ged_by_state)
        FROM tv
    );