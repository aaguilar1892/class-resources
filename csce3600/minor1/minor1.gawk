# Alexis Aguilar (aa1732)
# CSCE 3600.004
# Minor Assignment 1 - sed and gawk

# gawk

#Consider a list of angles in degrees, such as the following angles.txt file:
#Degrees
#135
#90
#2
#1860
#-45
#0
#-270
#1170
#-180
#-795
#-630
#
#When two angles have the same initial and terminal sides, they are called coterminal. This
#means that angles of 90° and -270° are coterminal as the following figure shows:
#In fact, all the following angles shown in the figure below are coterminal:
#We want to make sure that all angle values in degrees are between 0° < x < 360°.
#For any file containing a list of angles in degrees with the Degrees header line at
#the top (as in angles.txt), write a complete gawk program that prints out the
#original value of the angle in the file as well as its coterminal value between 0° < x <
#360°. In this file, for example, the gawk program should print the following:
#$ gawk -f minor1.gawk angles.txt
#135  135
#90   90
#186  60
#0    31
#-45  5
#0    0
#-270 90
#1170 90
#-180 18
#-795 0
#-630 28
#     5
#     90
#Formatting properly in columns as shown is required.

#!/usr/bin/gawk -f

BEGIN {
    # Print the header for the output
    printf("%-6s %-6s\n", "Angle", "Coterminal")
}

# Skip the header line in the input file
NR == 1 {
    next
}

# Function to compute coterminal angles in the range 0 < x < 360
function coterminal(angle) {
    # Ensure the angle is between 0 and 360
    angle = angle % 360
    if (angle < 0) {
        angle += 360
    }
    return angle
}

{
    # Calculate the coterminal angle for each input angle
    cot_angle = coterminal($1)
    
    # Print the original and coterminal angle, formatted to align in columns
    printf("%-6d %-6d\n", $1, cot_angle)
}
