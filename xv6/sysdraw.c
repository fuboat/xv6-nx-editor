#include "vesamode.h"
#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"

int set_color(int x, int y, int color) {
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT || color >= 65536) {
        return -1;
    }
    cprintf("SET x = %d y = %d color = %d from = %d\n", x, y, color, *VESA_ADDR);
    // VESA_ADDR[x + y * SCREEN_WIDTH] = (unsigned short) color;
    return 0;
}

// 将点 (xl, yl) 到点 (xr, yr) 的范围变成颜色 color.
int sys_drawrect(void)
{
    int xl, yl, width, height, color;
    if (argint(0, &xl) < 0 ||
    argint(1, &yl) < 0 ||
    argint(2, &width) < 0 ||
    argint(3, &height) < 0 ||
    argint(4, &color) < 0) {
        return -1;
    }

    int x, y;
    for (y = yl; y < yl + height; ++ y)
        for (x = xl; x < xl + width; ++ x) {
            set_color(x, y, color);
        }

    return 0;
}

int sys_drawarea(void) {
    int xl, yl, width, height;
    int *colors;

    if (argint(0, &xl) < 0 ||
    argint(1, &yl) < 0 ||
    argint(2, &width) < 0 ||
    argint(3, &height) < 0 ||
    argptr(4, (void*) &colors, sizeof(int) * width * height) < 0) {
        return -1;
    }

    int x, y;

    for (y = yl; y<yl+width; ++y)
        for (x = xl; x < xl+width; ++x) {
            set_color(x, y, colors[x-xl + (y-yl) * SCREEN_WIDTH]);
        }

    return 0;
}