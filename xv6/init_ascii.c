#include "types.h"
#include "user.h"
// draw char
int char_to_point[256][16][8];
int char_to_area[256][16][8];

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

int main() {
    char_point_init();
    drawrect(0,0,800,600,65535);
    drawarea(0,0,8,16,get_text_area('a'));
    while(1){
        
    }
    return 0;
}