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

### Auto loading modules(实现热插拔hotplug/模拟热插拔coldplug)

* **模块相关管理命令**
* 安装加载/卸载等管理模块的工具，这些工具包kmod中：kmod-12.tar.xz
* ./configure --prefix=/usr  && make  &&  make install
* kmod是module-init-tools的替代者，但是kmod是向后兼容Module-init-tools的，虽然kmod只提供了一个工具kmod，但是通过符号链接的形式
  支持module-init-tools中的各个命令，而且目前来看，也只能使用这种方式来使用各种模块管理命令。
  ln -s kmod insmod && ln -s kmod rmmod && ln -s kmod modinfo && ln -s kmod lsmod && ln -s kmod modprobe && ln -s kmod depmod.
* 将以上的命令及依赖的库添加到对应目录中。
* 其中，insmod rmmod modprobe用于加载/卸载模块；modinfo查看模块信息；lsmod查看已经加载的模块；depmod用于创建模块间的依赖关系。
* 注意，这里一定要将modprobe等命令放在/sbin目录下，因为后面的udevd将会使用“/sbin/modprobe”的形式调用modprobe命令。
* 最新的合并到systemd中的udev不再直接调用Modprobe等工具，而是使用libkmod提供的库提供的API加载模块，但无本质区别。
* 安装内核模块时，安装脚本已经调用depmod创建了modules.dep和使用Trie树组织的modules.dep.bin，需要将bin放到initramfs对应目录中。
   modprobe会根据dep.bin自动加载模块所依赖的相关模块，可以通过lsmod来查看模块是否正确加载，但是lsmod时通过proc和sysfs获取内核
   信息的，因此，为了使用lsmod，首先要挂载proc sysfs文件系统，为此要在initramfs根目录创建proc sys目录作为挂载点。


* **build and install udev**
* build and install udev-174.tar.gz
* tar -zxvf udev-174.tar.gz
*  ./configure --prefix=/usr/local --sysconfdir=/usr/local/etc --sbindir=/usr/local/sbin --libexecdir=/usr/local/lib/udev
* --disable-hwdb --disable-introspection --disable-keymap --disable-gudev
> 这里安装udev时指定的路径很重要，由于这里路径都指定到了/usr/local目录下，所以这告诉安装脚本将udev的规则文件以及一些helper程序
> 安装在/usr/local/lib/udev目录下，注意，这里默认路径一般是/lib/udev，后面的规则文件等一定要放在指定路径下，否则，会找不到文件，
> 影响功能的实现。

* **make && make install**
* copy udevd, udevadm and relevant rules to initramfs
* cp /usr/local/lib/udev/rules.d/80-drivers.rules initramfs/usr/local/lib/udev/rules.d
* ofcourse, libraries depended already was copied to initramfs before.
> 注意！这里由于指定了/usr/local路径，所以80-drivers-rules要放到/usr/local/lib/udev/rules.d目录下。

* **config kernel to support NETLINK**
* make menuconfig: Networking support->Networking options->Unix domain sockets

* **config kernel to support inotify**
* make menuconfig: File system->Inotify support for userspace

* **install modules.alias.bin file**
* cp lib/modules/3.7.4/modules.alias.bin initramfs/lib/modules/3.7.4
> 注意！这里的modules相关文件都可以在安装模块的路径下找到，编译安装模块命令：
> make bzImage && make modules && make INSTALL_MOD_PATH=/vita/sysroot modules_install
* if not auto generate bin file, use 'depmod -b /vita/sysroot/ 3.7.4'
* cp /usr/share/pci.ids initramfs/usr/share -->lspci
> 注意！ lspci命令会从pci.ids数据库中根据设备ID来查找对应的设备具体信息，如果没有显示具体信息，很可能是pci.ids路径不对，导致
> 没有找到数据库，需要在/usr/share/misc /usr/share/hwdata 目录下都分别放一份pci.ids，我遇到的问题就是在/usr/share/misc下才会
> 生效，其他目录不生效。

*  **start udevd and coldplug**
* modify initramfs/init to anolog hotplug
* mount -n -t ramfs ramfs /run
* udevd --daemon
* udevadm trigger --action=add
* udevadb settle
* **udev实现热插拔过程遇到的问题总结**

1. lspci不能显示设备的具体描述信息，这是pci.ids路径不对，放在/usr/share/misc目录后ok，另外pci.ids可以在安装lspci的目录中找到
1. udevd --daemon运行udevd后，执行udevadm control --log-priority=debug(默认是err,debug可以打开更多log用于调试udev相关问题)，
   再执行udevadm trigger --action=add出现错误提示：udevd[119]: no db file to read /run/udev/data/+pci:0000:00:03.0: No such 
   file or directory；这个问题根本原因还是上面说的，udev的安装路径是/usr/local，所以规则文件和udev配置文件udev.conf都要放到这
   个路径下面，udev.conf一般不需要修改，默认就行。udevadm test /sys/devices/pci:0000:00:03.0/ 这个test命令很有用，这个命令让我
   发现了规则文件路径的问题，后面基本可以再udev.conf中默认打开调试log：udev_log="debug"就可以了，有异常的话按提示的log去解决。

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

* **这里有个问题，一旦步骤1执行了，rootfs中就没有内容了，后面的步骤中使用的命令已经不在了，被删除了，步骤2/3
    就没有办法执行了，这里使用一个技巧，新增switch_root.c来完成2/3步骤。**
* switch_root源码参看：https://github.com/libin89/libin.github.com/switch_root

## 构建根文件系统

### 初始根文件系统
* /sbin/init: #!/bin/bash export HOME=/root   exec /bin/bash -l; "-l" 是告诉bash以登录方式启动，这样可以使bash读取在
  /etc/profile ~/.profile等文件中定义的环境变量。为了让shell提示符友好一些，在/etc/profile中加入 export PS1=
  "\[\e[31;1m\]\u@vita:\[\e[35;1m\]\w# \[\e[0m\]"
  
### 以读写模式重新挂载文件系统
* /sbin/init中加入 mount -o remount,rw /dev/sda5 /
* cat /proc/mounts查看是否以读写挂载了，这个有个问题，"\u"显示“i have no name!”，使用whoami也是出现同样的显示；这里需要
  在/etc/passwd文件中加入 root:x:0:0:root:/root:/bin/bash（passwd可以参考ubuntu系统里的对应文件），之后显示正确。
  
### 配置内核网络
* **配置讷河支持TCP/IP协议**
* make menuconfig: Networking support->Neworking options->TCP/IP networking

* **配置内核支持网卡**
* lspci查看以太网相关的设备，在总线好为0x00的PCI总线上，设备号0X03设备就是Intel的型号82540EM千兆以太网卡。
* 根据内核通过sys文件系统报告的uevent事件，可以看到MODALIAS值pci:v00008086d0000100Esv00008086sd0000001Ebc02sc00i00，以设备ID
“100E”在内核的drivers/net目录下搜索可以看到，我们需要配置内核支持e1000驱动
* make menuconfig:Device Drivers->Network device support->Ethernet driver support(NEW)->Intel(R) PRO/1000 Gigbbit Ethernet  support(这个配置为M，动态加载模块)

* **启动udev**
`udevd --daemon 
 udevadm trigger --action=add
 udevadm settle
`
* 这个在initramfs时已经用过了，这个启动udev服务，这里不仅是加载网卡驱动，还是重新模拟hotplug，从根文件系统中加载相关设备的驱动
模块；因为initramfs中往往只包含存储介质相关的驱动，而其他大量相关设备驱动还是保存在跟文件系统中的。

### 安装网络配置工具并配置网络
* 安装ip ping到根文件系统
* ip link show查看网络接口状态，如果是“down”状态，使用ip link set eth0 up将接口状态设置为“up”
* ip addr add 192.168.1.24/24 dev eth0 具体ip地址根据自身情况 与宿主机在一个网段上；设置ip后可以查看路由情况：ip route show
* 最后使用ping命令确认网络是否成功配置

### 安装并配置ssh服务
1. 安装zlib-1.2.7.tar.bz2 ->./configure --prefix=/usr && make && make install
1. 安装openssl-1.0.2p.tar.gz ->./config --prefix=/usr --openssldir=/etc/ssl && make &&
	make install MANDIR=/usr/share/man INSTALL_PREFIX=/vita/sysroot
1. 安装openssh-6.1p1.tar.gz ->LD=i686-linux-gnu-gcc ./configure --prefix=/usr --syconfdir=/etc/ssh --without-openssl-header-check &&
	make install DESTDIR=/vita/sysroot

> 在openssh的编译脚本中，调用链接器时传递了参数-fstack-protector-all。链接器不允许链接可执行文件时使用以“-f”开头的参数，以“-f”
  开头的参数只能用于链接动态库。解决这个问题的方法之一就是避免直接调用链接器进行链接，而是通过gcc间接调用链接。这就是在配置
  openssh时设定LD=i686-linux-gnu-gcc，覆盖系统环境变量中定义的LD=i686-linux-gnu-ldd的目的。
  这个问题可能实在交叉编译环境下出现的，非交叉编译环境并没有出现。
  
* openssh支持一种安全机制，称为特权分离（Privilege Separation），这个机制是默认开启的。但是这个机制要求一些附加操作，比如建立
  非特权用户等。为简单起见，我们关掉了这个机制。为了方便，我们允许SSH服务使用root用户登录。同样root密码设置为空：
* /etc/ssh/sshd_config: UsePrivilegeSeparation no, PermitRootLogin yes, PermitEmptyPasswords yes
* 除了配置ssh服务外，根据ssh协议2.0的要求，还需要为ssh服务创建dsa,rsa和ecdsa三种类型的密钥
* 而创建密钥需要一些账户信息，因此，我们首先为系统添加账户信息：
* 用户信息保存在文件/etc/passwd中，格式为：name:password:uid:gid:comment:home:shell
* name是用户名，password是用户密码，uid是用户ID，gid是用户所属的组，comment保存如用户的真实姓名等信息，home是用户的属主目录，
  shell是用户登录后执行的命令。
* 组信息保存在文件/etc/group中，格式为：group_name:password:gid:usr_list
* group_name是组名，password是组的密码，gid是组ID，user_list部分记录属于该组的所有用户（用户之间使用逗号分隔）。
* 我们vita系统创建的具体的passwd和group文件分别如下：
* /etc/passwd：root::0:0:/root:/bin/bash
* /etc/group：root::0:

* dsa,rsa和ecdsa三种类型的密钥(一路enter键)
* ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
* ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
* ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key

* 最后把/etc/ssh/*配置文件，/usr/bin/ssh*，/usr/sbin/sshd文件放入vita对应目录。

* 从宿主系统远程登录vita系统时，vita系统需要为登录的用户分配伪终端（PTY），而伪终端设备节点建立在/dev/pts目录下，并且/dev/pts
  要求挂载devpts文件系统。如果没有挂载devpts，登录失败，报错信息类似：PTY allocation request failed on channel 0
* 为此，修改init程序，挂载devpts, 一切就绪，系统启动时，默认启动ssh服务：
`mkdir /dev/pts
 mount -n -t devpts devpts /dev/pts
`
`/usr/sbin/sshd`
* **相关的安装源文件可以查看百度网盘：软件->linux_packages目录**

### 安装X窗口系统


