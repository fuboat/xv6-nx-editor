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
    char *res = (char *)malloc(sizeof(char) * (len1 + len2));

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
    char *dst = (char *)malloc(sizeof(char) * len);
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
    if (st.type == T_DIR)
    {
        return 1;
    }
    else
    {
        return 0;
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
    fd = open(filename, O_CREATE | O_RDWR);
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
    return 0;
}

//提取一段文本
struct textframe *textframe_extract(struct textframe *text, int start_row, int start_col, int end_row, int end_col)
{
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
    int start_line = start_row;
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
    // printf("extract \n");
    // for (int i = 0; i < res_text->maxrow; i++)
    // {
    //     printf("extract res_text->data=%s\n", res_text->data[i]);
    // }
    // printf("\n");
    return res_text;
}
//删除一段文本
struct textframe *textframe_delete(struct textframe *text, int start_row, int start_col, int end_row, int end_col)
{
    //不合法输入返回矫正
    if (start_row < 0)
    {
        start_row = 0;
    }
    if (start_col < 0)
    {
        start_col = 0;
    }
    int start_len = strlen(text->data[start_row]);
    int nflag = 0; //是否删去起始行换行符标志
    if (start_col > start_len)
    {
        start_col = start_len;
        nflag = 1; //保留换行符
    }
    if (end_row < 0 || end_row >= text->maxrow)
    {
        end_row = text->maxrow - 1;
    }
    int end_len = strlen(text->data[end_row]);
    //if (end_col < 0 ) {
    //    end_col = 0;
    //}
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    //正常起始行与结束行合并为一行
    int max_row = text->maxrow - (end_row - start_row);
    //起始行保留换行符+1行
    if (nflag)
    {
        max_row++;
    }
    //结束行删去换行符-1行
    if (end_col >= end_len)
    {
        max_row--;
    }

    res_text->maxrow = max_row;
    res_text->data = (char **)malloc(sizeof(char *) * max_row);
    int index = 0;
    int i = 0;
    while (1)
    {
        if (index < start_row || index > end_row)
        {
            char *tmp = substr(text->data[index], 0, strlen(text->data[index]));
            if (index == end_row + 1 && !nflag)
            {
                char *tmp2 = strcat(res_text->data[i], tmp, strlen(res_text->data[i]), strlen(tmp));
                res_text->data[i] = tmp2;
                //max_row--;
                //res_text->maxrow = max_row;
            }
            else
            {
                res_text->data[i] = tmp;
            }
            index++;
            i++;
        }
        else if (index == start_row)
        {
            if (start_row == end_row)
            {
                char *tmp1 = substr(text->data[index], 0, start_col);
                char *tmp2 = substr(text->data[index], end_col + 1, end_len - end_col - 1);
                res_text->data[i] = strcat(tmp1, tmp2, strlen(tmp1), strlen(tmp2));
                i++;
                index++;
            }
            else
            {
                if (start_col != 0)
                {
                    res_text->data[i] = substr(text->data[index], 0, start_col);
                    if (nflag == 1)
                    {
                        i++;
                    }
                }
                index = end_row;
            }
        }
        else if (index == end_row)
        {
            char *tmp = substr(text->data[index], end_col + 1, end_len - end_col - 1);
            if (nflag)
            {
                //free(res_text->data[i]);
                res_text->data[i] = tmp;
            }
            else
            {
                char *tmp2 = strcat(res_text->data[i], tmp, strlen(res_text->data[i]), strlen(tmp));
                //free(res_text->data[i]);
                res_text->data[i] = tmp2;
            }
            if (end_col < end_len)
            {
                i++;
                nflag = 1; //保留结束行的换行符
            }
            else
            {
                nflag = 0; //删除结束行的换行符
            }
            index++;
        }
        if (i >= max_row)
        {
            break;
        }
    }
    res_text->col = text->col;
    res_text->row = text->row;
    res_text->cursor_col = text->cursor_col;
    res_text->cursor_row = text->cursor_row;
    // printf("delete \n");
    // for (int i = 0; i < res_text->maxrow; i++)
    // {
    //     printf("delete res_text->data=%s\n", res_text->data[i]);
    // }
    // printf("\n");
    //释放text空间
    //for (int i = 0; i < text->maxrow;i++) {
    //    free(text->data[i]);
    //}
    //free(text->data);
    //free(text);
    return res_text;
}
//插入一段文本
struct textframe *textframe_insert(struct textframe *text, struct textframe *in_text, int start_row, int start_col)
{
    //为了便于调用，将start_col更改为插入文本第一个字符的坐标
    start_col = start_col - 1;
    //不合法输入返回矫正
    if (start_row < 0)
    {
        start_row = 0;
    }
    if (start_col < 0)
    {
        start_col = 0;
    }
    int start_len = strlen(text->data[start_row]);
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    res_text->col = 0;
    res_text->row = 0;
    res_text->cursor_col = 0;
    res_text->cursor_row = 0;
    res_text->maxrow = text->maxrow + in_text->maxrow - 1;
    res_text->data = (char **)malloc(sizeof(char *) * res_text->maxrow);
    int src_index = 0;
    int in_index = 0;
    int flag2 = start_row + in_text->maxrow;
    int i = 0;
    while (i < res_text->maxrow)
    {
        if (i < start_row || i > flag2)
        {
            //res_text->data[i] = (char*)malloc(sizeof(char));
            res_text->data[i] = substr(text->data[src_index], 0, strlen(text->data[src_index]));
            //printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
            //res_text->data[i] = text->data[src_index];
            src_index++;
            i++;
        }
        else if (i == start_row)
        {
            int len_tmp1 = start_col + 1;
            char *tmp1 = substr(text->data[src_index], 0, len_tmp1);
            int len_tmp2 = strlen(in_text->data[in_index]);
            char *tmp2 = substr(in_text->data[in_index], 0, len_tmp2);
            if (flag2 == start_row)
            {
                res_text->data[i] = strcat(tmp1, tmp2, len_tmp1, len_tmp2);
                len_tmp1 = strlen(text->data[src_index]) - start_col - 1;
                tmp1 = substr(text->data[src_index], start_col + 1, len_tmp1);
                len_tmp2 = strlen(res_text->data[i]);
                res_text->data[i] = strcat(res_text->data[i], tmp1, len_tmp2, len_tmp1);
                //printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
                src_index++;
                in_index++;
                i++;
            }
            else
            {
                //插在起始行换行符后
                if (start_col >= start_len)
                {
                    res_text->data[i] = tmp1;
                    //printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
                    res_text->data[i + 1] = tmp2;
                    //printf("insert res_text->data[%d]=%s\n", i + 1, res_text->data[i + 1]);
                    src_index++;
                    i = i + 2;
                }
                else
                {
                    res_text->data[i] = strcat(tmp1, tmp2, len_tmp1, len_tmp2);
                    //printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
                    i++;
                    flag2--;
                }
                in_index++;
            }
        }
        else if (i < flag2)
        {
            res_text->data[i] = substr(in_text->data[in_index], 0, strlen(in_text->data[in_index]));
            //printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
            in_index++;
            i++;
        }
        else if (i == flag2 && flag2 != start_row)
        {
            int len_tmp1 = strlen(text->data[src_index]) - start_col - 1;
            char *tmp1 = substr(text->data[src_index], start_col + 1, len_tmp1);
            //text起始行末尾没有剩余串，与下一行衔接
            if (start_col >= start_len)
            {
                len_tmp1 = strlen(text->data[src_index]);
                tmp1 = substr(text->data[src_index], 0, len_tmp1);
            }
            int len_tmp2 = strlen(in_text->data[in_index]);
            char *tmp2 = substr(in_text->data[in_index], 0, len_tmp2);
            res_text->data[i] = strcat(tmp2, tmp1, len_tmp2, len_tmp1);
            //printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
            i++;
            src_index++;
            in_index++;
        }
    }
    /*
    //释放text空间
    for (int i = 0; i < text->maxrow; i++) {
        free(text->data[i]);
    }
    free(text->data);
    free(text);
    //释放in_text空间
    for (int i = 0; i < in_text->maxrow; i++) {
        free(in_text->data[i]);
    }
    free(in_text->data);
    free(in_text);*/
    // printf("insert \n");
    // for (int i = 0; i < res_text->maxrow; i++)
    // {
    //     printf("insert res_text->data[%d]=%s\n", i, res_text->data[i]);
    // }
    // printf("\n");
    return res_text;
}

// int main()
// {
//     struct textframe *text = (struct textframe*)malloc(sizeof(struct textframe));
//     memset(text, 0, sizeof(*text));
//     //char* filename = "1.txt";
//     char *filename = (char *)malloc(sizeof(char)*100);
//     //strcpy(filename, "hankaku-test.txt");
//     //strcpy(filename, "123.cpp");
//     strcpy(filename, "in.txt");
//     std::cout<<"read filename=>" << filename << std::endl;
//     //int t = textframe_write(text, filename);
//     int t = textframe_read(text, filename);
//     struct textframe* res = (struct textframe*)malloc(sizeof(struct textframe));
//     //memset(res, 0, sizeof(*res));
//     //res = textframe_delete(text, 0, 0, 50, 0);

//     /*
//     //extract测试
//     //提取第0-50行，提取第0行换行符&不提取第8行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 20, 8, 0);
//     //不提取第0行换行符&不提取第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 100, 8, 0);
//     //不提取第0行换行符&不提取第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 100, 8, 16);
//     //不提取第0行换行符&提取第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 100, 8, 100);
//     //提取第0行换行符&提取第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 20, 8, 100);
//     */

//     /*
//     //delete测试
//     //删掉第0-50行，不保留第0行换行符&保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_delete(text, 0, 20, 50, 0);
//     //保留第0行换行符&保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_delete(text, 0, 100, 50, 0);
//     //保留第0行换行符&保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_delete(text, 0, 100, 50, 62);
//     //保留第0行换行符&不保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_delete(text, 0, 100, 50, 100);
//     //不保留第0行换行符&不保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_delete(text, 0, 20, 50, 100);
//     */

//     struct textframe* res2 = (struct textframe*)malloc(sizeof(struct textframe));
//     struct textframe* res3 = (struct textframe*)malloc(sizeof(struct textframe));

//     /*
//     //删除时保留第0行换行符&保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 20, 50, 0);
//     memset(res2, 0, sizeof(*res2));
//     res2 = textframe_delete(text, 0, 20, 50, 0);
//     memset(res3, 0, sizeof(*res));
//     res3 = textframe_insert(res2, res, 0, 20);
//     */
//     /*
//     //删除时保留第0行换行符&保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 100, 50, 0);
//     memset(res2, 0, sizeof(*res2));
//     res2 = textframe_delete(text, 0, 100, 50, 0);
//     memset(res3, 0, sizeof(*res));
//     res3 = textframe_insert(res2, res, 0, 100);
//     */
//     /*
//     //删除时保留第0行换行符&保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 100, 50, 62);
//     memset(res2, 0, sizeof(*res2));
//     res2 = textframe_delete(text, 0, 100, 50, 62);
//     memset(res3, 0, sizeof(*res));
//     res3 = textframe_insert(res2, res,0, 100);
//     */
//     /*
//     //删除时保留第0行换行符&不保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 100, 50, 100);
//     memset(res2, 0, sizeof(*res2));
//     res2 = textframe_delete(text, 0, 100, 50, 100);
//     memset(res3, 0, sizeof(*res));
//     res3 = textframe_insert(res2, res, 0, 100);
//     */
//     ///*
//     //删除时不保留第0行换行符&不保留第50行换行符
//     memset(res, 0, sizeof(*res));
//     res = textframe_extract(text, 0, 20, 50, 100);
//     memset(res2, 0, sizeof(*res2));
//     res2 = textframe_delete(text, 0, 20, 50, 100);
//     memset(res3, 0, sizeof(*res));
//     res3 = textframe_insert(res2, res, 0, 20);
//     //*/
//     strcpy(filename, "out.txt");
//     std::cout << "write filename=>" << filename << std::endl;
//     t = textframe_write(res3, filename);
// }

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
    char **s = &(text->data[text->cursor_row]);
    int p = text->cursor_col;
    int len = strlen(*s);
    int i;
    for (i = p; i < len; ++i)
        (*s)[i] = (*s)[i + 1];
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
}

void move_to_next_line(struct textframe *text)
{
    if (text->cursor_row + 1 < text->maxrow)
    {
        ++text->cursor_row;
    }

    int len = strlen(text->data[text->cursor_row]);
    if (text->cursor_col > len)
    {
        text->cursor_col = len;
    }
}

void move_to_last_line(struct textframe *text)
{
    if (text->cursor_row > 0)
    {
        --text->cursor_row;
    }

    int len = strlen(text->data[text->cursor_row]);
    if (text->cursor_col > len)
    {
        text->cursor_col = len;
    }
}

void new_line_to_editor(struct textframe *text)
{
    int len = text->maxrow;
    char **new_data;

    if (len >= text->maxrow_capacity)
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
    {
        new_data[r] = new_data[r - 1];
    }
    new_data[text->cursor_row + 1] = malloc(1);
    new_data[text->cursor_row + 1][0] = '\0';

    text->data = new_data;
    text->maxrow = len + 1;

    move_to_next_line(text);
}

void move_to_pos(struct textframe *text, int r, int c)
{
    if (r >= text->maxrow)
        r = text->maxrow - 1;
    if (r >= 0 && c > strlen(text->data[r]))
        c = strlen(text->data[r]);
    text->cursor_row = r;
    text->cursor_col = c;
}

void move_to_end(struct textframe *text)
{
    move_to_pos(text, 0x7fffffff, 0x7fffffff);
}

void LineEdit_set_str(struct textframe *text, char *str)
{
    for (int i = 0; i < text->maxrow; ++i)
    {
        free(text->data[i]);
    }

    if (text->data)
        free(text->data);

    memset(text, 0, sizeof(struct textframe));

    text->data = malloc(sizeof(char *) * 1);
    text->data[0] = malloc(strlen(str) + 1);
    strcpy(text->data[0], str);
    text->maxrow_capacity = text->maxrow = 1;
}