


/*
    Final Test       CSCE 4350,  University of North Texas
    
    Spring, 2025


    Enter your name here:




    Instructions:

    Do not type your code into the comment; the file should be able to
    run without error as a script in PSQL.

    Complete the tasks in this file, save it, test it, then upload.
    Please don't "ZIP" the file.  Be sure it's easy to see which item
    you're answering
*/

/*
    Create a new schema named ft1 and set the search_path there.

    #1  25 %

        The objective of this section is to focus on the one-to-many
        and the many-to-many relationships.  You will need to add
        fields; however, take a mimimalist approach.  I.e.: don't
        add fields or tables unless they're required to represent
        the relationship.  Try to keep the tables as simple as possible.
        
        USE ONLY NAMED CONSTRAINTS.

        We will create a schema (or "group of logically-connected
        tables") realizing the following entities:

        Owners

        Vehicles

        Maintenance Manuals

        Owners: An owner may be associated with zero or more vehicles.  (Hint: it's
        a one to many relationship.)

        The required properties of an owner are:

        fldo_id INTEGER, PRIMARY KEY
        fldo_name   VARCHAR(16)
        [Other fields may or may not be needed; if so, then add them.]

        Vehicles: A vehicle has exactly one owner.  (Note: *exactly* one owner
        means no orphan records allowed.)

        The required properties of a vehicle are:
        fldv_id INTEGER, PRIMARY KEY
        fldv_name   VARCHAR(16)
        [Other fields may or may not be needed; if so, then add them.  You do
        not need to include fields like "make" and "model".  It is recommended
        only to add a field as needed to represent the relationship.]

        A vehicle may be covered by zero or more manuals; a manual may cover
        zero or more vehicles.  (Hint: this is a many to many relationship.)

        The required properties of a manual are:
        fldm_id INTEGER, PRIMARY KEY
        fldm_name   VARCHAR(16)
        [Other fields may or may not be needed; if so, then add them.]

        [Other *tables* may or may not be needed; if so, then add them.]
*/




/*
    #2  23 %

    Insert records into the tables:

    tblOwners:

    id     name
    1       Al
    2       Betty
    3       Chas
*/


/*
    tblVehicles"

    id      name
    1       Chevy       owned by Al
    2       Ford        owned by Al
    3       Toyota      owned by Chas
*/
 
 
 
/*
    tblManuals:

    id      name
    1       Man_Sec3
    2       Pop_Mech
    3       Gen_Prac
*/



/*
    Insert the following relationships:

    Man_Sec3 applies to Chevy
    Pop_Mech applies to Chevy
    Man_Sec3 applies to Ford
    Gen_Prac applies to Toyota
*/



/*
    #3  24 % (8 % each)

    a)  Write an outer join query that will return all fields of any record in tblOwners
    that do not own a vehicle.  (Childless parent query.)
*/


/*
    b)  Write a query demonstrating a subselect that will return all fields of any record in tblVehicles
    where the parent record is not in tblOwners.  (Invalid parent query.)
    
    Whether or not there *are* any invalid parents isn't a criterion.
    
    
    Full credit calls for an outer join and a subselect.  Partial credit for solving it any way you can.
    
*/



/*
    c)  Based on the tables in the cap schema, create a VIEW named view_customer_product that 
    will show all customer/product (cid,pid) pairs where the customer's city is Dallas.
    --
    Test your view, *I* have four rows using my data.  
*/




/*
    #4  28 % (14 % each)
 -- Set the search_path to edu.

    Write a query to answer:
    
    a)  Which state (Geo_STUSAB) has the least number of people with 
    a Doctorate Degree? (ACS18_5yr_B15003025)  
    
    Part 1 is required.
    
    (I see Wyoming.)
    
    
    
    a, pt 2 [10 % optional extra credit] Which state (Geo_STUSAB) has the least number
    *per capita* of people with a Doctorate Degree? (ACS18_5yr_B15003025).
    (I.e.: which state has the lowest ratio of doctorates to the population?)
    (Hint: the county's population is in B15003001.)
    
    Display the state and ratio of doctorates to population for that state (or states, 
    I suppose.) Paste the state & ratio with your code to make it easy to check.  (Don't round the answer.) 
    
    There is no penalty for attempting it.  That means it's added to your grade, but 
    won't be subtracted.  (Your grade will not exceed 100%.)
*/

 
 
 
        

        
/*
    b)  In each state, which counties (Geo_QNAME) have a number of people with
    a Doctorate Degree, ACS18_5yr_B15003025, less than the average for
    their respective states? 
    Show: Geo_STUSAB, Geo_QNAME and ACS18_5yr_B15003025;
    Order by Geo_STUSAB, Geo_Name
    
    Test your solution by displaying the average for Vermont, then restricting the query to Vermont (Geo_STUSAB = 'vt')
    
    Here's what I got on 'vt' ordering by acs18_5yr_b15003025 DESC:
    
         vt         |       avg_docs       
--------------------+----------------------
 Vermont average =  | 592.9285714285714286
(1 row)

         geo_qname          | acs18_5yr_b15003025 
----------------------------+---------------------
 Windham County, Vermont    |                 533
 Bennington County, Vermont |                 407
 Orange County, Vermont     |                 379
 Rutland County, Vermont    |                 377
 Franklin County, Vermont   |                 349
 Lamoille County, Vermont   |                 249
 Caledonia County, Vermont  |                 237
 Orleans County, Vermont    |                 138
 Grand Isle County, Vermont |                 102
 Essex County, Vermont      |                  20
(10 rows)
    
*/
   
