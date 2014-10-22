#include "defer.h"
#include <signal.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#define SIG SIGRTMIN

typedef struct
{
	callback_t callback;
	void *proc_obj;
	struct timespec waitTime;
	struct timespec creationTime;
} Job;

typedef struct
{ 
	Job **elements;
	int size;
	int capacity;
} JobArray;

void addJob(JobArray *jobs, Job *newJob)
{
	if( jobs->size == jobs->capacity )
	{
		if( jobs->capacity == 0 )
			jobs->capacity = 1;
		else
			jobs->capacity *= 2;
		
		Job *tempJobs = realloc( jobs->elements, jobs->capacity * sizeof(Job *) );
		if( tempJobs != NULL )
			jobs->elements = tempJobs;
	}
	jobs->size++;
	jobs->elements[jobs->size - 1] = newJob;
}

Job* removeJob( JobArray *jobs, int pos )
{
	Job *removedJob = jobs->elements[pos];
	int i;
	for( i = pos; i < jobs->size - 1; i++ )
		jobs->elements[i] = jobs->elements[i+1];
	jobs->elements[jobs->size] = NULL;
	jobs->size--;
	if( jobs->size == 0 )//just in case we stop using this then we won't waste any memory
	{
		jobs->capacity = 0;
		free(jobs->elements);
		jobs->elements = NULL;
	}
	return removedJob;
}

JobArray g_jobs;

void handler( int signal )
{
	struct timespec now;
	clock_gettime(CLOCK_MONOTONIC, &now);
	
	Job *jobToRun = NULL;
	int i;
	for( i = 0; i < g_jobs.size; i++ )
	{
		if(  now.tv_sec - g_jobs.elements[i]->creationTime.tv_sec > g_jobs.elements[i]->waitTime.tv_sec ) 
		{
			jobToRun = removeJob( &g_jobs, i );
			break;
		}
		else if( now.tv_sec - g_jobs.elements[i]->creationTime.tv_sec == g_jobs.elements[i]->waitTime.tv_sec  
				&& now.tv_nsec - g_jobs.elements[i]->waitTime.tv_nsec >= g_jobs.elements[i]->creationTime.tv_nsec )
		{
			jobToRun = removeJob(&g_jobs, i );
			break;
		}
	}

	jobToRun->callback(jobToRun->proc_obj);
	free( jobToRun );
}



void deferNanoSec(callback_t callback, void *proc_obj, long long nanoSecs)
{
	timer_t timerid;
	struct sigevent sev;
	struct itimerspec its;
	sigset_t mask;
	struct sigaction sa;


	sa.sa_flags = SA_SIGINFO;
	sa.sa_sigaction = handler;
	sigemptyset(&sa.sa_mask);
	if (sigaction(SIG, &sa, NULL) == -1)
		printf("sigaction");

	/* Block timer signal temporarily */
	sigemptyset(&mask);
	sigaddset(&mask, SIG);
	if (sigprocmask(SIG_SETMASK, &mask, NULL) == -1)
		printf("sigprocmask");
	
	struct timespec tp, waitTime;
	clock_gettime(CLOCK_MONOTONIC, &tp);
	waitTime.tv_sec = nanoSecs / 1000000000;
	waitTime.tv_nsec = nanoSecs % 1000000000;

	Job* job = malloc( sizeof(Job) );
	job->callback = callback;
	job->proc_obj = proc_obj;
	job->creationTime = tp;
	job->waitTime = waitTime;

	addJob( &g_jobs, job );
	
	
	/* Create the timer */
	sev.sigev_notify = SIGEV_SIGNAL;
	sev.sigev_signo = SIG;
	sev.sigev_value.sival_ptr = &timerid;
	if (timer_create(CLOCK_REALTIME, &sev, &timerid) == -1)
		printf("timer_create");

	/* Start the timer */
	its.it_value = waitTime;
	its.it_interval.tv_sec = 0;
	its.it_interval.tv_nsec = 0;

	if (timer_settime(timerid, 0, &its, NULL) == -1)
		printf("timer_settime");

	/* Unlock the timer signal, so that timer notification
	 *               can be delivered */

	if (sigprocmask(SIG_UNBLOCK, &mask, NULL) == -1)
		printf("sigprocmask");
}
