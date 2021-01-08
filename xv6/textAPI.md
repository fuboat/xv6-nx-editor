text

1. 提取文本

   ```c
   /*
   text 源文本
   截取字符的坐标区间为[(start_row,start_col),(end_row,end_col)]
   start_row 起始行坐标,(-NaN,0)=>0;
   start_col 起始列坐标,(-NaN,0)=>0;(start_row.max_col,+NaN)=>保留本行换行符
   end_row 结束行坐标,(-NaN,0)∪(text->maxrow,+NaN)=>末尾行
   end_col 结束列坐标,(-NaN,0)∪(end_row.max_col,+NaN)=>末尾行最后一个字符
   */
   struct textframe* textframe_extract(struct textframe* text, int start_row, int start_col, int end_row, int end_col)
   
   ```

   

2. 删除文本

   ```c
   /*
   text 源文本
   删除字符的坐标区间为[(start_row,start_col),(end_row,end_col)]
   start_row 起始行坐标,(-NaN,0)=>0;
   start_col 起始列坐标,(-NaN,0)=>0;(start_row.max_col,+NaN)=>保留本行
   end_row 结束行坐标,(-NaN,0)∪(text->maxrow,+NaN)=>末尾行
   end_col 结束列坐标,(-NaN,0)∪(end_row.max_col,+NaN)=>末尾行最后一个字符
   */
   struct textframe* textframe_delete(struct textframe* text, int start_row, int start_col, int end_row, int end_col)
   
   ```

3. 插入文本

```c
/*
text 源文本
in_text 插入文本
start_row 插入文本第一个字符的行坐标,(-NaN,0)=>0;
start_col 插入文本第一个字符的列坐标,(-NaN,0)=>0;(start_row.length,+NaN)=>保留本行的换行符，即在下一行插入in_text
*/
struct textframe *textframe_insert(struct textframe *text, struct textframe *in_text, int start_row, int start_col)
```

