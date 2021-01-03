#include "textframe.h"

struct Area {
    int x, y;
    int width, height;
};

struct LineEdit {
    struct Area area;

    struct textframe* text;
    void * parent;
    char * parent_type; /* "FileListBuffer" */
};

struct BufferManager {
};

struct FileListBuffer {
};
