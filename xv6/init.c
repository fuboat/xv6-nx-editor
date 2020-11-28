// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = {"textframe", 0};

int main(void)
{
  int pid, wpid;

  if (open("console", O_RDWR) < 0)
  {
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr
  
  printf(1, "init: try to draw background\n");

  for (;;)
  {
    printf(1, "init: starting textframe\n");
    pid = fork();
    if (pid < 0)
    {
      printf(1, "init: fork failed\n");
      exit();
    }
    if (pid == 0)
    {
      exec("textframe", argv);
      printf(1, "init: exec textframe failed\n");
      exit();
    }
    while ((wpid = wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
