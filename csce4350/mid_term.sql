/*
    Mid-Term Test       CSCE 4350,  University of North Texas

    Enter your name here, please: 
*/




/*
    Assume that you are connected to the database db50.
    
    The schema mid_trm may or may not exist.  Drop it so that we may begin with a clean schema.  (Drop any tables it contains.)
    
    Create a the schema named mid_trm and set your search_path to that..

    #1  25 points (including creating the schema.)
    
        You will create two tables that conform to our naming convention.  The first will keep track of doctors.  

        A doctor has an ID that may contain numbers and letters.  It may be up to 128 characters but will usually have much fewer.  The ID is unique and must not be NULL.
        
        A doctor has a first and last name.  The last name may not be null.
        
        A doctor would USUALLY have more information than this, but this is enough and I don't want to add "busy work" to the test.  Fuss over your format.  Be sure it all conforms to our conventions.
        
        The second will keep track of patients.  (Name this and all tables according to our conventions.)
        
        A patient has a unique ID (probably their SSN) that most of the time will contain exactly nine characters.  All patients must have an ID (it cannot be NULL).
        
        A patient has a first and last name; the last name may not be NULL.
        
        A doctor has many (zero or more) patients.  A patient has *exactly one* doctor.
            That should tell you what I'm looking for here... one to many.
            
    #1b Enter the following records in doctors:
    
        (ID,    fname,  lname)
         2367   Al      Jones
         5432   Bob     Thompson
         4387   Cynthia Olsen
         7786   Sally   Watson
         
    #1c Enter the following patients
        (ID,    fname,  lname)
         5576    Bill    McMasters
         6723    Greg    Smith
         5533    Walter  Thompson
         2177    Susan   Harris
         
        Bill McMasters' doctor is Bob Thompson
        Bob Thompson also has Susan Harris as a patient
        Greg Smith's doctor is Al Jones
        Walter Thompson's doctor is Sally Watson
    
    #1d Change Susan Harris' (patient ID 2177) doctor to Al Jones (Doctor ID 2367)
    
    (We usually would not do this:)
    #1e Delete Sally Watson (Doctor ID 7786) from the doctors table, and also delete all of her patients.  Do NOT use CASCADE!  (Use one DELETE for each table using the doctor PK.)
    
    
    #2 (26 points)  Using the patients table you creates in part 1, add a table to track medications.  Name it appropriately following the class' naming conventions.  A medication has a unique ID that might have 16 characters.  It will also have a name... let's say 32 characters.  The name cannot be NULL.
    
        A patient may take many (zero or more) medications; a medication may be prescribed to many (zero or more) patients.  (Yes, there would be *much* more information in a database for a pharmacy, but we'll keep it minimal... demonstrate a many-many relationship.)
        
    Sample data for the medications table:
    
    (ID,    name)
     p52    Asperin
     p87    Omeprazole
     f33    atorvastatin
     
     Bill McMasters takes atorvastatin
     Greg Smith also takes atorvastatin
     Susan Harris takes asperin
     Susan Harris also takes Omeprazole
 */       
        



/*
    #3  7 points each, 49 points total
    
    Queries

    Connect to the CAP database:
    Write queries to answer the following questions:
    
    #3.a  Which Customers (fld_c_name) ordered product fld_p_id = 'p03'?
    
    #3.b  Which Customers (fld_c_name) ordered product fld_p_name = 'razor'? 
          (Same as a, only add tbl_products.)
    
    #3.c  How many orders were placed for fld_p_id = 'p01'?
    
    #3.d  How many orders were placed for fld_p_name = 'comb'?
    
    #3.e  How many orders were placed each month for fld_p_name = 'comb'?
          Show fld_o_month and count (GROUP BY)
    
    #3.f  Which order (fld_o_id_pk) had the greatest fld_o_dollars in tbl_orders? Report ties.  (Hint: it's a subquery!)
    
    
    
    
        Set the search_path to the mid_trm schema that you created on task one.
        
     #3.g  Write an SQL query to find the ID of all doctors who have no patients.
      It's a childless parent query.
*/    
    
    