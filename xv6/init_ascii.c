#include "types.h"
#include "user.h"
// draw char
int char_to_point[256][16][8];
int char_to_area[256][16][8];
char gbk_to_point[320000];

char * get_gbk_point_by_offset(int offset) {
    if (offset < 0)
        return gbk_to_point;
    if (offset >= sizeof(gbk_to_point))
        return gbk_to_point;
    return gbk_to_point + offset;
}

char * get_gbk_point_by_c1_c2(int c1, int c2) {
    int qh = c1 - 0xa0;
    int wh = c2 - 0xa0;
    int offset = (94 * (qh - 1) + (wh - 1)) * 32L;
    return get_gbk_point_by_offset(offset);
}

void gbk_point_init(){
    printf(0, "gbk initializing...\n");

    int f[5];
    f[0] = open("hzk16-0", 0);
    f[1] = open("hzk16-1", 0);
    f[2] = open("hzk16-2", 0);
    f[3] = open("hzk16-3", 0);
    f[4] = open("hzk16-4", 0);
    
    int n = 0, n_read;

    for (int i = 0; i < 5; ++ i) {
        while ((n_read = read(f[i], gbk_to_point + n, sizeof(gbk_to_point) - n))) {
            n += n_read;
        }
    }

    int n_han = n / 32;

    printf(0, "success read %d han char bitmap.\n", n_han);
}

void char_point_init(){
    printf(0, "\n\ninitializing ASCII\n\n");
    int fp;
    char buffer[1024];
    if((fp = open("hankaku.txt", 0)) < 0){
        printf(0, "open hankaku.txt error");
        return;
    }

    int i = 0, n = 0;
    int x = 0, y = 0, char_ascii = 0;
    while((n = read(fp, buffer, sizeof(buffer))) > 0){
        for(i = 0; i < n; ++i){
            if(buffer[i] == '*' || buffer[i] == '.'){
                if(buffer[i] == '*'){
                    char_to_point[char_ascii][y][x] = 1;
                    char_to_area[char_ascii][y][x] = 0;
                }else{
                    char_to_area[char_ascii][y][x] = -1;
                }
                ++x;
                if(x >= 8){
                    x = 0;
                    ++y;
                }
                if(y >= 16){
                    y = 0;
                    ++char_ascii;
                }

            }
        }
    }
    //for(i = 0; i < 256; ++i){
        /*for(int j = 0; j < 16; ++j){
            for (int k = 0; k < 8; ++k){
                printf(0,"%d ", char_to_area['a'][j][k]);
            }
            printf(0, "\n");
        }
        printf(0,"\n----------\n");
    //}*/
}

void* get_text_area(char c){
    int num = c;
    return char_to_area[num];
}

void* get_text_point(char c){
    int num = c;
    return char_to_point[num];
}

// int main() {
//     while(1){
        
//     }
//     return 0;
// }

#define MAXNODE 5000

int n;
int ch[MAXNODE][26];
char* hans[MAXNODE];

int insert(char* s) {
	int len = strlen(s);
	int u = 0;
	for (int i = 0; i < len; ++i) {
		int c = s[i] - 'a';
		if (!ch[u][c])
			ch[u][c] = ++n;
		u = ch[u][c];
	}

	return u;
}

int getnode(char* s) {
	int len = strlen(s);
	int u = 0;
	for (int i = 0; i < len; ++i) {
		int c = s[i] - 'a';
		if (!ch[u][c]) return -1;
		u = ch[u][c];
	}

	return u;
}

/* 
根据拼音(pinyin = "gan") 等，得到该拼音的第i个汉字，返回其两个字节的anscii值，存储在 c1, c2 当中。 
函数返回值为-1时表示该整数不存在。
*/
int get_pinyin_ith_han(char* pinyin, int i, char* c1, char* c2) {
	int u = getnode(pinyin);

	if (u == -1) {
		return -1;
	}

	char* han = hans[u];

	if (han == 0) {
		return -1;
	}

	int len = strlen(han);
	int offset = i * 2;
	if (offset + 1 >= len) {
		return -1;
	}
	else {
		*c1 = han[offset];
		*c2 = han[offset + 1];
		return 0;
	}
}

void handle_pinyin_hans(char* pinyin, char * han) {
	int u = insert(pinyin);
	hans[u] = malloc(strlen(han) + 1);
	hans[u][0] = 0;
	strcpy(hans[u], han);
}

int pinyin_init() {
    printf(0, "init pinyin.\n");

    int f = open("pinyin.txt", 0);
	
	static char pinyin_buffer[100] = { 0 };
	static char han_buffer[4096];

	unsigned char cs[4];

	pinyin_buffer[0] = 0;

	while (read(f, cs, 1)) {
		cs[1] = '\0';
		unsigned char c = cs[0];
		if ('a' <= c && c <= 'z') {
			strcpy(pinyin_buffer + strlen(pinyin_buffer), (char*) cs);
		}
		else if (c == ':') {
			while (read(f, cs, 2)) {
				cs[2] = 0;
				if (cs[0] >= 160 && cs[1] >= 160) {
					strcpy(han_buffer + strlen(han_buffer), (char*) cs);
				}
				else {
					handle_pinyin_hans(pinyin_buffer, han_buffer);

					//printf("%s:%s\n", pinyin_buffer, han_buffer);

					pinyin_buffer[0] = 0;
					han_buffer[0] = 0;

					for (int i = 0; i < 2; ++i) {
						if ('a' <= cs[i] && cs[i] <= 'z') {
							strcpy(pinyin_buffer + strlen(pinyin_buffer), (char*) cs + i);
						}
					}

					break;
				}
			}
		}
		else if (c == '\r' || c == '\n') {
			pinyin_buffer[0] = 0;
			continue;
		}
	}

    printf(0, "pinyin init finished.\n");
    return 0;
}
