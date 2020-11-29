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
    if (len <= 0)
    {
        return 0;
    }
    char *dst = (char *)malloc(sizeof(char *) * len);
    for (int i = 0; i < len; i++)
    {
        dst[i] = src[start_index + i];
    }
    return dst;
}
int textframe_read(struct textframe *text, char *filename)
{
    //打开文件
    filename = "1.txt";
    int fd = 0; //文件描述符
    printf(1, "textframe read start\n");
    fd = open(filename, O_RDWR);
    if (fd < 0)
    {
        return -1;
        printf(1, "read error\n");
    }
    printf(1, "read success\n");
    //释放textframe
    text->col = 0;
    text->row = 0;
    text->cursor_col = 0;
    text->cursor_row = 0;
    printf(1, "maxrow = %d\n", text->maxrow);
    /*if (text->maxrow != 0)
    {
        for (int i = 0; i < text->maxrow; i++)
        {
            free(text->data[i]);
        }
    }*/
    free(text->data);
    printf(1, "read\n");
    //读入
    int max_row = MAXROW;
    text->data = (char **)malloc(sizeof(char *) * max_row);
    int len = 0;                                              //读入数据长度
    char *read_data = (char *)malloc(sizeof(char) * ROWSIZE); //读入数据
    int rflag = 0;                                            // \r标志
    int index = 0;                                            //当前行下标
    int start_index = 0;
    char *tmp_end = 0;
    int no_rn = 0;
    //
    while ((len = read(fd, read_data, ROWSIZE)) > 0)
    {
        printf(1, "while\n");
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
                        text->data = (char **)malloc(sizeof(char *) * max_row);
                    }
                    //赋值给data[index]
                    int row_len = i - start_index;
                    if (no_rn)
                    {
                        no_rn = 0;
                        int tmp_len = strlen(tmp_end);
                        text->data[index] = (char *)malloc(sizeof(char) * (row_len + tmp_len));
                        text->data[index] = strcat(tmp_end, substr(read_data, start_index, row_len), tmp_len, row_len);
                    }
                    else
                    {
                        text->data[index] = (char *)malloc(sizeof(char) * row_len);
                        text->data[index] = substr(read_data, start_index, row_len);
                    }
                    printf(1, "last char\n");
                    //失败
                    if (text->data == 0)
                    {
                        close(fd);
                        return -1;
                    }
                    index++;
                }
                //.....
                else
                {
                    no_rn = 1;
                    int row_len = i - start_index + 1;
                    if (tmp_end != 0)
                        free(tmp_end);
                    tmp_end = (char *)malloc(sizeof(char) * row_len);
                    tmp_end = substr(read_data, start_index, row_len);
                    //失败
                    if (tmp_end == 0)
                    {
                        close(fd);
                        return -1;
                    }
                }
                start_index = 0;
            }
            else
            {
                if (rflag == 0)
                {
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
                            text->data = (char **)malloc(sizeof(char *) * max_row);
                        }
                        //赋值给data[index]
                        printf(1, "ordinary data line\n");
                        int row_len = i - start_index;
                        if (no_rn)
                        {
                            no_rn = 0;
                            int tmp_len = strlen(tmp_end);
                            text->data[index] = (char *)malloc(sizeof(char) * (row_len + tmp_len));
                            text->data[index] = strcat(tmp_end, substr(read_data, start_index, row_len), tmp_len, row_len);
                        }
                        else
                        {
                            text->data[index] = (char *)malloc(sizeof(char) * row_len);
                            text->data[index] = substr(read_data, start_index, row_len);
                        }
                        //失败
                        if (text->data == 0)
                        {
                            close(fd);
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
                    printf(1, "\"r************n\"\n");
                }
            }
        }
    }
    text->maxrow = index;

    //测试结果
    printf(1, "index=%d\n", index);
    //printf(1, index);
    for (int i = 0; i < text->maxrow; i++)
    {
        printf(1, "text->data=%s\n", text->data[i]);
        printf(1, "data len=%d\n", strlen(text->data[i]));
    }

    close(fd);
    return 0;
}
int textframe_write(struct textframe *text, char *filename)
{
    //测试用例
    text->maxrow = 3;
    text->data = (char **)malloc(sizeof(char *) * 3);
    for (int i = 0; i < 3; i++)
    {
        text->data[i] = (char *)malloc(sizeof(char) * 5);
        text->data[i] = "12345";
    }
    //打开文件
    filename = "1.txt";
    int fd = 0; //文件描述符
    printf(1, "textframe write start\n");
    fd = open(filename, O_CREATE | O_RDWR);
    if (fd < 0)
    {
        return -1;
    }
    int len = 0;
    for (int i = 0; i < text->maxrow; i++)
    {
        len = write(fd, text->data[i], strlen(text->data[i]));
        if (len < 0)
            return -1;
        if (i < text->maxrow)
        {
            len = write(fd, "\n", 1);
        }
        if (len < 0)
            return -1;
    }
    close(fd);
    printf(1, "%%%%%%%%%%%%%%%%%%%%%%\n");
    return 0;
}

// int main()
// {
//     struct textframe *text = malloc(sizeof(struct textframe));
//     memset(text, 0, sizeof(*text));
//     char *filename = "1.txt";
//     int t = textframe_write(text, filename);
//     t = textframe_read(text, filename);
// }
