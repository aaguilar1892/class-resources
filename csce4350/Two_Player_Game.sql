/*
    A "Two-Player Game" is exactly what it sounds like.  These are used frequently in
    database teaching.  It could be a game of tic-tac-toe... or chess, I suppose.  I use
    Rock-Paper-Scissors because it's simple
    
    We have players: a player has a name... and other stuff, but a name is enough.
    
    We have games: a game has two players that must be in the "players" table.
    
    We have rounds: A round is an event in a particular game.  In tic-tac-toe, it
    might be one complete match.  In Rock-Paper-Scissors, it's each player selecting
    one option.
    
    We'll make our schema be rps.
*/
    CREATE SCHEMA IF NOT EXISTS rps;
    SET SEARCH_PATH TO rps;

    
    
    -- DROP TABLE IF EXISTS tbl_rounds;
    DROP TABLE IF EXISTS tbl_games;
    DROP TABLE IF EXISTS tbl_players;
    
    DROP SEQUENCE IF EXISTS seq_pk; -- usually CASCADE
    
    CREATE SEQUENCE seq_pk;
    
    
    CREATE TABLE tbl_players
    (
        fld_pid_pk CHAR(16),
        --
        CONSTRAINT players_pk PRIMARY KEY(fld_pid_pk)
    );
    
    CREATE TABLE tbl_games
    (
        fld_gid_pk BIGINT DEFAULT NEXTVAL('seq_pk'),
        fld_pid1_fk CHAR(16), -- Player 1
        fld_pid2_fk CHAR(16), -- Player 2
        --
        CONSTRAINT games_pk PRIMARY KEY(fld_gid_pk),
        CONSTRAINT p1id_fk FOREIGN KEY(fld_pid1_fk) REFERENCES tbl_players(fld_pid_pk),
        CONSTRAINT p2id_fk FOREIGN KEY(fld_pid2_fk) REFERENCES tbl_players(fld_pid_pk)
    );

/*
    we won't implement Rounds
    
    CREATE TABLE tbl_rounds
    (
        fld_rid_pk BIGINT DEFAULT NEXTVAL(seq_pk),
        fld_gid_fk BIGINT,
        fld_rtoken1 CHAR(1), -- player 1's choice
        fld_rtoken2 CHAR(1), -- player 2's choice
        --
        CONSTRAINT rounds_pk PRIMARY KEY(fld_rid_pk),
        CONSTRAINT gid_fk FOREIGN KEY(fld_gid_fk) REFERENCES tbl_games(fld_gid_pk)
    );
*/    
    INSERT INTO tbl_players(fld_pid_pk)
    VALUES('Al'),('Bob'),('Chas'),('Dan'),('Ed'),('Frank');
    
    INSERT INTO tbl_games(fld_pid1_fk,fld_pid2_fk)
    VALUES('Al','Bob'),('Bob','Chas'),('Al','Dan'),('Bob','Frank'),('Al','Ed'),
            ('Bob','Dan'),('Chas','Ed'),('Bob','Ed');
    
   
    SELECT * FROM tbl_games;
/*
 fld_gid_pk |   fld_pid1_fk    |   fld_pid2_fk    
------------+------------------+------------------
          1 | Al               | Bob             
          2 | Bob              | Chas            
          3 | Al               | Dan             
          4 | Bob              | Frank           
          5 | Al               | Ed              
          6 | Bob              | Dan             
          7 | Chas             | Ed              
          8 | Bob              | Ed              
(8 rows)
*/    
    