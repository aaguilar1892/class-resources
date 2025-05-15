-- Let's write a simple table;

    CREATE SEQUENCE seq_t1; -- a sequence be like: "take a number"

    DROP TABLE IF EXISTS tbl1;
    
    CREATE TEMPORARY TABLE tbl1
    (
        fld_1_id_pk INT DEFAULT NEXTVAL('seq_t1'),
        fld_1_rate  NUMERIC(5,2),
        fld_1_time  NUMERIC(5,2),
        CONSTRAINT t1_pk PRIMARY KEY(fld_1_id_pk)
    );
    
    INSERT INTO tbl1(fld_1_rate, fld_1_time)
    VALUES ( 10, 5.2 ),
            (103, 0.69); -- & so on
            
        
        
    SELECT fld_1_rate, fld_1_time, fld_1_rate * fld_1_time AS distance
    FROM tbl1
    WHERE distance > 55 -- NO NO!  <BARF!!!>
    ;
    
    
    -- Q: What is this?  A: It's a table!!!
    SELECT fld_1_rate AS rate, fld_1_time AS time, fld_1_rate * fld_1_time AS distance
    FROM tbl1;
    
    
    SELECT rate, time, distance
    FROM
    (
        SELECT fld_1_rate AS rate, 
               fld_1_time AS time, fld_1_rate * fld_1_time AS distance
        FROM tbl1
    ) AS d -- derived table must be named!
    WHERE distance > 55;