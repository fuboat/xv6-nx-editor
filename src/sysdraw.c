#include "vesamode.h"
#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "mouse.h"

#define SCREEN_HEIGHT_EXPECT 600
#define SCREEN_WIDTH_EXPECT  800

ushort VESA_TEMP[SCREEN_WIDTH_EXPECT * SCREEN_HEIGHT_EXPECT];

#define B 0x0000,
#define W 0xffff,

int mouse[100] = {
2145, 25388, 44373, 63390, 65535, 65535, 65535, 63422, 63422, 63422, 
25388, 0, 0, 0, 4258, 29582, 54938, 65535, 65535, 63422, 
44405, 0, 0, 0, 0, 0, 0, 0, 16936, 63422, 
63422, 0, 0, 0, 0, 0, 0, 0, 38034, 65535, 
65535, 6339, 0, 0, 0, 0, 0, 44405, 65535, 63422, 
65535, 29582, 0, 0, 0, 0, 0, 0, 38066, 65535, 
65503, 54938, 0, 0, 0, 0, 0, 0, 0, 42260, 
63422, 65535, 0, 0, 44405, 0, 0, 0, 0, 0, 
63422, 65535, 16936, 38034, 65535, 38066, 0, 0, 0, 65535, 
63390, 65503, 63422, 65535, 63422, 65535, 42260, 0, 65535, 65535, 
};

int set_color_force(int x, int y, int color);

int drawarea_force(int xl, int yl, int width, int height, int *colors) {
    int x, y;

    for (y = yl; y<yl+height; ++y)
        for (x = xl; x < xl+width; ++x) {
            set_color_force(x, y, colors[x-xl + (y-yl) * width]);
        }
    
    return 0;
}

void draw_mouse(int x, int y) {
    drawarea_force(x, y, 10, 10, mouse);
    // drawrect_force(x, y, 10, 10, 0);
}

void update() {
    memmove(VESA_ADDR, VESA_TEMP, sizeof (ushort) * SCREEN_WIDTH_EXPECT * SCREEN_WIDTH_EXPECT);

    int mouse_x, mouse_y;

    get_mouse_pos(& mouse_x, & mouse_y);
    draw_mouse(mouse_x, mouse_y);
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

int drawarea_color(int xl, int yl, int width, int height, int color, int *colors) {
    int x, y, i, j;

    for (y = yl; y<yl+height; ++y)
        for (x = xl; x < xl+width; ++x) {
            j = x - xl;
            i = y - yl;
            j = j * 8 / width;
            i = i * 16 / height;
            int c = colors[j + i * 8];
            if (c != -1)
                set_color(x, y, color);
        }
    
    return 0;
}

int drawgbk_color(int xl, int yl, int width, int height, int color, char * gbk) {
    int n = 0;

    int i, j, k, x, y;

    int colors[16][16] = {0};

    for (i = 0; i < 16; i++) // 16x16点阵汉字
        for (j = 0; j < 2; j++)
            for (k = 0; k < 8; k++) {
                if (gbk[i * 2 + j] & (0x80 >> k))
                    colors[n % 16][n / 16] = color;
                else
                    colors[n % 16][n / 16] = -1;
                ++ n;
            }
    
    for (y = yl; y<yl+height; ++y)
        for (x = xl; x < xl+width; ++x) {
            j = x - xl;
            i = y - yl;
            j = j * 16 / width;
            i = i * 16 / height;
            int c = colors[j][i];
            if (c != -1)
                set_color(x, y, c);
        }
    
    return 0;
}

int drawgbk(int xl, int yl, int width, int height, char * gbk) {
    int n = 0;

    int i, j, k;
    for (i = 0; i < 16; i++) // 16x16点阵汉字
        for (j = 0; j < 2; j++)
            for (k = 0; k < 8; k++) {
                if (gbk[i * 2 + j] & (0x80 >> k)) {
                    set_color(xl + n % width, yl + n / width, 0);
                }
                ++ n;
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

int sys_drawgbk(void) {
    int xl, yl, width, height;
    char * gbk;

    if (argint(0, &xl) < 0 ||
    argint(1, &yl) < 0 ||
    argint(2, &width) < 0 ||
    argint(3, &height) < 0 ||
    argptr(4, (void*) &gbk, sizeof(char) * 32) < 0) {
        return -1;
    }

    drawgbk(xl, yl, width, height, gbk);

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

int sys_drawgbk_color(void) {
    int xl, yl, width, height, color;
    char * gbk;

    if (argint(0, &xl) < 0 ||
    argint(1, &yl) < 0 ||
    argint(2, &width) < 0 ||
    argint(3, &height) < 0 ||
    argint(4, &color) < 0 ||
    argptr(5, (void*) &gbk, sizeof(char) * 32) < 0) {
        return -1;
    }

    drawgbk_color(xl, yl, width, height, color, gbk);

    return 0;
}

int sys_drawarea_color(void) {
    int xl, yl, width, height, color;
    int *colors;

    if (argint(0, &xl) < 0 ||
    argint(1, &yl) < 0 ||
    argint(2, &width) < 0 ||
    argint(3, &height) < 0 ||
    argint(4, &color) < 0 ||
    argptr(5, (void*) &colors, sizeof(int) * width * height) < 0) {
        return -1;
    }

    drawarea_color(xl, yl, width, height, color, colors);

    return 0;
}

int sys_update(void) {
    update();
    return 0;
}