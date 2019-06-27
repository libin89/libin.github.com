### Build the environment to remote debug using gdb
> download gdb-7.6.2 package from ftp.gnu.org/gnu/gdb
> prepare host machine(ubuntu) and target machine(arm-linux)

1. generate arm-linux-gdb(run on host machine)
> extract gdb-7.6.2.tar.gz and cd gdb-7.6.2
> ./configure --target=arm-linux --prefix=$PWD/__install
> make
> make install
> cp ./__install/bin/arm-linux-gdb /usr/local/bin

2. generate gdbserver(run on target machine)
> cd gdb/gdbserver
> ./configure --target=arm-linux --host=arm-poky-linux-gnueabi(cross compiler for target machine)
> make
> copy gdbserver in current directory to target machine

3. test
> arm-poky-linux-gnueabi-gcc -g hello.c(will generate ELF hello)
> run "gdbserver 192.168.1.68:6666 hello" on target
> run "arm-linux-gdb hello" on host and input "target remote 192.168.1.52:6666" in gdb environment
> gdb will show "Remote debugging using 192.168.1.68:6666" and it means ok
> can do gdb debugging now

> note: host-ip: 192.168.1.68, target-ip: 192.168.1.52
