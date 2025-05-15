 tbl_customers

  fld_c_id_pk | fld_c_name | fld_c_city | fld_c_discnt
-------------+------------+------------+--------------
 c001        | Tiptop     | Duluth     |        10.00
 c002        | Basics     | Dallas     |        12.00
 c003        | Allied     | Dallas     |         8.00
 c004        | ACME       | Duluth     |         8.00
 c005        | Ace        | Denton     |        10.00
 c006        | ACME       | Kyoto      |         0.00



 tbl_agents

 fld_a_id_pk | fld_a_name | fld_a_city | fld_a_percent
-------------+------------+------------+---------------
 a01         | Smith      | New York   |             6
 a02         | Jones      | Newark     |             6
 a03         | Brown      | Tokyo      |             7
 a04         | Gray       | New York   |             6
 a05         | Otasi      | Duluth     |             5
 a06         | Smith      | Dallas     |             5


 tbl_products

  fld_p_id_pk | fld_p_name | fld_p_city | fld_p_quantity | fld_p_price
-------------+------------+------------+----------------+-------------
 p01         | comb       | Dallas     |         111400 |       $0.50
 p02         | brush      | Newark     |         203000 |       $0.50
 p03         | razor      | Duluth     |         150600 |       $1.00
 p04         | pen        | Duluth     |         125300 |       $1.00
 p05         | pencil     | Dallas     |         221400 |       $1.00
 p06         | folder     | Dallas     |         123100 |       $2.00
 p07         | case       | Newark     |         100500 |       $1.00
 p08         | floppy     | Tulsa      |         150995 |       $1.00

 tbl_orders (Bridge Table)

 fld_o_id_pk | fld_o_month | fld_o_qty | fld_o_dollars | fld_c_id_fk | fld_a_id_fk | fld_p_id_fk
------------+-------------+-----------+---------------+-------------+-------------+--------
       1011 | jan         |      1000 |       $450.00 | c001        | a01         | p01
       1012 | jan         |      1000 |       $450.00 | c001        | a01         | p01
       1019 | feb         |       400 |       $180.00 | c001        | a02         | p02
       1017 | feb         |       600 |       $540.00 | c001        | a06         | p03
       1018 | feb         |       600 |       $540.00 | c001        | a03         | p04
       1023 | mar         |       500 |       $450.00 | c001        | a04         | p05
       1022 | mar         |       400 |       $720.00 | c001        | a05         | p06
       1025 | apr         |       800 |       $720.00 | c001        | a05         | p07
       1013 | jan         |      1000 |       $880.00 | c002        | a03         | p03
       1026 | may         |       800 |       $704.00 | c002        | a05         | p03
       1015 | jan         |      1200 |     $1,104.00 | c003        | a03         | p05
       1014 | jan         |      1200 |     $1,104.00 | c003        | a03         | p05
       1021 | feb         |      1000 |       $460.00 | c004        | a06         | p01
       1016 | jan         |      1000 |       $500.00 | c006        | a01         | p01
       1020 | feb         |       600 |       $600.00 | c006        | a03         | p07
       1024 | mar         |       800 |       $400.00 | c006        | a06         | p01
       1027 | feb         |       800 |       $720.00 | c004        | a02         | p99

 tbl_product_supplier (bridges tbl_products & tbl_suppliers

 fld_p_id_fk | fld_s_id_fk
-------------+-------------
 p02         | s05
 p02         | s03
 p01         | s07
 p03         | s01
 p06         | s02
 p08         | s03
 p04         | s06
 p02         | s06
 p07         | s03
 p09         | s08

 tbl_suppliers

 fld_s_id_pk |   fld_s_name
-------------+----------------
 s01         | Alpha Supply
 s02         | Beta Supply
 s03         | Gamma Supply
 s04         | Delta Supply
 s05         | Epsilon Supply
 s06         | Lambda Supply
 s07         | Zeta Supply
