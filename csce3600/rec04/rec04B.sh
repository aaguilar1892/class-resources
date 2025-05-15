# Write a bash script that (1) prompts the user to enter a Linux command and reads in
# the user’s input, (2) prints out a meaningful message with the user’s entered
# command to be executed, and finally (3) executes the user’s entered command. The
# Linux command is to be read in, not passed as a command-line argument. This bash
# script should be called rec04B.sh.
#
# SAMPLE OUTPUT (input in asterisks):
# $ ./rec04B.sh
# Enter Linux command to perform: **ls**
# Command to be executed: ls
# a.out Lab01A.c Lab02B.sh minor1.c minor2.c
# $ ./rec04B.sh
# Enter Linux command to perform: **ls -l**
# Command to be executed: ls -l
# total 44
# -rwx------ 1 mat0299 mat0299 7668 Feb 2 15:57 a.out
# -rw------- 1 mat0299 mat0299 66 Feb 9 00:04 Lab01A.c
# -rwx------ 1 mat0299 mat0299 281 Feb 10 2019 Lab02B.sh
# -rw------- 1 mat0299 mat0299 2055 Oct 4 09:38 minor1.c
# -rw------- 1 mat0299 mat0299 3145 Oct 8 19:47 minor2.c

# Alexis Aguilar (aa1732)
# Fall 2024 CSCE 3600 - Systems Programming
# Recitation 4

#!/usr/bin/bash

# prompt user for command
echo "Please enter a Linux command to execute: "
read user_command

# print out command entered
echo "You have entered the command: $user_command"
echo "Executing command now..."

# execute command
eval $user_command