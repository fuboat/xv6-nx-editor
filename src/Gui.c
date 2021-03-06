#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "Gui.h"
#include "init_ascii_gbk_pinyin.h"
#include "fs.h"
#include "highlight.h"

#define RGB(r,g,b) ((r >> 3) << 11 | (g >> 2) << 5 | (b >> 3))
#define AREA_ARGS(area) area.x, area.y, area.width, area.height

static void * cursor_focus;

// 0 for "LineEdit" or 1 for "TextEdit";
static int cursor_focus_type = 0;
int isRename = 0;

void mouse_pos_transform(struct Area cur_area, int *x, int *y) {
    *x -= cur_area.x - cur_area.offset_x;
    *y -= cur_area.y - cur_area.offset_y;
}

// (x, y) 表示一个相对于当前组件 (0, 0) 的坐标。
// cur_area 表示子组件的 area。
// 用于在组件的处理函数处，判断某个坐标是否在子组件的控制范围。
int is_pos_in_area(struct Area cur_area, int x, int y) {
    return (x >= cur_area.x && y >= cur_area.y &&
    x < cur_area.x + cur_area.width &&
    y < cur_area.y + cur_area.height);
}

struct Area calc_current_area(struct Area parent_area, struct Area area) {
    parent_area.x += area.x - parent_area.offset_x;
    parent_area.y += area.y - parent_area.offset_y;
    parent_area.width -= area.x - parent_area.offset_x;
    parent_area.height -= area.y - parent_area.offset_y;
    if (parent_area.width > area.width) 
        parent_area.width = area.width;
    if (area.x - parent_area.offset_x < 0)
        parent_area.width = 0;
    if (area.y - parent_area.offset_y < 0)
        parent_area.height = 0;
    if (parent_area.height > area.height)
        parent_area.height = area.height;
    parent_area.offset_x = area.offset_x;
    parent_area.offset_y = area.offset_y;
    return parent_area;
}

/**************************
 * 
 * TextEdit handler functions.
 * 
 * make, draw, handle mouse, handle keyboard.
 * 
 **************************/

void TextEdit_adjust_col_row(struct TextEdit * text) {
    int r1 = text->point1_row;
    int c1 = text->point1_col;
    int r2 = text->point2_row;
    int c2 = text->point2_col;

    if (r2 < r1 || (r2 == r1 && c2 < c1)) {
        text->point1_row = r2;
        text->point1_col = c2;
        text->point2_row = r1;
        text->point2_col = c1;
    }
}

int make_TextEdit(struct TextEdit ** pedit, void * parent, char * parent_type) {
    struct TextEdit * edit = malloc(sizeof(struct TextEdit));
    edit->area = (struct Area) {0, 0, 100, 16, 0, 0 };
    edit->parent = parent;
    edit->parent_type = parent_type;
    edit->point1_col = -1;
    edit->point1_row = -1;
    edit->point2_col = -1;
    edit->point2_row = -1;
    edit->text = malloc(sizeof(struct textframe));
    memset(edit->text, 0, sizeof(struct textframe));
    LineEdit_set_str(edit->text, "");

    *pedit = edit;

    return 0;
}

int draw_TextEdit(struct TextEdit *edit, struct Area parent_area) {
    int font_width = 8;
    int font_height = 16;

    if (edit->scale < 0) font_width /= (1 << (-edit->scale)), font_height /= (1 << (-edit->scale));
    if (edit->scale > 0) font_width *= (1 << edit->scale), font_height *= ((1 << edit->scale));

    struct textframe * text = edit->text;

    struct Area area = calc_current_area(parent_area, edit->area);

    // DEBUGDF("[GUI TextEdit] draw text edit, %d %d %d %d (offset x y) = (%d %d)\n", area.x, area.y, area.width, area.height, area.offset_x, area.offset_y);

    // 绘制背景
    drawrect(AREA_ARGS(area), 131071);

    // 绘制光标
    /*****
     * 根据光标调整 offset.
     *****/
    struct Area cursor_area;

    // offset 的调整只尝试 10 次。
    if (edit == cursor_focus) {
        for (int i = 0; i < 10; ++ i) {

            cursor_area = calc_current_area(
                area,
                (struct Area) { text->cursor_col * font_width, text->cursor_row * font_height, 1, font_height, 0, 0 }
            );

            // 如果光标完全不可见，调整 offset，使得光标恰好在显示区域的最右下侧。
            if (cursor_area.height <= 0 || cursor_area.width <= 0 || cursor_area.x < 0 || cursor_area.y < 0) {
                DEBUG("[GUI TextEdit] offset adjust for curser. because: cursor_area(width, height) = (%d,%d)\n", 
                cursor_area.width, cursor_area.height);
                edit->area.offset_x = max(0, text->cursor_col * font_width - area.width + font_width);
                edit->area.offset_y = max(0, text->cursor_row * font_height - area.height + font_height);
                area = calc_current_area(parent_area, edit->area);
                DEBUG("[GUI TextEdit] area change. (%d %d %d %d)\n", area.x, area.y, area.width, area.height);
            } else {
                break;
            }
        }

        drawrect(
            AREA_ARGS(cursor_area), 
            RGB(0x0, 0x0, 0x0)
        );
       
        if(edit->point2_col != -1)
        {
            struct TextEdit old_edit = *edit;

            TextEdit_adjust_col_row(edit);

            if(edit->point1_row == edit->point2_row){
                struct Area cursor_area_line;
                //for (int i = 0; i < 10; ++ i) {
                int wid = (edit->point2_col-edit->point1_col + 1)*font_width;
                int len = strlen(edit->text->data[edit->point1_row]);
                if(edit->point1_col >= len){
                    edit->point1_col = len - 1 ;
                }
                int res_len = font_width*(len - edit->point1_col);
                if(wid > res_len){
                    wid = res_len;
                }
                if (!wid){
                    wid = font_width;
                }
                DEBUG2("DRAWING: row:%d len:%d col:%d \n", edit->point1_row, strlen(edit->text->data[edit->point1_row]), edit->point1_col );
                cursor_area_line = calc_current_area(
                    area,
                    (struct Area) { edit->point1_col * font_width, edit->point1_row * font_height, wid, font_height, 0, 0 }
                );
                //}
                drawrect(
                    AREA_ARGS(cursor_area_line), 
                    RGB(0xa0, 0xa0, 0xa0)
                );
            }else{
                struct Area cursor_area_top;
                int len = strlen(edit->text->data[edit->point1_row]);
                if(edit->point1_col >= len){
                    edit->point1_col = len - 1 ;
                }
                int wid = font_width*(len - edit->point1_col);
                //DEBUG2("DRAWING: row:%d len:%d col:%d \n", edit->point1_row, strlen(edit->text->data[edit->point1_row]), edit->point1_col );
                cursor_area_top = calc_current_area(
                    area,
                    (struct Area) { edit->point1_col* font_width, edit->point1_row * font_height, wid, font_height, 0, 0 }
                );
                drawrect(
                    AREA_ARGS(cursor_area_top), 
                    RGB(0xa0, 0xa0, 0xa0)
                );
                len = strlen(edit->text->data[edit->point2_row]);
                if(edit->point2_col >= len){
                    edit->point2_col = len - 1 ;
                }
                struct Area cursor_area_bottom;
                cursor_area_bottom = calc_current_area(
                    area,
                    (struct Area) { 0, edit->point2_row * font_height, (1 + edit->point2_col)*font_width, font_height, 0, 0 }
                );

                drawrect(
                    AREA_ARGS(cursor_area_bottom), 
                    RGB(0xa0, 0xa0, 0xa0)
                );
                for(int i = edit->point1_row + 1; i < edit->point2_row; i++){
                    struct Area cursor_area_mid;
                    cursor_area_mid = calc_current_area(
                        area,
                        (struct Area) { 0, i * font_height, font_width * strlen(edit->text->data[i]), font_height, 0, 0 }
                    );
                    drawrect(
                        AREA_ARGS(cursor_area_mid), 
                        RGB(0xa0, 0xa0, 0xa0)
                    );
                }
            }

            edit->point1_col = old_edit.point1_col;
            edit->point1_row = old_edit.point1_row;
            edit->point2_col = old_edit.point2_col;
            edit->point2_row = old_edit.point2_row;
        }
    }

    for (int r = 0; r < text->maxrow; ++ r) {
        int len = strlen(text->data[r]);

        // 代码高亮的参数
        int status = 0, count = 0, highlight_c = 0, hc = 0;

        for (int col = 0; col < len; ++ col) {            
            // 枚举所有的字符
            unsigned char c = text->data[r][col];

            // 根据高亮表，更新高亮状态。
            if (hc <= col && edit->highlight_on) {
                while (hc <= len) {
                    int res = highlight_update(text->data[r][hc], &status, &highlight_c, &count);
                    ++ hc;
                    if (res >= 0) {
                        break;
                    }
                    if (hc == len + 1) {
                        highlight_c = 0;
                        count = 0;
                    }
                }
            }

            int cur_c = col + count + 1 >= hc? highlight_c : 0;

            int is_han = (c >= 160 && col + 1 < len && (unsigned char) text->data[r][col+1] >= 160);
            int width = is_han? font_width * 2 : font_width;

            struct Area c_area = calc_current_area(area, (struct Area) { col * font_width, r * font_height, width, font_height, 0, 0 });

            // 只有在能够完整绘制的时候才进行绘制
            if (c_area.x >= 0 && c_area.y >= 0 && c_area.width == width && c_area.height == font_height) 
            {
                if (is_han) {
                    drawgbk_color(AREA_ARGS(c_area), cur_c, get_gbk_point_by_c1_c2(c, (unsigned char) text->data[r][col + 1]));
                } else {
                    drawarea_color(
                        AREA_ARGS(c_area),
                        cur_c,
                        get_text_area(c));
                }
            }

            if (is_han) ++ col;
        }
    }

    return 0;
}

int handle_mouse_TextEdit(struct TextEdit *edit, int x, int y, int mouse_opt) {
    int font_width = 8;
    int font_height = 16;

    if (edit->scale < 0) font_width /= (1 << (-edit->scale)), font_height /= (1 << (-edit->scale));
    if (edit->scale > 0) font_width *= (1 << edit->scale), font_height *= ((1 << edit->scale));

    mouse_pos_transform(edit->area, &x, &y);

    if (mouse_opt != MOUSE_MOVE) {
        cursor_focus = edit;
        cursor_focus_type = 1;
        move_to_pos(edit->text, y/font_height, x/font_width);
    }
    if(mouse_opt == MOUSE_LEFT_PRESS){
        edit->point1_row = y/font_height;
        edit->point1_col = x/font_width;
        edit->point2_row = -1;
        edit->point2_col = -1;
        edit->selecting = 1;
    }else if(mouse_opt == MOUSE_MOVE || mouse_opt == MOUSE_LEFT_RELEASE){
        if (!(edit->selecting)) return 0;

        if(edit->point1_row == y/font_height && edit->point1_col == x/font_width){

        }else{
            // if(edit->point1_row > y/font_height || (edit->point1_row == y/font_height && edit->point1_col > x/font_width)){
            //     edit->point2_col = edit->point1_col;
            //     edit->point2_row = edit->point1_row;
            //     edit->point1_col = x/font_width;
            //     edit->point1_row = y/font_height;
            // }else{
                edit->point2_row = y/font_height;
                edit->point2_col = x/font_width;
            // }
            if(edit->point1_row >= edit->text->maxrow){
                edit->point1_row = edit->text->maxrow - 1;
            }
            if(edit->point2_row >= edit->text->maxrow){
                edit->point2_row = edit->text->maxrow - 1;
            }
        }

        if (mouse_opt == MOUSE_LEFT_RELEASE)
            edit->selecting = 0;
        //}
        // DEBUG2("[GUI3: TextEdit] mouse in TextEdit, pos1 = (%d, %d), pos2(%d, %d), type = %d\n", 
        // edit->point1_row, edit->point1_col,
        // edit->point2_row, edit->point2_col, mouse_opt);
    } else {
        edit->selecting = 0;
    }
    
    return 0;
}

#define CTRL_P      16
#define BACKSPACE   8
#define ENTER       10
#define LEFT_ARROW  228
#define RIGHT_ARROW 229
#define UP_ARROW    226
#define DOWN_ARROW  227
#define DELETE 233
#define CTRL_S 19
#define TAB 9
#define CTRL_C 3
#define CTRL_V 22
#define CTRL_F 6
#define CTRL_X 24

#define DEBUG_TEXT(...) // printf(0, __VA_ARGS__)

void print_textframe(struct textframe * text) {
    int i;
    for (i = 0; i < text->maxrow; ++ i)
        DEBUG_TEXT("%s\n", text->data[i]);
}

int handle_keyboard_TextEdit(struct TextEdit *edit, int c) {
    struct textframe *text = edit->text;

    switch (c) {
    case ENTER:
        if(edit->point2_col != -1){
            TextEdit_adjust_col_row(edit);
            text = textframe_delete(text, edit->point1_row, edit->point1_col, 
                                                edit->point2_row, edit->point2_col);
            LineEdit_set_str(edit->text, "");
            edit->text = text;
            move_to_pos(text, edit->point1_row, edit->point1_col);
            edit->point2_col = -1;
            edit->point2_row = -1;
        }
        new_line_to_editor(text);
        break;

    case LEFT_ARROW: case BACKSPACE:{
        if(edit->point2_col == -1){
            if (c == LEFT_ARROW) move_to_previous_char(text);
        }
        if (c == BACKSPACE) {
            if(edit->point2_col == -1) {
                if (text->cursor_col > 0) {
                    move_to_previous_char(text);
                    backspace_to_str(text);
                } else {
                    move_cur_line_to_prev_line(text);
                }
            }else{
                TextEdit_adjust_col_row(edit);
                text = textframe_delete(text, edit->point1_row, edit->point1_col, 
                                              edit->point2_row, edit->point2_col);
                LineEdit_set_str(edit->text, "");
                edit->text = text;
                move_to_pos(text, edit->point1_row, edit->point1_col);
            }
        }
        edit->point2_col = -1;
        edit->point2_row = -1;
        break;
    }
    case RIGHT_ARROW:
        if(edit->point2_col != -1){
            move_to_pos(text, edit->point2_row, edit->point2_col);
            edit->point2_col = -1;
            edit->point2_row = -1;
        }
        move_to_next_char(text);
        break;
    case UP_ARROW:
        edit->point2_col = -1;
        edit->point2_row = -1;
        move_to_last_line(text);
        break; 
    case DOWN_ARROW:
        edit->point2_col = -1;
        edit->point2_row = -1;
        move_to_next_line(text);
        break;
    case CTRL_C:
        DEBUG2("in ctrlc\n");
        if(edit->point2_col != -1){
            struct FileBuffer* pFile = (struct FileBuffer*)(edit->parent);
            if(!pFile){
                break;
            }
            struct textframe* clip = pFile->parent->parent->clipBoard;
            if(clip){
                LineEdit_set_str(clip, "");
            }
            TextEdit_adjust_col_row(edit);
            pFile->parent->parent->clipBoard = textframe_extract(text, edit->point1_row, edit->point1_col, 
                                                edit->point2_row, edit->point2_col);
        }
        break;
    case CTRL_V:{
        struct FileBuffer* pFile = (struct FileBuffer*)(edit->parent);
        if(!pFile){
            break;
        }
        struct textframe* clip = pFile->parent->parent->clipBoard;
        if(!clip){
            break;
        }
        DEBUG2("in ctrlv \n");
        if(edit->point2_col != -1){
            TextEdit_adjust_col_row(edit);
            text  = (textframe_delete(text, edit->point1_row, edit->point1_col, edit->point2_row, edit->point2_col));
            LineEdit_set_str(edit->text, "");
            edit->text = text;
            edit->point2_col = -1;
            edit->point2_row = -1;
            move_to_pos(text, edit->point1_row, edit->point1_col);
        }
        DEBUG2("clip");
        DEBUG2(clip->data[0]);
        int start_row = text->cursor_row, start_col = text->cursor_col;
        DEBUG2("LALALA2: %d %d:\n", start_row,start_col);

        DEBUG_TEXT("------- ctrl-v -------\ntext:\n");
        print_textframe(text);
        DEBUG_TEXT("in_text:\n");
        print_textframe(clip);
        DEBUG_TEXT("------- ctrl-v -------\n");

        edit->point1_row = edit->text->cursor_row;
        edit->point1_col = edit->text->cursor_col;
        text = textframe_insert(text, clip, start_row, start_col);
        LineEdit_set_str(edit->text, "");
        edit->text = text;
        // 计算粘贴后的光标位置
        // move_to_pos(text, edit->point1_row, edit->point1_col);
        break;
    }
    case CTRL_X:
    {
        if(edit->point2_col != -1) {
            handle_keyboard_TextEdit(edit, CTRL_C);
            handle_keyboard_TextEdit(edit, BACKSPACE);
        }
    }
    default: {
        if (32 <= c && c <= 126) {
            if(edit->point2_col != -1){
                text  = (textframe_delete(text, edit->point1_row, edit->point1_col, edit->point2_row, edit->point2_col));
                LineEdit_set_str(edit->text, "");
                edit->text = text;
                edit->point2_col = -1;
                edit->point2_row = -1;
                move_to_pos(text, edit->point1_row, edit->point1_col);
            }
            putc_to_str(text, c);
            move_to_next_char(text);
        }
        break;
    }
    }

    return 0;
}

/**************************
 * 
 * LineEdit handler functions.
 * 
 * make, draw, handle mouse, handle keyboard.
 * 
 * 
 **************************/

int make_LineEdit(struct LineEdit ** pedit, void * parent, char * parent_type) {
    struct LineEdit * edit = malloc(sizeof(struct LineEdit));
    edit->area = (struct Area) {0, 0, 100, 16, 0, 0 };
    edit->parent = parent;
    edit->parent_type = parent_type;

    edit->text = malloc(sizeof(struct textframe));
    memset(edit->text, 0, sizeof(struct textframe));
    LineEdit_set_str(edit->text, "");

    *pedit = edit;

    return 0;
}

int draw_LineEdit(struct LineEdit *edit, struct Area parent_area) {
    struct textframe * text = edit->text;

    struct Area area = calc_current_area(parent_area, edit->area);

    DEBUG("[GUI LineEdit] draw line edit, %d %d %d %d\n", area.x, area.y, area.width, area.height);

    // 绘制背景
    drawrect(AREA_ARGS(area), 131071);

    // 绘制光标
    /*****
     * 根据光标调整 offset.
     *****/
    struct Area cursor_area;

    // offset 的调整只尝试 10 次。
    // 只有在焦点在当前编辑框中时，才尝试绘制光标
    if (edit == cursor_focus) {
        for (int i = 0; i < 10; ++ i) {
            cursor_area = calc_current_area(
                area,
                (struct Area) { text->cursor_col * 8, text->cursor_row * 16, 8, 16, 0, 0 }
            );

            // 如果光标完全不可见，调整 offset，使得光标恰好在显示区域的最右下侧。
            if (cursor_area.height <= 0 || cursor_area.width <= 0 || cursor_area.x < 0 || cursor_area.y < 0) {
                DEBUG("[GUI LineEdit] offset adjust for curser. because: cursor_area(width, height) = (%d,%d)\n", 
                cursor_area.width, cursor_area.height);
                edit->area.offset_x = max(0, text->cursor_col * 8 - area.width + 8);
                edit->area.offset_y = max(0, text->cursor_row * 16 - area.height + 16);
                area = calc_current_area(parent_area, edit->area);
                DEBUG("[GUI LineEdit] area change. (%d %d %d %d)\n", area.x, area.y, area.width, area.height);
            } else {
                break;
            }
        }

        drawrect(
            AREA_ARGS(cursor_area), 
            RGB(0xa0, 0xa0, 0xa0)
        );
    }

    for (int r = 0; r < text->maxrow; ++ r) {
        int len = strlen(text->data[r]);
        for (int col = 0; col < len; ++ col) {
            // 枚举所有的字符
            char c = text->data[r][col];

            // 该字符对应在屏幕上的 area
            struct Area c_area = calc_current_area(area, (struct Area) { col * 8, r * 16, 8, 16, 0, 0 });

            // 只有在能够完整绘制的时候才进行绘制
            if (c_area.x >= 0 && c_area.y >= 0 && c_area.width == 8 && c_area.height == 16) 
            {
                drawarea(
                    AREA_ARGS(c_area), 
                    get_text_area(c));
            }
        }
    }

    return 0;
}

int handle_mouse_LineEdit(struct LineEdit *edit, int x, int y, int mouse_opt) {
    mouse_pos_transform(edit->area, &x, &y);

    cursor_focus = edit;
    cursor_focus_type = 0;
    move_to_pos(edit->text, y/16, x/8);
    DEBUG("[GUI: LineEdit] mouse in LineEdit, pos = (%d, %d), type = %d\n", x, y, mouse_opt);

    return 0;
}

int handle_keyboard_LineEdit(struct LineEdit *edit, int c) {
    struct textframe *text = edit->text;

    switch (c) {
    // case ENTER:
    //     new_line_to_editor(&text);
    //     break;

    case LEFT_ARROW: case BACKSPACE:
        move_to_previous_char(text);

        if (c == BACKSPACE) {
            backspace_to_str(text);
        }

        break;

    case RIGHT_ARROW:
        move_to_next_char(text);
        break;

    // case UP_ARROW:
    //     move_to_last_line(&text);
    //     break; 
    // case DOWN_ARROW:
    //     move_to_next_line(&text);
    //     break;
    default: {
        if (32 <= c && c <= 126) {
            putc_to_str(text, c);
            move_to_next_char(text);
        }
        break;
    }
    }

    return 0;
}

/**************************
 * 
 * FileListBuffer handler functions.
 * make, draw, handle mouse, handle keyboard.
 * 
 * 
 **************************/

int make_FileListBuffer(struct FileListBuffer ** pbuffer, struct BufferManager * parent) {
    struct FileListBuffer * buffer = malloc(sizeof (struct FileListBuffer));
    buffer->area = (struct Area) { 10, 30, 90, 570, 0, 0 };
    buffer->n_files = 0;
    buffer->files = malloc(sizeof(struct FileNameControl *) * 0);
    buffer->file_selected = 0;
    buffer->parent = parent;

    buffer->path[0] = '\0';

    *pbuffer = buffer;

    FileListBuffer_update_FileList(buffer);

    return 0;
}

int draw_FileListBuffer(struct FileListBuffer * buffer, struct Area area) {
    area = calc_current_area(area, buffer->area);
    drawrect(100, 20, 2, 680, RGB(0, 0, 0));
    drawrect(0, 20, 800, 2, RGB(0, 0, 0));
    for (int i = 0; i < buffer->n_files; ++ i) {
        draw_FileNameControl(buffer->files[i], area);
    }

    return 0;
}

int handle_mouse_FileListBuffer(struct FileListBuffer * buffer, int x, int y, int mouse_opt) {
    mouse_pos_transform(buffer->area, &x, &y);

    for (int i = 0; i < buffer->n_files; ++ i) {
        if (is_pos_in_area(buffer->files[i]->area, x, y)) {
            buffer->file_selected = buffer->files[i];
            if (mouse_opt == MOUSE_LEFT_PRESS){
                FileSwitchBar_open_file(buffer->parent->fileSwitch, buffer->files[i]->edit->text->data[0]);
                return 0;
            }else if(mouse_opt == MOUSE_RIGHT_PRESS){
                isRename = 1;
                return handle_mouse_FileNameControl(buffer->files[i], x, y, mouse_opt);
            }
        }
    }

    return 0;
}

int handle_keyboard_FileListBuffer(struct FileListBuffer* buffer, int c) {
    if (buffer->file_selected) {
        return handle_keyboard_FileNameControl(buffer->file_selected, c);
    } else {
        return 0;
    }
}

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
  return buf;
}

int FileListBuffer_update_FileList(struct FileListBuffer * buffer) {
    char * path = buffer->path;
    DEBUGDF("file_path: %s\n", path);
    char buf[512];

    int fd = open(path, 0);
    struct stat st;
    struct dirent de;

    fstat(fd, &st);

    // 计算目录中有多少个项。

    int n_files = 0;

    if (st.type == T_DIR) {
        strcpy(buf, path);
        char * p = buf + strlen(buf);
        *p ++ = '/';
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
            if(de.inum == 0)
                continue;
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0;
            if(stat(buf, &st) >= 0) {
                ++ n_files;
            }
        }
    }

    buffer->n_files = n_files;
    buffer->files = malloc(sizeof(struct FileNameControl *) * n_files);

    DEBUGDF("----- fd = %d [GUI FileListBuffer] nfiles = %d -----\n", fd, n_files);

    close(fd); 
    fd = open(path, 0); 
    fstat(fd, &st);

    int file_index = 0;

    if (st.type == T_DIR) {
        strcpy(buf, path);
        char * p = buf + strlen(buf);
        *p ++ = '/';
        while(read(fd, &de, sizeof(de)) == sizeof(de)){
            if(de.inum == 0)
                continue;
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0;
            if(stat(buf, &st) >= 0) {
                if (strcmp(fmtname(buf), "console") == 0) {
                    continue;
                }

                make_FileNameControl(buffer->files + file_index, buffer);
                struct FileNameControl * file = buffer->files[file_index];
                file->area.y = file_index * 16;
                strcpy(file->oldName, fmtname(buf)); 
                LineEdit_set_str(file->edit->text, file->oldName);
                DEBUG("[GUI FileListBuffer] file: %s\n", file->oldName);
                ++ file_index;
            }
        }
    }

    buffer->n_files = file_index;

    close(fd);

    return 0;
}

/**************************
 * 
 * FileNameControl handler functions.
 * 
 **************************/

int make_FileNameControl(struct FileNameControl ** pcontrol, struct FileListBuffer * parent) {
    struct FileNameControl * control = malloc(sizeof (struct FileNameControl));
    memset(control, 0, sizeof(struct FileNameControl));
    make_LineEdit(& control->edit, control, "FileNameControl");
    control->oldName[0] = 0;
    control->parent = parent;
    control->area = (struct Area) {0, 0, 100, 16, 0, 0 };;

    *pcontrol = control;

    return 0;
}

int draw_FileNameControl(struct FileNameControl * control, struct Area area) {
    area = calc_current_area(area, control->area);

    DEBUG("[GUI FileNameControl] drawing. area (x, y, width, height) = (%d %d %d %d)\n",
    area.x,
    area.y,
    area.width,
    area.height);

    return draw_LineEdit(control->edit, area);
}

int handle_mouse_FileNameControl(struct FileNameControl * control, int x, int y, int mouse_opt) {
    return handle_mouse_LineEdit(control->edit, x, y, mouse_opt);
}

int handle_keyboard_FileNameControl(struct FileNameControl * control, int c) {
    return handle_keyboard_LineEdit(control->edit, c);
}

int rename_FileNameControl(struct FileNameControl * control){
    isRename = 0;
    int fileflag = File_isDir(control->oldName);
    if(strcmp(control->edit->text->data[0], control->oldName)){
        if(!fileflag){
            if (strlen(control->parent->path) > 0){
                if (chdir(control->parent->path) == 0){
                    DEBUGDF("chdir to path: %s\n", control->parent->path);
                }
            }
            if(link(control->oldName, control->edit->text->data[0]) < 0){
                DEBUGDF("link failed\n");
            }
            if(unlink(control->oldName) < 0){
                DEBUGDF("unlink failed\n");
            }
            char filepath[512] = {0};
            strcpy(filepath, control->parent->path);
            strcpy(filepath + strlen(filepath), control->oldName);
            DEBUGDF("filepath: %s\n", filepath);
            for (int i = 0; i < control->parent->parent->fileSwitch->n_files; i++){
                DEBUGDF("filepathname: %s\n", control->parent->parent->fileSwitch->files[i]->filepathname);
                if (strcmp(control->parent->parent->fileSwitch->buttons[i]->edit->text->data[0], control->oldName) == 0
                && strcmp(filepath, control->parent->parent->fileSwitch->files[i]->filepathname) == 0){
                    DEBUGDF("path1: %s,path2: %s\n", control->parent->path, control->parent->parent->fileSwitch->files[i]->filepathname);
                    LineEdit_set_str(control->parent->parent->fileSwitch->buttons[i]->edit->text, control->edit->text->data[0]);
                    int pos= -1;
                    for(int j = 0; j < strlen(control->parent->parent->fileSwitch->files[i]->filepathname); j++){
                        if (control->parent->parent->fileSwitch->files[i]->filepathname[j] == '/'){
                            pos = j;
                        }
                    }
                    strcpy(control->parent->parent->fileSwitch->files[i]->filepathname + pos + 1, control->edit->text->data[0]);
                    DEBUGDF("newfilepathname: %s\n", control->parent->parent->fileSwitch->files[i]->filepathname);
                }
            }
            if (chdir("/") == 0){
                DEBUGDF("chdir to Root.\n");
            }
        }
        else {
            // 文件夹重命名 
            return 0;
        }
        DEBUGDF("path: %s\n", control->parent->path);
        FileListBuffer_update_FileList(control->parent);
        DEBUGDF("old: %s,new: %s\n", control->oldName, control->edit->text->data[0]);
    }else{
        DEBUG2("no change finish\n");
    }
    return 0;
}





/**************************
 * 
 * CommandBuffer handler functions.
 * 
 **************************/

int make_FileBuffer(struct FileBuffer ** pbuffer, struct FileSwitchBar * parent) {
    struct FileBuffer * buffer = malloc(sizeof(struct FileBuffer));
    memset(buffer, 0, sizeof(struct FileBuffer));

    buffer->area = (struct Area) { 0, 20, 700, 400, 0, 0 };
    make_TextEdit(& buffer->edit, buffer, "FileBuffer");
    buffer->edit->scale = 0;
    buffer->parent = parent;
    buffer->edit->area = (struct Area) { 0, 0, 700, 400, 0, 0 };
    
    memset(buffer->filepathname, 0, sizeof(buffer->filepathname));

    *pbuffer = buffer;

    return 0;
}

int draw_FileBuffer(struct FileBuffer * buffer, struct Area area) {
    area = calc_current_area(area, buffer->area);
    return draw_TextEdit(buffer->edit, area);
}

int handle_mouse_FileBuffer(struct FileBuffer * buffer, int x, int y, int mouse_opt) {
    mouse_pos_transform(buffer->area, &x, &y);
    return handle_mouse_TextEdit(buffer->edit, x, y, mouse_opt);
}

int FileBuffer_save_file(struct FileBuffer * buffer, char * filepathname);

int handle_keyboard_FileBuffer(struct FileBuffer * buffer, int c) {
    switch (c)
    {
        case CTRL_S:
            return FileBuffer_save_file(buffer, buffer->filepathname);
            break;
        default:
            return handle_keyboard_TextEdit(buffer->edit, c);
            break;
    }
}

int FileBuffer_open_file(struct FileBuffer * buffer, char * filepathname) {
    strcpy(buffer->filepathname, filepathname);
    // textframe_write(buffer->edit->text, "1.txt");
    textframe_read(buffer->edit->text, filepathname);
    return 0;
}

int FileBuffer_save_file(struct FileBuffer * buffer, char * filepathname) {
    //DEBUG2("in saving\n");
    //DEBUG(filepathname);
    //DEBUG2("\ncontent:\n");
    //DEBUG2(buffer->edit->text->data[0]);
    // textframe_write(buffer->edit->text, "1.txt");
    textframe_write(buffer->edit->text, filepathname);
    FileListBuffer_update_FileList(buffer->parent->parent->fileList);
    DEBUG2("\nfinish save\n");
    return 0;
}

/**************************
 * 
 * BufferManager handler functions.
 * 
 * make, draw, handle mouse, handle keyboard.
 * 
 * 
 **************************/

int make_BufferManager(struct BufferManager ** pmanager) {
    struct BufferManager * manager = malloc(sizeof(struct BufferManager));
    manager->area = (struct Area) { 0, 0, 800, 600, 0, 0 };
    make_FileListBuffer(& manager->fileList, manager);
    // manager->file = 0;
    // make_FileBuffer(& manager->file, manager);
    manager->clipBoard = 0;
    make_FileSwitchBar(& manager->fileSwitch, manager);
    make_ToolBar(& manager->toolBar, manager);
    make_pinyinInput(& manager->pinyin, manager);
    make_StatusBar(& manager->statusBar, manager);
    manager->statusBar->area.width = 800;
    manager->statusBar->edit->area.width = 800;
    manager->focus = 0;
    *pmanager = manager;
    return 0;
}

int draw_BufferManager(struct BufferManager * manager, struct Area area) {
    DEBUG("----- Start draw BufferManager. -----\n");
    area = calc_current_area(area, manager->area);
    drawrect(AREA_ARGS(area), RGB(255, 255, 255));
    draw_FileListBuffer(manager->fileList, area);
    // draw_FileBuffer(manager->file, area);
    draw_FileSwitchBar(manager->fileSwitch, area);
    DEBUG("----- draw toolbar -----\n");
    draw_ToolBar(manager->toolBar, area);
    draw_pinyinInput(manager->pinyin, area);
    draw_StatusBar(manager->statusBar, area);
    return 0;
}

int handle_mouse_BufferManager(struct BufferManager* manager, int x, int y, int mouse_opt) {
    // 校正鼠标在当前部件的显示位置。
    mouse_pos_transform(manager->area, &x, &y);

    // DEBUG2("[GUI: BufferManager] mouse in BufferManager, pos = (%d, %d), type = %d\n", x, y, mouse_opt);
    manager->fileSwitch->searchInput = 0;

    if (mouse_opt == MOUSE_MOVE && cursor_focus && cursor_focus_type == 1) {
        return handle_mouse_FileSwitchBar((struct FileSwitchBar *) manager->fileSwitch, x, y, mouse_opt);
    }

    if(isRename && manager->fileList->file_selected){
        int x1 = x, y1 = y;
        mouse_pos_transform(manager->fileList->area, &x1, &y1);
        if(!is_pos_in_area(manager->fileList->file_selected->area, x1, y1)){
            if(isRename == 1){
                DEBUG2("renaming\n");
            }
            rename_FileNameControl(manager->fileList->file_selected);
        }
    }
    if(manager->fileSwitch->current){
        manager->fileSwitch->current->edit->point2_col = -1;
        manager->fileSwitch->current->edit->point2_row = -1;
    }
    if (is_pos_in_area(manager->fileSwitch->area, x, y)) {
        DEBUG2("in switch\n");
        return handle_mouse_FileSwitchBar(manager->focus=manager->fileSwitch, x, y, mouse_opt);
    } else if (is_pos_in_area(manager->fileList->area, x, y)) {
        DEBUG2("in filelist\n");
        // 如果点击了子部件，那么，焦点设在子部件上。
        return handle_mouse_FileListBuffer(manager->focus=manager->fileList, x, y, mouse_opt);
    } else if (is_pos_in_area(manager->toolBar->area, x, y)) {
        DEBUG2("in toolbar\n");
        return handle_mouse_ToolBar(manager->focus=manager->toolBar, x, y, mouse_opt);
    } else{
        return 0;
    }
}

int handle_keyboard_BufferManager(struct BufferManager * manager, int c) {
    // 根据焦点判断由哪一部件接收键盘输入
    // 当输入法启用且输入的内容为 a-z 的字母时，或数字时，控制权移交到输入法
    LineEdit_set_str(manager->statusBar->edit->text, "");
    if(c == CTRL_P) {
        manager->pinyin->on ^= 1;
        printf(0, "is pinyin on: %d\n", manager->pinyin->on);
        if(manager->pinyin->on){
            LineEdit_set_str(manager->statusBar->edit->text, "Chinese"); 
        }else{
            LineEdit_set_str(manager->statusBar->edit->text, "English"); 
        }
        return 0;
    } else if(manager->pinyin->on && 
                (('a' <= c && c <= 'z') || ('0' <= c && c <= '9') || c == ENTER || c == BACKSPACE || c == ',' || c == '.' || c == '\'') &&   
        handle_keyboard_pinyinInput(manager->pinyin, c) >= 0) {
        return 0;
    }
    else if (isRename && manager->focus == manager->fileList){
        return handle_keyboard_FileListBuffer(manager->fileList, c);
    }
    else if (manager->focus == manager->fileSwitch) {
        DEBUG2("key bord: %d\n", c);
        return handle_keyboard_FileSwitchBar(manager->fileSwitch, c);
    }
    else if (c == DELETE){
        if (manager->fileList->file_selected){
            DEBUGDF("to delete: %s\n", manager->fileList->file_selected->edit->text->data[0]);
            unlink(manager->fileList->file_selected->edit->text->data[0]);
            FileListBuffer_update_FileList(manager->fileList);
        }
        return 0;
    }  
    else {
        return 0;
    }
}

/*********************
 * 
 * Button handle function.
 * 
 *********************/

int make_Button(struct Button ** pbutton, void * parent, char * parent_type) {
    struct Button * button;
    
    button = malloc(sizeof(struct Button));
    button->area = (struct Area) { 0, 0, 100, 20, 0, 0 };
    make_LineEdit(& button->edit, button, "Button");
    button->parent = parent;
    button->parent_type = parent_type;

    button->exec = 0;

    *pbutton = button;

    return 0;
}

int draw_Button(struct Button * button, struct Area area) {
    area = calc_current_area(area, button->area);
    return draw_LineEdit(button->edit, area);
}

int handle_mouse_Button(struct Button * button, int x, int y, int mouse_opt) {
    //DEBUG2("in mouse-Button");
    //DEBUG2(mouse_opt);
    if (mouse_opt == MOUSE_LEFT_PRESS && button->exec) {
        button->exec(button);
        return 0;
    }else if(mouse_opt == MOUSE_RIGHT_PRESS) {
        //DEBUG2("close//\n");
        handle_close_Button(button);
        return 0;
    }else {
        DEBUG("\\\\no exec");
        return 0;
    }
}

int handle_close_Button(struct Button * button){
    if(button && button->parent && !strcmp(button->parent_type, "FileSwitchBar")){
        struct FileSwitchBar * fileswitch = (struct FileSwitchBar *) button->parent;
        for (int i = 0; i < fileswitch->n_files; ++ i) {
            if (fileswitch->buttons[i] == button) {
                // the last
                struct FileBuffer * buffer = fileswitch->files[i];
                DEBUG2("finding\n");
                if(i == fileswitch->n_files - 1){
                    if( i == 0){
                        fileswitch->current = 0;
                    }else{
                        fileswitch->current = fileswitch->files[i-1];
                    }
                }else{
                    for(int j = i; j < fileswitch->n_files; ++j){
                        fileswitch->files[j] = fileswitch->files[j+1];
                        fileswitch->buttons[j] = fileswitch->buttons[j+1];
                    }
                    fileswitch->current = fileswitch->files[i];
                }
                // free
                LineEdit_set_str(buffer->edit->text, "");
                LineEdit_set_str(button->edit->text, "");
                --(fileswitch->n_files);
                return 0;
            }
        }
    }
    return -1;
}

int Button_exec_switch_to_file(struct Button * button) {
    struct FileSwitchBar * fileswitch = (struct FileSwitchBar *) button->parent;
    for (int i = 0; i < fileswitch->n_files; ++ i) {
        if (fileswitch->buttons[i] == button) {
            fileswitch->current = fileswitch->files[i];
            cursor_focus = fileswitch->current->edit;
            cursor_focus_type = 1;
            return 0;
        }
    }
    return -1;
}

int free_Button(struct Button ** button){
    return 0;
}
/*********************
 * 
 * FileSwitchBar handle function.
 * 
 *********************/

int make_FileSwitchBar(struct FileSwitchBar **pfileSwitch, struct BufferManager * parent) {
    struct FileSwitchBar * fileSwitch = malloc(sizeof(struct FileSwitchBar));
    
    fileSwitch->area = (struct Area) { 115, 23, 700, 700, 0, 0 };

    memset(fileSwitch->buttons, 0, sizeof(fileSwitch->buttons));
    memset(fileSwitch->files, 0, sizeof(fileSwitch->files));
    fileSwitch->n_files = 0;
    fileSwitch->current = 0;
    fileSwitch->parent = parent;
    fileSwitch->ifSearch = 0;
    fileSwitch->searchInput = 0;
    make_SearchFrame(& fileSwitch->search, fileSwitch);
    *pfileSwitch = fileSwitch;

    return 0;
}

int draw_FileSwitchBar(struct FileSwitchBar * fileSwitch, struct Area area) {
    area = calc_current_area(area, fileSwitch->area);
    int x = 0;

    for (int i = 0; i < fileSwitch->n_files; ++ i) {
        struct Button * cur_button = fileSwitch->buttons[i];
        cur_button->area.x = x;
        draw_Button(cur_button, area);
        x += cur_button->area.width;
    }

    if (fileSwitch->current) {
        draw_FileBuffer(fileSwitch->current, area);
        if(fileSwitch->ifSearch){
            draw_SearchFrame(fileSwitch->search, area);
        }
    }

    
    return 0;
}

int handle_mouse_FileSwitchBar(struct FileSwitchBar * fileSwitch, int x, int y, int mouse_opt) {
    mouse_pos_transform(fileSwitch->area, &x, &y);

    if (mouse_opt == MOUSE_LEFT_PRESS) {
        for (int i = 0; i < fileSwitch->n_files; ++ i) {
            struct Button * cur_button = fileSwitch->buttons[i];
            if (is_pos_in_area(cur_button->area, x, y)) {
                return handle_mouse_Button(cur_button, x, y, mouse_opt);
            }
        }
    }else if (mouse_opt == MOUSE_RIGHT_PRESS) {
        for (int i = 0; i < fileSwitch->n_files; ++ i) {
            struct Button * cur_button = fileSwitch->buttons[i];
            if (is_pos_in_area(cur_button->area, x, y)) {
                return handle_mouse_Button(cur_button, x, y, mouse_opt);
            }
        }
    }
    
    if (fileSwitch->current && fileSwitch->ifSearch && is_pos_in_area(fileSwitch->search->area, x, y)){
        fileSwitch->searchInput = 1;
        DEBUG2("in searchmode\n");
        return handle_mouse_SearchFrame(fileSwitch->search, x, y, mouse_opt);
    }else if (fileSwitch->current && 
        is_pos_in_area(fileSwitch->current->area, x, y)) {
        return handle_mouse_FileBuffer(fileSwitch->current, x, y, mouse_opt);
    }

    return 0;
}

int handle_keyboard_FileSwitchBar(struct FileSwitchBar * fileSwitch, int c) {
    DEBUG2("key bord in File Switch: %d\n", c);
    switch (c)
    {
        case TAB:
            FileSwitchBar_handle_tab(fileSwitch);
            break;
        case CTRL_F:
            DEBUG2("inbore\n");
            fileSwitch->ifSearch = !(fileSwitch->ifSearch);
            if(fileSwitch->search->edit){
                move_to_end(fileSwitch->search->edit->text);
                // something wrong
                //move_to_pos(fileSwitch->search->edit->text,0,0);
            }
            cursor_focus = fileSwitch->search->edit;
            cursor_focus_type = 0;
            fileSwitch->searchInput  = 1;
            break;
        default:
            if (fileSwitch->current){
                if(fileSwitch->searchInput){
                    return handle_keyboard_SearchFrame(fileSwitch->search, c);
                }
                return handle_keyboard_FileBuffer(fileSwitch->current, c);
            }
            break;
    }

    return 0;
}

int FileSwitchBar_open_file(struct FileSwitchBar * fileSwitch, char * filename) {
    if(!FileSwitchBar_find_file(fileSwitch, filename)){
        return 0;
    }
    // 编辑器顶栏切换选中文件
    if (fileSwitch->n_files < FILESWITCH_MAX_FILES && File_isDir(filename) == 0) {
        make_Button(fileSwitch->buttons + fileSwitch->n_files, fileSwitch, "FileSwitchBar");
        fileSwitch->buttons[fileSwitch->n_files]->exec = Button_exec_switch_to_file;
        make_FileBuffer(fileSwitch->files + fileSwitch->n_files, fileSwitch);
        LineEdit_set_str(fileSwitch->buttons[fileSwitch->n_files]->edit->text, filename);
        char filepath[512] = {0};
        strcpy(filepath, fileSwitch->parent->fileList->path);
        strcpy(filepath + strlen(filepath), filename);
        FileBuffer_open_file(fileSwitch->files[fileSwitch->n_files], filepath);
        fileSwitch->current = fileSwitch->files[fileSwitch->n_files];
        cursor_focus = fileSwitch->current->edit;
        cursor_focus_type = 1;
        fileSwitch->n_files ++;
        return 0;
    }
    // 文件夹进入
    else if (File_isDir(filename) == 1) {
        //To do 释放之前的变量
        char * filepath = fileSwitch->parent->fileList->path;
        char * lastpath = (char *)malloc(strlen(filepath) + 2);
        memset(lastpath, 0, strlen(filepath) + 2);
        DEBUGDF("filename = %s\n", filename);
        if (strcmp(filename, ".") == 0) {
            ;
        } else if (strcmp(filename, "..") == 0){
            filepath[0] = '\0';
        } else {
            char * filepath = strcat(filename, "/", strlen(filename), 1);
            strcpy(fileSwitch->parent->fileList->path + strlen(fileSwitch->parent->fileList->path), filepath);
            free(filepath);
        }
        free(lastpath);
        FileListBuffer_update_FileList(fileSwitch->parent->fileList);
        return 0;
    } 
    else {
        return -1;
    }
}

int FileSwitchBar_find_file(struct FileSwitchBar * fileswitch, char * filename){
    //DEBUG2("\nin finding\n");
    for (int i = 0; i < fileswitch->n_files; ++ i) {
        if (!strcmp(fileswitch->buttons[i]->edit->text->data[0], filename)) {
            fileswitch->current = fileswitch->files[i];
            return 0;
        }
    }
    return -1;
}

/*********************
 * 
 * ToolBar
 * 
 *********************/
int make_ToolBar(struct ToolBar ** pToolBar, struct BufferManager * parent) {
    struct ToolBar * toolbar = malloc(sizeof(struct ToolBar));
    
    toolbar->area = (struct Area) { 0, 0, 700, 30, 0, 0 };

    memset(toolbar->buttons, 0, sizeof(toolbar->buttons));
    for(int i = 0; i < TOOL_NUM; ++i){
        make_Button(toolbar->buttons + i, toolbar, "ToolBar");
    }
    toolbar->parent = parent;

    *pToolBar = toolbar;

    return 0;
}

int draw_ToolBar(struct ToolBar * pToolBar, struct Area area) {
    area = calc_current_area(area, pToolBar->area);
    int x = 0;
    char tools[TOOL_NUM][20] = {"New File", "New Folder", "Save", "Highlight", "Zoom In", "Zoom Out"};
    for (int i = 0; i < TOOL_NUM; ++ i) {
        struct Button * cur_button = pToolBar->buttons[i];
        cur_button->area.x = x;
        draw_Button(cur_button, area);
        pToolBar->buttons[i]->exec = Button_exec_tool;
        LineEdit_set_str(cur_button->edit->text, tools[i]);
        x += cur_button->area.width;
    }
    return 0;
}

int handle_mouse_ToolBar(struct ToolBar* pToolBar, int x, int y, int mouse_opt){
    mouse_pos_transform(pToolBar->area, &x, &y);

    if (mouse_opt == MOUSE_LEFT_PRESS) {
        for (int i = 0; i < TOOL_NUM; ++ i) {
            struct Button * cur_button = pToolBar->buttons[i];
            if (is_pos_in_area(cur_button->area, x, y)) {
                return handle_mouse_Button(cur_button, x, y, mouse_opt);
            }
        }
    }
    return 0;
}

int Button_exec_tool(struct Button * button) {
    // DEBUG("button_exec\n");
    // DEBUG(button->edit->text->data[0]);
    // printf(0, "click Button %s\n", button->edit->text->data[0]);
    if(!button){
        return -1;
    }
    char* tool_name = button->edit->text->data[0];
    struct ToolBar * toolbar = (struct ToolBar *) button->parent;
    if(!tool_name){
        return -1;
    }
    if(!strcmp(tool_name,"New File")){
        DEBUGDF("\\\\\\ clicked new file botton ------\n");
        //To do
        // 新文件填入filelist 放在fileswitchbar末尾 显示untitled并调用重命名
        char * pathname = toolbar->parent->fileList->path;
        char * fullfilename = strcat(pathname, "New File", strlen(pathname), strlen("New File"));
        int fd;
        if ((fd = open(fullfilename, O_CREATE)) < 0){
            DEBUGDF("createFile Fail!\n");
        }
        close(fd);
        free(fullfilename);
        FileListBuffer_update_FileList(toolbar->parent->fileList);
    }else if(!strcmp(tool_name, "New Folder")){
        DEBUGDF("\\\\\\ clicked new folder botton ------\n");
        // 新目录填入filelist 显示untitled并调用重命名
        char * pathname = toolbar->parent->fileList->path;
        DEBUGDF("mkdirpath: %s\n", toolbar->parent->fileList->path);
        char * fullpath = strcat(pathname, "NewFolder", strlen(pathname), strlen("NewFolder"));
        // int s = mkdir(fullpath);
        // DEBUGDF("mkdir: %d\n", s);
        free(fullpath);
        FileListBuffer_update_FileList(toolbar->parent->fileList);
    }else if(!strcmp(tool_name, "Save")){
        DEBUGDF("\\\\\\ clicked save botton ------\n");
        if(strcmp(button->parent_type, "ToolBar")){
            return -1;
        }
        struct FileBuffer * cur = toolbar->parent->fileSwitch->current;
        if(cur){
            DEBUG("saving\n\n");
            FileBuffer_save_file(cur, cur->filepathname);
        }
        else
        {
            DEBUG("no open file\n");
        }
    } else if(!strcmp(tool_name, "Highlight")) {
        if (cursor_focus && cursor_focus_type == 1) {
            int on = (((struct TextEdit *) cursor_focus)->highlight_on ^= 1);
            LineEdit_set_str(toolbar->parent->statusBar->edit->text, (on? "Highlight Mode On" : "Highlight Mode Off"));
        }
    } else {
        struct FileBuffer * f;
        if ((f = toolbar->parent->fileSwitch->current)) {    
            struct TextEdit * edit = f->edit;
            if (!strcmp(tool_name, "Zoom In")) {
                if (edit->scale < MAX_SCALE) ++ edit->scale;
                else
                    LineEdit_set_str(toolbar->parent->statusBar->edit->text, "Already Max Size");
            } else if (!strcmp(tool_name, "Zoom Out")) {
                if (edit->scale > MIN_SCALE) -- edit->scale;
                else
                    LineEdit_set_str(toolbar->parent->statusBar->edit->text, "Already Min Size");
            }
        }
    }
    return -1;
}

/*********************
 * 
 * pinyin Input.
 * 
 *********************/

int make_pinyinInput(struct PinyinInput ** pPinyin, struct BufferManager * parent) {
    struct PinyinInput * pinyin = malloc(sizeof(struct PinyinInput));
    
    pinyin->area = (struct Area) { 600, 548, 200, 32, 0, 0 };
    pinyin->page = 0;
    pinyin->on = 0;
    make_TextEdit(& pinyin->edit, parent, "pinyinInput");
    pinyin->edit->area = (struct Area) { 0, 0, 200, 32, 0, 0 };
    LineEdit_set_str(pinyin->edit->text, "");
    new_line_to_editor(pinyin->edit->text);
    move_to_pos(pinyin->edit->text, 0, 0);
    pinyin->parent = parent;

    *pPinyin = pinyin;

    return 0;
}

int draw_pinyinInput(struct PinyinInput * pinyin, struct Area area) {
    area = calc_current_area(area, pinyin->area);
    drawrect(AREA_ARGS(area), 59196);
    draw_TextEdit(pinyin->edit, area);
    return 0;
}

void pinyin_updateHanList(struct PinyinInput * pinyin) {
    struct textframe * text = pinyin->edit->text;

    move_to_pos(text, 1, -1);
    clear_cur_line(text);

    for (int i = 0; i < ITEM_EVERY_PAGE; ++ i) {
        char han[5];
        han[0] = i+1 + '0';
        han[1] = '.';
        int count = 0;
        int r = get_pinyin_ith_han(text->data[0], pinyin->page * ITEM_EVERY_PAGE + i, han + 2, han + 3, &count);
        han[4] = 0;

        if (r >= 0) {
            // 在第二行显示中文
            move_to_pos(text, 1, -1);           
            for (int i = 0; i < 4; ++ i) {
                char c = han[i];
                putc_to_str(text, c);
                move_to_next_char(text);
            }
            move_to_pos(text, 0, -1);
        }
    }
}

int handle_keyboard_pinyinInput(struct PinyinInput * pinyin, int c) {
    struct textframe * text = pinyin->edit->text;

    // 当输入框中没有字符时，不识别字母以外的其他符号。
    if (text->data[0][0] == '\0' && !('a' <= c && c <= 'z')) {
        return -1;
    }


    if (('a' <= c && c <= 'z') || c == BACKSPACE || c == ',' || c == '.' || c == '\'') {
        if (c == ',') {
            if (pinyin->page > 0) -- pinyin->page;
        } else if (c == '.') {
            ++ pinyin->page;
        } else {
            pinyin->page = 0;
            move_to_pos(text, 0, -1);
            handle_keyboard_TextEdit(pinyin->edit, c);
        }

        pinyin_updateHanList(pinyin);

        return 0;
    } else if ((c == ENTER || ('1' <= c && c <= '0' + ITEM_EVERY_PAGE)) && 
                cursor_focus && 0 <= cursor_focus_type && cursor_focus_type <= 1) {
        struct textframe * target_text;
        if (cursor_focus_type == 1) target_text = ((struct TextEdit *) cursor_focus)->text;
        else if (cursor_focus_type == 0) target_text = ((struct LineEdit *) cursor_focus)->text;
        
        char han[3] = { 0 };
        char * str_to_insert;

        // 要从输入法的输入框中剔除掉的字母个数
        int count = 0;

        if (c == ENTER) {
            str_to_insert = text->data[0];
            count = strlen(str_to_insert);
        } else {
            int r = get_pinyin_ith_han(text->data[0], c - '0' - 1 + pinyin->page * ITEM_EVERY_PAGE, han, han + 1, &count);
            // printf(0, "pinyin han exist r: %d\n", r);
            han[2] = 0;
            if (r == -1) {
                return -1;
            }
            str_to_insert = han;
        }
        
        int len = strlen(str_to_insert);

        for (int i = 0; i < len; ++ i) {
            char c = str_to_insert[i];
            putc_to_str(target_text, c);
            move_to_next_char(target_text);
        }

        while (text->data[0][count] == '\'') ++ count;

        LineEdit_set_str(text, text->data[0] + count);
        printf(0, "count = %d\n", count);
        move_to_pos(text, 0, -1);
        new_line_to_editor(text);
        move_to_pos(text, 0, -1);

        pinyin_updateHanList(pinyin);

        return 0;
    } else {
        return -1;
    }
}

/*********************
 * 
 * SearchFrame.
 * 
 *********************/
int make_SearchFrame(struct SearchFrame** psearch, struct FileSwitchBar* parent){
    struct SearchFrame * search = malloc(sizeof (struct SearchFrame));
    memset(search, 0, sizeof(struct SearchFrame));
    search->edit = 0;
    make_TextEdit(&search->edit, search, "SearchFrame");
    
    search->parent = parent;
    search->area = (struct Area) {500, 0, 200, 18, 0, 0 };;

    *psearch = search;

    return 0;
}

int draw_SearchFrame(struct SearchFrame* search, struct Area area){
    area = calc_current_area(area, search->area);
    DEBUG2("[GUI SearchFrame] drawing. area (x, y, width, height) = (%d %d %d %d)\n",
    area.x,
    area.y,
    area.width,
    area.height);
    drawrect(AREA_ARGS(area), 59196);
    return draw_TextEdit(search->edit, area);
}

int handle_keyboard_SearchFrame(struct SearchFrame* search, int c){
    if(c == ENTER){
        // int Search(Textframe * edit, char * str);
        if(search->parent->current && search->edit->text){
            // not found
            if(Search(search->parent->current->edit->text, search->edit->text->data[0]) >= 0){
                struct TextEdit* edit = search->parent->current->edit;
                //edit->text->cursor_col = 4;
                //edit->text->cursor_row = 0;
                edit->point2_col = edit->text->cursor_col - 1;
                edit->point2_row = edit->text->cursor_row;
                edit->point1_col = edit->text->cursor_col - strlen(search->edit->text->data[0]);
                edit->point1_row = edit->text->cursor_row;
                edit->selecting = 1;
                // DEBUG2("there %d %d %d %d\n",edit->point2_col, edit->point2_row,
                // edit->point1_col,edit->point1_row);
                cursor_focus = edit;
                cursor_focus_type = 1;
            //  DEBUG2(" not found\n");
            }else
                LineEdit_set_str(search->parent->parent->statusBar->edit->text, "No results.");
        }
        DEBUG2("searching\n");
        return 0;
    }else{
        return handle_keyboard_TextEdit(search->edit, c);
    }
}

int handle_mouse_SearchFrame(struct SearchFrame* search, int x, int y, int mouse_opt){
    return handle_mouse_TextEdit(search->edit, x, y, mouse_opt);
}

/*********************
 * 
 * StatusBar
 * 
 *********************/
int make_StatusBar(struct StatusBar** pstatusBar, struct BufferManager* parent){
    struct StatusBar * statusBar = malloc(sizeof (struct StatusBar));
    memset(statusBar, 0, sizeof(struct StatusBar));
    statusBar->edit = 0;
    make_LineEdit(&statusBar->edit, statusBar, "StatusBar");
    
    statusBar->parent = parent;
    statusBar->area = (struct Area) {0, 580, 800, 20, 0, 0 };;

    *pstatusBar = statusBar;

    return 0;
}

int draw_StatusBar(struct StatusBar* statusBar, struct Area area){
    area = calc_current_area(area, statusBar->area);
    DEBUG2("[GUI SatusBar] drawing. area (x, y, width, height) = (%d %d %d %d)\n",
    area.x,
    area.y,
    area.width,
    area.height);
    drawrect(AREA_ARGS(area), 59196);
    return draw_LineEdit(statusBar->edit, area);
}

/*
 * 用于获取输入法当前的状态。
 * 输入法在输入框中有字符时，能够识别： a-z  ' , . 1-5
 * 没有字符时，能够识别 a-z
 */

/*********************
 * 
 * Main function. 
 * 
 *********************/

int main() {
    struct BufferManager *manager;

    gbk_point_init();
    char_point_init();
    pinyin_init();
    highlight_init();

    make_BufferManager(& manager);

    DEBUG("----- [GUI] BUffer Manager Init Finished. -----\n");

    draw_BufferManager(manager, (struct Area) {0, 0, 800, 600, 0, 0});

    int msg = get_msg();

    while (1) {
        int type = msg >> 24;
        int x = msg >> 12 & 0xfff;
        int y = msg & 0xfff;

        switch (type)
        {
        case MOUSE_LEFT_PRESS: 
        case MOUSE_LEFT_RELEASE:
        case MOUSE_RIGHT_PRESS:
        case MOUSE_RIGHT_RELEASE:
        case MOUSE_MOVE:
            DEBUG("[GUI] mouse message get. type = %d\n", type);
            handle_mouse_BufferManager(manager, x, y, type);
            break;

        case KEYBOARD:
            DEBUGDF("keyboard msg = %d\n",  msg);
            handle_keyboard_BufferManager(manager, msg & 0xffffff);
            break;

        default:
            break;
        }

        sleep(0);
        msg = get_msg();
        
        if (msg == 0) {
            draw_BufferManager(manager, (struct Area) {0, 0, 800, 600, 0, 0});
            update();
            
            do {
                msg = get_msg();
            } while (!msg);
        }
    }
}

int FileSwitchBar_handle_tab(struct FileSwitchBar * fileswitch){
    if(!fileswitch){
        return -1;
    }
    for (int i = 0; i < fileswitch->n_files; ++ i) {
        if (fileswitch->files[i] == fileswitch->current) {
            fileswitch->current = fileswitch->files[(i+1)%fileswitch->n_files];
            return 0;
        }
    }
    return -1;
}