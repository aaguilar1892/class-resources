/*
    Homework for module: Correlated subqueries.  Most of these will require a correlated subquery.

    Save your queries as a single SQL file and upload it to Canvas in the usual manner.

    These queries reference the b15003 table probably in the database named "edu"

#1  For each state (Geo_STUSAB), list the counties where the number of
    Professional School Degrees (PSD) (B15003024) is less than the average number of
    PSD *for that state*.  Show Geo_QName and the number of PSD for that county.
    Order by state, then county (Geo_NAME).
*/

SELECT Geo_QName , ACS18_5yr_B15003024
FROM b15003 AS tblOutside
WHERE ACS18_5yr_B15003024 < ALL
(
    SELECT AVG(ACS18_5yr_B15003024)
    FROM b15003 AS tblInside
    WHERE tblInside.Geo_STUSAB = tblOutside.Geo_STUSAB
)
ORDER BY Geo_STUSAB, Geo_Name
 LIMIT 50 -- just to avoid lots of data
;

-- This is also acceptable:
SELECT Geo_QName , ACS18_5yr_B15003024
FROM b15003 AS tblOutside
WHERE ACS18_5yr_B15003024 < ALL
(
    SELECT AVG(ACS18_5yr_B15003024)
    FROM b15003
    WHERE Geo_STUSAB = tblOutside.Geo_STUSAB
)
ORDER BY Geo_STUSAB, Geo_Name;

-- You don't have to rename the inside table.  (Typical, all queries.)
--
-- They *do* have to have "WHERE ACS18_5yr_B15003024 < ALL", even though
-- it will run without the "ALL".  (It performs a coercion if you don't
-- have it: INTEGER < TABLE containing an INTEGER... not the same!)
-- I covered that in detail. (Minus 5 points)  (Typical)



/*
I return 2,656 rows; here are my first 50:

                 geo_qname                 | acs18_5yr_b15003024
-------------------------------------------+---------------------
 Aleutians East Borough, Alaska            |                   0
 Aleutians West Census Area, Alaska        |                   9
 Bethel Census Area, Alaska                |                  84
 Bristol Bay Borough, Alaska               |                   2
 Denali Borough, Alaska                    |                  11
 Dillingham Census Area, Alaska            |                  79
 Haines Borough, Alaska                    |                  70
 Hoonah-Angoon Census Area, Alaska         |                   8
 Ketchikan Gateway Borough, Alaska         |                 118
 Kodiak Island Borough, Alaska             |                  63
 Kusilvak Census Area, Alaska              |                   0
 Lake and Peninsula Borough, Alaska        |                  29
 Nome Census Area, Alaska                  |                  72
 North Slope Borough, Alaska               |                   3
 Northwest Arctic Borough, Alaska          |                  11
 Petersburg Borough, Alaska                |                   8
 Prince of Wales-Hyder Census Area, Alaska |                  27
 Sitka City and Borough, Alaska            |                 153
 Skagway Municipality, Alaska              |                   0
 Southeast Fairbanks Census Area, Alaska   |                  50
 Valdez-Cordova Census Area, Alaska        |                  60
 Wrangell City and Borough, Alaska         |                   7
 Yakutat City and Borough, Alaska          |                   2
 Yukon-Koyukuk Census Area, Alaska         |                   4
 Autauga County, Alabama                   |                 510
 Barbour County, Alabama                   |                  92
 Bibb County, Alabama                      |                  87
 Blount County, Alabama                    |                 240
 Bullock County, Alabama                   |                 142
 Butler County, Alabama                    |                 136
 Chambers County, Alabama                  |                 245
 Cherokee County, Alabama                  |                 358
 Chilton County, Alabama                   |                 267
 Choctaw County, Alabama                   |                  38
 Clarke County, Alabama                    |                  99
 Clay County, Alabama                      |                  58
 Cleburne County, Alabama                  |                 130
 Coffee County, Alabama                    |                 310
 Colbert County, Alabama                   |                 381
 Conecuh County, Alabama                   |                  29
 Coosa County, Alabama                     |                  21
 Covington County, Alabama                 |                 257
 Crenshaw County, Alabama                  |                  35
 Cullman County, Alabama                   |                 572
 Dale County, Alabama                      |                 263
 Dallas County, Alabama                    |                 263
 DeKalb County, Alabama                    |                 433
 Elmore County, Alabama                    |                 647
 Escambia County, Alabama                  |                 150
 Fayette County, Alabama                   |                  37
(50 rows)







#2  Same as #1, but list the counties where the ratio of Professional School Degrees (PSD) to the
    county's population is less than the average ratio of the state's PSD *for that state*.


*/

    SELECT Geo_QName, ACS18_5yr_B15003024::NUMERIC/ACS18_5yr_B15003001 AS ratios
    FROM b15003 AS tblOutside
    WHERE ACS18_5yr_B15003024::NUMERIC/ACS18_5yr_B15003001 < ALL
    (
        SELECT SUM(ACS18_5yr_B15003024)::NUMERIC/SUM(ACS18_5yr_B15003001)
        FROM b15003 AS tblInside
        WHERE tblInside.Geo_STUSAB = tblOutside.Geo_STUSAB
    )
    ORDER BY Geo_STUSAB, Geo_QName
    LIMIT 50 -- optional
    ;

    -- I didn't say explicitly to ORDER BY Geo_STUSAB, Geo_QName
    -- as I did on my output.  Accept other sorting.  (paste that in
    -- to check it if you want.)



/*


    I return 2,758 rows; here are my first 50:

                 geo_qname                 |         ratios
-------------------------------------------+------------------------
 Aleutians East Borough, Alaska            | 0.00000000000000000000
 Aleutians West Census Area, Alaska        | 0.00219138056975894814
 Bethel Census Area, Alaska                | 0.00868037614963315077
 Bristol Bay Borough, Alaska               | 0.00310077519379844961
 Denali Borough, Alaska                    | 0.00687070580886945659
 Fairbanks North Star Borough, Alaska      | 0.01908211779164914777
 Hoonah-Angoon Census Area, Alaska         | 0.00476190476190476190
 Kenai Peninsula Borough, Alaska           | 0.01238920475705737766
 Ketchikan Gateway Borough, Alaska         | 0.01231732776617954071
 Kodiak Island Borough, Alaska             | 0.00717213114754098361
 Kusilvak Census Area, Alaska              | 0.00000000000000000000
 Matanuska-Susitna Borough, Alaska         | 0.01193899519730205808
 Nome Census Area, Alaska                  | 0.01315068493150684932
 North Slope Borough, Alaska               | 0.00046082949308755760
 Northwest Arctic Borough, Alaska          | 0.00262780697563306259
 Petersburg Borough, Alaska                | 0.00374707259953161593
 Prince of Wales-Hyder Census Area, Alaska | 0.00603756708407871199
 Skagway Municipality, Alaska              | 0.00000000000000000000
 Southeast Fairbanks Census Area, Alaska   | 0.01122334455667789001
 Valdez-Cordova Census Area, Alaska        | 0.00928074245939675174
 Wrangell City and Borough, Alaska         | 0.00373333333333333333
 Yakutat City and Borough, Alaska          | 0.00443458980044345898
 Yukon-Koyukuk Census Area, Alaska         | 0.00115573533660791679
 Autauga County, Alabama                   | 0.01372221923263197546
 Barbour County, Alabama                   | 0.00506245529081604578
 Bibb County, Alabama                      | 0.00551330798479087452
 Blount County, Alabama                    | 0.00605647664471193883
 Butler County, Alabama                    | 0.00979262672811059908
 Calhoun County, Alabama                   | 0.01247235736399823087
 Chambers County, Alabama                  | 0.01039721609234425395
 Chilton County, Alabama                   | 0.00896183667304400363
 Choctaw County, Alabama                   | 0.00402713013988978381
 Clarke County, Alabama                    | 0.00586840545346769413
 Clay County, Alabama                      | 0.00624663435648896069
 Cleburne County, Alabama                  | 0.01244614648157012925
 Coffee County, Alabama                    | 0.00887946837763519707
 Colbert County, Alabama                   | 0.00986075883844919509
 Conecuh County, Alabama                   | 0.00327757685352622061
 Coosa County, Alabama                     | 0.00255164034021871203
 Covington County, Alabama                 | 0.00972085634314244648
 Crenshaw County, Alabama                  | 0.00361757105943152455
 Cullman County, Alabama                   | 0.00999790253792910578
 Dale County, Alabama                      | 0.00787849739380504463
 Dallas County, Alabama                    | 0.00988721804511278195
 DeKalb County, Alabama                    | 0.00904419751023477316
 Elmore County, Alabama                    | 0.01160350795387291738
 Escambia County, Alabama                  | 0.00577700751010976314
 Etowah County, Alabama                    | 0.01377873463434960761
 Fayette County, Alabama                   | 0.00315780489886489716
 Franklin County, Alabama                  | 0.00432442821449163944
(50 rows)

    Similar to, but not the same as, #1.
*/






/*
#3  List the counties (Geo_QName) where the number of people with a high school diploma
    (ACS18_5yr_B15003017) is above the average for their state.  Show Geo_QName and
    ACS18_5yr_B15003017.  Order by Geo_STUSAB, Geo_QName with both *DESCENDING*.
*/
    SELECT Geo_QName, ACS18_5yr_B15003017
    FROM b15003 AS tblOutside
    WHERE ACS18_5yr_B15003017 > ALL
    (
        SELECT AVG(ACS18_5yr_B15003017)
        FROM b15003 AS tblInside
        WHERE tblInside.Geo_STUSAB = tblOutside.Geo_STUSAB -- here is the important part
        GROUP BY Geo_STUSAB
    )
    ORDER BY Geo_STUSAB DESC, Geo_QName DESC
    --LIMIT 50
    ;

    -- It calls for both fields descending.  Minus a point if they have:
    -- ORDER BY Geo_STUSAB, Geo_QName DESC
    -- If they have the correlation running, be leniant on the ORDER BY,
/*

    I see 796 rows; here are my first 50:

            geo_qname             | acs18_5yr_b15003017
----------------------------------+---------------------
 Uinta County, Wyoming            |                4326
 Sweetwater County, Wyoming       |                7629
 Sheridan County, Wyoming         |                4367
 Park County, Wyoming             |                4612
 Natrona County, Wyoming          |               12148
 Laramie County, Wyoming          |               13569
 Fremont County, Wyoming          |                6606
 Campbell County, Wyoming         |                8601
 Wood County, West Virginia       |               18006
 Wayne County, West Virginia      |                9784
 Randolph County, West Virginia   |                8430
 Raleigh County, West Virginia    |               17460
 Putnam County, West Virginia     |               13022
 Preston County, West Virginia    |                9902
 Ohio County, West Virginia       |                9447
 Monongalia County, West Virginia |               15069
 Mineral County, West Virginia    |                8124
 Mercer County, West Virginia     |               13092
 Marshall County, West Virginia   |                8576
 Marion County, West Virginia     |               13411
 Logan County, West Virginia      |                9454
 Kanawha County, West Virginia    |               42028
 Jefferson County, West Virginia  |                9947
 Jackson County, West Virginia    |                8030
 Harrison County, West Virginia   |               15990
 Greenbrier County, West Virginia |                8051
 Fayette County, West Virginia    |               10798
 Cabell County, West Virginia     |               17382
 Berkeley County, West Virginia   |               23672
 Wood County, Wisconsin           |               17441
 Winnebago County, Wisconsin      |               33319
 Waukesha County, Wisconsin       |               58630
 Washington County, Wisconsin     |               25724
 Walworth County, Wisconsin       |               18645
 Sheboygan County, Wisconsin      |               25812
 Rock County, Wisconsin           |               34257
 Racine County, Wisconsin         |               35820
 Outagamie County, Wisconsin      |               37100
 Milwaukee County, Wisconsin      |              153729
 Marathon County, Wisconsin       |               29031
 Manitowoc County, Wisconsin      |               20222
 La Crosse County, Wisconsin      |               17282
 Kenosha County, Wisconsin        |               30335
 Jefferson County, Wisconsin      |               17195
 Fond du Lac County, Wisconsin    |               23019
 Dodge County, Wisconsin          |               23112
 Dane County, Wisconsin           |               54316
 Brown County, Wisconsin          |               45967
 Yakima County, Washington        |               32779
 Whatcom County, Washington       |               27470
(50 rows)
*/


/*
#4  List the county names (Geo_NAME) and their respective counts where there are duplicate
    county names (more than one) in any state.
*/

-- This one does not require a correlated subquery!  It *can* be done with a correlated subquery to itself.

-- I should have said to ORDER BY Geo_NAME... oh, well.

SELECT Geo_NAME, COUNT(*) AS cnt
FROM b15003
GROUP BY Geo_Name HAVING COUNT(*) > 1
ORDER BY Geo_NAME
;


/*
    I get 423 rows.
*/
