/*
    A view is essentially an SQL query that is saved and acts like a table.
*/    

    DROP VIEW IF EXISTS view_tx_counties;
    
    CREATE VIEW view_tx_counties AS
        SELECT Geo_QName
        FROM b15003
        WHERE Geo_STUSAB='tx';
        
    SELECT * FROM view_tx_counties;
    
    
    SET SEARCH_PATH TO cap;
    
    DROP VIEW IF EXISTS view_ny_agents;
    
    CREATE VIEW view_ny_agents AS
        SELECT *
        FROM tblAgents
        WHERE acity='New York';
        
    SELECT * FROM view_ny_agents;
        
    -- You may update a view    
    UPDATE view_ny_agents
    SET apercent = 10
    WHERE aid = 'a04';
    -- This *will* update the underlying table
    
    -- let's set it back:
    UPDATE view_ny_agents
    SET apercent = 6
    WHERE aid = 'a04';
    
    
        
        
        
        
    DROP VIEW IF EXISTS view_ny_agents;
    
    CREATE VIEW view_ny_agents AS
        SELECT *
        FROM tblAgents
        WHERE acity='New York'
        WITH CHECK OPTION;
        
    -- "check option means that you cannot insert or update
    -- a row using the view such that the result is *not* in the view.
    
    UPDATE view_ny_agents
    SET acity = 'LA'
    WHERE aid = 'a04';
    


    -- A common use for a view:
    
    CREATE TEMPORARY TABLE tbl_patients
    (
        fld_pname   CHAR(16),
        fld_other_stuff TEXT,
        --
        fld_active BOOLEAN DEFAULT TRUE,
        --
        CONSTRAINT patients_pk PRIMARY KEY(fld_pname)
    );
    
    /*
        Discussion: I would not make the name a PK, but this
        is about a view.
        
        Most platforms do NOT include a BOOLEAN type.  PostgreSQL
        is unusual therein.  If we don't have one, we use the smallest
        integer we have and use the C method: zero is false, anything
        else is true.  Some platforms have a TINYINT type that is an
        unsigned byte.
    */
    
    CREATE TEMPORARY VIEW view_active_patients AS
        SELECT fld_pname, fld_other_stuff
        FROM tbl_patients
        WHERE fld_active = TRUE;
        
    INSERT INTO view_active_patients(fld_pname)
    VALUES  ('Al'),
            ('Betty'),
            ('Chas'),
            ('Debbie'),
            ('Ed');
            
    SELECT fld_pname FROM view_active_patients;
    
    /*
        Of course, a patient's medical records are never
        deleted; however, a patient may leave the practice
        thereby becoming inactive.
        
        E.g.: suppose Chas moves away:
    */
    
    UPDATE tbl_patients
    SET fld_active = FALSE
    WHERE fld_pname = 'Chas';
    
    /*
        'Chas' no longer appears in the view; however, he is
        still in the underlying table.
        
        I could not UPDATE the view because fld_active is not
        selected as the view's output.  Were the view creation
        to have been:
        
            CREATE TEMPORARY VIEW view_active_patients AS
                SELECT *
                FROM tbl_patients
                WHERE fld_active = TRUE;
                
        then we could have updated the view setting fld_active
        to FALSE (unless there were a "WITH CHECK OPTION" of
        course.
        
        In the next class, we learn how to automate the DELETE
        such that we over-ride the definition and write our own
        script for DELETE... but not in this class.
    */
    
        
        