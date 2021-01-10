
void gbk_point_init();
void char_point_init();
void* get_text_area(char c);
void* get_text_point(char c);
char * get_gbk_point_by_offset(int offset);
char * get_gbk_point_by_c1_c2(int c1, int c2);

int pinyin_init();
int get_pinyin_ith_han(char* pinyin, int i, char* c1, char* c2, int * count);
