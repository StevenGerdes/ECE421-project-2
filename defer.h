#ifndef CALLBACK_H
#define CALLBACK_H

typedef void (*callback_t) (void *user_data);

void deferNanoSec(callback_t callback, void *user_data, long long waitTime);

#endif
