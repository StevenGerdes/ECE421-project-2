#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/inotify.h>

#define EVENT_SIZE  ( sizeof (struct inotify_event) )
#define BUF_LEN     ( 1024 * ( EVENT_SIZE + 16 ) )

void watch( char* path, char* fileName, int watchType ) 
{
	int notRead = 1;
	while ( notRead )
	{
		int length, i = 0;
		int fd;
		int wd;
		char buffer[BUF_LEN];


		fd = inotify_init();

		if ( fd < 0 ) {
			perror( "inotify_init" );
		}

		wd = inotify_add_watch( fd, path, watchType );

		length = read( fd, buffer, BUF_LEN );  

		if ( length < 0 ) {
			return;
		}  

		while ( i < length ) {
			struct inotify_event *event = ( struct inotify_event * ) &buffer[ i ];
			printf("%s\n", event->name);
			printf("%s\n", fileName);
			printf("%d\n", strncmp(event->name, fileName, 10 ));
			if ( strncmp(event->name, fileName, 10) == 0 )			
				notRead = 0;
			
			i += EVENT_SIZE + event->len;
		}
		( void ) inotify_rm_watch( fd, wd );
		( void ) close( fd );
	}

}
