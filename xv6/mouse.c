#include "types.h"
#include "x86.h"
#include "traps.h"
#include "defs.h"
#include "spinlock.h"
#include "vesamode.h"

#define MOUSE_X_MIN 0
#define MOUSE_X_MAX 800
#define MOUSE_Y_MIN 0
#define MOUSE_Y_MAX 600

static struct spinlock mouse_lock;

static int count = 0;

static int x_overflow, y_overflow;
static int x_sign, y_sign;
static int btn_left, btn_right, btn_mid;

static int btn_left_down = 0;
static int btn_right_down = 0;

static int x_delta, y_delta;

static int x_pos = 400, y_pos = 300;

void get_mouse_pos(int *x, int *y) {
    *x = x_pos;
    *y = y_pos;
}

void mouseinit(void) {
    outb(0x64, 0xa8);
    outb(0x64, 0xd4);
    outb(0x60, 0xf4);
    outb(0x64, 0x60);
    outb(0x60, 0x47);

    initlock(&mouse_lock, "mouse");
    picenable(IRQ_MOUSE);
    ioapicenable(IRQ_MOUSE, 0);
}

void mouseintr(void) {
    uint st;

    st = inb(0x64);
    if ((st & 0x01) == 0) {
        count = 0;
        return ;
    }

    acquire(&mouse_lock);

    uint data = inb(0x60);
    
    ++ count;

    switch(count) {
        case 1:
        if ((data & 0x08) && (data & 0x04) == 0) {
            // data is valid.
            // get status from the bits of data.
            btn_left = !!(data & 0x01);
            btn_right = !!(data & 0x02);
            btn_mid = !!(data & 0x04);
            x_sign = !!(data & 0x10);
            y_sign = !!(data & 0x20);
            x_overflow = !!(data & 0x40);
            y_overflow = !!(data & 0x80);
        } else {
            // error mouseintr info
            count = 0;
        }
        break;
        case 2:
        // data means x movement. when x_sign == -1, means the delta is a nagetive number.
        x_delta = data - x_sign * 256;
        break;
        case 3:
        // data means y movement.
        y_delta = data - y_sign * 256;

#define abs(x) ((x > -x)? x : (-x))

        if (abs(x_delta) > 100 || abs(y_delta) > 100) {
            count = 0;
            break;
        }

        update_area(x_pos, y_pos, 10, 10);

        x_pos += x_delta;
        y_pos -= y_delta;

#define CHECK_IN_RANGE(v, MIN, MAX) if (v < MIN) v = MIN; if (v >= MAX) v = MAX - 1;
        CHECK_IN_RANGE(x_pos, MOUSE_X_MIN, MOUSE_X_MAX);
        CHECK_IN_RANGE(y_pos, MOUSE_Y_MIN, MOUSE_Y_MAX);
#undef  CHECK_IN_RANGE

        // cprintf("MOUSE x_pos = %d, y_pos = %d x_delta = %d y_delta = %d\n", x_pos, y_pos, x_delta, y_delta);
        // drawrect_force(x_pos, y_pos, 10, 10, 0);
        draw_mouse(x_pos, y_pos);
        if (btn_left && !btn_left_down) add_mouse_msg(MOUSE_LEFT_PRESS, x_pos, y_pos);
        else if (!btn_left && btn_left_down) add_mouse_msg(MOUSE_LEFT_RELEASE, x_pos, y_pos);
        else if (btn_right && !btn_right_down) add_mouse_msg(MOUSE_RIGHT_PRESS, x_pos, y_pos);
        else if (!btn_right && btn_right_down) add_mouse_msg(MOUSE_RIGHT_RELEASE, x_pos, y_pos);
        else add_mouse_msg(MOUSE_MOVE, x_pos, y_pos);

        btn_left_down = btn_left;
        btn_right_down = btn_right;

        // if (btn_left) cprintf("[SYS] btn left msg.\n");
        // if (btn_right) cprintf("[SYS] btn right msg.\n");

        // all information get. a new circle.
        count = 0;
        break;

        default:
        // other unexpected status
        count = 0;
        break;
    }

    release(&mouse_lock);
}