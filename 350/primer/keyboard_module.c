
#include <linux/errno.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/kallsyms.h>
#include <linux/module.h>
#include <linux/proc_fs.h>
#include <linux/sched.h>
#include <linux/tty.h>
#include <linux/wait.h>  
#include <asm/uaccess.h>

MODULE_LICENSE("GPL");

DECLARE_WAIT_QUEUE_HEAD (my_queue);

/* attribute structure */
struct ioctl_getchar_t {
  char *ret_addr;
};

/* ioctl fields */
#define IOCTL_GETCHAR _IOR(0, 6, struct ioctl_getchar_t)

static int pseudo_device_ioctl(struct inode *inode, struct file *file,
			       unsigned int cmd, unsigned long arg);

static struct file_operations pseudo_dev_proc_operations;

static struct proc_dir_entry *proc_entry;

/* interrupt fields and functions */
static char my_char;

static int is_shifted = 0;

static int is_caps_locked = 0;

irqreturn_t (*i8042_interrupt)(int, void *) = NULL;

static inline unsigned char inb( unsigned short usPort ) {

    unsigned char uch;
   
    asm volatile( "inb %1,%0" : "=a" (uch) : "Nd" (usPort) );
    return uch;
}

static inline void outb( unsigned char uch, unsigned short usPort ) {

    asm volatile( "outb %0,%1" : : "a" (uch), "Nd" (usPort) );
}

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

/***
 * keyboard interrupt handler
 */

irqreturn_t keyboard_interrupt (int irq, void *dev_id) {

  int index = (int) inb( 0x60 );;

  static char *scancode;
  
  if(is_shifted || is_caps_locked) {
    scancode = "\0\e!@#$%^&*()_+\b\tQWERTYUIOP{}\n\0ASDFGHJKL:\"~l|ZXCVBNM<>?r*\0 \0\0\0\0\0\0\0\0\0\0\0\0\000789-456+1230.\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
  } else {
    scancode = "\0\e1234567890-=\b\tqwertyuiop[]\n\0asdfghjkl;'`L\\zxcvbnm,./R*\0 \0\0\0\0\0\0\0\0\0\0\0\0\000789-456+1230.\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
  }
  
  // printk("<1> Interrupt");
  // printk("<1> Data Port: %x, %d, %c", index, index, scancode[index]);

  my_char = '\0';

  if(index == 42 || index == 54) { // left or right shift pressed
    is_shifted = 1; 
    //printk("<1> Shift on");
  } else if(index == 170 || index == 182 || index == -86 || index == -74) { // left or right shift released
    is_shifted = 0; 
    //printk("<1> Shift off");
  } else if(index == 58) { // Caps lock pressed
    is_caps_locked = ~is_caps_locked;
  } else if(//(inb( 0x64 ) & 0x1) && 
      !(index & 0x80)) {
    my_char = scancode[index];
    //printk("<1> %c", my_char);
  }

  wake_up_interruptible((wait_queue_head_t *) &my_queue);
  return IRQ_HANDLED;
}

/***
 * ioctl() entry point
 */

static int pseudo_device_ioctl(struct inode *inode, struct file *file,
				unsigned int cmd, unsigned long arg)
{
  struct ioctl_getchar_t ioc_getchar;
  
  switch (cmd) {
    case IOCTL_GETCHAR:
      copy_from_user(&ioc_getchar, (struct ioctl_getchar_t *)arg, sizeof(struct ioctl_getchar_t));
      while(1) {
        interruptible_sleep_on((wait_queue_head_t *) &my_queue);
        if(my_char != '\0') {
          copy_to_user(ioc_getchar.ret_addr, &my_char, 1);
          printk("<1> ioctl: Character \"%c\" sent to address %x!\n", my_char, (unsigned int) ioc_getchar.ret_addr);
          break;
        }
      }
      break;
    default:
      return -EINVAL;
      break;
  }
  
  return 0;
}

/***
 * module initialization and removal routines
 */

static int __init initialization_routine(void) {
  printk("<1> Loading module\n");
  i8042_interrupt = (irqreturn_t (*)(int, void *)) kallsyms_lookup_name("i8042_interrupt");

  pseudo_dev_proc_operations.ioctl = pseudo_device_ioctl;

  /* Start create proc entry */
  proc_entry = create_proc_entry("keyboard_test", 0444, NULL);
  if(!proc_entry)
  {
    printk("<1> Error creating /proc entry.\n");
    return 1;
  }

  proc_entry->proc_fops = &pseudo_dev_proc_operations;

  void (*i8042_free_irqs)(void) = (void (*)(void)) kallsyms_lookup_name("i8042_free_irqs");
  i8042_free_irqs();
  free_irq(1, (void *) i8042_interrupt);

  int i = request_irq(1, &keyboard_interrupt, IRQF_SHARED, "keyboard driver", (void *) keyboard_interrupt);
  printk("<1> Request IRQ gave response %d", i);

  return i;
}

static void __exit cleanup_routine(void) {
  remove_proc_entry("keyboard_test", NULL);

  request_irq(1, i8042_interrupt, 
    IRQF_SHARED, "i8042", (void *) i8042_interrupt);

  free_irq(1, (void *) keyboard_interrupt);

  printk("<1> Dumping module\n");

  return;
}

module_init(initialization_routine); 
module_exit(cleanup_routine); 
