// Zombie Process

/*
Recall that when a child terminates, but its parent is not currently waiting, the
terminated child process becomes a zombie process. Use the following algorithm and
specific instructions to develop a short, simple C program called rec06A.c to create
a zombie process.
    a. Add the include directives for the stdlib.h and unistd.h libraries.
    b. Declare a variable called pid with the data type pid_t and invoke the
    fork() system call, assigning the result to pid.
    c. Write an if – else if – else branching statement to handle the child
    process, parent process, and error case, respectively.
        i. In the child process, exit immediately.
        ii. In the parent process, sleep for 5 seconds, then issue the system()
        system call with "ps -e -o pid,ppid,stat,user,cmd | grep $USER". This
        prints out the current PID, parent PID, status, user ID, and command
        process information.
        iii. In the error case, call the perror() system call with "fork error".
Now, compile and run your program. After 5 seconds, you should see the result of the
ps command. Specifically, look for the process with the Z+ status. This is an indication
that it is a zombie process. This process should also be the child process of your parent
./a.out executable that contains the <defunct> indicator.
Now, on the command line, enter the ps -u $USER command to see your existing
processes. You should notice that this zombie process no longer exists as it has been
reaped by the init/systemd process.
*/

#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/types.h>

int main() {
    // Declare the variable pid of type pid_t
    pid_t pid;

    // Call fork() and assign its return value to pid
    pid = fork();

    // Check for child process, parent process, and error cases
    if (pid == 0) {
        // Child process: exit immediately
        exit(0);
    }
    else if (pid > 0) {
        // Parent process: sleep for 5 seconds, then call system command to check processes
        sleep(5);
        system("ps -e -o pid,ppid,stat,user,cmd | grep $USER");
    }
    else {
        // Error case: fork() failed
        perror("fork error");
    }

    return 0;
}