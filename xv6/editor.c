
#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "textframe.h"
#include "init_ascii.h"

void refresh(struct textframe *text) {
    int r;
    drawrect(0, 0, 800, 600, 65535);
    for (r = 0; r < text->maxrow; ++ r) {
        int len = strlen(text->data[r]), col;
        for (col = 0; col < len; ++ col) {
            drawarea(col * 8, r * 16, 8, 16, get_text_area(text->data[r][col]));
        }
    }
    update();
}

void putc_to_str(char **s, int c) {
    int len = strlen(*s);
    char *new_s = (char*) malloc(len + 2);
    memmove(new_s, *s, len);
    new_s[len] = c;
    new_s[len+1] = '\0';
    free(*s);
    *s = new_s;
}

void backspace_to_str(char **s) {
    int len = strlen(*s);
    if (len > 0)
        (*s)[len-1] = '\0';
}

#define BACKSPACE  8
#define ENTER      10


int main() {
    struct textframe text;

    char_point_init();
    textframe_write(&text, "1.txt");
    textframe_read(&text, "1.txt");

    while (1) {
        int c = get_msg();
        if (c != 0) {
            // printf(1, "kbd num = %d, c = %c\n", c, c);

            switch (c)
            {
            case BACKSPACE:
                backspace_to_str(&(text.data[text.maxrow-1]));
                break;
            case ENTER:
                break;
            default:
                putc_to_str(&(text.data[text.maxrow-1]), c);
                break;
            }

            refresh(&text);
        }
    }
}
