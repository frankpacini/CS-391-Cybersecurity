/*
 *  ioctl test module -- Rich West.
 */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h> /* error codes */
#include <linux/proc_fs.h>
#include <asm/uaccess.h>
#include <linux/tty.h>
#include <linux/sched.h>
#include <linux/interrupt.h>
#include <linux/wait.h>

MODULE_LICENSE("GPL");

/* 'printk' version that prints to active tty. */
void my_printk(char *string)
{
  struct tty_struct *my_tty;

  my_tty = current->signal->tty;

  if (my_tty != NULL) {
    (*my_tty->driver->ops->write)(my_tty, string, strlen(string));
    (*my_tty->driver->ops->write)(my_tty, "\015\012", 2);
  }
} 

/* attribute structures */
struct ioctl_test_t {
  int field1;
  char field2;
};

struct ioctl_getchar_t {
  char *ret_addr;
};

#define IOCTL_TEST _IOW(0, 6, struct ioctl_test_t)
#define IOCTL_GETCHAR _IOR(1, 7, struct ioctl_getchar_t)

static int pseudo_device_ioctl(struct inode *inode, struct file *file,
			       unsigned int cmd, unsigned long arg);

static struct file_operations pseudo_dev_proc_operations;

static struct proc_dir_entry *proc_entry;

DECLARE_WAIT_QUEUE_HEAD (my_queue);

static char my_char;

static int is_shifted = 0;

static int is_caps_locked = 0;

static inline unsigned char inb( unsigned short usPort ) {

    unsigned char uch;
   
    asm volatile( "inb %1,%0" : "=a" (uch) : "Nd" (usPort) );
    return uch;
}

static inline void outb( unsigned char uch, unsigned short usPort ) {

    asm volatile( "outb %0,%1" : : "a" (uch), "Nd" (usPort) );
}

irqreturn_t my_getchar (int irq, void *dev_id) {

  int c;

  static char *scancode;
  
  if(is_shifted || is_caps_locked) {
    scancode = "\0\e!@#$%^&*()_+\b\tQWERTYUIOP{}\n\0ASDFGHJKL:\"~l|ZXCVBNM<>?r*\0 \0\0\0\0\0\0\0\0\0\0\0\0\000789-456+1230.\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
  } else {
    scancode = "\0\e1234567890-=\b\tqwertyuiop[]\n\0asdfghjkl;'`L\\zxcvbnm,./R*\0 \0\0\0\0\0\0\0\0\0\0\0\0\000789-456+1230.\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
  }

  /* Poll keyboard status register at port 0x64 checking bit 0 to see if
   * output buffer is full. We continue to poll if the msb of port 0x60
   * (data port) is set, as this indicates out-of-band data or a release
   * keystroke
   */
  c = (int) inb( 0x60 );
  
  printk("<1> Interrupt");
  printk("<1> Data Port: %x, %d, %c", c, c, scancode[(int) c]);

  my_char = '\0';

  if(c == 42 || c == 54) { // left or right shift pressed
    is_shifted = 1; 
    printk("<1> Shift on");
  } else if(c == 170 || c == 182 || c == -86 || c == -74) { // left or right shift released
    is_shifted = 0; 
    printk("<1> Shift off");
  } else if(c == 58) { // Caps lock pressed
    is_caps_locked = ~is_caps_locked;
  } else if(//(inb( 0x64 ) & 0x1) && 
      !(c & 0x80)) {
    my_char = scancode[c];
    printk("<1> %c", my_char);
  }

  wake_up_interruptible((wait_queue_head_t *) &my_queue);
  return IRQ_HANDLED;
}

static int __init initialization_routine(void) {
  printk("<1> Loading module\n");

  pseudo_dev_proc_operations.ioctl = pseudo_device_ioctl;

  /* Start create proc entry */
  proc_entry = create_proc_entry("ioctl_test", 0444, NULL);
  if(!proc_entry)
  {
    printk("<1> Error creating /proc entry.\n");
    return 1;
  }

  proc_entry->proc_fops = &pseudo_dev_proc_operations;

  int i = request_irq(1, &my_getchar, IRQF_SHARED, "my keyboard driver", "1234");
  printk("<1> Request IRQ gave response %d", i);
  return i;
}

static void __exit cleanup_routine(void) {
  free_irq(1, "1234");
  printk("<1> Dumping module\n");
  remove_proc_entry("ioctl_test", NULL);

  return;
}


/***
 * ioctl() entry point...
 */

static int pseudo_device_ioctl(struct inode *inode, struct file *file,
				unsigned int cmd, unsigned long arg)
{
  struct ioctl_test_t ioc_test;
  struct ioctl_getchar_t ioc_getchar;
  
  switch (cmd) {
    case IOCTL_TEST:
      copy_from_user(&ioc_test, (struct ioctl_test_t *)arg, 
        sizeof(struct ioctl_test_t));
      printk("<1> ioctl: call to IOCTL_TEST (%d,%c)!\n", 
      ioc_test.field1, ioc_test.field2);
      my_printk ("Got msg in kernel\n");
      break;
    case IOCTL_GETCHAR:
      copy_from_user(&ioc_getchar, (struct ioctl_getchar_t *)arg, sizeof(struct ioctl_getchar_t));
      while(1) {
        interruptible_sleep_on((wait_queue_head_t *) &my_queue);
        if(my_char != '\0') {
          copy_to_user(ioc_getchar.ret_addr, &my_char, 1);
          printk("<1> ioctl: Character \"%c\" sent to address %x!\n", my_char, (unsigned int) ioc_getchar.ret_addr);
          break;
        } else {
          printk("Skip");
        }
      }
      
      break;
    default:
      return -EINVAL;
      break;
  }
  
  return 0;
}


module_init(initialization_routine); 
module_exit(cleanup_routine); 
