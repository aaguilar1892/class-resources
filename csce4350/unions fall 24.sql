/*
        List all opponents of a given player, e.g.: 'Al'

*/
            SELECT fld_pid2_fk AS player
            FROM tbl_games
            WHERE fld_pid1_fk = 'Al'
        UNION
            SELECT fld_pid1_fk
            FROM tbl_games
            WHERE fld_pid2_fk = 'Al'
        ORDER BY player;
/*
    All of the respective fields in the SELECT statement
    must be type compatable, meaning that one can be converted
    to the other.  If you mix INT & FLOAT, they will all
    promote to FLOAT.  CHAR(8) and VARCHAR(16) would end up
    as CHAR(16).

    The statement takes the names of the output fields from the
    first table.

    ORDER BY will apply to the UNION.  ORDER BY on one of the tables
    is ignored.

    UNION ALL returns duplicates.


    INTERSECT returns values that are in *both* tables.

    Example: which players are player1 and player2 in different games?
*/
            SELECT fld_pid1_fk AS player
            FROM tbl_games
        INTERSECT
            SELECT fld_pid2_fk
            FROM tbl_games
        ORDER BY player;
/*
    A EXCEPT B returns all values of A that are not in B
    
    List all values of player1 who are not player2 in any game.
*/
            SELECT fld_pid1_fk AS player
            FROM tbl_games
        EXCEPT
            SELECT fld_pid2_fk
            FROM tbl_games
        ORDER BY player;
        
-- A more complex example:

-- What is the greatest number of games any single player has... either as #1 or #2
-- Allow for ties



    SELECT player, s -- or   SELECT DISTINCT(S)    for just the number
    FROM
    (
        SELECT player, SUM(cnt) AS s
        FROM
        (
            SELECT fld_pid1_fk AS player, COUNT(*) AS cnt
            FROM tbl_games
            GROUP BY  fld_pid1_fk
        UNION
            SELECT fld_pid2_fk, COUNT(*)
            FROM tbl_games
            GROUP BY  fld_pid2_fk
        ) AS d
        GROUP BY player
    ) AS e
    WHERE s IN
    (
        SELECT MAX(s)
        FROM
        (
            SELECT player, SUM(cnt) AS s
            FROM
            (
                    SELECT fld_pid1_fk AS player, COUNT(*) AS cnt
                    FROM tbl_games
                    GROUP BY  fld_pid1_fk
                UNION
                    SELECT fld_pid2_fk, COUNT(*)
                    FROM tbl_games
                    GROUP BY  fld_pid2_fk
            ) AS d
            GROUP BY player
        ) AS e
    )
    ORDER BY player;