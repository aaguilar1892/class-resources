    -- Let's go back to edu
    \c edu
    
/*
    Reconsider:  Which state has the greatest ratio of people with no school?
                 (Include ties.)
*/ 
   
    SELECT Geo_STUSAB, ratioNoSchool
    FROM( 
    
            -- begin derived table
            SELECT Geo_STUSAB, 
                   SUM(ACS18_5yr_B15003002::NUMERIC)/SUM(ACS18_5yr_B15003001) 
                        AS ratioNoSchool
            FROM b15003
            GROUP BY Geo_STUSAB
            -- end derived table
            
        ) AS derived_table
    WHERE ratioNoSchool IN
    (
        SELECT MAX(ratioNoSchool)
        FROM(   
        
                -- begin derived table
                SELECT Geo_STUSAB, 
                       SUM(ACS18_5yr_B15003002::NUMERIC)/SUM(ACS18_5yr_B15003001) 
                            AS ratioNoSchool
                FROM b15003
                GROUP BY Geo_STUSAB
                -- end derived table
                
            ) AS derived_table
    );



-- let's look at it from a different perspective:

    DROP VIEW IF EXISTS view_derived_table;
    
    CREATE TEMPORARY VIEW view_derived_table AS -- "TEMPORARY" is optional
        -- begin view
        SELECT Geo_STUSAB, 
               SUM(ACS18_5yr_B15003002::NUMERIC)/SUM(ACS18_5yr_B15003001) 
                    AS ratioNoSchool
        FROM b15003
        GROUP BY Geo_STUSAB;
        -- end view
        
    -- Notice, please, that the SQL that creates the view is *exactly*
    -- the same as the SQL in the derived table.  (Creating a "TEMPORARY"
    -- object means the object only exists until the session ends.)

            
    -- Thus, using the view, our previous problem becomes:
    SELECT Geo_STUSAB, ratioNoSchool
    FROM view_derived_table
    WHERE ratioNoSchool IN 
    ( 
        SELECT MAX(ratioNoSchool) 
        FROM view_derived_table
    );