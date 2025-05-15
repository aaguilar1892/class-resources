/*
    Connect to the database db50 and set your search path to cap.
    
    Write SQL queries to answer the following requests for data.  In all cases, please show the (usually optional) ORDER BY line (You decide whether it's ascending or descending  (try some variation.)   Remember, the exercise calls for an SQL query, not textual data.  Example:
    
    There are at least 3 parts (seperated by under_score) to a field name:  "fld" "first letter of table" "field identifier.  So, the "name" in tbl_products is: fld_p_name.  I will just ask for "name" unless it's ambiguous.  A query that produces no output may be perfectly correct!
.
    
    Q: What prodcuct id and names in tbl_products are sourced from city = "Dallas"?
    
    A: (wrong) p01 comb, p04 pencil, p05 folder
    
    A: (correct)
    
    SELECT fld_p_id_pk, fld_p_name
    FROM tbl_products
    WHERE fld_p_city = 'Dallas'
    ORDER BY fld_p_id_pk DESC;
    
    You may get creative on ORDER BY... E.g.: ORDER BY fld_p_name ASC;  is also correct.
    If I don't say which field, use your own judgement and it'll be right.  (You can also order by a field not in the output... all queries will demonstrate an ORDER BY; I didn't say by *what*.)
    
    
    1)  What product id and names in tbl_products have quantity greater than 150,000?
    
    2)  In which city (or cities) is the customer named 'ACME' located? (tbl_customers)
    
    3)  In which city (or cities) is the agent named 'Smith' located? (tbl_agents)
    
    4)  What customer (or customers) (id and name) live in Dallas AND have a discount greater than 10.0?
    
    5)  Which agents (id and name) have a percent less than 6 OR live in Tokyo?
    
    6)  List all id for customers who have no city.  (You're looking for NULL.  It's OK if there aren't any.)
