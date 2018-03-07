# usb overview
### 通过WIFI进行adb调试
1. PC和DUT连接同一wifi
2. adb tcpip 5555 进入TCP模式
3. adb connect 192.168.43.252:5555即可
