#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char * highlight_file[] = { ".c", ".h" };
char * types[] = { "int", "short", "char", "void", "long", "float", "double" };
char * reserve[] = { "if", "else", "while", "continue", "break", "for", "inline", "struct" };
char * special[] = {"#", "//"};

#define RGB(r,g,b) ((r >> 3) << 11 | (g >> 2) << 5 | (b >> 3))

int types_color = RGB(2, 100, 255);
int reserve_color = RGB(152, 1, 152);
int special_color = RGB(0, 133, 30);

static int n;
static int ch[200][256];
static int deep[200];
static int colors[200];
static int include_alls[200];

int highlight_update(unsigned char c, int *status, int * color, int * count) {
    int u = * status;
    int nextu = ch[u][c];

    *status = nextu;

    if (colors[u] && nextu == 0 && !('a' <= c && c <= 'z') && !('0' <= c && c <= '9') && !(c == '_')) {
        *color = colors[u];
        *count = deep[u];
        return 0;
    } else if (colors[u] && nextu == u) {
        *color = colors[u];
        *count = 1;
        return 0;
    } else if (colors[nextu] && include_alls[nextu]) {
        *color = colors[nextu];
        *count = deep[nextu] - 1;
        return 0;
    } else {
        return -1;
    }
}

static int insert(char * s, int include_any) {
    int len = strlen(s);
    int u = 0;
    
    for (int i = 0; i < len; ++i) {
        unsigned char c = s[i];
        if (!ch[u][c]) {
            ch[u][c] = ++ n;
            deep[n] = deep[u] + 1;
        }
        u = ch[u][c];
    }

    if (include_any) {
        for (int i = 0; i < 256; ++ i) {
            ch[u][i] = u;
        }
        include_alls[u] = 1;
    }

    return u;
}

void highlight_init() {
    printf(0, "highlight init...\n");
    for (int i = 0; i < sizeof(types) / sizeof(char *); ++ i) {
        colors[insert(types[i], 0)] = types_color;
    }

    for (int i = 0; i < sizeof(reserve) / sizeof(char *); ++ i) {
        colors[insert(reserve[i], 0)] = reserve_color;
    }

    for (int i = 0; i < sizeof(special) / sizeof(char *); ++ i) {
        colors[insert(special[i], 1)] = special_color;
    }

    char *s = "int ";

    int status = 0;
    int color = 0;
    int count = 0;

    for (int i = 0; i < strlen(s); ++ i) {
        int c = s[i];
        int r = highlight_update(c, &status, &color, &count);
        printf(0, "r = %d\n", r);
        printf(0, "%d %d %d\n", status, color, count);
    }
}