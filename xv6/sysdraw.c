#include "vesamode.h"
#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"

#define SCREEN_HEIGHT_EXPECT 600
#define SCREEN_WIDTH_EXPECT  800

ushort VESA_TEMP[SCREEN_WIDTH_EXPECT * SCREEN_HEIGHT_EXPECT];

void update() {
    memmove(VESA_ADDR, VESA_TEMP, sizeof (ushort) * SCREEN_WIDTH_EXPECT * SCREEN_WIDTH_EXPECT);
}

int set_color(int x, int y, int color) {
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT || color >= 65536) {
        return -1;
    }
    VESA_TEMP[x + y * SCREEN_WIDTH] = (unsigned short) color;
    return 0;
}
// (2^5-1, 0, 0) 31 << 11
// (0, 2^6-1, 0) 63 << 5
// 将点 (xl, yl) 到点 (xl + width, yl + height) 的范围变成颜色 color.

int drawrect(int xl, int yl, int width, int height, int color) {
    int x, y;
    for (y = yl; y < yl + height; ++ y)
        for (x = xl; x < xl + width; ++ x) {
            set_color(x, y, color);
        }
}

int drawarea(int xl, int yl, int width, int height, int *colors) {
    int x, y;

    for (y = yl; y<yl+height; ++y)
        for (x = xl; x < xl+width; ++x) {
            set_color(x, y, colors[x-xl + (y-yl) * width]);
        }
}

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

    drawrect(xl, yl, width, height, color);
    update();

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

    drawarea(xl, yl, width, height, colors);
    update();

cprintf("drawarea:\n");
for (int j=0;j<16;++j){
    for (int i = 0; i < 8; ++i)
        cprintf("%d",colors[i+j*8]);
    cprintf("\n");
}
    return 0;
}
