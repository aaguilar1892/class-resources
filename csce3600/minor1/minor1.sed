# Alexis Aguilar (aa1732)
# CSCE 3600.004
# Minor Assignment 1 - sed and gawk

# sed

# Write a complete sed script called minor1.sed that will encrypt the phone data according to the following:
#     1. Preprocessing:
#         a. Remove the parentheses from each phone number
#         b. Remove any whitespace from each phone number
#         c. Remove any dashes (i.e., '-') from each phone number
#     2. Transposition (i.e., rearrange the order of individual characters):
#         a. Swap the third and eigth number in each phone number
#     3. Substitution (i.e., replace characters by other characters):
#         a. Substitute each number in the phone nuber with random letters, being sure to use an even mix of upper and lower case letters
#     4. Append extra data:
#         a. Append te first 10 letters of your first and last name AFTER the third phone number in the file. If your first and last names 
#            combined are shorter than 10 letters, use letters from your middle name as well. In this file, for example, my sed script 
#            should print the following:
#                $ sed -r -f minor1.sed phone.txt
#                FSSFDGDStD FFttDtDFet
#                rDqSDqSwqS MarkThomps
#                FSAeSSASFF
#                FtGtwArtAA
#                FqDerDeqtD FqDSSDeqtD

#!/bin/sed -f

# Step 1: Preprocessing
# Remove parentheses
s/[()]//g
# Remove whitespace
s/ //g
# Remove dashes
s/-//g

# Step 2: Transposition
# Swap the third and eighth digits
s/\([0-9]\{2\}\)\([0-9]\)\([0-9]\{4\}\)\([0-9]\)\([0-9]\{2\}\)/\1\4\3\2\5/

# Step 3: Substitution with random upper and lower case letters
# Substitute each digit with a random letter
y/0123456789/ReXzYtOiNa/

# Step 4: Append extra data after the third phone number
# Check if it's the third phone number, then append "MarkThomps" after it
3 s/$/ AlexisAgui/
