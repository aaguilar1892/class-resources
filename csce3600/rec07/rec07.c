#include <stdio.h>
#include <string.h>
#include <pthread.h>

#define SIZE 50

char sentence[2000];
int ind = 0;
pthread_mutex_t lock;  // Declare a mutex lock

char convertUppercase(char lower) {
    // Converts lowercase to uppercase
    if ((lower > 96) && (lower < 123)) {
        return (lower - 32);
    } else {
        return lower;
    }
}

void printChar() {
    // Prints the converted sentence
    printf("The new sentence is [%d]: \t%c\n", ind, sentence[ind]);
    ind++;
}

void *convertMessage(void *ptr) {
    // Function that each thread initiates its execution
    pthread_mutex_lock(&lock);  // Lock the mutex before modifying shared data

    if (ind % 2) {
        sentence[ind] = convertUppercase(sentence[ind]);
    }
    
    printChar();

    pthread_mutex_unlock(&lock);  // Unlock the mutex after finishing

    return 0;
}

int main() {
    int i;
    char buffer[SIZE];
    char *p;
    pthread_t ts[SIZE];  // Define up to 50 threads

    pthread_mutex_init(&lock, NULL);  // Initialize the mutex

    printf("Please enter a phrase (less than 50 characters): ");

    if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
        if ((p = strchr(buffer, '\n')) != NULL) {
            *p = '\0';
        }
    }

    strcpy(sentence, buffer);  // Copy string to char array

    printf("The original sentence is: \t %s\n", sentence);

    // Create one thread for each character in the input sentence
    for (i = 0; i < strlen(buffer) + 1; ++i) {
        pthread_create(&ts[i], NULL, convertMessage, NULL);
    }
    
    // Wait until all threads finish execution
    for (i = 0; i < strlen(buffer); i++) {
        pthread_join(ts[i], NULL);
    }

    // Destroy the mutex after threads are done
    pthread_mutex_destroy(&lock);

    printf("\n");

    return 0;
}