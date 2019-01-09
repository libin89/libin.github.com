############################################

Reference resource: blog.topspeedsnail.com/archives/4922

Detail introduction:
1. switch from user interface to cmdline mode
   $ sudo systemctl set-default multi-user.target
2. switch to user interface
   $ sudo systemctl start lightdm
3. default bootup into user interface
   $ systemctl set-default graphical.target
