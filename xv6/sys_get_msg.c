#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"

int kbd_c = 0;

void add_kbd_msg(int c) {
    kbd_c = c;
}

int sys_get_msg(void) {
    int res = kbd_c;
    kbd_c = 0;
    return res;
}