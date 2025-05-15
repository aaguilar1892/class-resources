
/*

Check that you have created the b15003 table.

Start your GCP and run PSQL. Enter the command: \dn (Shows schema)

Look for a schema named "edu" or "sch_edu"

Set your search_path and look for the b15003 table with the command: \dt

If you don't have b15003, here is the video on how to create it:

https://unt.zoom.us/rec/share/lsUGQ3w99l-f1VR7tyLvyydldENHPvOIpxX0llLqkBdIFBYBxBuSdXJuJTqUjWSL.fW_kUZLDmrOvAPyS

There was a page on creating the edu schema; however, we didn't cover it in detail. It was in the module: Install & Configure PSQL Environment.Here is a link to the page with instructions:https://unt.instructure.com/courses/119125/modules/items/7317722

(I checked the instructions on 3/15/2025. I noticed that it says to name the schema "sch_edu". I did that for a while; however, there is no good reason to prepend the "sch_" to schema names. Just name it "edu" is fine."

The table's documentation is found at:https://www.socialexplorer.com/data/ACS2018_5yr/metadata/?ds=ACS18_5yr&table=B15003(Links to an external site).

Do you recall that I said not to use LIMIT? Well, that ain't necessarily so! I use it when I want to sample data in a table, but I don't want to wade through three thousand rows!

SELECT geo_name, geo_qname, geo_stusab, acs18_5yr_b15003001 AS _001
FROM b15003
LIMIT 10; -- Just show me a few rows.

Geo_name is the tract name (usually the county), geo_qname is the county & state, geo_stusab is the state abbreviation, and acs18_5yr_b15003001 is the population of the tract in 2018. Notice that all of the fields are of the form: "acs18_5yr_b15003nnn[x]" where n is a single digit and x is an optional character. You'll have to spell them out, but I'll discuss them as 3 digits.




Find the geo_qname with the greatest population. Show gqo_qname & acs18_5yr_b15003001; allow for ties.

No peeking!!! (Hint: Los Angeles County, California, with 6,845,489 happy residents.

*/














SELECT geo_qname, acs18_5yr_b15003001
FROM b15003
WHERE acs18_5yr_b15003001 IN
(
    SELECT MAX(acs18_5yr_b15003001)
    FROM b15003
);