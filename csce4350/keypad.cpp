
    int main()
    {
        char digit, ch;

        // psql doesn't have any console input... none do.  They use PHP

        digit = 'M'; // kinda like:    cin>>digit;

        if(digit<'A' || digit > 'Z')
            ch = '#';

        if(digit == 'A')
            ch = '2';
        if(digit == 'B')
            ch = '2';
        if(digit == 'C')
            ch = '2';
        if(digit == 'D')
            ch = '3';
        if(digit == 'E')
            ch = '3';
        if(digit == 'F')
            ch = '3';
        if(digit == 'G')
            ch = '4';
        if(digit == 'H')
            ch = '4';
        if(digit == 'I')
            ch = '4';
        if(digit == 'J')
            ch = '5';
        if(digit == 'K')
            ch = '5';
        if(digit == 'L')
            ch = '5';
        if(digit == 'M')
            ch = '6';
        if(digit == 'N')
            ch = '6';
        if(digit == 'O')
            ch = '6';
        if(digit == 'P')
            ch = '7';
        if(digit == 'Q')
            ch = '7';
        if(digit == 'R')
            ch = '7';
        if(digit == 'S')
            ch = '7';
        if(digit == 'T')
            ch = '8';
        if(digit == 'U')
            ch = '8';
        if(digit == 'V')
            ch = '8';
        if(digit == 'W')
            ch = '9';
        if(digit == 'X')
            ch = '9';
        if(digit == 'Y')
            ch = '9';
        if(digit == 'Z')
            ch = '9';

        cout<<ch;

        return 0;
    }





    int main()
    {
        char digit, ch;

        // psql doesn't have any console input... none do.  They use PHP

        digit = 'M'; // kinda like:    cin>>digit;

        if(digit<'A' || digit > 'Z')
            ch = '#';

        if(digit == 'A' || digit == 'B' || digit == 'C')
            ch = '2';

        if(digit == 'D' || digit == 'E' || digit == 'F')
            ch = '3';

        if(digit == 'G' || digit == 'H' || digit == 'I')
            ch = '4';

        if(digit == 'J' || digit == 'K' || digit == 'L')
            ch = '5';

        if(digit == 'M' || digit == 'N' || digit == 'O')
            ch = '6';

        if(digit == 'P' || digit == 'Q' || digit == 'R' || digit == 'S')
            ch = '7';

        if(digit == 'T' || digit == 'U' || digit == 'V')
            ch = '8';

        if(digit == 'W' || digit == 'X' || digit == 'Y' || digit == 'Z')
            ch = '9';

        cout<<ch;

        return 0;
    }




    int main()
    {
        char digit, ch;

        // psql doesn't have any console input... none do.  They use PHP

        digit = 'M'; // kinda like:    cin>>digit;

        if(digit<'A' || digit > 'Z')
            ch = '#';
        // Any time you have "ELSE" followed by "IF", it's "ELSIF"
        else
            if(digit == 'A' || digit == 'B' || digit == 'C')
                ch = '2';
            else
                if(digit == 'D' || digit == 'E' || digit == 'F')
                    ch = '3';
                else
                    if(digit == 'G' || digit == 'H' || digit == 'I')
                        ch = '4';
                    else
                        if(digit == 'J' || digit == 'K' || digit == 'L')
                            ch = '5';
                        else
                            if(digit == 'M' || digit == 'N' || digit == 'O')
                                ch = '6';
                            else
                                if(digit == 'P' || digit == 'Q' || digit == 'R' || digit == 'S')
                                    ch = '7';
                                else
                                    if(digit == 'T' || digit == 'U' || digit == 'V')
                                        ch = '8';
                                    else
                                        if(digit == 'W' || digit == 'X' || digit == 'Y' || digit == 'Z')
                                            ch = '9';

        cout<<ch;

        return 0;
    }
    
    
    
    
    
    
    
    
   int main()
    {
        char digit, ch;

        // psql doesn't have any console input... none do.  They use PHP

        digit = 'M'; // kinda like:    cin>>digit;

        if(digit<'A' || digit > 'Z')
            ch = '#';
        // Any time you have "ELSE" followed by "IF", it's "ELSIF"
        else
            if(digit >= 'A' && digit <= 'C')
                ch = '2';
            else
                if(digit >= 'D' && digit <= 'F')
                    ch = '3';
                else
                    if(digit >= 'G' && digit <= 'I')
                        ch = '4';
                    else
                        if(digit >= 'J' && digit <= 'L')
                            ch = '5';
                        else
                            if(digit >= 'M' && digit <= 'O')
                                ch = '6';
                            else
                                if(digit >= 'P' && digit <= 'S')
                                    ch = '7';
                                else
                                    if(digit >= 'T' && digit <= 'V')
                                        ch = '8';
                                    else
                                        if(digit >= 'W' && digit <= 'Z')
                                            ch = '9';

        cout<<ch;

        return 0;
    }




    // "Ladder logic"
    int main()
    {
        char digit, ch;

        // psql doesn't have any console input... none do.  They use PHP

        digit = 'M'; // kinda like:    cin>>digit;

        if(digit<'A' || digit > 'Z')
            ch = '#';
        // Any time you have "ELSE" followed by "IF", it's "ELSIF"
        else
            if(digit <= 'C')
                ch = '2';
            else
                if(digit <= 'F')
                    ch = '3';
                else
                    if(digit <= 'I')
                        ch = '4';
                    else
                        if(digit <= 'L')
                            ch = '5';
                        else
                            if(digit <= 'O')
                                ch = '6';
                            else
                                if(digit <= 'S')
                                    ch = '7';
                                else
                                    if(digit <= 'V')
                                        ch = '8';
                                    else
                                        if(digit <= 'Z') // and, do we really need to ask this last one?
                                            ch = '9';
        cout<<ch;

        return 0;
    }
    
    
// How many comparisons (after validation)?

// (1+2+3+4+5+6+7+7)/8 = 35/8 = 4.375 (average)

// it can be done in 3!


   int main()
    {
        char digit, ch;

        // psql doesn't have any console input... none do.  They use PHP

        digit = 'M'; // kinda like:    cin>>digit;

        if(digit<'A' || digit > 'Z')
            ch = '#';
        else
            if(digit <= 'L')
                if(digit <= 'F')
                    if(digit <= 'C')
                        ch = '2';
                    else
                        ch = '3';
                else
                    if(digit <= 'I')
                        ch = '4';
            else
                if(digit <= 'S')
                    if(digit <= 'O')
                        ch = '6';
                    else
                        ch = '7';
                else
                    if(digit <= 'V')
                        ch = '8';
                    else
                        ch = '9';
        cout<<ch;

        return 0;
    }
/*
    Doing it this way is tricky in psql because we don't have a "THENIF", thus
    our code loses it's symmetry.  *IF* you take this route, 1) get it running
    using ladder logic and save that for full credit... then modify it to binary
    logic.  It can be written using '<', '>', '<=', '>=' ... pick one and use
    only that.  Also, don't use "ELSIF"... this means you'll have seven "END IF"
    statements; however, it preserves the symmetry.
*/
  

  

//    Now, this would make a wonderful function, don't you think?
    
    char telephone( char digit)
    {
        if(digit<'A' || digit > 'Z')
            return'#';
        // Any time you have "ELSE" followed by "IF", it's "ELSIF"
        else
            if(digit <= 'C')
                return '2';
            else
                if(digit <= 'F')
                    return '3';
                else
                    if(digit <= 'I')
                        return '4';
                    else
                        if(digit <= 'L')
                            return '5';
                        else
                            if(digit <= 'O')
                                return '6';
                            else
                                if(digit <= 'S')
                                    return '7';
                                else
                                    if(digit <= 'V')
                                        return '8';
                                    else
                                        if(digit <= 'Z') // and, do we really need to ask this last one?
                                            return '9';
        cout<<ch;

        return 0;
    }
    
    //  I always say that RETURN should never be used as a logical control structure.
    // I.e., it does *NOT* replace "else"!!!
    
    
// psql code

    DROP FUNCTION IF EXISTS func_demo;  -- demonstrates demo(x) = 3X + 7
    
    CREATE OR REPLACE FUNCTION func_demo(  IN arg_x INTEGER ) RETURNS INTEGER
        LANGUAGE PLPGSQL
    AS $GO$
    DECLARE
        -- local variables *may go here
    BEGIN
        RETURN 3 * arg_x + 7;
    END $GO$;
    
    -- To run it:
    
    SELECT func_demo(6); -- or any argument you like