#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"

#define KBD_C_QUEUE_LENGTH 100

/*
    The message format:
        m = get_msg()
        type = (m >> 24)

        when type is mouse_opt:
            x = (m >> 12) & 0xfff
            y = m & 0xfff
*/

int message[KBD_C_QUEUE_LENGTH];
int front = 0;
int tail = 0;

void add_kbd_msg(int c) {
    message[tail++] = c;
    if (tail == KBD_C_QUEUE_LENGTH)
        tail = 0;
}

void add_mouse_msg(enum MSG_TYPE mouse_opt, int x, int y) {
    message[tail++] = mouse_opt << 24 | x << 12 | y;
}

int sys_get_msg(void) {
    if (front == tail) {
        return 0;
    } else {
        int res = message[front ++];
        if (front == KBD_C_QUEUE_LENGTH)
            front = 0;
        return res;
    }
}
