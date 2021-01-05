#include "vesamode.h"
#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "mouse.h"

#define SCREEN_HEIGHT_EXPECT 600
#define SCREEN_WIDTH_EXPECT  800

ushort VESA_TEMP[SCREEN_WIDTH_EXPECT * SCREEN_HEIGHT_EXPECT];

void update() {
    memmove(VESA_ADDR, VESA_TEMP, sizeof (ushort) * SCREEN_WIDTH_EXPECT * SCREEN_WIDTH_EXPECT);

    int mouse_x, mouse_y;

    get_mouse_pos(& mouse_x, & mouse_y);
    drawrect_force(mouse_x, mouse_y, 10, 10, 0);
}

void update_area(int xl, int yl, int width, int height) {
    int x, y;
    for (y = yl; y < yl + height; ++ y)
        for (x = xl; x < xl + width; ++ x) {
            VESA_ADDR[x + y * SCREEN_WIDTH] = VESA_TEMP[x + y * SCREEN_WIDTH];
        }
}

void reverse_update() {
    memmove(VESA_TEMP, VESA_ADDR, sizeof (ushort) * SCREEN_WIDTH_EXPECT * SCREEN_WIDTH_EXPECT);
}

int set_color(int x, int y, int color) {
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT || color >= 65536 || color < 0) {
        return -1;
    }
    VESA_TEMP[x + y * SCREEN_WIDTH] = (unsigned short) color;
    return 0;
}

int set_color_force(int x, int y, int color) {
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT || color >= 65536 || color < 0) {
        return -1;
    }
    VESA_ADDR[x + y * SCREEN_WIDTH] = (unsigned short) color;
    return 0;
}

int drawrect_force(int xl, int yl, int width, int height, int color) {
    int x, y;
    for (y = yl; y < yl + height; ++ y)
        for (x = xl; x < xl + width; ++ x) {
            set_color_force(x, y, color);
        }
    return 0;
}

// (2^5-1, 0, 0) 31 << 11
// (0, 2^6-1, 0) 63 << 5
// 将点 (xl, yl) 到点 (xl + width, yl + height) 的范围变成颜色 color.

int drawrect(int xl, int yl, int width, int height, int color) {
    if (color >= 65536 || color < 0) {
        return -1;
    } else if (xl == 0 && yl == 0 && width == 800 && height == 600 && color == 65535) {
        memset(VESA_TEMP, 0xff, sizeof(ushort) * SCREEN_WIDTH * SCREEN_HEIGHT);
    } else {
        int x, y;
        for (y = yl; y < yl + height; ++ y)
            for (x = xl; x < xl + width; ++ x) {
                set_color(x, y, color);
            }
    }
    return 0;

}



int drawarea(int xl, int yl, int width, int height, int *colors) {
    int x, y;

    for (y = yl; y<yl+height; ++y)
        for (x = xl; x < xl+width; ++x) {
            set_color(x, y, colors[x-xl + (y-yl) * width]);
        }
    
    return 0;
}


int drawarea_short(int xl, int yl, int width, int height, ushort *colors) {
    if (xl == 0 && yl == 0 && width == 800 && height == 600) {
        memmove(VESA_TEMP, colors, sizeof(ushort) * width * height);
        return 0;
    }

    int x, y;

    for (y = yl; y<yl+height; ++y)
        for (x = xl; x < xl+width; ++x) {
            set_color(x, y, colors[x-xl + (y-yl) * width]);
        }
    return 0;
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

    return 0;
}

int sys_drawarea_short(void) {
    int xl, yl, width, height;
    ushort *colors;

    if (argint(0, &xl) < 0 ||
    argint(1, &yl) < 0 ||
    argint(2, &width) < 0 ||
    argint(3, &height) < 0 ||
    argptr(4, (void*) &colors, sizeof(ushort) * width * height) < 0) {
        return -1;
    }

    drawarea_short(xl, yl, width, height, colors);

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

    return 0;
}

int sys_update(void) {
    update();
    return 0;
}