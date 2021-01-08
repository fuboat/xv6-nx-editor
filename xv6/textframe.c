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
    if (len1 <= 0 || len2 <= 0)
    {
        return 0;
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
    if (len < 0)
    {
        return 0;
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
int File_isDir(char *filename){
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

    while ((len = read(fd, read_data, ROWSIZE)) > 0) {
        for (int i = 0; i < len; ++ i) {
            char c = read_data[i];
            if (c == '\r' || c == '\n') {
                if (c == '\r' || (c == '\n' && lastc != '\r')) {
                    new_line_to_editor(text);
                }
            } else {
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

// int textframe_read(struct textframe *text, char *filename)
// {
//     //打开文件
//     //std::ifstream fd;
//     //printf("textframe read start\n");
//     //fd.open(filename, std::ios::in);
//     int fd = 0; //文件描述符
//     printf(1, "textframe read start\n");
//     fd = open(filename, O_RDWR);
//     if (fd < 0)
//     //if (!fd)
//     {
//         //printf("textframe read error\n");
//         printf(1, "textframe read error\n");
//         return -1;
//     }
//     printf(1, "read success\n");
//     //printf("read success\n");
//     //释放textframe
//     text->col = 0;
//     text->row = 0;
//     text->cursor_col = 0;
//     text->cursor_row = 0;
//     //printf(1, "maxrow = %d\n", text->maxrow);
//     //printf("maxrow = %d\n", text->maxrow);
//     /*if (text->maxrow != 0)
//     {
//         for (int i = 0; i < text->maxrow; i++)
//         {
//             free(text->data[i]);
//         }
//     }*/
//     free(text->data);
//     printf(1, "read\n");
//     //printf("read\n");
//     //读入
//     int max_row = MAXROW;
//     text->data = (char **)malloc(sizeof(char *) * max_row);

//     char *read_data = (char *)malloc(sizeof(char) * ROWSIZE); //读入数据
//     int rflag = 0;                                            // \r标志
//     int nflag = 0;
//     int tmpflag = 0;
//     int index = 0; //当前行下标
//     int start_index = 0;
//     char *tmp_end = (char *)malloc(sizeof(char) * 1);
//     tmp_end[0] = '\0';
//     int no_rn = 0;
//     //int len = fd.read(read_data, ROWSIZE).gcount(); //读入数据长度
//     int len = 0;
//     int total_len = 0;
//     //
//     while ((len = read(fd, read_data, ROWSIZE)) > 0)
//     //while (len > 0)
//     {
//         //遍历read_data，切分行，并加入text->data
//         for (int i = 0; i < len; i++)
//         {
//             if (read_data[i] == '\r')
//             {
//                 rflag = 1;
//             }
//             if (read_data[i] == '\n')
//             {
//                 nflag = 1;
//             }
//             if (nflag)
//             {
//                 if (rflag)
//                 {
//                     // \r\n 情况 修改start_index
//                     rflag = 0;
//                     nflag = 0;
//                     start_index = i + 1;
//                 }
//                 else
//                 {
//                     // \n 情况 赋值给text->data[index]
//                     int row_len = i - start_index;
//                     if (index > max_row)
//                     {
//                         max_row = 2 * max_row;
//                         text->data = (char **)malloc(sizeof(char *) * max_row);
//                     }
//                     text->data[index] = data_assign(read_data, start_index, row_len, tmp_end, strlen(tmp_end), tmpflag);
//                     //printf("text->data[%d]=>%s\n", index, text->data[index]);
//                     //printf(2,"text->data[%d]=>%s\n", index, text->data[index]);
//                     tmpflag = 0;
//                     nflag = 0;
//                     //下次截取从当前字符的下一个字符开始
//                     start_index = i + 1;
//                     index++;
//                     text->data[index] = (char *)malloc(sizeof(char));
//                     strcpy(text->data[index], "\0");
//                     total_len = index + 1;
//                     continue;
//                 }
//             }
//             else if (rflag)
//             {
//                 if (nflag)
//                 {
//                     // \r\n 情况 修改start_index
//                     rflag = 0;
//                     nflag = 0;
//                     start_index = i + 1;
//                 }
//                 //\r 情况 赋值给text->data[index]，此时i在\r处
//                 int row_len = i - start_index;
//                 if (index > max_row)
//                 {
//                     max_row = 2 * max_row;
//                     text->data = (char **)malloc(sizeof(char *) * max_row);
//                 }
//                 text->data[index] = data_assign(read_data, start_index, row_len, tmp_end, strlen(tmp_end), tmpflag);
//                 //printf("text->data[%d]=>%s\n", index, text->data[index]);
//                 tmpflag = 0;
//                 index++;
//                 text->data[index] = (char *)malloc(sizeof(char));
//                 strcpy(text->data[index], "\0");
//                 total_len = index + 1;
//                 start_index = i + 1;
//                 //下一个字符是\n则保留rflag,\r为最后一个字符保留rflag
//                 if (i == len - 1 || read_data[i + 1] == '\n')
//                 {
//                     continue;
//                 }
//                 else
//                 {
//                     rflag = 0;
//                 }
//             }
//             else
//             {
//                 //不是\n 不是\r 不是\r\n,赋值给text->data[index]待下一次接上
//                 if (i == len - 1)
//                 {
//                     int row_len = i - start_index + 1;
//                     if (tmpflag == 0)
//                     {
//                         free(tmp_end);
//                         tmp_end = (char *)malloc(sizeof(char) * row_len);
//                         tmp_end = substr(read_data, start_index, row_len);
//                         tmpflag = 1;
//                     }
//                     else
//                     {
//                         int tmplen = strlen(tmp_end);
//                         char *tmp_res = (char *)malloc(sizeof(char) * (row_len + tmplen));
//                         tmp_res = data_assign(read_data, start_index, row_len, tmp_end, tmplen, 1);
//                         tmp_end = tmp_res;
//                     }
//                 }
//             }
//         }
//         //读取下一ROWSIZE字节
//         //len = fd.read(read_data, ROWSIZE).gcount();
//     }
//     if (tmpflag)
//     {
//         if (index > max_row)
//         {
//             max_row = max_row + 1;
//             text->data = (char **)malloc(sizeof(char *) * max_row);
//         }
//         text->data[index] = data_assign(tmp_end, 0, strlen(tmp_end), tmp_end, 1, 0);
//         //printf("text->data[%d]=>%s\n", index, text->data[index]);
//         index++;
//         tmpflag = 0;
//     }
//     /*
//     while (len>0)
//     {
//         //printf(1, "while\n");
//         //遍历找到换行符
//         for (int i = 0; i < len; i++)
//         {
//             if (start_index > i)
//             {
//                 //....\r\n...
//                 continue;
//             }
//             //read_data结尾处理
//             if (i == len - 1)
//             {
//                 //...\r
//                 if (read_data[i] == '\r')
//                 {
//                     rflag = 1;
//                     read_data[i] = '\n';
//                 }
//                 //...\n or \r
//                 if (read_data[i] == '\n')
//                 {
//                     //内存不够
//                     if (index > max_row)
//                     {
//                         max_row = max_row << 1;
//                         text->data = (char**)malloc(sizeof(char*) * max_row);
//                     }
//                     //赋值给data[index]
//                     int row_len = i - start_index;
//                     //没有换行符，修改标志为有换行符，并将暂存在tmp_end的加入index行
//                     if (no_rn)
//                     {
//                         no_rn = 0;
//                         int tmp_len = strlen(tmp_end);
//                         text->data[index] = (char*)malloc(sizeof(char) * (row_len + tmp_len));
//                         text->data[index] = strcat(tmp_end, substr(read_data, start_index, row_len), tmp_len, row_len);
//                     }
//                     //有换行符直接加入index行
//                     else
//                     {
//                         text->data[index] = (char*)malloc(sizeof(char) * row_len);
//                         text->data[index] = substr(read_data, start_index, row_len);
//                     }
//                     //printf(1, "last char\n");
//                     //失败
//                     if (text->data == 0)
//                     {
//                         //close(fd);
//                         fd.close();
//                         return -1;
//                     }
//                     index++;
//                 }
//                 //.....
//                 else
//                 {
//                     //没有换行符标志
//                     no_rn = 1;
//                     int row_len = i - start_index + 1;
//                     if (tmp_end != 0)
//                         free(tmp_end);
//                     tmp_end = (char*)malloc(sizeof(char) * row_len);
//                     tmp_end = substr(read_data, start_index, row_len);
//                     text->data[index] = (char*)malloc(sizeof(char) * row_len);
//                     text->data[index] = substr(read_data, start_index, row_len);
//                     //失败
//                     if (tmp_end == 0)
//                     {
//                         //close(fd);
//                         fd.close();
//                         return -1;
//                     }
//                 }
//                 start_index = 0;
//             }
//             //read_data非结尾处理
//             else
//             {
//                 //目前没有遇到\r
//                 if (rflag == 0)
//                 {
//                     //遇到换行标志
//                     if (read_data[i] == '\n' || read_data[i] == '\r')
//                     {
//                         int rnflag = 0;
//                         if (read_data[i] == '\r')
//                         {
//                             //\r
//                             read_data[i] = '\n';
//                             //\r\n
//                             if (read_data[i + 1] == '\n')
//                             {
//                                 rnflag = 1;
//                             }
//                         }
//                         //内存不够
//                         if (index > max_row)
//                         {
//                             max_row = max_row << 1;
//                             text->data = (char**)malloc(sizeof(char*) * max_row);
//                         }
//                         //赋值给data[index]
//                         //printf(1, "ordinary data line\n");
//                         int row_len = i - start_index;
//                         //没有换行符，修改标志为有换行符，并将暂存在tmp_end的加入index行
//                         if (no_rn)
//                         {
//                             no_rn = 0;
//                             int tmp_len = strlen(tmp_end);
//                             text->data[index] = (char*)malloc(sizeof(char) * (row_len + tmp_len));
//                             text->data[index] = strcat(tmp_end, substr(read_data, start_index, row_len), tmp_len, row_len);
//                         }
//                         else
//                         {
//                             text->data[index] = (char*)malloc(sizeof(char) * row_len);
//                             text->data[index] = substr(read_data, start_index, row_len);
//                         }
//                         //失败
//                         if (text->data == 0)
//                         {
//                             //close(fd);
//                             fd.close();
//                             return -1;
//                         }
//                         //成功
//                         if (rnflag)
//                         {
//                             rnflag = 0;
//                             //.....\r\n\.....
//                             start_index = i + 2;
//                             //.....\r\n
//                             if (start_index == len)
//                             {
//                                 break;
//                             }
//                         }
//                         else
//                         {
//                             start_index = i + 1;
//                         }
//                         //data下一行
//                         index++;
//                     }
//                 }
//                 else
//                 {
//                     //上一次读入最后一个字符为\r
//                     rflag = 0;
//                     //....\r       \n....
//                     if (read_data[0] == '\n')
//                     {
//                         start_index = 1;
//                     }
//                     //....\r       ......
//                     //printf(1, "\"r************n\"\n");
//                     printf("\"r************n\"\n");
//                 }
//             }
//         }
//         len = fd.read(read_data, ROWSIZE).gcount();
//     }
//     */
//     text->maxrow = total_len;
//     //printf("read end maxrow = %d\n", text->maxrow);
//     printf(1, "read end maxrow = %d\n", text->maxrow);

//     //测试结果
//     //printf(1, "index=%d\n", index);
//     //printf(1, index);
//     for (int i = 0; i < text->maxrow; i++)
//     {
//         //printf("text->data=%s\n", text->data[i]);
//         printf(1, "text->data=%s\n", text->data[i]);
//     }

//     close(fd);
//     //fd.close();
//     return 0;
// }

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
    if (start_col < 0)
    {
        start_col = 0;
    }
    int start_len = strlen(text->data[start_row]);
    if (start_col >= start_len)
    {
        start_col = start_len - 1;
    }
    if (end_row < 0 || end_row >= text->maxrow)
    {
        start_row = text->maxrow - 1;
    }
    int end_len = strlen(text->data[end_row]);
    if (end_col < 0 || end_col >= end_len)
    {
        start_col = end_len - 1;
    }
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    int max_row = end_row - start_row + 1;
    if (max_row <= 0)
    {
        res_text->maxrow = -1;
        return res_text;
    }
    res_text->maxrow = max_row;
    res_text->data = (char **)malloc(sizeof(char *) * max_row);
    int start_line = start_row;
    int line_len = start_len - start_col;
    if (start_row == end_row)
    {
        line_len = end_col - start_col + 1;
    }
    for (int i = 0; i < max_row; i++)
    {
        res_text->data[i] = substr(text->data[start_row], start_col, line_len);
        start_row++;
        start_col = 0;
        if (i < max_row - 1)
        {
            line_len = strlen(text->data[start_row]);
        }
        else
        {
            line_len = end_col + 1;
        }
    }
    res_text->col = 0;
    res_text->row = 0;
    res_text->cursor_col = 0;
    res_text->cursor_row = 0;
    for (int i = 0; i < res_text->maxrow; i++)
    {
        //printf("extract res_text->data=%s\n", res_text->data[i]);
        printf(1, "extract res_text->data=%s\n", res_text->data[i]);
    }
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
    if (start_col >= start_len)
    {
        start_col = start_len - 1;
    }
    if (end_row < 0 || end_row >= text->maxrow)
    {
        start_row = text->maxrow - 1;
    }
    int end_len = strlen(text->data[end_row]);
    if (end_col < 0 || end_col >= end_len)
    {
        start_col = end_len - 1;
    }
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    int max_row = text->maxrow - (end_row - start_row + 1);
    if (start_col != 0)
    {
        max_row++;
    }

    if (end_col != end_len - 1 && start_row != end_row)
    {
        max_row++;
    }

    res_text->maxrow = max_row;
    res_text->data = (char **)malloc(sizeof(char *) * max_row);
    int index = 0;
    int i = 0;
    while (1)
    {
        if (index < start_row || index > end_row)
        {
            res_text->data[i] = substr(text->data[index], 0, strlen(text->data[index]));
            index++;
        }
        else if (index == start_row && start_col != 0)
        {
            if (start_row == end_row)
            {
                char *tmp1 = substr(text->data[index], 0, start_col);
                char *tmp2 = substr(text->data[index], end_col + 1, end_len - end_col - 1);
                res_text->data[i] = strcat(tmp1, tmp2, strlen(tmp1), strlen(tmp2));
                index++;
            }
            else
            {
                res_text->data[i] = substr(text->data[index], 0, start_col);
                index = end_row;
            }
        }
        else if (index == end_row && end_col != end_len - 1)
        {
            res_text->data[i] = substr(text->data[index], end_col, end_len - end_col);
            index++;
        }
        i++;
        if (i >= max_row)
        {
            break;
        }
    }
    res_text->col = text->col;
    res_text->row = text->row;
    res_text->cursor_col = text->cursor_col;
    res_text->cursor_row = text->cursor_row;
    for (int i = 0; i < res_text->maxrow; i++)
    {
        //printf("delete res_text->data=%s\n", res_text->data[i]);
        printf(1, "delete res_text->data=%s\n", res_text->data[i]);
    }
    return res_text;
}
//插入一段文本
struct textframe *textframe_insert(struct textframe *text, struct textframe *in_text, int start_row, int start_col)
{
    for (int i = 0; i < text->maxrow; i++)
    {
        //printf("insert text->data=%s\n", text->data[i]);
        printf(1, "insert text->data=%s\n", text->data[i]);
    }
    for (int i = 0; i < in_text->maxrow; i++)
    {
        //printf("in_text->data=%s\n", in_text->data[i]);
        printf(1, "in_text->data=%s\n", in_text->data[i]);
    }
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
    if (start_col >= start_len)
    {
        start_col = start_len - 1;
    }
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    res_text->col = 0;
    res_text->row = 0;
    res_text->cursor_col = 0;
    res_text->cursor_row = 0;
    res_text->maxrow = text->maxrow + in_text->maxrow - 1;
    res_text->data = (char **)malloc(sizeof(char *) * res_text->maxrow);
    int src_index = 0;
    int in_index = 0;
    int flag2 = start_row + in_text->maxrow - 1;
    for (int i = 0; i < res_text->maxrow; i++)
    {
        if (i < start_row || i > flag2)
        {
            //res_text->data[i] = (char*)malloc(sizeof(char));
            res_text->data[i] = substr(text->data[src_index], 0, strlen(text->data[src_index]));
            //res_text->data[i] = text->data[src_index];
            src_index++;
        }
        else if (i == start_row)
        {
            int len_tmp1 = start_col + 1;
            char *tmp1 = substr(text->data[src_index], 0, len_tmp1);
            int len_tmp2 = strlen(in_text->data[in_index]);
            char *tmp2 = substr(in_text->data[in_index], 0, len_tmp2);
            res_text->data[i] = strcat(tmp1, tmp2, len_tmp1, len_tmp2);
            //src_index++;
            in_index++;
            if (flag2 == start_row)
            {
                int len_tmp1 = strlen(text->data[src_index]) - start_col - 1;
                char *tmp1 = substr(text->data[src_index], start_col + 1, len_tmp1);
                len_tmp2 = strlen(res_text->data[i]);
                res_text->data[i] = strcat(res_text->data[i], tmp1, len_tmp2, len_tmp1);
                src_index++;
            }
        }
        else if (i < flag2)
        {
            res_text->data[i] = substr(in_text->data[in_index], 0, strlen(in_text->data[in_index]));
            in_index++;
        }
        else if (i == flag2 && flag2 != start_row)
        {
            int len_tmp1 = strlen(text->data[src_index]) - start_col - 1;
            char *tmp1 = substr(text->data[src_index], start_col + 1, len_tmp1);
            int len_tmp2 = strlen(in_text->data[in_index]);
            char *tmp2 = substr(in_text->data[in_index], 0, len_tmp2);
            res_text->data[i] = strcat(tmp2, tmp1, len_tmp2, len_tmp1);
            src_index++;
            in_index++;
        }
    }
    for (int i = 0; i < res_text->maxrow; i++)
    {
        //printf("res_text->data=%s\n", res_text->data[i]);
        printf(1, "res_text->data=%s\n", res_text->data[i]);
    }
    return res_text;
}

/*int main()
{
    struct textframe *text = (struct textframe *)malloc(sizeof(struct textframe));
    memset(text, 0, sizeof(*text));
    //char* filename = "1.txt";
    char *filename = (char *)malloc(sizeof(char) * 100);
    //strcpy(filename, "hankaku-test.txt");
    //strcpy(filename, "123.cpp");
    strcpy(filename, "in.txt");
    std::cout << "read filename=>" << filename << std::endl;
    //int t = textframe_write(text, filename);
    int t = textframe_read(text, filename);
    // struct textframe* res = (struct textframe*)malloc(sizeof(struct textframe));
    // memset(res, 0, sizeof(*res));
    //res = textframe_extract(text, 0, 0, 2, 0);
    // res = textframe_extract(text, 1, 2, 1, 7);
    // struct textframe* res2 = (struct textframe*)malloc(sizeof(struct textframe));
    // memset(res2, 0, sizeof(*res));
    // res2 = textframe_delete(text, 1, 2, 1, 7);
    // struct textframe* res3 = (struct textframe*)malloc(sizeof(struct textframe));
    // memset(res3, 0, sizeof(*res));
    // res3 = textframe_insert(res2, res, 1, 1);
    strcpy(filename, "out.txt");
    std::cout << "write filename=>" << filename << std::endl;
    t = textframe_write(text, filename);
}*/

void putc_to_str(struct textframe * text, int ch) {
    char **s = &(text->data[text->cursor_row]);
    int len = strlen(*s);
    char *new_s = (char*) malloc(len + 2);
    memmove(new_s, *s, len);
    for (int i = len + 1; i > text->cursor_col; -- i)
        new_s[i] = new_s[i - 1];
    new_s[text->cursor_col] = ch;
    new_s[len + 1] = 0;
    free(*s);
    *s = new_s;
}

void backspace_to_str(struct textframe * text) {
    char **s = &(text->data[text->cursor_row]);
    int p = text->cursor_col;
    int len = strlen(*s);
    int i;
    for (i = p; i < len; ++ i)
        (*s)[i] = (*s)[i + 1];
}

void move_to_next_char(struct textframe * text) {
    int len = strlen(text->data[text->cursor_row]);
    if (text->cursor_col < len)
        ++ text->cursor_col;
    else if (text->cursor_row + 1 < text->maxrow) {
        ++ text->cursor_row;
        text->cursor_col = 0;
    }
}

void move_to_previous_char(struct textframe * text) {
    if (text->cursor_col > 0)
        -- text->cursor_col;
    else if (text->cursor_row > 0)
    {
        -- text->cursor_row;
        text->cursor_col = strlen(text->data[text->cursor_row]);
    }
}

void move_to_next_line(struct textframe * text) {
    if (text->cursor_row + 1 < text->maxrow) {
        ++ text->cursor_row;
    }

    int len = strlen(text->data[text->cursor_row]);
    if (text->cursor_col > len) {
        text->cursor_col = len;
    }
}

void move_to_last_line(struct textframe * text) {
    if (text->cursor_row > 0) {
        -- text->cursor_row;
    }

    int len = strlen(text->data[text->cursor_row]);
    if (text->cursor_col > len) {
        text->cursor_col = len;
    }
}

void new_line_to_editor(struct textframe * text) {
    int len = text->maxrow;
    char ** new_data;
    
    if (len >= text->maxrow_capacity) {
        // data 不足以存储这么多行：重新为 data 分配空间
        new_data = malloc(sizeof(char*) * (len * 2));
        memset(new_data, 0, sizeof(char*) * (len * 2));
        memmove(new_data, text->data, sizeof(char*) * len);
        free(text->data);
        text->maxrow_capacity = len * 2;
    } else {
        // 足够存储，直接用即可
        new_data = text->data;
    }

    for (int r = len; r > text->cursor_row + 1; -- r) {
        new_data[r] = new_data[r - 1];
    }
    new_data[text->cursor_row + 1] = malloc(1);
    new_data[text->cursor_row + 1][0] = '\0';

    text->data = new_data;
    text->maxrow = len + 1;

    move_to_next_line(text);
}

void move_to_pos(struct textframe * text, int r, int c) {
    if (r >= text->maxrow) r = text->maxrow - 1;
    if (r >= 0 && c > strlen(text->data[r])) c = strlen(text->data[r]);
    text->cursor_row = r;
    text->cursor_col = c;
}

void move_to_end(struct textframe * text) {
    move_to_pos(text, 0x7fffffff, 0x7fffffff);
}

void LineEdit_set_str(struct textframe * text, char * str) {
    for (int i = 0; i < text->maxrow; ++ i) {
        free(text->data[i]);
    }

    if (text->data)
        free(text->data);

    memset(text, 0, sizeof (struct textframe));

    text->data = malloc(sizeof(char*) * 1);
    text->data[0] = malloc(strlen(str) + 1);
    strcpy(text->data[0], str);
    text->maxrow_capacity = text->maxrow = 1;
}