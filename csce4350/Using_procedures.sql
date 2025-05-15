/*
    Consider a table containing sensitive data:
*/

    -- \c db50

    CREATE SCHEMA IF NOT EXISTS security_demo;
    SET SEARCH_PATH TO security_demo;
    ALTER DATABASE db50 SET SEARCH_PATH TO security_demo; -- make security_demo the default

    -- to undo that
    -- ALTER DATABASE db50 RESET SEARCH_PATH;


    DROP TABLE IF EXISTS tbl_financial_data;
    DROP TABLE IF EXISTS tbl_accounts;

    CREATE TABLE tbl_accounts
    (
        fld_accnt_id_pk CHAR(16),
        --
        CONSTRAINT accnt_PK PRIMARY KEY(fld_accnt_id_pk)
    );


    CREATE TABLE tbl_financial_data
    (
        fld_sequence_num_pk BIGINT GENERATED ALWAYS AS IDENTITY,
                -- auto numbered (it takes care fo itself).
        fld_accnt_id_fk CHAR(16),
        fld_accnt_info VARCHAR(256),
        --
        CONSTRAINT fd_pk PRIMARY KEY(fld_sequence_num_pk),
        CONSTRAINT accnt_fk FOREIGN KEY(fld_accnt_id_fk)
            REFERENCES tbl_accounts(fld_accnt_id_pk)
    );

/*
    We will create a procedure that allows a user to insert a row
    into tbl_financial_data.
*/

    DROP PROCEDURE IF EXISTS proc_insert_financial_data;

    CREATE OR REPLACE PROCEDURE proc_insert_financial_data
            (IN parm_accnt_id CHAR(16), IN parm_accnt_info VARCHAR(256), INOUT parm_errlvl SMALLINT)
        SECURITY DEFINER
        LANGUAGE plpgsql
        /*
            Return codes:
                0 - success
                1 - NULL or zero-length accnt ID parameter
                2 - NULL or zero-length data parameter
                3 - accnt_id not in parent table

            Comment on 1 and 2: many programmers would write:

                IF parm__accnt_id IS NULL OR LENGTH(parm__accnt_id)=0
                THEN parm_errlvl:=1;
                [...]

                There is a more graceful method:

                IF NULLIF(parm_errlvl, '') IS NULL
                THEN parm_errlvl:=1;
                [...]

                Basically, NULLIF(a, b) says:   IF a = b
                                                THEN RETURN NULL
                                                ELSE RETURN a

                The issue is that a string with 0 characters isn't NULL and
                the LENGTH of NULL is undefined, but not equal to zero!
        */

    AS $GO$
    DECLARE
        lv_example INTEGER; -- an example of a local variable, not used in the code
    BEGIN
        parm_errlvl := 0; -- I always begin with optimism!

        IF NULLIF(parm_accnt_id, '') IS NULL
        THEN parm_errlvl:=1;
        ELSIF NULLIF(parm_accnt_info, '') IS NULL
            THEN parm_errlvl := 2;
            -- Those are easy, now we search a table
            ELSIF NOT EXISTS
                (
                    SELECT *
                    FROM tbl_accounts
                    WHERE fld_accnt_id_pk = parm_accnt_id
                ) -- no semicolon
                THEN parm_errlvl := 3;
                ELSE
                    INSERT INTO tbl_financial_data(fld_accnt_id_fk, fld_accnt_info)
                    VALUES(parm_accnt_id, parm_accnt_info);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN -- on any error
            /*
                Write the application errata log... something is wrong!
            */
            RAISE EXCEPTION 'Something has happened that should not have happened!';
    END $GO$;

-- ------------------------------------------------------------------------------

    -- Let's test the code
    INSERT INTO tbl_accounts(fld_accnt_id_pk)
    VALUES('Al'),('Bob'),('Chas'),('Dale'),('Ed');

    -- Now, I will call the procedure; however, the third parameter is an output
    -- parameter passed by reference.  In any language, the actual parameter has
    -- to be a variable.  In order to have a variable, I must have a transaction
    -- block.

    TRUNCATE tbl_financial_data RESTART IDENTITY;


    DO $GO$
    DECLARE
        lv_errlvl SMALLINT;
    BEGIN
        CALL proc_insert_financial_data('Al', 'test data 1', lv_errlvl); -- code 0
        RAISE INFO 'The first run returns %.', lv_errlvl;

        CALL proc_insert_financial_data(NULL, 'test data 2', lv_errlvl); -- code 1
        RAISE INFO 'The second run returns %.', lv_errlvl;

        CALL proc_insert_financial_data('Al', '', lv_errlvl);           -- code 2
        RAISE INFO 'The third run returns %.', lv_errlvl;

        CALL proc_insert_financial_data('foo', 'test data 1', lv_errlvl); -- code 3
        RAISE INFO 'The fourth run returns %.', lv_errlvl;
    END $GO$;

    SELECT * FROM tbl_financial_data;


/*
    So, our procedure is working!  Now, remember the other user we created named "jqpublic"?
    Jqpublic is an Ubuntu user *and* a PostgreSQL user.  I strongly recommended that you
    make jqpublic's password be "Blu3Ski3s".

    Now, jqpublic represents a public user, probably a PHP script on a web server.  Web
    servers are notoriously vulnerable; therefore, we want jqpublic to have only minimal
    access to the database.  We must grant jqpublic CONNECT to the database and USAGE on
    the schema.  He/she gets *no* privilages on the tables.  In addition, jqpublic is
    granted EXECUTE on the procedure.

    Jqpublic is a representative member of public_users, so we will grant these privileges
    to the group.
*/

    GRANT CONNECT ON DATABASE db50 TO public_users;
    GRANT USAGE ON SCHEMA security_demo TO public_users;

    GRANT EXECUTE ON PROCEDURE proc_insert_financial_data TO public_users;

/*
    Either exit psql or open another terminal window.

    At the Ubuntu prompt, enter:            su jqpublic
    You will be prompted for the password.

    Enter                                   psql
                                            \c db50

    Copy & paste the following:

    DO $GO$
    DECLARE
        lv_errlvl SMALLINT;
    BEGIN
        CALL proc_insert_financial_data('Chas', 'test data public', lv_errlvl); -- code 0
        RAISE INFO 'Jqpublic sees %.', lv_errlvl;
    END $GO$;

    SELECT * FROM tbl_financial_data; -- permission denied for table tbl_financial_data

    We must connect as our admin user to see the tables.
