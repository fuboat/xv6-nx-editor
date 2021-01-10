
#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "textframe.h"
#include "init_ascii.h"
#include "background.h"

#define RGB(r,g,b) ((r >> 3) << 11 | (g >> 2) << 5 | (b >> 3))

void refresh(struct textframe *text) {
    int beginx = 236, beginy = 55;

    // 绘制背景
    drawarea_short(0, 0, 800, 600, background);
    printf(1, "text->cursor_row = %d, text->cursor_col = %d\n", text->cursor_row, text->cursor_col);

    // 绘制光标
    drawrect(beginx + text->cursor_col * 8, beginy + text->cursor_row * 16, 8, 16, RGB(0xa0, 0xa0, 0xa0));
    for (int r = 0; r < text->maxrow; ++ r) {
        int len = strlen(text->data[r]), col;
        for (col = 0; col < len; ++ col) {
            drawarea(beginx + col * 8, beginy + r * 16, 8, 16, get_text_area(text->data[r][col]));
        }
    }
    update();
}

#define BACKSPACE   8
#define ENTER       10
#define LEFT_ARROW  228
#define RIGHT_ARROW 229
#define UP_ARROW    226
#define DOWN_ARROW  227

ushort background[800 * 600];

void background_init() {
    int height = 600;
    int width = 800;
    int total = height * width;

    for (int i = 0; i < total; ++ i) {
        background[i] = 59196;
    }

    for (int i = 0; i < 52 * 800; ++ i) {
        background[i] = 65535;
    }

    int x1 = 1, xe = 229, y1 = 54, y1_e = 85;

    for (int x = x1; x < xe; ++ x) {
        for (int y = y1; y < y1_e; ++ y) {
            background[x + y * width] = 50712;
        }
    }

    int x2 = 1, y2 = 90, y2_e = 600;

    for (int x = x2; x < xe; ++ x) {
        for (int y = y2; y < y2_e; ++ y) {
            background[x + y * width] = 50712;
        }
    }
}

int main() {
    struct textframe text;
    
    text.cursor_row = 0, text.cursor_col = 0;

    background_init();
    char_point_init();
    textframe_write(&text, "1.txt");
    textframe_read(&text, "1.txt");

    refresh(&text);

    while (1) {
        int c = get_msg();
        // int len;

        if (c != 0) {
            printf(1, "kbd num = %d, c = %c\n", c, c);

            switch (c)
            {
            case ENTER:
                new_line_to_editor(&text);
                break;

            case LEFT_ARROW: case BACKSPACE:
                move_to_previous_char(&text);

                if (c == BACKSPACE) {
                    backspace_to_str(&text);
                }

                break;

            case RIGHT_ARROW:
                move_to_next_char(&text);
                break;

            case UP_ARROW:
                move_to_last_line(&text);
                break; 
            case DOWN_ARROW:
                move_to_next_line(&text);
                break;
            default: {
                if (32 <= c && c <= 126) {
                    putc_to_str(&text, c);
                    move_to_next_char(&text);
                }
                break;
            }
            }

            refresh(&text);
        }
    }
}
