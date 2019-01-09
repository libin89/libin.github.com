### High performance linux server programming Note

## Test Environment Issue
* 1. Telnet [Unable to connect to remote host: Connection refused]: 
* Try by following way: https://stackoverflow.com/questions/34389620/telnet-unable-to-connect-to-remote-host-connection-refused

* 2. commands to check ARP instance
* arp -a //look for ARP cache
* sudo arp -d 192.168.1.109  //delete ARP cache
* sudo arp -s 192.168.109 08:00:27:53:10:67  //add ARP cache

* instance below to observe ARP action
* sudo arp -d 192.168.1.109
* sudo tcpdump -i eth0 -ent '(dst 192.168.1.109 and src 192.168.1.108) or (dst 192.168.1.108 and src 192.168.1.109)'
* telnet 192.168.1.109 echo
* telnet-> quit

* for DNS
* host -t A www.baidu.com  // look up device name's IP address
* sudo tcpdump -i eth0 -nt -s 500 port domain

* for IPv4
* sudo tcpdump -ntx -i lo
* telnet 127.0.0.1

* for IP分片(ICMP)
* sudo tcpdump -ntv -i eth0 icmp
* ping 192.168.1.108 -s 1473  //-s decide how many bytes to send


## TCP/IP协议族

# TCP/IP协议族体系结构以及主要协议

* TCP/IP协议族是一个四层协议系统，自底而上分别是数据链路层/网络层/传输层/应用层。
* 每一层完成不同的功能，且通过若干协议来实现，上层协议使用下层协议提供的服务：
* 