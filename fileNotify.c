/*
 * This codes is adpated from the example here: http://www.ibm.com/developerworks/library/l-ubuntu-inotify/
 * I didn't change a lot so I am citing it.
 * 
*/



#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/inotify.h>

#include "fileNotify.h"

#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )

/* Watches a file for either a deletion, creation, or alteration depending on what watchType is set to
 * str is the name of the file to watch. The functions returns when the desired event occurs.
*/
void watch( char* str, int watchType ) 
{
	int length, i = 0;
	int fd;
	int wd;
	char buffer[BUF_LEN];

	char *fileName = str;
	printf(fileName);
	
	fd = inotify_init();

	if ( fd < 0 ) {
		perror( "inotify_init" );
	}

	wd = inotify_add_watch( fd, fileName, watchType );
	int notRead = 1;
	
	while ( notRead )
	{
		length = read( fd, buffer, BUF_LEN );  

		if ( length < 0 ) {
				return;
		}  

		while ( i < length ) {
			struct inotify_event *event = ( struct inotify_event * ) &buffer[ i ];
			if ( event->len && strncmp(event->name, fileName, 10) == 0 )			
				notRead = 0;

			i += EVENT_SIZE + event->len;
		}
	}

	( void ) inotify_rm_watch( fd, wd );
	( void ) close( fd );
}
