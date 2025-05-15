/*
    Below is a procedure that compiles as is.  You will complete
    the logic such that it will match the letter to its corresponding
    digit.  My digit is a char; you may use SMALLINT if you please.
    
    It will likely be case sensitive, but that's OK.  Just work in 
    uppercase and let lowercase fail to '#' will be fine.
    
    
    The letters on a telephone keypad be like:
    
    ABC--> 2     DEF--> 3     GHI--> 4     JKL--> 5
    MNO--> 6     PQRS--> 7    TUV--> 8     WXYZ--> 9

    None of the above--> #
    
    
    The following procedure compiles and runs, but it always maps to '9'.
    Write the "IF" logic to make it work.
    
    Do not use CASE logic, please... don't use ASCII arithmetic, either.
    Stick to simple ladder logic.
    
    IF
    THEN
    ELSIF
        THEN
        ELSIF
            THEN
            ELSIF
                THEN
                ELSE
    END IF; -- you'll have eight levels, I think... including the validation
    
*/
    DROP PROCEDURE IF EXISTS proc_char_digit;
    
    CREATE OR REPLACE PROCEDURE proc_char_digit(IN parm_letter CHAR(1) )
        LANGUAGE plpgsql
    AS $GO$ -- you may make up your own delimiter if you like... or use mine.
    DECLARE
        lv_digit CHAR(1); -- may be SMALLINT if you prefer
    BEGIN
    /*
        if it's less than 'A' or greater than 'Z'
        then        it's a '#'
            else... is it a 2?
                else... is it a 3?
                 and so on.
                 
                    else... is it an 8?
                    else gotta be 9 */
                    
                    lv_digit:='9'; -- mine is CHAR so I use 'quotes'
        
        RAISE INFO 'The letter % corresponds to %.', parm_letter, lv_digit;
        
        /*
            You might want the error code ('#') at the end... that also works.
        */
    END $GO$;
    
    -- Run your code:
    CALL proc_char_digit('K'); -- should say it's a 5 when you finish.
              
/*
    There are lots of ways to write this CSCE 2100 program... simple ladder logic
    works well in this platform.  We do this kind of stuff frequently.  It can
    be written as a binary search if you're feeling macho, but a simple solution
    that works is worth just as much.
    
    Think about your format!  It counts.  I know that it's a subjective thing, but
    try to format the code... if you try, it'll be OK.  Don't use RETURN.  "ELSIF"
    is your friend.
    
    IF x=3
    THEN something
    ELSE
        IF x=4
        THEN something different
        ELSE default
        END IF;
    END IF;
    
    -- Two "END IF"
    -- better:
    
    IF x=3
    THEN something
    ELSIF x=4
        THEN something different
        ELSE default
    END IF;
    
    -- Only one "END IF" ... same logic.