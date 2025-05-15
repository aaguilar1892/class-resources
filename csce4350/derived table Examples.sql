
/*
    When I introduce derived tables, I usually look across the class and see
  a lot of "deer in the headlights" looks. I'll try this approach:

  Example: Find the state with the max number of associate degrees.

  Let's create a table for the demo:

*/

    DROP TABLE IF EXISTS derived_table_demo;
    
    CREATE TABLE derived_table_demo AS  
    (
        SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
        FROM b15003
        GROUP BY geo_stusab
    );
/*
    Here I'm creating a table from an SQL query.  This is known as "materializing the query".  I could add a PRIMARY KEY constraint by:
    
    ALTER TABLE derived_table_demo ADD
        CONSTRAINT dtd_pk PRIMARY KEY(my_state);
        
    ... but we really don't need it.
    
    Let's take a look at the data:
*/

    SELECT * FROM derived_table_demo;
    
/*
 
 my_state | num_associates 
----------+----------------
 wy       |          42835
 ga       |         518144
 wi       |         422227
 pa       |         741590
 or       |         249852
 ks       |         161016
 nd       |          67212
 me       |          96570
 nh       |          96387
 hi       |         105186
 ia       |         238423
 mo       |         323751
 sc       |         324446
 nc       |         652658
 ok       |         198903
 al       |         273493
 ma       |         365103
 dc       |          14637
 ri       |          61136
 fl       |        1438630
 sd       |          65075
 ct       |         190869
 ut       |         173766
 vt       |          37513
 co       |         314214
 ak       |          40052
 la       |         186448
 mt       |          64097
 ne       |         130043
 az       |         398147
 pr       |         235051
 il       |         692622
 de       |          51522
 va       |         436970
 tx       |        1261050
 md       |         273518
 mn       |         424424
 id       |         104333
 mi       |         636753
 tn       |         323928
 oh       |         681630
 ms       |         184334
 nj       |         401069
 ky       |         244802
 wa       |         501449
 ar       |         139070
 ca       |        2051313
 wv       |          91975
 nm       |         114664
 nv       |         163699
 in       |         382510
 ny       |        1184265
(52 rows)
 

        Now, given that we have such a table, how would we find the state with the MAX of num_associates?

        Well, you know how to do that!  It's a simple "find the min/max"
        subquery.  You know, find person with the highest grade:

            SELECT name, grade
            FROM class_data
            WHERE grade IN
            (
                SELECT MAX(grade)
                FROM class_data
            );

        This query returns ties; remember this one!!!

        We've been there, done that.  We'll just do the same thing
        for this question:
*/


    SELECT my_state, num_associates
    FROM derived_table_demo
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM derived_table_demo
    );

/*
 my_state | num_associates 
----------+----------------
 ca       |        2051313
(1 row)

    Now, REMEMBER THE QUERY I USED TO CREATE THE TABLE!
*/
    SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
    FROM b15003
    GROUP BY geo_stusab;
/*

    So, I'm going to take this simple query:

    SELECT my_state, num_associates
    FROM derived_table_demo
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM derived_table_demo
    );
    
    
    I will add some unnecessary parenthese for demonstration:


    And where it has "derived_table_demo", I will replace it with the SQL that created the demo table:

    SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
    FROM b15003
    GROUP BY geo_stusab

    in parenthese and give the name "d"
*/

    SELECT my_state, num_associates
    FROM
    -- <paste>
    (
        SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
        FROM b15003
        GROUP BY geo_stusab
    ) AS d
    -- </paste>
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM
        -- <paste>
        (
            SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
            FROM b15003
            GROUP BY geo_stusab
        ) AS d
        -- </paste>
    );

/*
    Once you get the idea that an SQL SELECT query *is* a table (or, returns a
    table when it executes), you may replace any table with a query!

    This method is useful when the task is to maximize (or minimize) an aggregate
    function.
    
    
    
    Some points:
        This is called a "derived table" because it appears in the "FROM" clauseof the outer query.
        
        The derived table must be named; I tend to use "d" because it means "derived" to me; however, name it as you please.  notice that I have two of them.  These may or may not be named the same.  What you name them (as long as it's a legal identifier) is irrelevant
*/

    SELECT my_state, num_associates
    FROM
    -- <paste>
    (
        SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
        FROM b15003
        GROUP BY geo_stusab
    ) AS figmoe
    -- </paste>
    WHERE num_associates IN
    (
        SELECT MAX(num_associates)
        FROM
        -- <paste>
        (
            SELECT geo_stusab AS my_state, SUM(ACS18_5yr_B15003021) AS num_associates
            FROM b15003
            GROUP BY geo_stusab
        ) AS foobar
        -- </paste>
    );
    
/*
    Each derived table stands alone and is independent of others.
    
    Let's try another one:
    
    Which state has the greatest average number of associate's degrees (table 021)?
    
    First, let's do it without the derived table:
*/

    SELECT geo_stusab, MAX( AVG(ACS18_5yr_B15003021) ) AS num_associates
    FROM b15003
    GROUP BY geo_stusab;

/*
    Didn't work well, did it?  ERROR:  aggregate function calls cannot be nested (applies to all platforms!)  (I think I'll just use geo_stusab without the alias... you may do likewise if you wish.  You must alias a calculated field, though.)
    
    How can we see the averages by state?
*/

    SELECT geo_stusab,  AVG(ACS18_5yr_B15003021) AS my_avg
    FROM b15003
    GROUP BY geo_stusab;
  
/*
    And *there*, ladies & gentlemen, is the derived table!
*/
    SELECT geo_stusab, my_avg
    FROM
    (
        SELECT geo_stusab,  AVG(ACS18_5yr_B15003021) AS my_avg
        FROM b15003
        GROUP BY geo_stusab
    ) AS d -- name it as you like, but it *must* have a name!
    WHERE my_avg IN
    (
        SELECT MAX(my_avg)
        FROM
        (
            SELECT geo_stusab,  AVG(ACS18_5yr_B15003021) AS my_avg
            FROM b15003
            GROUP BY geo_stusab
        ) AS d -- the name may or may not match the previous one.
    );
    
/*
    This brings up a little philosophical matter: suppose I had written 
    "WHERE my_avg =" instead of "WHERE my_avg IN" ???
    
    Like this:
*/

    SELECT geo_stusab, my_avg
    FROM
    (
        SELECT geo_stusab,  AVG(ACS18_5yr_B15003021) AS my_avg
        FROM b15003
        GROUP BY geo_stusab
    ) AS d
    WHERE my_avg =   -- here's the only difference, what will happen?
    (
        SELECT MAX(my_avg)
        FROM
        (
            SELECT geo_stusab,  AVG(ACS18_5yr_B15003021) AS my_avg
            FROM b15003
            GROUP BY geo_stusab
        ) AS d
    );
/*
    Oh my goodness!  It works!
    
    But, let's think: what is on the left side of that equality? (answer: my_avg)  And what is that? (answer, a single number)
    
    Good.  Now, what is on the right hand side? (answer: an SQL query)  And what is that? (answer: a table)
    
    We have a type mismatch here!  This will work; however, it forces a type coercion.  It's a bit like assigning 5.7 to a float in C++; it will work, but it is a poor programming practice.  ( A literal 5.7 is a double.)  If *I* were your professor in C++, you would have been required to cast:  my_float = (float)5.7;  Same idea with "IN" versus "=".
    
    
    Example: Which Texas (Geo_STUSAB = 'tx') counties (Geo_QName) have a population (ACS18_5yr_B15003001) greater than the average population of Texas counties?
    
    First: what is the average county population in Texas?
*/
    SELECT AVG(ACS18_5yr_B15003001) AS my_avg
    FROM b15003
    WHERE Geo_STUSAB = 'tx';
/*
       my_avg       
--------------------
 70139.208661417323
(1 row)

    OK, look at the populations.  I will order them descending to see it better, but the final SQL won't matter about order.
*/
    SELECT ACS18_5yr_B15003001
    FROM b15003
    WHERE Geo_STUSAB = 'tx'
    ORDER BY ACS18_5yr_B15003001 DESC;
/*
     acs18_5yr_b15003001 
---------------------
             2923369
             1648710
             1290366
             1224170
              819773
              616730
              526185
              508397
              473253
              472198
              360769
              346522
              245532
              234039
              230216
              218621
              206845
              177457
              169331
              150034
              149553
              146551
              121585
              115287
              108071
              106651
              102481
              101274
               93869
               93728
               87084
               86951
               86890
               84203
               83059
               79588
               76310
               76279
               75126
               
                        <-- 70139.208661417323 (average)
                        
               63489
               60942
               60582
               59826
               57243
               56575
               56063
               54428
               53387
               47257
               46214
               43759
               43243
               42736
               42009
               41014
               37792
               37568
               37475
               37151
               36574
               35345
               34334
               33820
               33676
               32962
               32606
               32427
               32115
               31947
               31679
               30916
               29364
               28749
               27604
               27588
               26922
               26634
               26495
               25753
               25722
               25562
               24970
               24295
               24146
               24144
               24052
               23947
               23659
               23187
               22241
               21139
               20893
               20134
               19884
               19779
               19305
               19255
               18973
               18136
               18026
               17263
               16824
               16692
               16678
               16562
               16546
               16320
               16099
               15785
               15121
               15109
               14715
               14552
               14475
               14416
               14354
               14336
               14141
               13854
               13732
               13600
               13546
               13288
               12989
               12553
               12516
               12441
               12396
               12088
               12035
               12025
               11572
               11401
               11238
               11142
               11100
               10680
               10610
               10580
               10480
               10073
                9840
                9708
                9689
                9637
                9613
                9440
                8922
                8804
                8787
                8673
                8473
                8463
                8351
                8345
                8277
                8059
                8029
                7994
                7573
                7494
                7260
                7254
                7234
                7149
                6968
                6732
                6534
                6422
                6181
                6174
                6141
                6124
                6073
                6048
                5972
                5925
                5769
                5715
                5257
                5059
                5059
                5010
                4958
                4900
                4717
                4602
                4597
                4547
                4407
                4379
                4335
                4239
                4143
                4118
                4032
                3823
                3805
                3753
                3712
                3565
                3411
                3377
                3290
                3240
                3148
                2990
                2976
                2886
                2747
                2740
                2722
                2718
                2659
                2529
                2467
                2440
                2440
                2399
                2377
                2311
                2283
                2275
                2257
                2245
                2092
                2084
                2003
                2001
                1868
                1716
                1706
                1603
                1581
                1495
                1413
                1150
                1126
                1096
                1047
                1033
                1007
                 989
                 876
                 791
                 782
                 717
                 567
                 556
                 464
                 463
                 413
                 159
                  75
(254 rows)


Bunch of 'em, huh?

Put them together:
*/
    SELECT ACS18_5yr_B15003001
    FROM b15003
    WHERE Geo_STUSAB = 'tx' AND ACS18_5yr_B15003001 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003001) AS my_avg
        FROM b15003
        WHERE Geo_STUSAB = 'tx'
    )
    ORDER BY ACS18_5yr_B15003001 DESC; -- Order for demo only; not used by the logic
/*
    In the outside query, I could have dropped the "ALL" and written:
    
    "WHERE Geo_STUSAB = 'tx' AND ACS18_5yr_B15003001 >"
    
    and it would have worked; however, it would have been a type coercion.
    
    Note also that this example is not a derived table subquery because the subquery is in the WHERE clause, not the FROM clause.






-- Another example:

/*
    Find the state or states (Geo_STUSAB) with the maximum ratio of people with no school SUM(ACS18_5yr_B15003002) to the state's population SUM(ACS18_5yr_B15003001)
    
    First, let's find the ratios.  We will divide the SUM of 002 by the sum of 001.  If we divided first, then summed, we'd arrive at a slightly different answer.  Another issue is that the fields are type INTEGER and integer division truncates just as it does in C++, thus we CAST to NUMERIC.
*/
    SELECT Geo_STUSAB,
            SUM(CAST(ACS18_5yr_B15003002 AS NUMERIC))/SUM(ACS18_5yr_B15003001) AS
                ratioNoSchool
    FROM b15003
    GROUP BY Geo_STUSAB;
/*
    This is the derived table, run that and take a look at the data.  This is what we will maximize.
    
    For demonstration, I will materialize the table and name it d.
*/
    DROP TABLE IF EXISTS d;
    
    CREATE TABLE d AS
    (
        SELECT Geo_STUSAB,
            SUM(CAST(ACS18_5yr_B15003002 AS NUMERIC))/SUM(ACS18_5yr_B15003001) AS
                ratioNoSchool
        FROM b15003
        GROUP BY Geo_STUSAB
    );
/*
    Take a look at it:
*/
    SELECT * FROM d ORDER BY ratioNoSchool DESC; -- we expect to see California
/*
    Find the state or states with MAX(ratioNoSchool)... easy!
*/
    SELECT Geo_STUSAB, ratioNoSchool
    FROM d
    WHERE ratioNoSchool IN
    (
        SELECT MAX(ratioNoSchool)
        FROM d
    );
/*
    Now, replace d with the SQL query that created it.  Since I will use that name, I'll drop the materialized table... not sure what might happen if I didn't... I think it would work fine.
*/
    DROP TABLE IF EXISTS d;
    
    SELECT Geo_STUSAB, ratioNoSchool
    FROM 
    (
        SELECT Geo_STUSAB,
                SUM(CAST(ACS18_5yr_B15003002 AS NUMERIC))/SUM(ACS18_5yr_B15003001) 
                    AS ratioNoSchool
        FROM b15003
        GROUP BY Geo_STUSAB
    ) AS d
    WHERE ratioNoSchool IN
    (
        SELECT MAX(ratioNoSchool)
        FROM
        ( 
            SELECT Geo_STUSAB,
            SUM(CAST(ACS18_5yr_B15003002 AS NUMERIC))/SUM(ACS18_5yr_B15003001) 
                AS ratioNoSchool
            FROM b15003
            GROUP BY Geo_STUSAB
        ) AS d
    );
/*
    And, just FYI, the short version of: "CAST(fld_name AS INTEGER)" is simply "fld_name::INT"
    You may use the short version.
*/




/*
    WHEN DO WE USE THIS APPROACH?
    
    Q: When we're asked to maximize (or minimize) an aggregate function.
        (There are others, but that's classic.)
        
    Example: What state has the greatest AVERAGE number of Ged Or Alternative Credential
    (ACS18_5yr_B15003018)
    
    Here, I identify that I'm being asked to maximize an average.
    
    Step 1: Isolate the data you're being asked to maximize:
*/   
        SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003018) AS avg_ged
        FROM B15003
        GROUP BY Geo_STUSAB;
/*
    Think of that *as if* you had created the table:
    
    CREATE TABLE derived_table AS
        SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003018) AS avg_ged
        FROM B15003
        GROUP BY Geo_STUSAB;
     
    but you don't need to do it.  (DROP it when you're done.)
    
    You might run the query with
    
        ORDER BY avg_ged DESC  
    
    in it, so you know the answer.
    
    Visualize the simple MAX query:
*/
    SELECT Geo_STUSAB, avg_ged
    FROM derived_table
    WHERE avg_ged IN
    (
        SELECT MAX(avg_ged)
        FROM derived_table
    );
    
    -- Now, replace "derived table" with the query for "derived_table"
    -- Put it in parenthese and name it.  (*I* always use "d").
    
    SELECT Geo_STUSAB, avg_ged
    FROM 
    (
        SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003018) AS avg_ged
        FROM B15003
        GROUP BY Geo_STUSAB
    ) AS d
    WHERE avg_ged IN
    (
        SELECT MAX(avg_ged)
        FROM 
        (
            SELECT Geo_STUSAB, AVG(ACS18_5yr_B15003018) AS avg_ged
            FROM B15003
            GROUP BY Geo_STUSAB
        ) AS d
    );