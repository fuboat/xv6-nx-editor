# BufferManager 缓冲区管理器

```c
typedef struct {
	int x, y;  // 左上角坐标
    int width, height;  // 宽度和高度
} Area;
```

```c
typedef struct {
	Area area;
    
    FileListBuffer * fileList;
    CommandBuffer * command;
    ToolBar * toolbar;
    FileSwitchBar * fileSwitchBar;
    TextEdit * edit;
} BufferManager;
```



## FileListBuffer 文件列表

该类用于维护当前目录下有哪些文件，并将其显示在列表中。

```c
typedef struct {
    Area area;
    
    int n_edits;
    
    LineEdit **edits;
    LineEdit *edit_selected;
    
    BufferManager * parent;
    
    // ...
} FileListBuffer;

int make_FileListBuffer(FileListBuffer**, BufferManager * parent);
int draw_FileListBuffer(FileListBuffer*, Area area);
int handle_mouse_FileListBuffer(FileListBuffer*, int x, int y, int mouse_opt);
int handle_keyboard_FileListBuffer(FileListBuffer*, int c);
```



## CommandBuffer 

该类用于维护一个buffer，支持在其中输入指令，完成类似命令行的功能，并绘制在屏幕。

```c
typedef struct {
    Area area;
    
    TextEdit *edit;
    
    BufferManager * parent;
    
    // ...，参考 console.c
} CommandBuffer;

int make_CommandBuffer(CommandBuffer**);
int draw_CommandBuffer(CommandBuffer*, Area area);
int handle_mouse_CommandBuffer(CommandBuffer*, int x, int y, int mouse_opt);
int handle_keyboard_CommandBuffer(CommandBuffer*, int c);
```

## ToolBar

该类用于维护工具栏的按钮，在按钮被按下时执行相应的指令，并将按钮绘制在屏幕。

```c
typedef struct {
	Area area;
	
	BufferManager * parent;
    
    // ..., 应该有一系列button
} ToolBar;

int make_ToolBar(ToolBar**);
int draw_ToolBar(ToolBar*, Area area);
int handle_mouse_ToolBar(ToolBar*, int x, int y, int mouse_opt);
int handle_keyboard_ToolBar(ToolBar*, int c);
```

## Button

表示一个按钮。在按钮被按下时执行相应的指令。

```c
typedef struct {
	Area area;
    
    ToolBar * parent;
    
    // ...
    
    int flag;
    
    void * parent;
} Button;

int make_Button(Button**, void * parent);
int draw_Button(Button*, Area area);
int handle_mouse_Button(Button* b, int x, int y, int mouse_opt) {
    switch_case(b->flag) {
        case ...:
        {
            ToolBar * parent = b->flag;
            // ...
        }
    }
}
int handle_keyboard_Button(Button*, int c);
```

## FileSwitchBar

该类用于维护当前打开的所有文件的tab。按下相应的tab会切到相应的文件。并将这些tab绘制在屏幕。

```c
typedef struct {
	Area area;
	
	BufferManager * parent;
} FileSwitchBar;

int make_FileSwitchBar(FileSwitchBar**);
int draw_FileSwitchBar(FileSwitchBar*, Area area);
int handle_mouse_FileSwitchBar(FileSwitchBar*, int x, int y, int mouse_opt);
int handle_keyboard_FileSwitchBar(FileSwitchBar*, int c);
```

## LineEdit

单行文本编辑框。支持各类文本操作。并且可以设置哪些操作被屏蔽。

```c
typedef struct {
	Area area;
    textframe * text;
}

int make_LineEdit(LineEdit**);
int draw_LineEdit(LineEdit*, Area area);
int handle_mouse_LineEdit(LineEdit*, int x, int y, int mouse_opt);
int handle_keyboard_LineEdit(LineEdit*, int c);
```



## TextEdit

文本编辑框。支持各类文本操作。并且可以设置哪些操作被屏蔽。

```c
typedef struct {
	Area area;
	textframe * text;
}

int make_TextEdit(TextEdit**);
int draw_TextEdit(TextEdit*, Area area);
int handle_mouse_TextEdit(TextEdit*, int x, int y, int mouse_opt);
int handle_keyboard_TextEdit(TextEdit*, int c);
```

