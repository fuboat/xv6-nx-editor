struct stat;

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(char*, int);
int mknod(char*, short, short);
int unlink(char*);
int fstat(int fd, struct stat*);
int link(char*, char*);
int mkdir(char*);
int chdir(char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);
int drawrect(int xl, int yl, int width, int height, int color);
int drawarea(int xl, int yl, int width, int height, int *colors);
int drawarea_short(int xl, int yl, int width, int height, unsigned short *colors);
int drawgbk(int xl, int yl, int width, int height, char * gbk);
int update();
int get_msg(void);

// ulib.c
int stat(char*, struct stat*);
char* strcpy(char*, char*);
void *memmove(void*, void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, char*, ...);
char* gets(char*, int max);
uint strlen(char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);

// for message
enum MSG_TYPE {
    KEYBOARD,
    MOUSE_LEFT_PRESS,
    MOUSE_LEFT_RELEASE,
    MOUSE_RIGHT_PRESS,
    MOUSE_RIGHT_RELEASE
};

#define DEBUG(...)  // printf(2, __VA_ARGS__)
#define DEBUG2(...)  // printf(2, __VA_ARGS__)
#define DEBUGDF(...) printf(2, __VA_ARGS__)
#define max(a, b) (a) > (b) ? (a) : (b)
#define min(a, b) (a) < (b) ? (a) : (b)