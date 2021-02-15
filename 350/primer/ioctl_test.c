#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define IOCTL_TEST _IOW(0, 6, struct ioctl_test_t)
#define IOCTL_GETCHAR _IOR(1, 7, struct ioctl_getchar_t)

int main () {

  int fd = open ("/proc/ioctl_test", O_RDONLY);

  struct ioctl_getchar_t {
    char *ret_addr;
  } ioctl_getchar;

  char ch;
  ioctl_getchar.ret_addr = &ch;

  while(1) {
    ioctl (fd, IOCTL_GETCHAR, &ioctl_getchar);
    //char str[3];
    //sprintf(str, "%02X", ch);
    char str[2] = {ch, '\0'};
    write(STDOUT_FILENO, str, sizeof(str)/sizeof(str[0]));
  }

  return 0;
}
