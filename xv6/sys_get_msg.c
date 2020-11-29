#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"

#define KBD_C_QUEUE_LENGTH 100

int kbd_c_queue[KBD_C_QUEUE_LENGTH];
int front = 0;
int tail = 0;

void add_kbd_msg(int c) {
    kbd_c_queue[tail++] = c;
    if (tail == KBD_C_QUEUE_LENGTH)
        tail = 0;
}

int sys_get_msg(void) {
    if (front == tail) {
        return 0;
    } else {
        int res = kbd_c_queue[front ++];
        if (front == KBD_C_QUEUE_LENGTH)
            front = 0;
        return res;
    }
}
