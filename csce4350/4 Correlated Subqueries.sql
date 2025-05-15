/*
    Note: we're in the edu schema.
    
    
    What Texas county (or "counties" in the event of a tie) has the
    least population?
    
    We already know this one:
*/

    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003
    WHERE ACS18_5yr_B15003001 =
    (
        SELECT MIN(ACS18_5yr_B15003001)
        FROM b15003
        WHERE Geo_STUSAB='tx'
    )
    AND Geo_STUSAB='tx';
    
/*
    And, it worked.  But, *wait*...!  Aren't we supposed to say 
    "WHERE ACS18_5yr_B15003001 IN ..."  This example uses equality.
    
    Yes, it's true.  People misuse the idea of equality.  Consider:
    
    "ACS18_5yr_B15003001 = ( SELECT something FROM a_table)"
    
    What is on the left side (lhs)? (Answer: an integer)
    What is in the right side (rhs)? (Answer: a table [queries return tables])
    
    Now, the rhs contains one integer, bit it is *still* a type mismatch.
    
    For this reason, we use "IN" instead of "="; although most platforms
    will coerce the table into its content ("most" does not mean *all*!)
    
    It works the same way with '>' (and all relational operators). 
    
    

    Which What Texas counties have above average population?  (similar query:)  
*/
    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003
    WHERE ACS18_5yr_B15003001 >
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM b15003
        WHERE Geo_STUSAB='tx'
    )
    AND Geo_STUSAB='tx'
    ORDER BY ACS18_5yr_B15003001; -- optional
/*
    It works; however, it is a coercion. coercing a data type is *always*
    considered sloppy programming.  We will use: "> ALL" meaning that
    "the rhs > everything in the table", and the table contains INT.
    
    The query written correctly:
*/
    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM b15003
        WHERE Geo_STUSAB='tx'
    )
    AND Geo_STUSAB='tx';
/*
    There is another quantifier: "> ANY" which means "anything in the table";
    however, "ALL" is used far more frequently.  (If the table contains a
    single integer, either will work; we will use "ALL" as convention.)
    











/*
    For this discussion, we will step over to the "edu" database and consider
    the b15003 table.
*/
    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS mySum
    FROM b15003
    GROUP BY Geo_STUSAB; -- state abbreviation
    
/*
    It's a straight forward grouping of states and their county populations summed.
    The county names are in the field "Geo_NAME" and "Geo_QName" is the county *and*
    state together... either is usable.
    
    
    
    Here's the point:
    There is a family of queries that ask: "Within a state (or any grouping), 
    which counties are above the average **FOR THAT STATE**?"  I.e.: within
    a group, which records are above (or below) that group's average?  Actually, "average" is common; however, the question as easily applies to any calculated
    property (e.g., a standard deviation).
    
    
    
    
    
    This family of problems requires an approach called the "correlated subquery"
    
    For any state, what counties have a population above average for that state? 
    Let's look at New Hampshire because it only has 10 counties and that makes it 
    easy to use as an example:
    
    First, let's get the average county population for the state:
*/

    SELECT ROUND(AVG(ACS18_5yr_B15003001)) AS newHampshireAVG
    FROM b15003
    WHERE Geo_STUSAB = 'nh'; -- New Hampshire
    
--    newhampshireavg 
--    -----------------
--           95212

/*
    Now, let's get the county numbers.  (There won't be many.)
*/

    SELECT Geo_NAME, ACS18_5yr_B15003001
    FROM b15003
    WHERE Geo_STUSAB = 'nh'
    ORDER BY ACS18_5yr_B15003001 DESC;
/*
      geo_name       | acs18_5yr_b15003001 
---------------------+---------------------
 Hillsborough County |              288293
 Rockingham County   |              220700
 Merrimack County    |              105915
                                            <-- newHampshireAVG: 95212
 Strafford County    |               83241
 Grafton County      |               62875
 Cheshire County     |               53033
 Belknap County      |               44796
 Carroll County      |               37013
 Sullivan County     |               31807
 Coos County         |               24442





    So, for New Hampshire, we want only:
    
 Hillsborough County |              288293
 Rockingham County   |              220700
 Merrimack County    |              105915

Other states will be completely different!

*/
    
    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003 AS outside
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM b15003 AS inside
        WHERE outside.Geo_STUSAB = inside.Geo_STUSAB
        GROUP BY Geo_STUSAB
    )
    AND Geo_STUSAB = 'nh' -- for testing only.
    ORDER BY ACS18_5yr_B15003001 DESC;  -- optional
/*
    You should notice that the table, b15003, in the outer query
    has been renamed.  (Sometimes programmers will also rename the table
    in the inner query, but it's optional.)  Applying normal rules
    of scope, the outer table (renamed as "outSide") is accessible by
    the inner query.  Thus, the outer query runs and the inner query
    validates its data against the average for that state.  
    
    Something like:
    
    for(int i=0; i<10; i++)
    {
        for(int j=0; j<10; j++)
            cout<<i<<j<<' ';
            
        cout<<'\n';
    }
    // for each value of i, it prints 10 j values.
        
    The line: "AND Geo_STUSAB = 'nh'" restricts it to one state for testing.
    I will remove that for the full version.
    
*/   
    
    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003 AS outSide
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM b15003
        WHERE outSide.Geo_STUSAB = Geo_STUSAB
        GROUP BY Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, ACS18_5yr_B15003001 DESC;  -- optional but a good idea
    
    



-- ******************************************************************************    
    
-- If you didn't quite follow the last one, here is a simple example of a 
-- correlated subquery: Find the county with the maximum population 
-- in each state:

-- First of all, I *could* accomplish this one with a simple GROUP BY.  Most grouped
-- queries can be written as correlated subqueries.  As a GROUP BY query:

    SELECT Geo_QNAME, MAX(ACS18_5yr_B15003001) AS myMax
    FROM b15003
    GROUP BY Geo_QNAME
    ORDER BY Geo_QNAME
    LIMIT 5; -- I don't want a whole page of data; 5 is plenty to compare
    -- We *only* use LIMIT as a demonstration tool!!!
    
-- As a correlated subquery

    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003 AS outSide
    WHERE ACS18_5yr_B15003001 >= ALL
    (
        SELECT ACS18_5yr_B15003001
        FROM b15003 AS inSide
        WHERE inSide.Geo_QNAME = outSide.Geo_QNAME
    )
    ORDER BY Geo_QNAME
    LIMIT 5;    
    
    
    
    
    
    
    
    
    
    -- We'll come back to this one
-- **************************************************************************
    
/*
    Another example: list the counties within each state that are within 10% of the
    mean (average) ratio of no schooling to the total population.
    

    ACS18_5yr_B15003002     No schooling
    ACS18_5yr_B15003001     Total pop
    
    The Ratio = ACS18_5yr_B15003002/ACS18_5yr_B15003001

*/

-- We'll use Oklahoma as our test case.
-- First: what is the *average* ratio for Oklahoma?  (I'll use 8 decimal places.)

SELECT ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) AS avgRatio
FROM b15003
WHERE Geo_STUSAB = 'ok';
-- AVG = 0.00875440

-- Let's look at the upper and lower bounds:
SELECT  ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) +
        0.1*ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) AS upperBound,
        --
        ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) -
        0.1*ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) AS lowerBound
FROM b15003
WHERE Geo_STUSAB = 'ok';
/*    

 upperbound  | lowerbound  
-------------+-------------
 0.009629840 | 0.007878960

*/

-- Look at the county ratios for whole state of Oklahoma:
SELECT Geo_NAME, ROUND(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001,8) AS ratio
FROM b15003
WHERE Geo_STUSAB = 'ok'
ORDER BY ratio DESC;

/*

      geo_name       |   ratio    
---------------------+------------
 Tillman County      | 0.02633632
 Harper County       | 0.02277040
 Harmon County       | 0.02019679
 Jefferson County    | 0.01933962
 Blaine County       | 0.01660281
 Texas County        | 0.01483680
 Choctaw County      | 0.01454974
 Oklahoma County     | 0.01426302
 Garvin County       | 0.01418135
 Craig County        | 0.01327434
 Seminole County     | 0.01311157
 Cherokee County     | 0.01268241
 Garfield County     | 0.01246883
 Jackson County      | 0.01246452
 Kiowa County        | 0.01233974
 Custer County       | 0.01228761
 Okfuskee County     | 0.01222464
 Johnston County     | 0.01180099
 Tulsa County        | 0.01174012
 Marshall County     | 0.01130698
 Le Flore County     | 0.01083826
 Canadian County     | 0.01029135
 Murray County       | 0.01016387
 McIntosh County     | 0.00984743
                                    <-- 0.009629840  UpperBound
 Hughes County       | 0.00949094
 Latimer County      | 0.00943795
 Stephens County     | 0.00940470
 Major County        | 0.00914460
 Greer County        | 0.00914420
 Delaware County     | 0.00909960
 McCurtain County    | 0.00864237
 Creek County        | 0.00826686
 Ottawa County       | 0.00825323
 Sequoyah County     | 0.00807194
 Nowata County       | 0.00793651
                                    <-- 0.007878960 LowerBound
 Kingfisher County   | 0.00779477
 Carter County       | 0.00746803
 Beaver County       | 0.00744212
 Okmulgee County     | 0.00735864
 Rogers County       | 0.00731234
 Beckham County      | 0.00717014
 Muskogee County     | 0.00706098
 Grant County        | 0.00694674
 Washington County   | 0.00689578
 Pontotoc County     | 0.00685594
 McClain County      | 0.00678230
 Ellis County        | 0.00672091
 Washita County      | 0.00652912
 Cleveland County    | 0.00651384
 Roger Mills County  | 0.00648824
 Kay County          | 0.00643466
 Pawnee County       | 0.00640569
 Caddo County        | 0.00638057
 Wagoner County      | 0.00629649
 Pushmataha County   | 0.00599031
 Atoka County        | 0.00598617
 Bryan County        | 0.00592316
 Mayes County        | 0.00582294
 Cimarron County     | 0.00575816
 Comanche County     | 0.00564643
 Grady County        | 0.00553010
 Adair County        | 0.00550484
 Pottawatomie County | 0.00543696
 Love County         | 0.00530866
 Noble County        | 0.00528555
 Haskell County      | 0.00507907
 Osage County        | 0.00475700
 Payne County        | 0.00474096
 Lincoln County      | 0.00460071
 Logan County        | 0.00447153
 Pittsburg County    | 0.00445584
 Alfalfa County      | 0.00441655
 Woods County        | 0.00380162
 Woodward County     | 0.00340432
 Coal County         | 0.00264620
 Cotton County       | 0.00122911
 Dewey County        | 0.00062305
 */
    
    
    
    
    
    SELECT Geo_QNAME, ROUND(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001,8) AS ratio
    FROM b15003 AS outSide
    WHERE 
        -- Check the upper bound
        ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001 <= ALL
        (
            SELECT ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) +
            0.1*ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8)
            FROM b15003
            WHERE outSide.Geo_STUSAB = Geo_STUSAB
            GROUP BY Geo_STUSAB
        )
        AND
        -- check the lower Bound
        ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001 >= ALL
        (
            SELECT ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8) - 
            0.1*ROUND(AVG(ACS18_5yr_B15003002::NUMERIC/ACS18_5yr_B15003001),8)
            FROM b15003
            WHERE outSide.Geo_STUSAB = Geo_STUSAB
            GROUP BY Geo_STUSAB
        )
        AND Geo_STUSAB = 'ok' -- for testing only.
    ORDER BY Geo_STUSAB, ratio DESC;
    
    
    
    
    
    
    
    

        