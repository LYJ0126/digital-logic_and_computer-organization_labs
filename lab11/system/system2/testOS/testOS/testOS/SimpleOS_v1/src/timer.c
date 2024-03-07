#include "io.h"

unsigned int get_time() {
    return *(unsigned int*)timer_start;
}

void wait(unsigned int dtime) {
    unsigned int now = get_time();
    while(get_time() - now < dtime);
}