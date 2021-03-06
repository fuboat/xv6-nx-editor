struct textframe
{
    char **data;    //文件内容
    int row;        //起始行
    int col;        //起始列
    int cursor_row; //光标所在行
    int cursor_col; //光标所在列
    int maxrow;     //文件行总数
    int maxrow_capacity; // data 作为一个 char * 数组可以存储的量
};

char *substr(char *src, int start_index, int len);
char *strcat(char *str1, char *str2, int len1, int len2);
char *data_assign(char *src, int index, int len, char *tmp, int tmplen, int tmpflag);
int File_isDir(char *filename);
int textframe_read(struct textframe *text, char *filename);
int textframe_write(struct textframe *text, char *filename);
struct textframe *textframe_extract(struct textframe *text, int start_row, int start_col, int end_row, int end_col);
struct textframe *textframe_delete(struct textframe *text, int start_row, int start_col, int end_row, int end_col);
struct textframe *textframe_insert(struct textframe *text, struct textframe *in_text, int start_row, int start_col);
void putc_to_str(struct textframe * text, int ch);
void backspace_to_str(struct textframe * text);
void move_to_next_char(struct textframe * text);
void move_to_previous_char(struct textframe * text);
void move_to_next_line(struct textframe * text);
void move_to_last_line(struct textframe * text);
void new_line_to_editor(struct textframe * text);
void move_to_end(struct textframe * text);
void move_to_pos(struct textframe *text, int r, int c);
void LineEdit_set_str(struct textframe * text, char * str);
void clear_cur_line(struct textframe * text);
void move_cur_line_to_prev_line(struct textframe * text);
int Search(struct textframe * edit, char * str);

extern struct textframe * command_textframe;
