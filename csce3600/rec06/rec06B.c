//Orphan Process

/*
Recall that a child process whose parent has terminated is referred to as an orphan
process. This means that the child is still executing, but its parent has terminated and
that some process is then needed to handle the child’s exit status. Use the 
following algorithm and specific instructions to develop a short, simple C program
called rec06B.c to create an orphan process.
    a. Add the include directives for the stdio.h, stdlib.h and unistd.h
    libraries.
    b. Declare a pointer to a char called name.
    c. Declare a variable called pid with the data type pid_t and invoke the
    fork() system call, assigning the result to pid.
    d. Write an if-else if-else branching statement to handle the child
    process, parent process, and error case, respectively.
        i. In the child process, print "child: %d started\n" using the getpid()
        system call for the %d. Then, print "child: parent = %d\n" using the
        getppid() system call for the %d. Now, print another child status
        (use "child: ...") to indicate the child is about to go to sleep. Then, sleep
        for 20 seconds. Finally, print a child status to indicate that the child just
        woke up.
        ii. In the parent process, print "parent: %d started\n" using the
        getpid() system call for the %d. Then print "parent: parent =
        %d\n" using the getppid() system call for the %d.
        iii. In the error case, call the perror() system call with "fork error".
    e. Outside of the if-else if-else branching statement, use the ternary
    operator (condition) ? (if_true) : (if_false) to assign "child"
    to the name character pointer if pid is 0 and "parent" otherwise. Then, print
    "%s: terminating...\n" using the name character pointer for the %s.
Now, compile and run your program. After your program initially runs, but before the
child process has terminated, enter the ps -ef|grep $USER command to see
your existing processes. You should notice your child process is still running, but has
1 for its parent process – this means that the init/systemd process has taken
over as the parent (since our parent terminated) and will handle the child once it has
terminated
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>

int main() {
    // Declare the char pointer variable name
    char *name;

    // Declare the variable pid of type pid_t
    pid_t pid;

    // Call fork() and assign its return value to pid
    pid = fork();

    // Check for child process, parent process, and error cases
    if (pid == 0) {
        // Child process: print information and go to sleep
        printf("child: %d started\n", getpid());
        printf("child: parent = %d\n", getppid());
        printf("child: going to sleep...\n");
        sleep(20); // Sleep for 20 seconds
        printf("child: just woke up\n");
    }
    else if (pid > 0) {
        // Parent process: print information and exit
        printf("parent: %d started\n", getpid());
        printf("parent: parent = %d\n", getppid());
        // Parent process terminates here (creating an orphaned child)
    }
    else {
        // Error case: fork() failed
        perror("fork error");
    }

    // Assign "child" to name if pid is 0, otherwise assign "parent"
    name = (pid == 0) ? "child" : "parent";

    // Print termination message
    printf("%s: terminating...\n", name);

    return 0;
}