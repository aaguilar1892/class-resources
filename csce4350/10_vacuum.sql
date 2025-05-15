-- VACUUM — garbage-collect and optionally analyze a database

-- aka: "defragment"

-- Documentation:
-- https://www.postgresql.org/docs/current/sql-vacuum.html

-- Also, see:
-- https://www.postgresql.org/docs/current/routine-vacuuming.html

\c rps

VACUUM (VERBOSE, ANALYZE) tblPlayers;

-- Autovacuum -- See: line# 577 in config file
/*
    "VACUUM" and defragmentation in general are not written into the SQL standard;
    however, all platforms preform this task and PostgreSQL is pretty typical.
    
    Regular vacuuming keeps the statistics up to data and optimizes the indexes.
    
    The default time is once a minute.  If it's a busy database, you'll need it.
    If not, then it doesn't matter very much.
*/

\c edu

VACUUM (VERBOSE, ANALYZE) b15003;


