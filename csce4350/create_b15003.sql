-- Start PostgreSQL and log in.  For CSCE 4355, Connect to db55.  For CSCE 4350, Connect to db50.

DROP SCHEMA IF EXISTS sch_edu CASCADE;
-- Warning: drops everything in the schema!
-- Won't work without CASCADE.

CREATE SCHEMA sch_edu;
SET SEARCH_PATH TO sch_edu;

/*
    Download the file:  b15003.sql and open it in your favorite text editor.
    SELECT ALL and COPY; PASTE it into the database window.

    Download the file  b15003_8.csv  Upload the file into your Ubuntu home directory... this sometimes fails, so be ready to retry.

    Download the file  load_b15003 and open it in your favorite text editor.
    Locate the line reading:  FROM '/home/sws_000125/b15003_8.csv'  
    (line #107, near the end) and make it reflect your home directory.
    
    SELECT ALL and COPY; PASTE it into the database window.  
*/

-- Execute:

SELECT COUNT(*) AS cnt
FROM b15003;

/*
    Output:

    cnt  
    ------
    3220
    (1 row)

 

    The table's documentation is found at: https://www.socialexplorer.com/data/ACS2018_5yr/metadata/?ds=ACS18_5yr&table=B15003Links to an external site.

    However, I have modified the table to demonstrate the database INDEX.  I have changed the data type of the first field: Geo_FIPS (the primary key, BTW) from a nice, sequential INTEGER to a random FLOAT.  (OUCH!)  This will seriously hurt the performance of this table because the PRIMARY KEY is a CLUSTERED, B-TREE INDEX... which means that the data are stored in that order.  Where the data were nicely sorted by state, now they're in random order.

    SELECT Geo_FIPS, Geo_QName
    FROM b15003 LIMIT 100;  -- I seldom use LIMIT
*/