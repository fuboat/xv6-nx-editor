struct textframe
{
    char **data;    //文件内容
    int row;        //起始行
    int col;        //起始列
    int cursor_row; //光标所在行
    int cursor_col; //光标所在列
    int maxrow;     //文件行总数
};

char *substr(char *src, int start_index, int len);
char *strcat(char *str1, char *str2, int len1, int len2);
int textframe_read(struct textframe *text, char *filename);
int textframe_write(struct textframe *text, char *filename);