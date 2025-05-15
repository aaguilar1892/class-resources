# SCRIPT DESCRIPTION:
# Write a complete bash script that monitors who logs in and logs out of the current CSE
# Linux machine (e.g., cell01, cell02, etc.) where the script is running.
#   - You will check the status of who is logged in every 10 seconds and report each
#   user ID that logs in or logs out during that time frame. Note that there may be
#   more than one user that logs in or out during this interval.
#   - You must include the host name when reporting the user ID information.
#   - In addition, you will install a custom signal handler to trap the SIGINT (i.e., ^C)
#   one time before you are able to terminate the script with the SIGINT.
#   - You will also print out the current date and time and report the number of users
#   logged in, even if there are no changes (i.e., no one logged in or out during the
#   interval).
# Please see the SAMPLE OUTPUT for several examples, including the different
# scenarios that might occur.

# REQUIREMENTS:
# • Your script should be well documented in terms of comments. For example, good
# comments in general consist of a header (with your name, course section, date,
# and brief description), comments for each variable, and commented blocks of
# code. • Your bash script should be named “minor2.sh”, without the quotes.
# Note that this must be done as a bash script, not a C program.
# • Your script will be graded based largely on whether it works correctly on the
# CELL machines (e.g., cell01, cell02, ..., cell06), so you should make sure
# that your script runs on a CELL machine.
# • Please pay attention to the SAMPLE OUTPUT for how this script is expected to
# work. If you have any questions about this, please contact your instructor or TAs
# assigned to this course to ensure you understand these directions.
# • This is an individual programming assignment that must be the sole work of the
# individual student. Any instance of academic dishonesty will result in a grade of
# “F” for the course, along with a report filed into the Academic Integrity Database.
# SAMPLE OUTPUT (user input shown in bold):
# $ ./minor2.sh
# Thu Jun 13 01:05:25 CST 2024) initial users logged in
# > xyz0123 logged in to cell01
# > abc0456 logged in to cell01
# > def0789 logged in to cell01
# > sp1568 logged in to cell01 >
# mn0012 logged in to cell01
# > rst0034 logged in to cell01
# > jkl0056 logged in to cell01
# > uv0078 logged in to cell01
# Thu Jun 13 01:05:25 CST 2024) # of users: 8
# Thu Jun 13 01:05:35 CST 2024) # of users: 8
# Thu Jun 13 01:05:45 CST 2024) # of users: 8
# Thu Jun 13 01:05:55 CST 2024) # of users: 8 Thu
# Jun 13 01:06:05 CST 2024) # of users: 8 > sp1568
# logged in to cell01
# Thu Jun 13 01:06:15 CST 2024) # of users: 9
# Thu Jun 13 01:06:25 CST 2024) # of users: 9
# > sp1568 logged in to cell01
# >
# > mn0012 logged out of cell01
# Thu Jun 13 01:06:35 CST 2024) # of users: 9
# Thu Jun 13 01:06:45 CST 2024) # of users: 9
# ^C (SIGINT) ignored. enter ^C 1 more time to terminate program.
# Thu Jun 13 01:06:52 CST 2024) # of users: 9 ^C

########################################################################

#!/bin/bash

# minor2.sh
# Alexis Aguilar (aa1732)
# CSCE 3600.004 - Principles of Systems Programming
# Fall 2024 - 09/25/2024

# Script to monitor user login/logout activities on the current CSE Linux machine
# It checks every 10 seconds and reports changes
# Includes custom signal handler for SIGINT

# Function to handle SIGINT (Ctrl+C)
sigint_handler() {
  if [[ $SIGINT_COUNT -lt 1 ]]; then
    echo "^C (SIGINT) ignored. enter ^C 1 more time to terminate program."
    SIGINT_COUNT=$((SIGINT_COUNT+1))
  else
    echo "Terminating the script..."
    exit 0
  fi
}

# Register the SIGINT handler
trap sigint_handler SIGINT

# Variables
HOSTNAME=$(hostname)  # Get the hostname of the machine
PREVIOUS_USERS=$(who | awk '{print $1}')  # Get the list of currently logged-in users
SIGINT_COUNT=0  # Track the number of SIGINT occurrences

# Main loop
while true; do
  # Capture the current date and time
  CURRENT_TIME=$(date "+%a %b %d %T %Z %Y")
  
  # Get the list of currently logged-in users
  CURRENT_USERS=$(who | awk '{print $1}')
  
  # Compare previous and current user lists
  # Report if anyone has logged in or out
  for user in $CURRENT_USERS; do
    if [[ ! " $PREVIOUS_USERS " =~ " $user " ]]; then
      echo "> $user logged in to $HOSTNAME"
    fi
  done

  for user in $PREVIOUS_USERS; do
    if [[ ! " $CURRENT_USERS " =~ " $user " ]]; then
      echo "> $user logged out of $HOSTNAME"
    fi
  done

  # Display the current time and the number of logged-in users
  NUM_USERS=$(echo "$CURRENT_USERS" | wc -l)
  echo "$CURRENT_TIME) # of users: $NUM_USERS"
  
  # Update the previous user list
  PREVIOUS_USERS=$CURRENT_USERS

  # Wait for 10 seconds before the next check
  sleep 10
done