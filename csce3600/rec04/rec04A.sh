# Write a bash script that accepts a person’s name as a command-line argument and
# simply prints out the following greeting: "Good day, <name_entered>! Nice to meet
# you!", where <name_entered> is a positional parameter (i.e., a command-line
# argument) passed to the script. If the user does not enter a command-line argument
# when invoking this shell script, you will simply output: "Hope you have a great day!",
# without any name displayed. This bash script should be called rec04A.sh.
# 
# SAMPLE OUTPUT (input in bold):
# $ ./rec04A.sh Mark
# Good day, Mark! Nice to meet you!
# $ ./rec04A.sh
# Hope you have a great day!

# Alexis Aguilar (aa1732)
# Fall 2024 CSCE 3600 - Systems Programming
# Recitation 4

#!/usr/bin/bash

# checking if a name was provide
if [ $# -eq 0 ]; then
    # for no name
    echo "Hope you have a great day!"
else
    # yes name, greet with name
    echo "Good day, $1! Nice to meet you!"
fi