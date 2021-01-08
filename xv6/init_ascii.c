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
    printf(0, "gbk init ing...\n");

    int f[5];
    f[0] = open("hzk16-0", 0);
    f[1] = open("hzk16-1", 0);
    f[2] = open("hzk16-2", 0);
    f[3] = open("hzk16-3", 0);
    f[4] = open("hzk16-4", 0);

    int b_64kB = 64 * 1024;
    
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