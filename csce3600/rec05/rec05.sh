# Write a bash script called rec05.sh that curves the quiz grades using for loops,
# arrays, and functions as follows:
    # 1. Write a function called curve that will apply a given curve to an array of grades. This
    # function will take as input the curve amount, followed by the array of grades.
        # a. Assign the first positional parameter sent to the function to a user-defined
        # variable called incr.
        # b. Use the shift command with no arguments that will shift all arguments to the
        # left (that means the first positional parameter will disappear, but that’s OK
        # because we already assigned it to incr). The rest of the parameters represent
        # elements in the array passed to the function.
        # c. Now, assign the rest of the elements of the array to arr using ("$@"). See
        # recitation5-example.sh from my public directory for help on this and
        # other parts of this recitation.
        # d. Create a new user variable called index and assign the value 0.
        # e. Write a traditional for loop that uses the control variable i to iterate over the
        # elements of the array, as in "${arr[@]}". Inside the for loop, you will have
        # two lines:
            # i. Use let to assign the sum of the control variable i and the value of incr to
            # the array grades with subscript index.
            # ii. Then, increment the value of index by 1.
    # 2. Your program should accept 1 command-line argument: the amount that grades will
    # be curved in this script. If the number of positional parameters is not equal to 1
    # (meaning that nothing was passed in as a command-line argument), then you will print
    # out a usage statement indicating that the curve amount should be passed in as a
    # command-line argument.
    # 3. Otherwise, you will do the following:
        # a. Write a traditional bash for loop that iterates over the arguments 1, 2, 3, 4, and
        # 5. Inside the for loop, you will prompt for the user to enter their grade for a
        # numbered quiz (see SAMPLE OUTPUT) and store that value into an array called
        # 2
        # grades using the read command. When indexing into the array, be sure to
        # use $i-1, assuming i is the control variable of the for loop.
        # b. Call the curve function, passing in the first positional parameter (i.e., the amount
        # of the curve) and the array grades itself. The array can be passed using
        # "${grades[@]}".
        # c. Use echo to print out the message "Curved Grades:".
        # d. Now, use a C-like for loop to iterate through all elements of the grades array
        # and print out the text for the array element (see SAMPLE OUTPUT) along with the
        # value of the now curved grade. Take a look at the bash lecture notes or the
        # example recitation5-example.sh for details on how to do this.
# SAMPLE OUTPUT (input in asterisks):
# $ **./rec05.sh**
# usage: ./rec05.sh <curve amount>
# $ **./rec05.sh 5**
# Enter QUIZ #1: **92**
# Enter QUIZ #2: **84**
# Enter QUIZ #3: **75**
# Enter QUIZ #4: **88**
# Enter QUIZ #5: **96**
# Curved Grades:
# grades[0] = 97
# grades[1] = 89
# grades[2] = 80
# grades[3] = 93
# grades[4] = 101

# Alexis Aguilar (aa1732)
# CSCE 3600.208 Fall 2024
# 10/07/2024
# Recitation 05

#!/bin/bash

# Function to curve grades
curve() {
    incr=$1        # Assign first argument to incr (the curve amount)
    shift          # Shift the positional parameters to the left, removing the first argument (incr)
    arr=("$@")     # Assign the rest of the arguments (grades) to arr
    
    index=0        # Initialize index to 0
    
    # Iterate over the array of grades
    for i in "${arr[@]}"; do
        let grades[$index]=$i+$incr  # Apply the curve and assign it back to the grades array
        let index=$index+1            # Increment index by 1
    done
}

# Check if the number of arguments is not equal to 1
if [ $# -ne 1 ]; then
    echo "usage: $0 <curve amount>"
    exit 1
fi

# Read grades from the user
for (( i=1; i<=5; i++ )); do
    read -p "Enter QUIZ #$i: " grade  # Prompt the user to enter a grade
    grades[$((i-1))]=$grade            # Store the entered grade in the grades array
done

# Call the curve function with the curve amount and the grades array
curve $1 "${grades[@]}"

# Output the curved grades
echo "Curved Grades:"
for (( i=0; i<${#grades[@]}; i++ )); do
    echo "grades[$i] = ${grades[$i]}"
done