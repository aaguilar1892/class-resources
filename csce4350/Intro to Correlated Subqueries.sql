/*
    List all customer IDs, names, and number of orders.  (Zero is a valid number of orders)

    There is an obscure subquery that is useful... sometimes.  The subquery is in the WHERE
    clause.  It must return only one value (single row, single column), thus there is a bit
    of type coercion going on
*/


    SELECT  fld_c_id_pk, fld_c_name,
            --
            (   SELECT COUNT(*)
                FROM tbl_orders
                WHERE tbl_orders.fld_c_id_fk = tbl_customers.fld_c_id_pk
                -- Notice that the WHERE clause refers to tbl_customers, which is
                -- *not* in the subquery, but in the enclosing scope!
            ) AS cnt_orders
            --
    FROM tbl_customers
    ORDER BY fld_c_name, fld_c_id_pk; -- for consistency
    
    
/*
 fld_c_id_pk | fld_c_name | cnt_orders
-------------+------------+------------
 c004        | ACME       |          1
 c006        | ACME       |          3
 c005        | Ace        |          0
 c003        | Allied     |          2
 c002        | Basics     |          2
 c001        | Tiptop     |          8
(6 rows)
*/


    /*
        This query is interesting because the subquery appears in te SELECT
        clause and, notice that the subquery references the outer table.
        (I chose to qualify the field names; however, since they had unique
        names, this was optional.
        
        From the subquery (inner block), I can access fields in the outer query.
        From the outer query, I am *NOT* able to access the inner query!!!
        This consistent with the scoping rules of most languages such as C.
               
        This type of a subquery is useful for some tasks; however,
        I have never seen an application that could not be
        accomplished with a table join.  It is most interesting as a demonstration
        of scope in an SQL query.
    */
    
    
    
    
-- ---------------------------------------------
/*
    For this discussion, we will step over to the "edu" database and consider
    the b15003 table.
*/
          -- State      State population
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
    a group, which records are above (or below) that group's average?  Actually, 
    "average" is common; however, the question as easily applies to any calculated
    property (e.g., a standard deviation).
    
    Our example problem will be: For each state, list the counties (or tracts) where the
    tract's population is above the average tract population *for that state*.
    
    I usually begin this discussion by picking a state with few counties... New Hampshire,
    for example, would make a good example because it only has 10 counties.  Let's look
    at them:
*/

    --      county      population
    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM B15003
    WHERE Geo_STUSAB = 'nh'
    --
    ORDER BY ACS18_5yr_B15003001;
    
/*
             geo_qname              | acs18_5yr_b15003001 
------------------------------------+---------------------
 Coos County, New Hampshire         |               24442
 Sullivan County, New Hampshire     |               31807
 Carroll County, New Hampshire      |               37013
 Belknap County, New Hampshire      |               44796
 Cheshire County, New Hampshire     |               53033
 Grafton County, New Hampshire      |               62875
 Strafford County, New Hampshire    |               83241
 Merrimack County, New Hampshire    |              105915
 Rockingham County, New Hampshire   |              220700
 Hillsborough County, New Hampshire |              288293
(10 rows)

    The next part is: what is the average population for
    tracts in New Hampshire?
    
*/
    SELECT ROUND(AVG(acs18_5yr_b15003001)) AS nh_avg
    FROM B15003
    WHERE Geo_STUSAB = 'nh';
/*
 nh_avg 
--------
  95212
(1 row)

    Thus, taking that average, I can glance quickly at the table
    of county populations and see that I expect Merrimack County, 
    Rockingham County, and Hillsborough County to be returned for
    New Hampshire.
    
*/

    SELECT Geo_QNAME, ACS18_5yr_B15003001 AS pop
    FROM B15003 AS outside
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM B15003 AS inside
        WHERE inside.Geo_STUSAB = outside.Geo_STUSAB
    )
        --
        AND Geo_STUSAB = 'nh';
        
/*
    I have tacked on the "AND Geo_STUSAB = 'nh';" just to
    show that it works for one state where I know what to expect.
    
    If I remove that, it will run for all states.  I will add an 
    ORDER BY on the state and the population.
    
*/

    SELECT Geo_QNAME, ACS18_5yr_B15003001 AS pop
    FROM B15003 AS outside
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM B15003 AS inside
        WHERE inside.Geo_STUSAB = outside.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, ACS18_5yr_B15003001;

/*
    This next isn't a big deal one way or the other, but I do
    not have to rename the inside table, only the outside
    table.  Neither do I have to qualify the reference to
    Geo_STUSAB in the subquery because the table is local
    and there is no ambiguity.
*/

    SELECT Geo_QNAME, ACS18_5yr_B15003001 AS pop
    FROM B15003 AS outside
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM B15003
        WHERE Geo_STUSAB = outside.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, ACS18_5yr_B15003001
    --
    LIMIT 50; -- because I'm tired of looking at pages of data!

    
    
    
    
    
-- Testing a concept:
    SELECT Geo_QNAME, ACS18_5yr_B15003001 AS pop,
           (
                SELECT ROUND(AVG(ACS18_5yr_B15003001))
                FROM B15003
                WHERE Geo_STUSAB = outside.Geo_STUSAB
           ) AS st_avg
    FROM B15003 AS outside
    WHERE ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001)
        FROM B15003
        WHERE Geo_STUSAB = outside.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, ACS18_5yr_B15003001
    --
    LIMIT 50;
/*
    I was curious if it would work to put the state average on
    the SELECT line... it did.  It's a good example, but well beyond
    what I want to do with that one.
*/





/*

    If you didn't quite follow the last one, here is an easier example of a 
    correlated subquery: Find the county with the maximum population 
    in each state:

*/

    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003 AS outside
    WHERE ACS18_5yr_B15003001 IN
    (
        SELECT MAX(ACS18_5yr_B15003001)
        FROM b15003 AS inside
        WHERE inside.Geo_STUSAB = outside.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB;
    
    -- As before, it isn't necessary to qualify references to the
    -- inner table.  It would be out of scope anyplace else.
    
    SELECT Geo_QNAME, ACS18_5yr_B15003001
    FROM b15003 AS outside
    WHERE ACS18_5yr_B15003001 IN
    (
        SELECT MAX(ACS18_5yr_B15003001)
        FROM b15003
        WHERE Geo_STUSAB = outside.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB;
    
    
    
    -- If all I want is the state and the maximum population,
    -- that's easy:
    SELECT Geo_STUSAB, MAX(ACS18_5yr_B15003001) as my_max
    FROM b15003
    GROUP BY Geo_STUSAB
    ORDER BY Geo_STUSAB;
    
    -- Adding the tract name requires the correlated subquery
    









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
 McCurtain County    | 0.00864237   <-- closest to average
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
        AND Geo_STUSAB = 'ok' -- for testing only... remove for complete data set.
    ORDER BY Geo_STUSAB, ratio DESC;
/*
         geo_qname          |   ratio    
----------------------------+------------
 Hughes County, Oklahoma    | 0.00949094
 Latimer County, Oklahoma   | 0.00943795
 Stephens County, Oklahoma  | 0.00940470
 Major County, Oklahoma     | 0.00914460
 Greer County, Oklahoma     | 0.00914420
 Delaware County, Oklahoma  | 0.00909960
 McCurtain County, Oklahoma | 0.00864237
 Creek County, Oklahoma     | 0.00826686
 Ottawa County, Oklahoma    | 0.00825323
 Sequoyah County, Oklahoma  | 0.00807194
 Nowata County, Oklahoma    | 0.00793651
(11 rows)
   



   
   
Wasn't that fun?

    The number of associate's degrees for a tract is
    found in the field: ACS18_5yr_B15003021.

    For each state (Geo_STUSAB), list the counties where the number of
    associate's degrees (B15003021) is greater than the average number of
    ASD *for that state*.  Show Geo_QName and the number of ASD for that county.
    Order by state, then county (Geo_NAME).
    
    Since I like New Hampshire, let's use that as the example again:
    
    Let's see the data:
*/
    SELECT Geo_QName, ACS18_5yr_B15003021 AS asd
    FROM B15003
    WHERE Geo_STUSAB = 'nh'
    ORDER BY asd;
/*
    ... and what is New Hampshire's average?
*/
    SELECT ROUND(AVG(ACS18_5yr_B15003021)) AS my_avg
    FROM B15003
    WHERE Geo_STUSAB = 'nh';
/*
             geo_qname              |  asd  
------------------------------------+-------
 Coos County, New Hampshire         |  2649
 Sullivan County, New Hampshire     |  3019
 Carroll County, New Hampshire      |  3847
 Belknap County, New Hampshire      |  4590
 Grafton County, New Hampshire      |  5228
 Cheshire County, New Hampshire     |  5416
 Strafford County, New Hampshire    |  8363
                                            <-- avg: 9639
 Merrimack County, New Hampshire    | 12271
 Rockingham County, New Hampshire   | 22721
 Hillsborough County, New Hampshire | 28283
(10 rows)

Thus, we expect three rows for this state.

*/

SELECT Geo_QName , ACS18_5yr_B15003021
FROM b15003 AS tbl_outside
WHERE ACS18_5yr_B15003021 > ALL
(
    SELECT AVG(ACS18_5yr_B15003021)
    FROM b15003 AS tbl_inside
    WHERE tbl_inside.Geo_STUSAB = tbl_outside.Geo_STUSAB
)
--
--    AND Geo_STUSAB = 'nh'  -- for testing; remove for production
--
ORDER BY Geo_STUSAB, Geo_Name;  

-- I get 764 rows.  You do not have to qualify the inside table.


/*
    Another common example: Same as previous example, but list the counties where the ratio of
    associate's degrees (ASD) to the county's population is greater than the average ratio of the 
    state's ASD *for that state*.  Remember, the population is in B15003001.
    
    Pick on poor New Hampshire again:
    
    List all counties:
*/

    SELECT Geo_QName, ACS18_5yr_B15003021::NUMERIC/ACS18_5yr_B15003001 AS ratios
    FROM B15003
    WHERE Geo_STUSAB = 'nh'
    ORDER BY ratios; 
    
    -- and the average, as usual:
    
    SELECT ROUND(AVG(ACS18_5yr_B15003021::NUMERIC/ACS18_5yr_B15003001), 8) AS avg_rat
    FROM B15003
    WHERE Geo_STUSAB = 'nh';
/*
             geo_qname              |         ratios         
------------------------------------+------------------------
 Grafton County, New Hampshire      | 0.08314910536779324056
 Sullivan County, New Hampshire     | 0.09491621341214198132
 Hillsborough County, New Hampshire | 0.09810505284554255566
 Strafford County, New Hampshire    | 0.10046731778810922502
                                                            <-- avg:  0.10123495
 Cheshire County, New Hampshire     | 0.10212509192389644184
 Belknap County, New Hampshire      | 0.10246450575944280739
 Rockingham County, New Hampshire   | 0.10294970548255550521
 Carroll County, New Hampshire      | 0.10393645475913868100
 Coos County, New Hampshire         | 0.10837901972015383357
 Merrimack County, New Hampshire    | 0.11585705518576216778
(10 rows)
    I should see six rows for N.H.:
*/
    
    SELECT Geo_QName, ACS18_5yr_B15003021::NUMERIC/ACS18_5yr_B15003001 AS ratios
    FROM b15003 AS tbl_outside
    WHERE ACS18_5yr_B15003021::NUMERIC/ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003021::NUMERIC/ACS18_5yr_B15003001)
        FROM b15003 AS tbl_inside
        WHERE tbl_inside.Geo_STUSAB = tbl_outside.Geo_STUSAB
    )
    --
    --    AND Geo_STUSAB = 'nh' -- remove before flight
    --
    ORDER BY Geo_STUSAB, Geo_QName;
    
    -- 1603 rows in full data set
    
    
    
    