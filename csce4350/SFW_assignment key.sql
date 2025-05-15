-- In all cases, ORDER BY is required.  The students choose the field.
-- Minus two points if (not exists) or creates a syntax error.

--    1)  What product id and names in tbl_products have quantity greater than 150,000?

        SELECT fld_p_id_pk, fld_p_name
        FROM tbl_products
        WHERE fld_p_quantity > 150000
        ORDER BY ffld_p_id_pk DESC; -- *any* ORDER BY satisfies.  - 2 points if none.
    
--    2)  In which city (or cities) is the customer named 'ACME' located? (tbl_customers)

        SELECT fld_c_city
        FROM tbl_customers
        WHERE fld_c_name = 'ACME' -- accept is student used lower case
        ORDER BY fld_c_city ASC; -- *any* ORDER BY satisfies.  - 2 points if none (typ).
    
--   3)  In which city (or cities) is the agent named 'Smith' located? (tbl_agents)

        SELECT fld_a_city
        FROM tbl_agents
        WHERE fld_a_name = 'Smith'
        ORDER BY fld_a_city;
        -- Accept if case does not match.  
        -- (This is a database setting & sometimes it matters.)
    
--    4)  What customer (or customers) (id and name) live in Dallas 
--        AND have a discount greater than 10.0?

        SELECT fld_c_id_pk, fld_c_name
        FROM tbl_customers
        WHERE fld_c_city = 'Dallas' AND fld_c_discnt > 10
        ORDER BY  fld_c_id_pk;
        -- This one is tricky on the field name: "fld_c_discnt"
        -- Minus 1 if spelled "fld_c_discount"
        
        
    
--    5)  Which agents (id and name) have a percent less than 6 OR live in Tokyo?

        SELECT fld_a_id_pk, fld_a_name
        FROM tbl_agents
        WHERE fld_a_percent < 6 OR fld_a_city = 'Tokyo'
        ORDER BY fld_a_name DESC;
    
--    6)  List all id for customers who have no city. 

        SELECT fld_c_id_pk
        FROM tbl_customers
        WHERE fld_c_city IS NULL   -- minus 10 points for "= NULL"
        ORDER BY fld_c_id_pk;
        -- zero rows