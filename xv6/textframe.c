#define ROWSIZE 1024
#define MAXROW 512
#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"

#include "textframe.h"

#define printf(...)

struct textframe *command_textframe;
//字符串连接
char *strcat(char *str1, char *str2, int len1, int len2)
{
    if (len1 < 0)
    {
        len1 = 0;
    }
    if (len2 < 0)
    {
        len2 = 0;
    }
    char *res = (char *)malloc(sizeof(char) * (len1 + len2 + 1));

    for (int i = 0; i < len1; i++)
    {
        res[i] = str1[i];
    }
    for (int i = 0; i < len2; i++)
    {
        res[len1 + i] = str2[i];
    }
    strcpy(&res[len1 + len2], "\0");
    return res;
}
//子串复制
char *substr(char *src, int start_index, int len)
{
    //printf(1, "substr len=%d\n", len);
    //std::cout << "substr len=" << len << std::endl;
    if (start_index < 0)
    {
        return src;
    }
    int max_len = strlen(src) - start_index;
    if (len > max_len)
    {
        len = max_len;
    }
    if (len < 0)
    {
        len = 0;
    }
    char *dst = (char *)malloc(sizeof(char) * (len + 1));
    for (int i = 0; i < len; i++)
    {
        dst[i] = src[start_index + i];
    }
    strcpy(&dst[len], "\0");
    return dst;
}
char *data_assign(char *src, int index, int len, char *tmp, int tmplen, int tmpflag)
{
    if (tmpflag)
    {
        char *res = (char *)malloc(tmplen + len);
        res = strcat(tmp, substr(src, index, len), tmplen, len);
        return res;
    }
    else
    {
        char *res = (char *)malloc(tmplen + len);
        res = substr(src, index, len);
        return res;
    }
}

// 判断路径类型 0 for file 1 for dir
int File_isDir(char *filename)
{
    int fd = open(filename, 0);
    struct stat st;
    fstat(fd, &st);
    close(fd);
    if (st.type == T_DIR)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

// 针对中文，专门用于处理 r 和 c 的值
// pos = 0 表示定位到汉字的左边那个字符，pos = 1 则是定位到右边。
// dir = -1 或 1， 表示想左和向右的倾向。
void textframe_adjust_r_c(struct textframe * text, int * r, int *c, int pos, int dir) {
    if (*r >= text->maxrow) *r = text->maxrow - 1;
    if (*r < 0)             *r = text->maxrow + 1;
    if (0 <= *r && *r < text->maxrow) {
        int len = strlen(text->data[*r]);
        if (*c > len) *c = len;
        if (*c < 0)   *c = 0;

        if (0 <= *c && *c < len) {
            char * curline = text->data[*r];
            unsigned char ch = curline[*c];
            // 出现了汉字字节。
            if (ch >= 160) {
                int i;
                for (i = *c; i >= 0; --i) {
                    ch = curline[i];
                    if (ch < 160) break;
                }
                // 该汉字字节一直往前，一共有多少个汉字字节（包括当前）
                int count = *c - i;
                // 根据此，微调 c
                if (pos == 0 && count % 2 == 0) {
                    *c += dir;
                }
                if (pos == 1 && count % 2 == 1) {
                    *c += dir;
                }
            }
        }
    }
}

int textframe_read(struct textframe *text, char *filename)
{
    //打开文件
    int fd = 0;
    fd = open(filename, O_RDWR);
    if (fd < 0)
    {
        printf(1, "textframe read error\n");
        return -1;
    }
    printf(1, "read success\n");

    memset(text, 0, sizeof(struct textframe));
    LineEdit_set_str(text, "");

    char read_data[ROWSIZE];
    int len, lastc = -1;

    while ((len = read(fd, read_data, ROWSIZE)) > 0)
    {
        for (int i = 0; i < len; ++i)
        {
            char c = read_data[i];
            if (c == '\r' || c == '\n')
            {
                if (c == '\r' || (c == '\n' && lastc != '\r'))
                {
                    new_line_to_editor(text);
                }
            }
            else
            {
                putc_to_str(text, c);
                move_to_next_char(text);
            }

            lastc = c;
        }
    }

    if (text->maxrow > 0)
        move_to_pos(text, 0, 0);

    close(fd);

    text->maxrow_capacity = text->maxrow;
    return 0;
}

int textframe_write(struct textframe *text, char *filename)
{
    //打开文件
    // std::ofstream fd;
    // fd.open(filename, std::ios::out);
    // DEBUG("start write file\n");
    int fd = 0; //文件描述符
    printf(1, "textframe write start\n");
    fd = open(filename, O_CREATE | O_WRONLY);
    if (fd < 0)
    //if (!fd)
    {
        DEBUG2("can't open file\n");
        return -1;
    }
    DEBUG2("opened file\n");
    int len = 0;
    for (int i = 0; i < text->maxrow; i++)
    {
        len = strlen(text->data[i]);
        printf("write len=>%d\n", len);
        //fd.write(text->data[i], strlen(text->data[i]));
        len = write(fd, text->data[i], strlen(text->data[i]));
        if (len < 0)
            return -1;
        if (i < text->maxrow - 1)
        {
            //fd.write("\n", 1);
            len = write(fd, "\n", 1);
        }
    }
    close(fd);
    //fd.close();
    printf("write over\n");
    text->maxrow_capacity = text->maxrow;
    return 0;
}

//提取一段文本
struct textframe *textframe_extract(struct textframe *text, int start_row, int start_col, int end_row, int end_col)
{
    textframe_adjust_r_c(text, & start_row, & start_col, 0, -1);
    textframe_adjust_r_c(text, & end_row, & end_col, 1, 1);

    //不合法输入返回矫正
    if (start_row < 0)
    {
        start_row = 0;
    }

    if (end_row < 0 || end_row >= text->maxrow)
    {
        end_row = text->maxrow - 1;
    }
    int start_len = strlen(text->data[start_row]);
    int end_len = strlen(text->data[end_row]);

    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    int max_row = end_row - start_row + 1;
    //不提取起始行换行符
    if (start_col > start_len)
    {
        max_row--;
    }
    //提取结束行换行符
    if (end_col >= end_len)
    {
        max_row++;
    }
    if (max_row <= 0)
    {
        res_text->maxrow = -1;
        return res_text;
    }
    res_text->maxrow = max_row;
    res_text->data = (char **)malloc(sizeof(char *) * max_row);
    // int start_line = start_row;
    if (start_col < 0)
    {
        start_col = 0;
    }
    int line_len = start_len - start_col;
    if (start_row == end_row)
    {
        line_len = end_col - start_col + 1;
    }
    for (int i = 0; i < max_row; i++)
    {
        if (i == 0 && start_col > start_len)
        {
            start_row++;
            start_col = 0;
            line_len = strlen(text->data[start_row]);
        }
        res_text->data[i] = substr(text->data[start_row], start_col, line_len);
        start_row++;
        start_col = 0;
        if (i < max_row - 2)
        {
            line_len = strlen(text->data[start_row]);
        }
        else
        {
            line_len = end_col + 1;
            if (end_col >= end_len && i == max_row - 2)
            {
                line_len = 0;
            }
        }
    }
    res_text->col = 0;
    res_text->row = 0;
    res_text->cursor_col = 0;
    res_text->cursor_row = 0;
    res_text->maxrow_capacity = res_text->maxrow;
    return res_text;
}
//删除一段文本
struct textframe *textframe_delete(struct textframe *text, int start_row, int start_col, int end_row, int end_col)
{
    textframe_adjust_r_c(text, & start_row, & start_col, 0, -1);
    textframe_adjust_r_c(text, & end_row, & end_col, 1, 1);

    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    memset(res_text, 0, sizeof(struct textframe));

    if (start_row < 0) start_row = 0;
    if (start_col < 0) start_col = 0;
    if (end_row >= text->maxrow) end_row = text->maxrow - 1, end_col = -1;

    res_text->maxrow_capacity = res_text->maxrow = text->maxrow;
    res_text->data = malloc(sizeof(char*) * res_text->maxrow_capacity);

    int i_res_text = 0;

    for (int i_text = 0; i_text < text->maxrow; ++ i_text) {
        if (i_text > start_row && i_text < end_row) {
            // 被完整删掉的行，忽略。
            continue;
        }

        char * text_cur_line = text->data[i_text];
        char * res_cur_line;
        
        if (i_text < start_row || i_text > end_row) {
            // 完整复制的行。
            res_cur_line = substr(text_cur_line, 0, strlen(text_cur_line));
        } else {
            char * left = substr(text->data[start_row], 0, start_col);
            char * right = substr(text->data[end_row], end_col + 1, strlen(text_cur_line) - end_col - 1);

            res_cur_line = strcat(left, right, strlen(left), strlen(right));
            free(left), free(right);
            i_text = end_row;
        }

        if (res_cur_line == 0) { res_cur_line = malloc(1); res_cur_line[0] = 0; }

        res_text->data[i_res_text] = res_cur_line;

        ++ i_res_text;
    }

    res_text->maxrow = i_res_text;
    res_text->maxrow_capacity = i_res_text;

    printf(0, "i_res_text = %d\n", i_res_text);

    return res_text;
}
//插入一段文本
struct textframe *textframe_insert(struct textframe *text, struct textframe *in_text, int start_row, int start_col)
{
    //为了便于调用，将start_col更改为插入文本第一个字符的坐标
    // start_col = start_col - 1;
    //不合法输入返回矫正

    textframe_adjust_r_c(text, & start_row, & start_col, 0, 1);

    struct textframe * res_text = malloc(sizeof(struct textframe));
    memset(res_text, 0, sizeof(struct textframe));
    res_text->maxrow = text->maxrow + in_text->maxrow - 1;
    res_text->data = malloc(sizeof(char *) * res_text->maxrow);

    for (int i = 0; i < res_text->maxrow; ++ i) {
        char * curline;

        if (i < start_row) {
            curline = substr(text->data[i], 0, strlen(text->data[i]));
        } else if (start_row < i && i < start_row + in_text->maxrow - 1) {
            curline = substr(in_text->data[i - start_row], 0, strlen(in_text->data[i - start_row]));
        } else if (i == start_row || i == start_row + in_text->maxrow - 1) {
            char * left = substr(text->data[start_row], 0, start_col);
            char * right = substr(text->data[start_row] + start_col, 0, strlen(text->data[start_row]) - start_col);

            if (in_text->maxrow == 1) {
                char * curline_left = strcat(left, in_text->data[0], strlen(left), strlen(in_text->data[0]));
                curline = strcat(curline_left, right, strlen(curline_left), strlen(right));
                res_text->cursor_row = i;
                res_text->cursor_col = strlen(curline_left);
                free(curline_left);
            } else if (i == start_row) {
                curline = strcat(left, in_text->data[0], strlen(left), strlen(in_text->data[0]));
            } else if (i == start_row + in_text->maxrow - 1) {
                curline = strcat(in_text->data[in_text->maxrow-1], right, strlen(in_text->data[in_text->maxrow-1]), strlen(right));
                res_text->cursor_row = i;
                res_text->cursor_col = strlen(in_text->data[in_text->maxrow-1]);
            } else {
                curline = 0;
            }

            free(left);
            free(right);
        } else {
            curline = text->data[i - (in_text->maxrow-1)];
            curline = substr(curline, 0, strlen(curline));
        }

        if (curline == 0) { curline = malloc(1); curline[0] = 0; }

        res_text->data[i] = curline;
    }

    return res_text;
}

void putc_to_str(struct textframe *text, int ch)
{
    char **s = &(text->data[text->cursor_row]);
    int len = strlen(*s);
    char *new_s = (char *)malloc(len + 2);
    memmove(new_s, *s, len);
    for (int i = len + 1; i > text->cursor_col; --i)
        new_s[i] = new_s[i - 1];
    new_s[text->cursor_col] = ch;
    new_s[len + 1] = 0;
    free(*s);
    *s = new_s;
}

void backspace_to_str(struct textframe *text)
{
    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, 1);
    char **s = &(text->data[text->cursor_row]);
    int p = text->cursor_col;
    int len = strlen(*s);
    int i;

    int is_han = (p >= 0 && p < len && (unsigned char) (*s)[p] >= 160);

    do {
        for (i = p; i < len; ++i)
            (*s)[i] = (*s)[i + 1];
        // 如果是汉字，则删两个字符
    } while (is_han --);
}

void move_to_next_char(struct textframe *text)
{
    int len = strlen(text->data[text->cursor_row]);
    if (text->cursor_col < len)
        ++text->cursor_col;
    else if (text->cursor_row + 1 < text->maxrow)
    {
        ++text->cursor_row;
        text->cursor_col = 0;
    }
    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, 1);
}

void move_to_previous_char(struct textframe *text)
{
    if (text->cursor_col > 0)
        --text->cursor_col;
    else if (text->cursor_row > 0)
    {
        --text->cursor_row;
        text->cursor_col = strlen(text->data[text->cursor_row]);
    }
    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, -1);
}

void move_to_next_line(struct textframe *text)
{
    if (text->cursor_row + 1 < text->maxrow)
        ++text->cursor_row;
    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, 1);
}

void move_to_last_line(struct textframe *text)
{
    if (text->cursor_row > 0)
        --text->cursor_row;
    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, 1);
}

void new_line_to_editor(struct textframe *text)
{
    int len = text->maxrow;
    char **new_data;

    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, 1);

    if (len + 1 >= text->maxrow_capacity)
    {
        // data 不足以存储这么多行：重新为 data 分配空间
        new_data = malloc(sizeof(char *) * (len * 2));
        memset(new_data, 0, sizeof(char *) * (len * 2));
        memmove(new_data, text->data, sizeof(char *) * len);
        free(text->data);
        text->maxrow_capacity = len * 2;
    }
    else
    {
        // 足够存储，直接用即可
        new_data = text->data;
    }

    for (int r = len; r > text->cursor_row + 1; --r)
        new_data[r] = new_data[r - 1];

    // 将上一行光标后的部分移到下一行去

    char * curline = new_data[text->cursor_row];

    new_data[text->cursor_row + 1] = substr(curline, text->cursor_col, strlen(curline) - text->cursor_col);
    curline[text->cursor_col] = 0;

    text->data = new_data;
    text->maxrow = len + 1;

    move_to_pos(text, text->cursor_row + 1, 0);
}

void move_to_pos(struct textframe *text, int r, int c)
{
    if (r == -1) r = 0x7fffffff;
    if (c == -1) c = 0x7fffffff;
    if (r >= text->maxrow)
        r = text->maxrow - 1;
    if (r >= 0 && c > strlen(text->data[r]))
        c = strlen(text->data[r]);
    text->cursor_row = r;
    text->cursor_col = c;

    textframe_adjust_r_c(text, & text->cursor_row, & text->cursor_col, 0, 1);
}

void move_to_end(struct textframe *text)
{
    move_to_pos(text, 0x7fffffff, 0x7fffffff);
}

void LineEdit_set_str(struct textframe *text, char *str)
{
    struct textframe old_text = *text;

    memset(text, 0, sizeof(struct textframe));

    text->data = malloc(sizeof(char *) * 1);
    text->data[0] = malloc(strlen(str) + 1);
    strcpy(text->data[0], str);
    text->maxrow_capacity = text->maxrow = 1;
    text->cursor_col = text->cursor_row = 0;

    for (int i = 0; i < old_text.maxrow; ++i)
    {
        free(old_text.data[i]);
    }

    if (old_text.data)
        free(old_text.data);
}

void clear_cur_line(struct textframe *text) {
    if (0 <= text->cursor_row && text->cursor_row < text->maxrow) {
        free(text->data[text->cursor_row]);
        text->data[text->cursor_row] = malloc(1);
        text->data[text->cursor_row][0] = 0;
        text->cursor_col = 0;
    }
}

void move_cur_line_to_prev_line(struct textframe * text) {
    if (0 < text->cursor_row && text->cursor_row < text->maxrow) {
        char * cur = text->data[text->cursor_row];
        char * prev = text->data[text->cursor_row - 1];
        text->data[text->cursor_row - 1] = strcat(prev, cur, strlen(prev), strlen(cur));
        free(cur), free(prev);
        for (int i = text->cursor_row; i + 1 < text->maxrow; ++ i)
            text->data[i] = text->data[i + 1];
        -- text->maxrow;
        move_to_pos(text, text->cursor_row - 1, -1);
    }
}

int Search(struct textframe * edit, char * str) {
    int str_len = strlen(str);

    if (str_len < 0) return -1;

    for (int i = edit->cursor_row; i < edit->maxrow; ++ i) {
        char * S = edit->data[i];
        int len = strlen(S);
        for (int j = i == edit->cursor_row? edit->cursor_col : 0; j < len; ++ j) {
            int k = j;
            int l = 0;
            while (k < len && l < str_len && S[k++] == str[l++]);
            if (l == str_len && S[k-1] == str[l-1]) {
                edit->cursor_row = i;
                edit->cursor_col = k;
                return 0;
            }
        }
    }

    if (edit->cursor_row != 0 || edit->cursor_col != 0) {
        int row = edit->cursor_row;
        int col = edit->cursor_col;
        edit->cursor_row = 0;
        edit->cursor_col = 0;
        if (Search(edit, str) >= 0) {
            return 1;
        } else {
            edit->cursor_row = row;
            edit->cursor_col = col;
            return -1;
        }
    } else {
        return -1;
    }
}