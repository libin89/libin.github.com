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
