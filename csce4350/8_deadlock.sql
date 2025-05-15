-- See line 691 in the configuration file

-- https://www.postgresql.org/docs/current/runtime-config-locks.html

-- More on explicit locking:
-- https://www.postgresql.org/docs/current/sql-lock.html




DROP TABLE IF EXISTS tbl1;
DROP TABLE IF EXISTS tbl2;

CREATE TABLE tbl1
(
    val1    INTEGER
);

CREATE TABLE tbl2
(
    val2    INTEGER
);





INSERT INTO tbl1(val1)
VALUES(1);

INSERT INTO tbl2(val2)
VALUES(2);

-- Both sessions:
BEGIN TRANSACTION;




-- "LOCK TABLE" is not in the SQL standard; however, it is used in many platforms.

-- Session 1
LOCK TABLE tbl1 IN ACCESS EXCLUSIVE MODE; -- X-Lock acquired
-- SELECT * FROM tbl1 FOR UPDATE;

    -- SESSION 2
    LOCK TABLE tbl2 IN ACCESS EXCLUSIVE MODE; -- X-Lock acquired
    -- SELECT * FROM tbl2 FOR UPDATE;

-- Session 1 
LOCK TABLE tbl2 IN ACCESS EXCLUSIVE MODE; -- Blocked, waiting on Session 2
-- SELECT * FROM tbl2 FOR UPDATE;

    -- SESSION 2
    LOCK TABLE tbl1 IN ACCESS EXCLUSIVE MODE; -- DEADLOCK!
    -- SELECT * FROM tbl1 FOR UPDATE;

-- The "log_lock_waits" option is found on line# 566 of the config file.
-- To enable deadlock logging, enable that line by removing the '#'
-- and change it to  log_lock_waits = on    (The default is off.)
-- The deadlock_timeout is set on line 738

-- the actual human readable logs are found in /var/log/postgresql

-- Google: "PostgresQL log monitoring software" and choose one; it will come in handy!
-- I know of none in the public domain; therefore, I have no recommendations.



-- Isolation Levels:
-- https://www.postgresql.org/docs/current/transaction-iso.html
/*
    13.2.1. Read Committed Isolation Level
    13.2.2. Repeatable Read Isolation Level
    13.2.3. Serializable Isolation Level
*/
