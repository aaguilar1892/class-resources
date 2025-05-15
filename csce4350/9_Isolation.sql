/*

See: line 628 in configuration file

            Isolation Levels:
            
READ UNCOMMITTED (aka: "Dirty Read)-- *Considered too weak, not implemented by PostgreSQL*; 
PostgreSQL simply promotes it to the next level.

READ COMMITTED -- A statement can only see rows committed before it began. This is the default.

REPEATABLE READ -- All statements of the current transaction can only see rows 
committed before the first query or data-modification statement was executed 
in this transaction.

SERIALIZABLE -- All statements of the current transaction can only see rows committed 
before the first query or data-modification statement was executed in this transaction. 
If a pattern of reads and writes among concurrent serializable transactions would 
create a situation which could not have occurred for any serial (one-at-a-time) 
execution of those transactions, one of them will be rolled back with a 
serialization_failure error.

Examples:
*/

BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- stronger than the default

-- BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- also works but the above is standard

-- SQL statements

COMMIT;

/*
    REPEATABLE READ: You'd use this one if you wanted to read available flights for a 
    customer and choose one... but you had better be *very* quick about it because 
    you're holding a lock until you commit!
    
    With READ COMMITTED, you might read, and then it disappears before you can book it.
    All you know is that it *was* there when you read it.
    
    The bottom line is that as soon as you have the concept of a transaction --- a group 
    of read and write operations --- you need to have rules for what happens during the 
    timeline between the first of the operations of the group and the last of the operations 
    of the group. What operations by other threads of execution are allowed to occur during 
    this time period between the first and last operation and which operations are not allowed? 
    
    These set of rules are defined by isolation levels that I discussed previously. For example, 
    serializable isolation states that the only concurrent operations that are allowed to 
    occur are those which will not cause a visible change in database state relative to what 
    the state would have been if there were no concurrent operations.
    
*/