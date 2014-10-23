#ifndef DEFER_FILE_NOTIFY_H
#define DEFER_FILE_NOTIFY_H

typedef void (*callback_t) (void *user_data);

long deferNanoSec(callback_t callback, void *user_data, long long waitTime);
void stop(long id);
void watch( char* path, char* nameFile, int watchType );

#endif
