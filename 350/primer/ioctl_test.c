#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

#define IOCTL_TEST _IOW(0, 6, struct ioctl_test_t)
#define IOCTL_GETCHAR _IOR(1, 7, struct ioctl_getchar_t)

int main () {

  int fd = open ("/proc/ioctl_test", O_RDONLY);

  /* attribute structures 
  struct ioctl_test_t {
    int field1;
    char field2;
  } ioctl_test;

  ioctl_test.field1 = 10;
  ioctl_test.field2 = 'a';

  ioctl (fd, IOCTL_TEST, &ioctl_test);
  */

  struct ioctl_getchar_t {
    char *ret_addr;
  } ioctl_getchar;

  char ch;
  ioctl_getchar.ret_addr = &ch;


  while(1) {
    ioctl (fd, IOCTL_GETCHAR, &ioctl_getchar);
    char str[2] = {ch, '\0'};
    write(STDOUT_FILENO, str, 2);
  }

  return 0;
}
