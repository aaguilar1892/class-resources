/*
    A simple example to use in the assignment:

    Which state in the b15003 table (edu database) has the greatest population?

    The tract (essentially, the county) population is in the field: ACS18_5yr_B15003001.  The state (2-letter form) is in the field: Geo_STUSAB.  The state populations are obtained by taking the SUM ACS18_5yr_B15003001 and GROUP BY Geo_STUSAB... and you want the MAX of that.

    Conceptually, it's easy:

        SELECT Geo_STUSAB, MAX( SUM(ACS18_5yr_B15003001) ) AS population
        FROM b15003
        GROUP BY Geo_STUSAB;

    The problem is that you can't nest aggregate function calls: MAX( SUM(ACS18_5yr_B15003001) ) won't work!

    One solution to this situation is the *derived table*.  This means a SELECT subquery in the FROM clause:
*/

    SELECT Geo_STUSAB, population
    FROM
    (
        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS population
        FROM b15003
        GROUP BY Geo_STUSAB
    ) AS d -- derived table must be named
    WHERE population IN
    (
        SELECT MAX(population)
        FROM
        (
            SELECT SUM(ACS18_5yr_B15003001) AS population
            FROM b15003
            GROUP BY Geo_STUSAB
        ) AS d -- again, derived table must be named. (It may or may not have a different name.)
    );
/*
    geo_stusab | population
    ------------+------------
    ca         |   26218885

    There is an alternative way of thinking about this problem.  I cannot write:

        SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS population
        FROM b15003
        GROUP BY Geo_STUSAB
        WHERE SUM(ACS18_5yr_B15003001) IN ...

    because, not only may they not be nested, aggregate functions may not be in
    the WHERE clause, either.  (This is why we needed the first derived table.)

    *BUT*, aggregate functions *may* be in the HAVING clause!  (Think about it: "HAVING"
    applies groups, and so do aggregate functions.)
*/

    SELECT Geo_STUSAB, SUM(ACS18_5yr_B15003001) AS population
    FROM b15003
    GROUP BY Geo_STUSAB
        HAVING SUM(ACS18_5yr_B15003001) IN
        (
            SELECT MAX(population)
            FROM
            (
                SELECT SUM(ACS18_5yr_B15003001) AS population
                FROM b15003
                GROUP BY Geo_STUSAB
            ) AS d
        );
/*
    We find ourselves needing a derived table subquery when we're faced with nested
    aggregate functions.  Both of the examples above boil down to the same logic.
    Furthermore, there are other variations on the syntax that all amount to exactly
    the same thing.  (E.g: please disregard the "WITH" clause if you happen to see it.
    That's just another way to write a derived table.  I won't cover it here because
    the logic isn't different.

    Assignment:  All of the exercises are designed to call for nested aggregate functions. Open a new SQL file for your queries.  For the exercises, either approach above will work; logically, the derived table approach and "HAVING" 
    are the same; however, we will focus on derived tables.



    Number your solutions, test them.  (You don't have to include the test.)  The answers are
    *always* SQL queries, not state names & numbers.

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
