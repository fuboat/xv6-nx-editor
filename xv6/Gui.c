#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "Gui.h"

int main() {
    BufferManager *manager = malloc(sizeof(BufferManager));

    while (1) {
        enum MSG_TYPE msg = get_msg();
        int type = msg >> 24;
        int x = msg >> 12 & 0xfff;
        int y = msg & 0xfff;

        switch (type)
        {
        case MOUSE_LEFT_PRESS: 
        case MOUSE_LEFT_RELEASE:
        case MOUSE_RIGHT_PRESS:
        case MOUSE_RIGHT_RELEASE:
            break;

        case KEYBOARD:
            break;

        default:
            break;
        }
    }
}