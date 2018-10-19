# Ubuntu-ARM
## install oracle vbox（ubuntu system）on the win7-64bit host

### installation packages
* ubuntu system link: https://pan.baidu.com/s/1f1w6nnjl1ff175PdAF9fjQ  password:b97m
* oracle vbox 5.2.18 link: https://pan.baidu.com/s/1koiBCryygSjVVyc4-y0Z9g  password:69vy

### face some issues in this work
> **1. when startup to install ubuntu image, vbox has a error prompt diag.**
`Unable to load R3 module C:\Program Files\Oracle\VirtualBox/VBoxDD.DLL (VBoxDD): GetLastError=1790 (VERR_UNRESOLVED_ERROR).`
`E_FAIL   (0x80004005)`
`Console`
`IConsole   {8ab7c520-2442-4b66-8d74-4ff1e195d2b6}`
* same to issue that the link shows: https://jingyan.baidu.com/article/ab69b270bb7b2a2ca6189f6d.html.
* according to the link, we can replace uxtheme.dll(c:/windows/system32) with win7-64 orignal. file(https://pan.baidu.com/s/13VV-cyIKpT82Bt-VXKVoaw)
> **2. when want to create share memory between host and virtual ubuntu system, need to install VBoxLinuxAdditions package. But installation Fail!**
* because i used oracle vbox 4.3.8, the fail reason is same as Ticket #16966(fixed on Virtual Box official web https://www.virtualbox.org/ticket/16966).
* at last, i update vbox version to 5.2.18 to fix the issue.
* use "df" command, we can see share directory has been mounted.

> **3. ubuntu user has no permission to operate share directory.**
* we can see share directory usergroup is vboxsf via "ls -l" command.
* so use command "sudo adduser username vboxsf" to modify permission.
* it will work after reboot system(sudo reboot).

## install crosstools for embedded development
* 3 ways to build cross compile envirement.
* can try first and second way to build it via following the link below:
* https://blog.csdn.net/t17178351/article/details/72818174, i tried it. but not successful.
* so at last, used third way to complete it.
* the crosstools has beed made completely can be download at https://pan.baidu.com/s/1BTkuJEJen3jZzs7JqWQmhg.
* also issue below, The problem has been solved, because I installed the amd64.iso linux system,so first must excuse apt-get install lsb-core,then you can excuse arm-linux-gcc -v
* **sudo apt-get install lsb-core**
> ~$ arm-none-linux-gnueabi-gcc -v
> bash: /home/xxx/armlinux/tools/bin/arm-none-linux-gnueabi-gcc: No such file or directory
* In addition, use "gcc -dM -E - < /dev/null" to show predefined macro.
* usefull free web link:
1. https://www.kernel.org/
1. https://launchpad.net/gcc-arm-embedded/+download
1. http://ftp.gnu.org/
1. https://blog.csdn.net/iot_ai/article/details/62231622
1. https://blog.csdn.net/victorwjw/article/details/72864770

## 编译内核(虚拟机模拟安装linux镜像笔记，目标机器intel 80386)
### 修改makefile文件
* 根据目标机器配置makefile
* intel 80386: ARCH ?= i386   CROSS_COMPILE ?= i686-none-linux-gnu-
* 三星 s5cpv210: ARCH ?= arm   CROSS_COMPILE ?= arm-none-linux-gnu-

### 编译内核过程中遇到的几个问题
1. fatal error: linux/compiler-gcc5.h: No such file or directory
* copy linux/compiler-gcc4.h to linux/compiler-gcc5.h

2. Can't use 'defined(@array)' (Maybe you should just omit the defined()?) at kernel/timeconst.pl line 373.
* change if (!defined(@val)) to {改为if (!@val) {后，编译成功。

### 内核配置.config
* 根据CPU/MCU选择最接近的defconfig
* cat /proc/cpuinfo | grep "model name"  model name      : Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz
* 以上可以选择arch/x86/configs/i386_defconfig  这个默认配置一般编出来的image直接就是ok的
* 如果是其他cpu，比如三星的S5cpv210，选择arch/arm/configs/s5cpv210_defconfig
* 另外，如果要从头开始定制的话  就使用make allnoconfig，然后根据硬件设备一步步选择配置
* 可以使用make menuconfig UI界面来配置，这个UI需要apt-get install libnucurses5-dev支持

## 构建基本根文件系统
### 根文件系统的基本目录结构
* Linux的根文件系统的目录结构不是随意定义的，而是依照Filesystem Hierarchy Standard Group制定的FHS标准。
* 从服务器/个人计算机到嵌入式系统，大体上都是遵循这个标准的。
* /bin 保存系统管理员与用户均会使用的重要命令
* /boot 系统开机使用的文件，如内核镜像和boot loader的相关文件
* /dev 设备文件
* /etc 系统配置
* /lib 重要的库文件及内核模块
* /media 可移动存储介质的挂载点
* /mnt 临时挂载点，当然用户也可以自行选择一些临时挂载点
* /opt 用户自行安装软件的位置，通常用户也会选择将软件安装在/usr/local目录下
* /sbin 系统管理员使用的重要的系统命令
* /tmp 主要是正在执行的程序存放的临时文件
* /usr 包含系统中安装的主要程序的相关文件，类似MS Windows OS中的“Program files”目录
* /var 针对的主要是系统在运行过程中经常发生变化的一些数据，比如cache/log/临时的数据库/打印机队列等
* /home 用户目录保存的地方
* /root root用户的用户目录
* /srv 主要用在服务器版本上，是很多服务器软件用来保存数据的目录。比如www服务器使用的网页资料就可以放在/srv/www目录下
> 几个容易混淆的目录说明：
* 有四个存放可执行程序的目录：/bin /sbin /usr/bin /usr/sbin。
* 系统管理员和普通用户都使用的重要命令保存在/bin目录下
* 仅由系统管理员使用的重要命令保存在/sbin目录下
* 相应的，不是很重要的命令则分别存放在/usr/bin和/usr/sbin目录下。
* 同样的道理，重要的系统库一般存放在/lib目录下，其他的库则存放在/usr/lib目录下。

### 构建最基本的根文件系统
* 由内核进入用户空间（init/main.c）时 执行/bin/sh
* 在/boot/grub/grub.cfg（bootloader引导配置）中设置'init='
* menuentry 'vita' {
    set root='(hd0,5)' //5是分区标号 为根目录 比如sda1 sda5
    linux /boot/bzImage root=/dev/sda5 ro init=/bin/bash
}
* 以上例子是明确告诉内核，第一个进程执行运行/bin/bash，如果用户没有通过命令行参数“init”指定第一个执行的程序，
* 这个进程将依次尝试执行/sbin，/etc, /bin下的init, 最后尝试执行/bin/sh。
> 另外，执行bash需要必要的C库支持:
* 可以使用'readelf -d ./bash | grep NEEDED' to find out which libs are required.
* **NOTE, file ./bash提示需要解释器/lib/ld-linux.so.2!!!**
* file ./bash输出：./bash: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), dynamically linked, 
* interpreter /lib/ld-linux.so.2, for GNU/Linux 2.6.32, BuildID[sha1]=e53f89d40c6b2cea5d74682160b3180327877d64, not stripped
* Use 'readelf -d lib* | grep NEEDED' to find out the lib's despends.
* 所以在根目录下创建/bin /lib目录下，选择vita系统后 正常进入了shell应用程序。

### make initramfs
* **config kernel to support initramfs**
* make menuconfig: General setup->Initial RAM filesystem and RAM disk(initramfs/initrd) support
* this item has a subitem 'Initramfs source file(s)',can be build into kernel special section .init.ramfs
* also, usually, we don't link initramfs into kernel, but as a separated file that can be loaded into ram by bootloader.
* **make simple initramfs**
* if don't deliver 'rdinit' parameter to kernel, will execute initramfs/init after kernel bootup.
* so we make /initramfs/init(shell script), and chmod a+x init
* and we need mkdir bin lib in the initramfs directory.
* finally, use 'find . | cpio -o -H newc | gzip -9 > /vita/boot/initrd.img'
* change grub config: menuentry 'vita' { set root='(hd0,5)' linux /boot/bzImage root=/dev/sda5 ro initrd /boot/initrd.img }
* **load device drivers by insmod modules**
* modules.dep.bin/modules.dep record module despends information.
* copy modules.dep.bin to corresponding directory, and we can use 'modprobe module-name' to insert module that despended modules will be loaded auto.
* ... init shell script:
` #!/bin/bash
  echo "Hello Linux!"
  export PATH=/usr/sbin:/usr/bin:/sbin:/bin
  mount -n -t devtmpfs udev /dev
  mount -n -t proc proc /proc
  mount -n -t sysfs sysfs /sys
  exec /bin/sh
 `
 * ofcourse, we should make menuconfig for devtmpfs support
 * Device Drivers->Generic Driver Options->Maintain a devtmpfs filesystem to mount at /dev

### Auto loading modules ->page156

* **build and install udev**
* build and install udev-174.tar.gz
* tar -zxvf udev-174.tar.gz
*  ./configure --prefix=/usr/local --sysconfdir=/usr/local/etc --sbindir=/usr/local/sbin --libexecdir=/usr/local/lib/udev
* --disable-hwdb --disable-introspection --disable-keymap --disable-gudev
* make && make install
* copy udevd, udevadm and relevant rules to initramfs
* cp /usr/local/lib/udev/rules.d/80-drivers.rules initramfs/lib/udev/rules.d
* ofcourse, libraries depended already was copied to initramfs before.

* **config kernel to support NETLINK**
* make menuconfig: Networking support->Networking options->Unix domain sockets

* **config kernel to support inotify**
* make menuconfig: File system->Inotify support for userspace

* **install modules.alias.bin file**
* cp lib/modules/3.7.4/modules.alias.bin initramfs/lib/modules/3.7.4
* if not auto generate bin file, use 'depmod -b /vita/sysroot/ 3.7.4'
* cp /usr/share/pci.ids initramfs/usr/share -->lspci

*  **start udevd and coldplug**
* modify initramfs/init to anolog hotplug
* mount -n -t ramfs ramfs /run
* udevd --daemon
* udevadm trigger --action=add
* udevadb settle
* **this hotplug feature test fail, need to find out reason ...**


## Mount and switch to root filesystem
### Mount root filesystem
* /proc/cmdline contain kernel bootargs that got from bootloader.
* modify initramfs/init:
` export ROOTMNT=/root
 export ROFLAG=-r
 for x in $(cat /proc/cmdline); do
     case $x in
     root=*)
	ROOT=${x#root=}
	;;
     ro)
	ROFLAG=-r
	;;
     rw)
	ROFLAG=-w
	;;
     esac
 done
 mount ${ROFLAG} ${ROOT} ${ROOTMNT}`

### Switch to root filesystem
* 真正的根文件系统已经挂载了，initramfs/init完成使命要退出了。
* 系统的第一个进程应该使用根文件系统中的一个程序了，这里为了简化，使用/sbin/init（shell script）
* #！/bin/bash\exec /bin/bash  -> chmod a+x init
* 根文件系统准备好后，开始向根文件系统切换，步骤如下：

1. 删除rootfs文件系统中不再需要的内容，释放内存空间
> 现在挂载在“/”下的rootfs中的内容是initramfs解压来的，在我们准备把磁盘文件系统挂载到“/”前，需要删除rootfs内容，
以释放占用的内存空间。但是删除前，需要：
> 停止正在运行的进程，这里就是udevd；
> 将/dev /run /proc和/sys目录移动到真正文件系统上。因此需要在根文件系统上建立如下目录：
> mkdir sys proc dev run

2. 将根文件系统从“/root”移动到“/”下。
3. 更改进程的文件系统namespace，使其指向真正的根文件系统。因为当前进程就是进程1，而后续进程都是从进程1复制的，
所以后续进程的文件系统的namespace自然就是使用的真正的根文件系统。
4. 运行真正的文件系统中的“init”程序。

* **这里有个问题，一旦步骤1执行了，rootfs中就没有内容了，后面的步骤中使用的命令已经不在了，被删除了，步骤2/3**
* **就没有办法执行了，这里使用一个技巧，新增switch_root.c来完成2/3步骤。**
* switch_root源码参看：https://github.com/libin89/libin.github.com/switch_root



