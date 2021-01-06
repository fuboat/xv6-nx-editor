#include "textframe.h"

struct Area {
    int x, y;
    int width, height;
    int offset_x, offset_y;

    /* area 中的 x, y 表示相较于父组件的 (0, 0)，属于该组件的绘制区域的左上角坐标。 */ 
    /* area 中的 width 和 height 则表示绘制区域的宽度和高度。 */
    /* 用于控制各个组件的位置。 */
    /* offset_x, offset_y 表示，相较于自己的 (0, 0)，要绘制的区域在 (offset_x, offset_y)。 */
    /* 用于控制翻页。 */
};

struct LineEdit {
    struct Area area; 
    struct textframe* text;
    void * parent;
    char * parent_type; /* "FileListBuffer" */
};

struct TextEdit {
    struct Area area; 
    struct textframe* text;
    void * parent;
    char * parent_type; /* "FileListBuffer" */
};

struct FileNameControl {
    struct Area area;
    struct LineEdit * edit;
    char oldName[512];

    struct FileListBuffer * parent;
};

struct FileListBuffer {
    struct Area area;
    
    int n_files;

    struct FileNameControl ** files;
    struct FileNameControl * file_selected;

    struct BufferManager * parent;

    char path[512];
};

struct BufferManager {
    struct Area area;
    struct FileListBuffer * fileList;
    struct FileSwitchBar * fileSwitch;
    struct ToolBar * toolBar;
    void * focus;
};

struct FileBuffer {
    struct Area area;
    struct TextEdit *edit;
    struct FileSwitchBar * parent;
    char filepathname[512];
};

struct Button;

struct Button {
    struct Area area;
    struct LineEdit *edit; // 控制按钮显示的文本内容。

    void * parent;
    char * parent_type;

    int (*exec)(struct Button *); // **重要**：该按钮按下时触发的操作。
};

#define FILESWITCH_MAX_FILES 10

struct FileSwitchBar {
    struct Area area;

    struct Button * buttons[FILESWITCH_MAX_FILES];
    struct FileBuffer * files[FILESWITCH_MAX_FILES];

    int n_files;

    struct FileBuffer * current;
    
    struct BufferManager * parent;
};

#define TOOL_NUM 3

struct ToolBar
{
    struct Area area;
    struct Button * buttons[TOOL_NUM];

    struct BufferManager * parent;
    
};


int make_TextEdit(struct TextEdit **, void * parent, char * parent_type);
int draw_TextEdit(struct TextEdit*, struct Area area);
int handle_mouse_TextEdit(struct TextEdit*, int x, int y,  int mouse_opt);
int handle_keyboard_TextEdit(struct TextEdit *edit, int c);

int make_LineEdit(struct LineEdit **, void * parent, char * parent_type);
int draw_LineEdit(struct LineEdit*, struct Area area);
int handle_mouse_LineEdit(struct LineEdit*, int x, int y,  int mouse_opt);
int handle_keyboard_LineEdit(struct LineEdit *edit, int c);

int make_FileListBuffer(struct FileListBuffer **, struct BufferManager * parent);
int draw_FileListBuffer(struct FileListBuffer *, struct Area area);
int handle_mouse_FileListBuffer(struct FileListBuffer*, int x, int y, int mouse_opt);
int handle_keyboard_FileListBuffer(struct FileListBuffer*, int c);
int FileListBuffer_update_FileList(struct FileListBuffer *);

int make_FileNameControl(struct FileNameControl **, struct FileListBuffer * parent);
int draw_FileNameControl(struct FileNameControl *, struct Area area);
int handle_mouse_FileNameControl(struct FileNameControl*, int x, int y, int mouse_opt);
int handle_keyboard_FileNameControl(struct FileNameControl*, int c);

int make_FileBuffer(struct FileBuffer **, struct FileSwitchBar * parent);
int draw_FileBuffer(struct FileBuffer *, struct Area area);
int handle_mouse_FileBuffer(struct FileBuffer *, int x, int y, int mouse_opt);
int handle_keyboard_FileBuffer(struct FileBuffer *, int c);

int make_BufferManager(struct BufferManager **);
int draw_BufferManager(struct BufferManager *, struct Area area);
int handle_mouse_BufferManager(struct BufferManager *, int x, int y, int mouse_opt);
int handle_keyboard_BufferManager(struct BufferManager *, int c);

int make_Button(struct Button **, void * parent, char * parent_type);
int draw_Button(struct Button *, struct Area area);
int handle_mouse_Button(struct Button *, int x, int y, int mouse_opt);

int make_FileSwitchBar(struct FileSwitchBar **, struct BufferManager * parent);
int draw_FileSwitchBar(struct FileSwitchBar *, struct Area area);
int handle_mouse_FileSwitchBar(struct FileSwitchBar *, int x, int y, int mouse_opt);
int handle_keyboard_FileSwitchBar(struct FileSwitchBar *, int c);
int FileSwitchBar_open_file(struct FileSwitchBar * fileSwitch, char * filename);
int FileSwitchBar_save_file(struct FileSwitchBar * fileSwitch, char * filename);

int make_ToolBar(struct ToolBar **, struct BufferManager* parent);
int draw_ToolBar(struct ToolBar *, struct Area area);
int handle_mouse_ToolBar(struct ToolBar*, int x, int y, int mouse_opt);
int handle_keyboard_ToolBar(struct ToolBar*, int c);
int Button_exec_tool(struct Button * button);