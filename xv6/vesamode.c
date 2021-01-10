#include "types.h"
#include "defs.h"
#include "memlayout.h"
#include "vesamode.h"

// Get the VESA mode information
void vesamodeinit()
{
    VESA_ADDR = KERNBASE + 0x1028;
    SCREEN_WIDTH = *((unsigned short*)(KERNBASE + 0x1012));
    SCREEN_HEIGHT = *((unsigned short*)(KERNBASE + 0x1014));
}
