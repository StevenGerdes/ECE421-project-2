#ifndef CALLBACK_H
#define CALLBACK_H


#include <stdint.h>
typedef void (*callback_t) (void *user_data);

long deferNanoSec(callback_t callback, void *user_data, long long waitTime);
void stop(long id);


#endif
