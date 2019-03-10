### Issues on network of ubuntu system

1.Firefox Web Browser cannot connect internet but network connection is fine

> Try to change network proxy setting:
> Firefox -> preferences -> Network Proxy setting -> 
> Auto-detect proxy setting for this network

2.Apt-get always fail on "0% [Connecting to 185.46.212.90 (185.46.212.90)]"

> Firstly, network connection is fine
> And also change the /etc/apt/sources.list following another good one
> finally, find it is the error of apt-get proxy
> so, remove /etc/apt/apt.conf file, but proxy is also exist via "env | grep proxy"
> comment proxy related setting of /etc/environment, and then it works.
