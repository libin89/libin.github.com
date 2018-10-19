#include <errno.h>
#include <dirent.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mount.h>
#include <fcntl.h>
#include <unistd.h>

int delete_dir(char *directory);

void delete(char *what)
{
  if (unlink(what)) {
    if(errno == EISDIR) {
      if (!delete_dir(what))
	rmdir(what);
    }
  }
}

int delete_dir(char *directory)
{
  DIR *dir;
  struct dirent *d;
  struct stat st1, st2;
  char path[PATH_MAX];

  if (lstat(directory, &st1))
    return errno;

  if (!(dir = opendir(directory)))
      return errno;
      
  while ((d = readdir(dir))) {
    /* skip ./.. */
    if (d->d_name[0] == '.' &&
	(d->d_name[1] == '\0' ||
	 (d->d_name[1] == '.' && d->d_name[2] == '\0')))
      continue;

    sprintf(path, "%s/%s", directory, d->d_name);
    lstat(path, &st2);
    /* do not recurse down mountpoint avoiding del realroot */
    if (st2.st_dev != st1.st_dev)
      continue;

    delete(path);
  }
      closedir(dir);
      return 0;
}

int main(int argc, char *argv[])
{
  int console_fd;

  /* change to the new root directory */
  chdir(argv[1]);

  /* delete rootfs contents */
  delete_dir("/");

  /* overmount the root */
  mount(".", "/", NULL, MS_MOVE, NULL);

  /* chroot, chdir */
  chroot(".");
  chdir("/");

  /* open /dev/console */
  console_fd = open("/dev/console", O_RDWR);
  dup2(console_fd, 0);
  dup2(console_fd, 1);
  dup2(console_fd, 2);
  close(console_fd);

  /* spawn init */
  execlp(argv[2], argv[2], NULL);

  return 0;
}
