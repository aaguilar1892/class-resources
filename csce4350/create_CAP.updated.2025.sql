-- create_CAP.sql
--
-- SQL statements for table creation of the "CAP" database
-- Adapted for PostgreSQL from "Database Principles, Programming, and
-- Performance". Patrick O'Neil (1988), (Morgan Kaufmann, pub, 2nd ed., 2000)
-- Modified by Dr. Steven W. Smith, University of North Texas, 2023
-- May be copied for educational use so long as it is properly cited.

/*
    This is called a "transaction block".  It is a lot like
    a C program, but a different syntax.  In a transaction, it
    all either executes successfully or it all fails.

    Before you run this code, CREATE the "Customers, Agents, Products" (CAP)
    schema, then set the SEARCH_PATH:

        \c db50
        -- connect to the class database

        DROP SCHEMA IF EXISTS cap CASCADE;

        CREATE SCHEMA cap;

        SET SEARCH_PATH TO cap;

    Select all & paste.
*/

DO $GO$
BEGIN
    DROP TABLE IF EXISTS tbl_orders; -- Must DROP the table with FOREIGN KEY first!
    DROP TABLE IF EXISTS tbl_product_supplier;
    DROP TABLE IF EXISTS tbl_suppliers;
    DROP TABLE IF EXISTS tbl_products;
    DROP TABLE IF EXISTS tbl_agents;
    DROP TABLE IF EXISTS tbl_customers;


    CREATE TABLE tbl_customers
    (
        fld_c_id_pk CHAR(4),
        fld_c_name VARCHAR(13),
        fld_c_city VARCHAR(20),
        fld_c_discnt NUMERIC(4,2),
        --
        CONSTRAINT cpk PRIMARY KEY(fld_c_id_pk),
        CONSTRAINT cReasonableDiscount CHECK(fld_c_discnt>=0 AND fld_c_discnt<100)
    );


    CREATE TABLE tbl_agents
    (
        fld_a_id_pk CHAR(3),
        fld_a_name VARCHAR(13),
        fld_a_city VARCHAR(20),
        fld_a_percent SMALLINT,
        --
        CONSTRAINT apk PRIMARY KEY (fld_a_id_pk)
    );


    CREATE TABLE tbl_products
    (
        fld_p_id_pk CHAR(3),
        fld_p_name VARCHAR(13),
        fld_p_city VARCHAR(20),
        fld_p_quantity INTEGER,
        fld_p_price MONEY,
        --
        CONSTRAINT ppk PRIMARY KEY(fld_p_id_pk)
    );


    CREATE TABLE tbl_suppliers
    (
        fld_s_id_pk CHAR(3),
        fld_s_name VARCHAR(24),
        --
        CONSTRAINT spk PRIMARY KEY(fld_s_id_pk),
        CONSTRAINT null_sname CHECK( fld_s_name IS NOT NULL )
    );

    CREATE TABLE tbl_product_supplier
    (
        -- might have its own PK
        fld_p_id_fk CHAR(3),
        fld_s_id_fk CHAR(3),
        --
        CONSTRAINT ps_PK PRIMARY KEY(fld_p_id_fk, fld_s_id_fk),
        CONSTRAINT pid_FK FOREIGN KEY(fld_p_id_fk) REFERENCES tbl_products(fld_p_id_pk),
        CONSTRAINT sid_FK FOREIGN KEY(fld_s_id_fk) REFERENCES tbl_suppliers(fld_s_id_pk)
    );


    CREATE TABLE tbl_orders
    (
        fld_o_id_pk INTEGER,
        fld_o_month CHAR(3),
        fld_o_qty INTEGER,
        fld_o_dollars MONEY,
        --
        fld_c_id_fk CHAR(4),
        fld_a_id_fk CHAR(3),
        fld_p_id_fk CHAR(3),
        --
        CONSTRAINT opk PRIMARY KEY(fld_o_id_pk),
        CONSTRAINT cfk FOREIGN KEY(fld_c_id_fk) REFERENCES tbl_customers(fld_c_id_pk),
        CONSTRAINT afk FOREIGN KEY(fld_a_id_fk) REFERENCES tbl_agents(fld_a_id_pk),
        CONSTRAINT pfk FOREIGN KEY(fld_p_id_fk) REFERENCES tbl_products(fld_p_id_pk)
    );

    -- -------------------------------------------------------
    -- Inserting Data

    INSERT INTO tbl_customers(fld_c_id_pk, fld_c_name, fld_c_city, fld_c_discnt)
    VALUES  ( 'c001','Tiptop','Duluth',10.00),
            ('c002','Basics','Dallas',12.00),
            ('c003','Allied','Dallas',8.00),
            ('c004','ACME','Duluth',8.00),
            ('c005','Ace','Denton', 10.00),
            ('c006','ACME','Kyoto',0.00);


    INSERT INTO tbl_agents(fld_a_id_pk, fld_a_name,  fld_a_city,  fld_a_percent)
    VALUES  (   'a01','Smith','New York',6  ),
            (   'a02','Jones','Newark',6    ),
            (   'a03','Brown','Tokyo',7     ),
            (   'a04','Gray','New York',6   ),
            (   'a05','Otasi','Duluth',5    ),
            (   'a06','Smith','Dallas',5    );


    INSERT INTO tbl_products(fld_p_id_pk, fld_p_name, fld_p_city, fld_p_quantity, fld_p_price)
    VALUES  (   'p01','comb','Dallas',111400,0.50   ),
            (   'p02','brush','Newark',203000,0.50  ),
            (   'p03','razor','Duluth',150600,1.00  ),
            (   'p04','pen','Duluth',125300,1.00    ),
            (   'p05','pencil','Dallas',221400,1.00 ),
            (   'p06','folder','Dallas',123100,2.00 ),
            (   'p07','case','Newark',100500,1.00   ),
            (   'p08','floppy','Tulsa',150995, 1.00 );


    INSERT INTO tbl_suppliers( fld_s_id_pk, fld_s_name )
    VALUES  (   's01', 'Alpha Supply' ),
            (   's02', 'Beta Supply' ),
            (   's03', 'Gamma Supply' ),
            (   's04', 'Delta Supply' ),
            (   's05', 'Epsilon Supply' ),
            (   's06', 'Lambda Supply' ),
            (   's07', 'Zeta Supply' );


    ALTER TABLE tbl_product_supplier DISABLE TRIGGER ALL;
    INSERT INTO tbl_product_supplier( fld_p_id_fk, fld_s_id_fk )
    VALUES  (   'p02', 's05' ),
            (   'p02', 's03' ),
            (   'p01', 's07' ),
            (   'p03', 's01' ),
            (   'p06', 's02' ),
            (   'p08', 's03' ),
            (   'p04', 's06' ),
            (   'p02', 's06' ),
            (   'p07', 's03' ),
            (   'p09', 's08' );
    ALTER TABLE tbl_product_supplier ENABLE TRIGGER ALL;


    ALTER TABLE tbl_orders DISABLE TRIGGER ALL;
    -- The statement above "turns off" the FOREIGN KEY CONSTRAINT.
    -- Sometimes admins do this to make INSERTion easier (and some claim that it works).

    INSERT INTO tbl_orders( fld_o_id_pk, fld_o_month, fld_c_id_fk, fld_a_id_fk, fld_p_id_fk, 
                             fld_o_qty, fld_o_dollars )
    VALUES  (   1011,'jan','c001','a01','p01',1000,450.00   ),
            (   1012,'jan','c001','a01','p01',1000,450.00   ),
            (   1019,'feb','c001','a02','p02',400,180.00    ),
            (   1017,'feb','c001','a06','p03',600,540.00    ),
            (   1018,'feb','c001','a03','p04',600,540.00   ),
            (   1023,'mar','c001','a04','p05',500,450.00   ),
            (   1022,'mar','c001','a05','p06',400,720.00   ),
            (   1025,'apr','c001','a05','p07',800,720.00   ),
            (   1013,'jan','c002','a03','p03',1000,880.00   ),
            (   1026,'may','c002','a05','p03',800,704.00   ),
            (   1015,'jan','c003','a03','p05',1200,1104.00   ),
            (   1014,'jan','c003','a03','p05',1200,1104.00   ),
            (   1021,'feb','c004','a06','p01',1000,460.00   ),
            (   1016,'jan','c006','a01','p01',1000,500.00   ),
            (   1020,'feb','c006','a03','p07',600,600.00   ),
            (   1024,'mar','c006','a06','p01',800,400.00   ),
            (   1027,'feb','c004','a02','p99',800,720.00    );

    ALTER TABLE tbl_orders ENABLE TRIGGER ALL;
    -- Turns FOREIGN KEY CONSTRAINTs back on


    RAISE NOTICE E'\n\t\tCAP Creation Successful.';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE E'\n\t\tErrors Detected:  %,  %', SQLERRM, SQLSTATE;
END $GO$ LANGUAGE plpgsql;
