#include <linux/fs.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>

static int cmdline_proc_show(struct seq_file *m, void *v)
{
	seq_printf(m, "%s\n", saved_command_line);
	return 0;
}

static int cmdline_proc_open(struct inode *inode, struct file *file)
{
	return single_open(file, cmdline_proc_show, NULL);
}

static const struct file_operations cmdline_proc_fops = {
	.open		= cmdline_proc_open,
	.read		= seq_read,
	.llseek		= seq_lseek,
	.release	= single_release,
};

static int __init proc_cmdline_init(void)
{
	proc_create("cmdline", 0, NULL, &cmdline_proc_fops);
	return 0;
}
module_init(proc_cmdline_init);

#ifdef CONFIG_CMDLINE_OVERRIDE
static int original_cmdline_proc_show(struct seq_file *m, void *v)
{
	seq_printf(m, "%s\n", original_command_line);
	return 0;
}

static int original_cmdline_proc_open(struct inode *inode, struct file *file)
{
	return single_open(file, original_cmdline_proc_show, NULL);
}

static const struct file_operations original_cmdline_proc_fops = {
	.open		= original_cmdline_proc_open,
	.read		= seq_read,
	.llseek		= seq_lseek,
	.release	= single_release,
};

static int __init proc_original_cmdline_init(void)
{
	proc_create("original_cmdline", 0, NULL, &original_cmdline_proc_fops);
	return 0;
}
module_init(proc_original_cmdline_init);
#endif
