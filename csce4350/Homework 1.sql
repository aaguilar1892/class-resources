/*
Consider the information represented below in a tabular format:

tbl_employees:

fld_e_id_pk  fld_e_fname   fld_e_lname  fld_e_dob    fld_e_dept   fld_e_salary  fld_e_phone
  (PK)    (first name)  (last name)  (birth date) (department) (salary)	     (phone number)
1111	    John	        Doe	        1/26/1997	Admin	    56000	        8733
2222	    Jane	        Roe	        7/23/1082	Engineering	73000	        2239
3333	    Joe	            Bloe	    3/14/2001	Circulation	32000	        1595
4444	    Sally	        Waldron	    6/22/1993	Engineering	61000	        2220
5555	    Bill	        Thompson	12/1/1989	Admin	    53000	        1288
 

Write an SQL CREATE TABLE statement that will create the table: tbl_employees.  Drop the table first if it already exists.  Use appropriate data types.  I will post a key; your choices might not match mine; however, this does not mean that yours were wrong.  For example: e_fname might be CHAR(16) or VARCHAR(32) or another size.  CHAR(2) is wrong because it's way too small and CHAR(1024) is too big.  A person's name is not an INTEGER!  A number certainly can be stored as a text value if it will never have math performed on it.  Use named constraints.  (e_id is the PRIMARY KEY.  CHECK that e_lname IS NOT NULL and e_salary>0.)

e_id could be CHAR(4) or INTEGER.  Same for e_phone.  Think about why you'd choose one over the other.

Next, write the SQL INSERT statements to insert the data shown.  Place the INSERT in the same SQL file as the CREATE TABLE statements.

SELECT everything to make sure it worked.

SELECT *
FROM tbl_employees;

Write an SQL UPDATE statement to change the e_phone for e_id=2222 to 2340. 

Write an SQL DELETE statement to delete all records for e_dept = 'Circulation''.

 

Save your .SQL file as an SQL file with a meaningful name, for example:  hw1.sql.  Do not save the output.  Upload the SQL file here.
*/