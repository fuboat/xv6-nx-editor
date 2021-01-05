#define ROWSIZE 1024
#define MAXROW 512
#include "textframe.h"
#include "types.h"
#include "user.h"
#include "fcntl.h"

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
    return res;
}
//子串复制
char *substr(char *src, int start_index, int len)
{
    printf(1, "substr len=%d\n", len);
    //std::cout << "substr len=" << len << std::endl;
    if (len < 0)
    {
        return 0;
    }
    char *dst = (char *)malloc(sizeof(char *) * len);
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
int textframe_read(struct textframe *text, char *filename)
{
    //打开文件
    int fd = 0; //文件描述符
    //std::ifstream fd;
    printf(1, "textframe read start\n");
    //printf("textframe read start\n");
    fd = open(filename, O_RDWR);
    //fd.open(filename, std::ios::in);
    if (fd < 0)
    //if (!fd)
    {
        return -1;
    }
    printf(1, "read success\n");
    //printf("read success\n");
    //释放textframe
    text->col = 0;
    text->row = 0;
    text->cursor_col = 0;
    text->cursor_row = 0;
    //printf(1, "maxrow = %d\n", text->maxrow);
    //printf("maxrow = %d\n", text->maxrow);
    /*if (text->maxrow != 0)
    {
        for (int i = 0; i < text->maxrow; i++)
        {
            free(text->data[i]);
        }
    }*/
    free(text->data);
    //printf(1, "read\n");
    //printf("read\n");
    //读入
    int max_row = MAXROW;
    text->data = (char **)malloc(sizeof(char *) * max_row);

    char *read_data = (char *)malloc(sizeof(char) * ROWSIZE); //读入数据
    int rflag = 0;                                            // \r标志
    int nflag = 0;
    int tmpflag = 0;
    int index = 0; //当前行下标
    int start_index = 0;
    char *tmp_end = (char *)malloc(sizeof(char) * 1);
    tmp_end[0] = '\0';
    int no_rn = 0;
    int len = 0;
    //int len = fd.read(read_data, ROWSIZE).gcount(); //读入数据长度
    int total_len = 0;
    //
    while ((len = read(fd, read_data, ROWSIZE)) > 0)
    //while (len > 0)
    {
        //遍历read_data，切分行，并加入text->data
        for (int i = 0; i < len; i++)
        {
            if (read_data[i] == '\r')
            {
                rflag = 1;
            }
            if (read_data[i] == '\n')
            {
                nflag = 1;
            }
            if (nflag)
            {
                if (rflag)
                {
                    // \r\n 情况 修改start_index
                    rflag = 0;
                    nflag = 0;
                    start_index = i + 1;
                }
                else
                {
                    // \n 情况 赋值给text->data[index]
                    int row_len = i - start_index;
                    text->data[index] = data_assign(read_data, start_index, row_len, tmp_end, strlen(tmp_end), tmpflag);
                    tmpflag = 0;
                    nflag = 0;
                    //下次截取从当前字符的下一个字符开始
                    start_index = i + 1;
                    index++;
                    text->data[index] = (char *)malloc(sizeof(char));
                    strcpy(text->data[index], "\0");
                    total_len = index + 1;
                    continue;
                }
            }
            else if (rflag)
            {
                if (nflag)
                {
                    // \r\n 情况 修改start_index
                    rflag = 0;
                    nflag = 0;
                    start_index = i + 1;
                }
                //\r 情况 赋值给text->data[index]，此时i在\r处
                int row_len = i - start_index;
                text->data[index] = data_assign(read_data, start_index, row_len, tmp_end, strlen(tmp_end), tmpflag);
                tmpflag = 0;
                index++;
                text->data[index] = (char *)malloc(sizeof(char));
                strcpy(text->data[index], "\0");
                total_len = index + 1;
                start_index = i + 1;
                //下一个字符是\n则保留rflag,\r为最后一个字符保留rflag
                if (i == len - 1 || read_data[i + 1] == '\n')
                {
                    continue;
                }
                else
                {
                    rflag = 0;
                }
            }
            else
            {
                //不是\n 不是\r 不是\r\n,赋值给text->data[index]待下一次接上
                if (i == len - 1)
                {
                    int row_len = i - start_index + 1;
                    if (tmpflag == 0)
                    {
                        free(tmp_end);
                        tmp_end = (char *)malloc(sizeof(char) * row_len);
                        tmp_end = substr(read_data, start_index, row_len);
                        tmpflag = 1;
                    }
                    else
                    {
                        int tmplen = strlen(tmp_end);
                        char *tmp_res = (char *)malloc(sizeof(char) * (row_len + tmplen));
                        tmp_res = data_assign(read_data, start_index, row_len, tmp_end, tmplen, 1);
                        tmp_end = tmp_res;
                    }
                }
            }
        }
        //读取下一ROWSIZE字节
        //len = fd.read(read_data, ROWSIZE).gcount();
    }
    if (tmpflag)
    {
        text->data[index] = data_assign(tmp_end, 0, strlen(tmp_end), tmp_end, 1, 0);
        index++;
        tmpflag = 0;
    }
    /*
    while (len>0)
    {
        //printf(1, "while\n");
        //遍历找到换行符
        for (int i = 0; i < len; i++)
        {
            if (start_index > i)
            {
                //....\r\n...
                continue;
            }
            //read_data结尾处理
            if (i == len - 1)
            {
                //...\r
                if (read_data[i] == '\r')
                {
                    rflag = 1;
                    read_data[i] = '\n';
                }
                //...\n or \r
                if (read_data[i] == '\n')
                {
                    //内存不够
                    if (index > max_row)
                    {
                        max_row = max_row << 1;
                        text->data = (char**)malloc(sizeof(char*) * max_row);
                    }
                    //赋值给data[index]
                    int row_len = i - start_index;
                    //没有换行符，修改标志为有换行符，并将暂存在tmp_end的加入index行
                    if (no_rn)
                    {
                        no_rn = 0;
                        int tmp_len = strlen(tmp_end);
                        text->data[index] = (char*)malloc(sizeof(char) * (row_len + tmp_len));
                        text->data[index] = strcat(tmp_end, substr(read_data, start_index, row_len), tmp_len, row_len);
                    }
                    //有换行符直接加入index行
                    else
                    {
                        text->data[index] = (char*)malloc(sizeof(char) * row_len);
                        text->data[index] = substr(read_data, start_index, row_len);
                    }
                    //printf(1, "last char\n");
                    //失败
                    if (text->data == 0)
                    {
                        //close(fd);
                        fd.close();
                        return -1;
                    }
                    index++;
                }
                //.....
                else
                {
                    //没有换行符标志
                    no_rn = 1;
                    int row_len = i - start_index + 1;
                    if (tmp_end != 0)
                        free(tmp_end);
                    tmp_end = (char*)malloc(sizeof(char) * row_len);
                    tmp_end = substr(read_data, start_index, row_len);
                    text->data[index] = (char*)malloc(sizeof(char) * row_len);
                    text->data[index] = substr(read_data, start_index, row_len);
                    //失败
                    if (tmp_end == 0)
                    {
                        //close(fd);
                        fd.close();
                        return -1;
                    }
                }
                start_index = 0;
            }
            //read_data非结尾处理
            else
            {
                //目前没有遇到\r
                if (rflag == 0)
                {
                    //遇到换行标志
                    if (read_data[i] == '\n' || read_data[i] == '\r')
                    {
                        int rnflag = 0;
                        if (read_data[i] == '\r')
                        {
                            //\r
                            read_data[i] = '\n';
                            //\r\n
                            if (read_data[i + 1] == '\n')
                            {
                                rnflag = 1;
                            }
                        }
                        //内存不够
                        if (index > max_row)
                        {
                            max_row = max_row << 1;
                            text->data = (char**)malloc(sizeof(char*) * max_row);
                        }
                        //赋值给data[index]
                        //printf(1, "ordinary data line\n");
                        int row_len = i - start_index;
                        //没有换行符，修改标志为有换行符，并将暂存在tmp_end的加入index行
                        if (no_rn)
                        {
                            no_rn = 0;
                            int tmp_len = strlen(tmp_end);
                            text->data[index] = (char*)malloc(sizeof(char) * (row_len + tmp_len));
                            text->data[index] = strcat(tmp_end, substr(read_data, start_index, row_len), tmp_len, row_len);
                        }
                        else
                        {
                            text->data[index] = (char*)malloc(sizeof(char) * row_len);
                            text->data[index] = substr(read_data, start_index, row_len);
                        }
                        //失败
                        if (text->data == 0)
                        {
                            //close(fd);
                            fd.close();
                            return -1;
                        }
                        //成功
                        if (rnflag)
                        {
                            rnflag = 0;
                            //.....\r\n\.....
                            start_index = i + 2;
                            //.....\r\n
                            if (start_index == len)
                            {
                                break;
                            }
                        }
                        else
                        {
                            start_index = i + 1;
                        }
                        //data下一行
                        index++;
                    }
                }
                else
                {
                    //上一次读入最后一个字符为\r
                    rflag = 0;
                    //....\r       \n....
                    if (read_data[0] == '\n')
                    {
                        start_index = 1;
                    }
                    //....\r       ......
                    //printf(1, "\"r************n\"\n");
                    printf("\"r************n\"\n");
                }
            }
        }
        len = fd.read(read_data, ROWSIZE).gcount();
    }
    */
    text->maxrow = total_len;
    //printf("read end maxrow = %d\n", text->maxrow);
    printf(1, "read end maxrow = %d\n", text->maxrow);

    //测试结果
    //printf(1, "index=%d\n", index);
    //printf(1, index);
    for (int i = 0; i < text->maxrow; i++)
    {
        //printf("text->data=%s\n", text->data[i]);
        printf(1, "text->data=%s\n", text->data[i]);
    }

    close(fd);
    //fd.close();
    return 0;
}
int textframe_write(struct textframe *text, char *filename)
{
    //打开文件
    int fd = 0; //文件描述符
    //std::ofstream fd;
    printf(1, "textframe write start\n");
    fd = open(filename, O_CREATE | O_RDWR);
    //fd.open(filename, std::ios::out);
    if (fd < 0)
    //if (!fd)
    {
        return -1;
    }
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
            if (len < 0)
                return -1;
        }
    }
    close(fd);
    //fd.close();
    //printf("write over\n");
    printf(1, "write over\n");
    return 0;
}

//提取一段文本
struct textframe *textframe_extract(struct textframe *text, int start_row, int start_col, int end_row, int end_col)
{
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
    int line_len = strlen(text->data[start_row]) - start_col;
    for (int i = 0; i < max_row; i++)
    {
        res_text->data[i] = substr(text->data[start_row], start_col, line_len);
        start_row++;
        start_col = 0;
        line_len = strlen(text->data[start_row]);
        if (i == max_row - 1)
        {
            line_len = end_col + 1;
        }
    }
    res_text->col = 0;
    res_text->row = 0;
    res_text->cursor_col = 0;
    res_text->cursor_row = 0;
    return res_text;
}
//删除一段文本
struct textframe *textframe_delete(struct textframe *text, int start_row, int start_col, int end_row, int end_col)
{
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    int max_row = text->maxrow - (end_row - start_row + 1);
    if (start_col != 0)
    {
        max_row++;
    }
    int end_len = strlen(text->data[end_row]);
    if (end_col != end_len - 1)
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
            res_text->data[i] = substr(text->data[index], 0, start_col + 1);
            index = end_row;
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
    return res_text;
}
//插入一段文本
struct textframe *textframe_insert(struct textframe *text, struct textframe *in_text, int start_row, int start_col)
{
    struct textframe *res_text = (struct textframe *)malloc(sizeof(struct textframe));
    res_text->col = 0;
    res_text->row = 0;
    res_text->cursor_col = 0;
    res_text->cursor_row = 0;
    res_text->maxrow = -1;
    return res_text;
}

// int main()
// {
//     struct textframe *text = (struct textframe *)malloc(sizeof(struct textframe));
//     memset(text, 0, sizeof(*text));
//     //char* filename = "1.txt";
//     char *filename = (char *)malloc(sizeof(char) * 100);
//     strcpy(filename, "hankaku-test.txt");
//     //strcpy(filename, "in.txt");
//     std::cout << "read filename=>" << filename << std::endl;
//     //int t = textframe_write(text, filename);
//     int t = textframe_read(text, filename);
//     strcpy(filename, "out.txt");
//     std::cout << "write filename=>" << filename << std::endl;
//     t = textframe_write(text, filename);
// }
