/* minor3.c - using producer-consumer paradigm. */

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define NITEMS 10		// number of items in shared buffer

// shared variables
char shared_buffer[NITEMS];	// echo buffer
int shared_count = 0;		// item count

pthread_mutex_t mutex;		// pthread mutex
pthread_cond_t cond_full;    // condition variable for full buffer
pthread_cond_t cond_empty;   // condition variable for empty buffer
unsigned int prod_index = 0; 	// producer index into shared buffer
unsigned int cons_index = 0; 	// consumer index into shared buffer

// function prototypes
void * producer(void *arg);
void * consumer(void *arg);

int main() 
{ 
	pthread_t prod_tid, cons_tid1, cons_tid2; 

	// initialize pthread variables
	pthread_mutex_init(&mutex, NULL);
	pthread_cond_init(&cond_full, NULL);
	pthread_cond_init(&cond_empty, NULL);
	
	// start producer thread
	pthread_create(&prod_tid, NULL, producer, NULL);

	// start consumer threads
	pthread_create(&cons_tid1, NULL, consumer, NULL);
	pthread_create(&cons_tid2, NULL, consumer, NULL);
	
	// wait for threads to finish
	pthread_join(prod_tid, NULL);
	pthread_join(cons_tid1, NULL);
	pthread_join(cons_tid2, NULL);
			
	// clean up
	pthread_mutex_destroy(&mutex);
	pthread_cond_destroy(&cond_full);
	pthread_cond_destroy(&cond_empty);
	
	return 0;
}

// producer thread executes this function
void * producer(void *arg)
{
	char key;

	printf("Enter text for producer to read and consumer to print, use Ctrl-C to exit.\n\n");

	while (1)
	{
		// read input key
		scanf("%c", &key);

		pthread_mutex_lock(&mutex);

		// wait until the buffer has space (i.e., it's not full)
		while (shared_count == NITEMS)
		{
			pthread_cond_wait(&cond_full, &mutex); // wait on full condition
		}

		// store key in shared buffer
		shared_buffer[prod_index] = key;

		// update shared count variable
		shared_count++;

		// update producer index
		if (prod_index == NITEMS - 1)
			prod_index = 0;
		else
			prod_index++;

		// signal that the buffer is not empty anymore
		pthread_cond_signal(&cond_empty);

		pthread_mutex_unlock(&mutex); 
	}

	return NULL;
}

// consumer thread executes this function
void * consumer(void *arg)
{
	char key;
	long unsigned int id = (long unsigned int)pthread_self();

	while (1)
	{
		pthread_mutex_lock(&mutex);

		// wait until the buffer has something to consume (i.e., it's not empty)
		while (shared_count == 0)
		{
			pthread_cond_wait(&cond_empty, &mutex); // wait on empty condition
		}

		// read key from shared buffer
		key = shared_buffer[cons_index];
		
		// echo key
		printf("consumer %lu: %c\n", id, key);

		// update shared count variable
		shared_count--;

		// update consumer index
		if (cons_index == NITEMS - 1)
			cons_index = 0;
		else
			cons_index++;

		// signal that the buffer is not full anymore
		pthread_cond_signal(&cond_full);

		pthread_mutex_unlock(&mutex);
	}

	return NULL;
}