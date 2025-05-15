/*
    A simple example to use in the assignment:

    Which state in the b15003 table (edu database) has the greatest population?

    Here is the solution from homework six using a derived table approach:
*/

    SELECT Geo_STUSAB, population
    FROM
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS population
        FROM b15003
        GROUP BY Geo_STUSAB
    ) AS dt
    WHERE population IN
    (
        SELECT MAX(population)
        FROM
        (
            SELECT SUM(ACS18_5yr_B15003001) AS population
            FROM b15003
            GROUP BY Geo_STUSAB
        ) AS dt
    );
    
    -- any derived table (dt) may be converted to a 
    -- common table expression (cte)
    
    WITH cte(Geo_STUSAB, population) AS
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001)
        FROM b15003
        GROUP BY Geo_STUSAB
    )
    SELECT Geo_STUSAB, population
    FROM cte
    WHERE population IN
    (
        SELECT MAX(population)
        FROM cte
    );
    
    
    
    
/*
    geo_stusab | population
    ------------+------------
    ca         |   26218885

    Using Common Table Expressions (cte) does not usually lend itself to an
    approach using the HAVING clause because that would go inside the logic
    of the cte thereby complicating it.  Your instructor uses derived tables
    to teach the concept; however, prefers cte as a simple way to implement
    that idea.  (Any derived table may be written as a common table expression.)

    You already have these as derived tables... convert your solutions to
    common table expressions.  (Please do not copy the derived table solution
    into your finished product... delete that part after you have converted.)

    This should be an easy assignment:
    
    
    1)  Which state (Geo_STUSAB) has the least number of people with a Professional
    School Degree (ACS18_5yr_B15003024)?

    I get:
     geo_stusab | tsp  (Tech school pop)
    ------------+------
     wy         | 5489
(1 row)
*/






/*
    #2  What is the average population of all states.  (Hint: SELECT the AVG from one derived
    table that sums the county populations and groups by state.)  Do not ROUND... it might
    introduce an error in #3.

 avgstatepop
----------------------
 4246355.173076923077
(1 row)

*/






/*
    #3  Which states have a population above the national average population?
    Show state and population of each.  Remember, the state is in Geo_STUSAB and SUM(ACS18_5yr_B15003001) GROUPED BY state gives their respective populations.
    (It needs a derived table subquery. Hint: Use the query you wrote for #2 as the
    derived table.)

    Use "> ALL" when asking is a numeric value is greater than the content of a table.

    (I used ORDER BY, but I didn't say you had to.)

 geo_stusab |   pop
------------+----------
 in         |  4399815
 tn         |  4530706
 az         |  4633932
 ma         |  4748795
 wa         |  5001943
 va         |  5730352
 nj         |  6129542
 mi         |  6772215
 ga         |  6786547
 nc         |  6881774
 oh         |  7937085
 il         |  8682343
 pa         |  8921363
 ny         | 13606342
 fl         | 14686727
 tx         | 17815359
 ca         | 26218885
(17 rows)

*/







/*
    #4  Which state (or states) have the most counties?  Show Geo_STUSAB and the count... allow for ties;
    Do *NOT* use LIMIT!

        SELECT COUNT(*) AS cnt
        FROM b15003
        GROUP BY Geo_STUSAB;

    Will give you all of the counts by state.

    Hint: The answer is Texas with 254.
*/
