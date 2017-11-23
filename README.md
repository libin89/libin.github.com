# libin.github.com
Github pages blog for my android

Upload some usefull documents.
# Edit this file firstly by libin @2016.04.25 

###############################################################################################################
#########################################常见问题汇总##########################################################
常见问题类型及所需log

1、Crash(full crash dump)  

2、Reboot(Logcat,kmesg,tomestone)
Logcat logs(main,events,radio)
Dmesg/kernel logs
bugreport and dumpstate log
--adb shell bugreport > bugreport.txt
--adb shell dumpstate > dumpstate.log // this command will produce trace log about all 
									  //  process then you need adb pull /data/anr to collect the trace log
--adb pull /d/binder/ .
Trace file /data/anr
adb pull /data/tombstones  // All log file time must be consistent with issue occurred time,it needs to 
                           // clear /data/anr & /data/tombstones after stability issue occur
						   
3、System Freeze / Touch panel freeze(Logcat,kmesg)
Logcat logs(main,events/key events,system,radio,procrank log,meminfo,and top log)
Kernel logs:"adb shell getevent"
--open echo w > /proc/sysrq-trigger when capture dmesg and bugreport log as follows:
	adb root
	adb remount
	adb shell
	echo w > /proc/sysrq-trigger
	& then exit adb shell,then collect bugreport
	adb shell bugreport > bugreport.txt
	adb shell kmesg > kmesg.txt
Key events log
--adb shell getevent -rtl /dev/input/event0
bugreport and dumpstate log
--adb shell bugreport > bugreport.txt
--adb shell dumpstate > dumpstate.log 								  
--adb pull /d/binder/ .
Dumpsys window log:
--adb shell dumpsys window > dump_window.txt
Meminfo log:
--adb shell cat /proc/meminfo > meminfo.txt
Procrank log:
--adb shell procrank > procrank.txt
Top log:
--adb shell top > top.txt
Add below information:
--Adb workable or not,ANR or not
--CTP workable or not -> touch screen and observe the output of "adb shell getevent"
--Display driver workable or not -> Use the screencast to see if the screen can be displayed
--Power key/volume key work or not? Menu/back/home key work or not?
It's better to trigger a ram dump:
--Before test:
	adb root
	adb shell "echo 0x843 > /d/spmi/spmi-0/address"
	adb shell "echo 0x80 > /d/spmi/spmi-0/data"
	Then long press power key more than 10-30s could trigger a dump.If device is rebooted,it needs to set again.

4、Force close/ANR(reproducible rate>50%) 
Force close: logcat,kmesg
ANR: logcat,trace log

5、APPs freeze/crash(logcat,kmesg,tomestone)
Logcat logs(main,events,radio)
Dmesg/kernel logs
Trace file /data/anr
	// All log file time must be consistent with issue occurred time,it needs to 
    // clear /data/anr & /data/tombstones after stability issue occur
	
	
Android logcat命令
1、logcat -c 清除已有log信息
2、 logcat -b main 显示主缓冲区Log
	logcat -b radio 显示无线缓冲区log
	logcat -b events显示事件缓冲区log
3、logcat -f[filename]将log保存到指定的文件中，例如 logcat -b radio -f /data/radio.log
4、logcat -v 设置logcat输出格式
主要有7中输出格式：
1/ brief --Display priority/tag and PID of originating process(the default format)
2/ process --Display PID only.
3/ tag --Display the priority/tag only.
4/ thread  --Display process:thread and priority/tag only.
5/ raw -- Display the raw log message,with no other metadata fields.
6/ time --Display the date,invocation time,priority/tag,and PID of the originating process.
7/ long --Display all metadata fields and separate messages with a blank lines.
比较常见的是显示时间：logcat -v time & 
5、logcat -g查看缓冲区的大小
	logcat -g main
	logcat -g radio
	logcat -g events
	
	
	
How to debug UI freeze?
•             Prefer live device to debug UI freezes. 

•             Check for any apparent errors in logcat logs, CPU utilization in top logs

•             What screen is the UI stuck on (e.g., home screen, app screen, etc.)?

•             Run the command "adb shell getevent“

•             Now touch the touch screen and observe the output of "adb shell getevent" Do you see touch events being printed on the screen?

•             Press the power and volume up / down buttons. Do you see button press events being printed on the screen? Moreover, the volume up / down buttons usually cause a sound effect when pressed. Do you hear this sound when the buttons are pressed?

•             Check if there is an actual UI freeze, or if the UI is simply not responding to touch input:

•             Run the command "adb shell input keyevent 3". Replace the "3" with other numbers to see if the UI responds to inputs given through adb.

•             Try to start activities through adb, for example using: "# am start com.android.settings" etc.

•             If possible, take note of the time shown on the device (in the top right corner, or in the middle for the lock screen). Is the time changing/ticking or is it frozen indefinitely? This will help correlate the freeze with a specific time in the logs.

•             In 'top' logs, see if any of the threads of system_server or surfaceflinger are in D state. If so, you will have to  connect JTAG and see their respective kernel level tasks. If everything else checks out : probably driver problem. 

•             Check kernel logs for Low Memory Killer logs


adb shell input text "ANDROID" 支持的KEYCODE
input Usage: input [<source>] <command> [<arg>...]
The commands and default sources are:
      text <string> (Default: touchscreen)
      keyevent [--longpress] <key code num
      tap <x> <y> (Default: touchscreen)
      swipe <x1> <y1> <x2> <y2> [duration]
      press (Default: trackball)
      roll <dx> <dy> (Default: trackball)
输入文本： input text abcdefg 
按键 ： input keyevent KEYCODE_MENU 
点击 ： input tap 100 300 
拖拽 ： input swipe 100 600 500 600 
0 -->  "KEYCODE_UNKNOWN"
1 -->  "KEYCODE_MENU"
2 -->  "KEYCODE_SOFT_RIGHT"
3 -->  "KEYCODE_HOME"
4 -->  "KEYCODE_BACK"
5 -->  "KEYCODE_CALL" 
6 -->  "KEYCODE_ENDCALL" 
7 -->  "KEYCODE_0" 
8 -->  "KEYCODE_1" 
9 -->  "KEYCODE_2" 
10 -->  "KEYCODE_3"
11 -->  "KEYCODE_4" 
12 -->  "KEYCODE_5" 
13 -->  "KEYCODE_6" 
14 -->  "KEYCODE_7" 
15 -->  "KEYCODE_8" 
16 -->  "KEYCODE_9" 
17 -->  "KEYCODE_STAR" 
18 -->  "KEYCODE_POUND" 
19 -->  "KEYCODE_DPAD_UP" 
20 -->  "KEYCODE_DPAD_DOWN" 
21 -->  "KEYCODE_DPAD_LEFT" 
22 -->  "KEYCODE_DPAD_RIGHT"
23 -->  "KEYCODE_DPAD_CENTER"
24 -->  "KEYCODE_VOLUME_UP" 
25 -->  "KEYCODE_VOLUME_DOWN" 
26 -->  "KEYCODE_POWER" 
27 -->  "KEYCODE_CAMERA" 
28 -->  "KEYCODE_CLEAR" 
29 -->  "KEYCODE_A" 
30 -->  "KEYCODE_B" 
31 -->  "KEYCODE_C" 
32 -->  "KEYCODE_D" 
33 -->  "KEYCODE_E" 
34 -->  "KEYCODE_F" 
35 -->  "KEYCODE_G" 
36 -->  "KEYCODE_H" 
37 -->  "KEYCODE_I" 
38 -->  "KEYCODE_J" 
39 -->  "KEYCODE_K" 
40 -->  "KEYCODE_L" 
41 -->  "KEYCODE_M"
42 -->  "KEYCODE_N" 
43 -->  "KEYCODE_O" 
44 -->  "KEYCODE_P" 
45 -->  "KEYCODE_Q" 
46 -->  "KEYCODE_R" 
47 -->  "KEYCODE_S" 
48 -->  "KEYCODE_T" 
49 -->  "KEYCODE_U" 
50 -->  "KEYCODE_V" 
51 -->  "KEYCODE_W" 
52 -->  "KEYCODE_X"
53 -->  "KEYCODE_Y" 
54 -->  "KEYCODE_Z" 
55 -->  "KEYCODE_COMMA" 
56 -->  "KEYCODE_PERIOD"
57 -->  "KEYCODE_ALT_LEFT" 
58 -->  "KEYCODE_ALT_RIGHT" 
59 -->  "KEYCODE_SHIFT_LEFT" 
60 -->  "KEYCODE_SHIFT_RIGHT" 
61 -->  "KEYCODE_TAB" 
62 -->  "KEYCODE_SPACE" 
63 -->  "KEYCODE_SYM" 
64 -->  "KEYCODE_EXPLORER" 
65 -->  "KEYCODE_ENVELOPE" 
66 -->  "KEYCODE_ENTER" 
67 -->  "KEYCODE_DEL" 
68 -->  "KEYCODE_GRAVE" 
69 -->  "KEYCODE_MINUS" 
70 -->  "KEYCODE_EQUALS" 
71 -->  "KEYCODE_LEFT_BRACKET" 
72 -->  "KEYCODE_RIGHT_BRACKET" 
73 -->  "KEYCODE_BACKSLASH"
74 -->  "KEYCODE_SEMICOLON" 
75 -->  "KEYCODE_APOSTROPHE"
76 -->  "KEYCODE_SLASH" 
77 -->  "KEYCODE_AT" 
78 -->  "KEYCODE_NUM" 
79 -->  "KEYCODE_HEADSETHOOK" 
80 -->  "KEYCODE_FOCUS"
81 -->  "KEYCODE_PLUS"
82 -->  "KEYCODE_MENU"
83 -->  "KEYCODE_NOTIFICATION"
84 -->  "KEYCODE_SEARCH" 
85 -->  "TAG_LAST_KEYCODE"  

addr2line -f -e vmlinux 0xc032b350/c032b350

adb logcat [-b main] [-v time]：
1、自动休眠：I/PowerManagerService( 2298): Going to sleep due to screen timeout (uid 1000)
2、powerkey休眠：I/PowerManagerService( 2298): Going to sleep due to power button (uid 1000)
3、powerkey唤醒：I/PowerManagerService( 2298): Waking up from dozing (uid 1000)
4、Gsensor方向：I/DisplayManagerService( 2298): Display device changed: DisplayDeviceInfo
{"Built-in Screen": uniqueId="local:0", 1200 x 1920, 60.0 fps, 
supportedRefreshRates [60.0], density 320, 225.777 x 225.777 dpi, appVsyncOff 0, presDeadline 17666667, 
touch INTERNAL, rotation 0, type BUILT_IN, state OFF, FLAG_DEFAULT_DISPLAY, FLAG_ROTATES_WITH_CONTENT, FLAG_SECURE, FLAG_SUPPORTS_PROTECTED_BUFFERS}

Display debug:
1、cat framebuffer:
adb shell screencap -p /data/screencap.png
shell screenrecord /sdcard/xxx.mp4 
adb pull /data/screencap.png .
2、通过删除libscale.so来确定问题是否与此库有关
adb root
adb shell
cd /vendor/lib/
rm libscale.so
exit
adb shell sync
adb reboot
如果是64位的系统，请删除/vendor/lib64目录下的libscale.so
3、如何使能libscale.so的debug信息
在build.prop中，添加debug.scale.logs，具体如下：
adb root 
adb shell
adb pull /system/build.prop
debug.scale.logs=1
adb push build.prop /system/
adb shell chmod 644 /system/build.prop
adb shell sync
adb shell logcat -v threadtime
这样，在logcat中，可以看到与libscale相关的Log，关键字：MDP_SCALE
4、PTOR调试
在build.prop中，具体如下：
adb root
adb shell
adb pull /system/build.prop .
persist.hwc.ptor.enable=false or ture //false是disable，true是enable
adb push build.prop /system/
adb shell chmod 644 /system/build.prop
adb shell sync
adb shell reboot
或者通过adb command对其进行操作：
adb shell setprop persist.hwc.ptor.enable false
adb shell stop
adb shell start //注意一定要执行stop/start

default lcd backlight: l9220_mcx_a01/overlay/frameworks/base/packages/SettingsProvider/res/values/defaults.xml
-------<integer name="def_screen_brightness">204</integer>
minimum lcd backlight: l9220_mcx_a01/overlay/frameworks/base/core/res/res/values/config.xml
-------<integer name="config_screenBrightnessSettingMinimum">5</integer>

Y:\p3585_0518\device\qcom\common\rootdir\etc
se
        if [ $fb_width -ge 1080 ]; then
           setprop ro.sf.lcd_density 320   //480->320
        elif [ $fb_width -ge 720 ]; then
		
		

adb shell echo -n "file mdss_fb.c +tp" > d/dynamic_debug/control

LK相关问题：
1、死机发生在LK时，大致分两种情况：（使用平台8952、8956）
	a、panic: 这种情况下，lk的开机串口日志会有具体的出错原因，以及寄存器打印和内存的转储
	b、未知原因重启： 这种情况下，如果没有JTAG，很难追踪。所以可以考虑在LK里使能download模式，
    这样可以通过分析randump的方式来分析LK死机
    具体使能的方法：
    /bootable/bootloader/lk/project/msmxxx.mk
			ENABLE_WDOG_SUPPORT := 0  //把0改成1.
			ifeq($(ENABLE_WDOG_SUPPORT),1)
				DEFINES += WDOG_SUPPORT=1
				Endif
	 具体实现见/bootable/bootloader/lk/platform/msm_shared/wdog.c
2、lk log打印到屏幕的方法
	以msm8956为例，但是有些平台字体会很小
	修改路径bootable/bootloader/lk/project/msm8952.mk
	DEFINES += WITH_DEBUG_FBCOM=1
	DEFINES += WITH_DEV_FBCON=1
	打开一个开关，增加一个定义，重新编译aboot即可。
3、How to restore legacy kernel buffer based android log mechanism Android M
	https://qualcomm-cdmatech-support.my.salesforce.com/50130000000MnPi
	
autoBrightness: https://qualcomm-cdmatech-support.my.salesforce.com/50130000000VCJE?srPos=0&srKp=501
lux->lcd-backlight: \l9100\device\qcom\common\device\overlay\frameworks\base\core\res\res\values\config.xml
	
SElinux policy问题
MTK ON LINE: https://onlinesso.mediatek.com/_layouts/15/mol/topic/ext/Topic.aspx?mappingId=50d75f53-684c-4c51-9460-c5aa7f091813
QCOM: 00028826(online display debugging)

repo sync:
fatal: '../../8939-repository/platform/abi/cpp.git' does not appear to be a git repository fatal: Could not read from remote repository
--> cd .repo  --> modify manifest.xml(<remote>fetch:"ssh://172.16.16.17:29418/")

dump layers:
adb shell setprop debug.hwui.render_dirty_regions false
adb shell stop
adb shell start

And provide the layer dumps file.
 Please dump the layers with the following commands.
And upload the files from the "/data/sf.dump.xxxx" folder. 
 adb root
adb shell su -c setenforce 0 // it will disable selinux, so dump folder can be created.
$adb shell setprop debug.sf.dump.enable true
$adb shell stop
$adb shell start
$adb shell setprop debug.sf.dump 0
$adb shell setprop debug.sf.dump 300
//dumplicate the issue
$adb shell setprop debug.sf.dump 0

selinux:
#run init.target.rc before init.qcom.sh, this lead the property of the file is invalid.
#
In device/qcom/rootdir/init.qcom.sh:
touch /persist/g_sensor_correct
chmod -h 666 /persist/g_sensor_correct
chown -h system.system /persist/g_sensor_correct

In device/qcom/rootdir/init.target.rc:
chown system system /persist/g_sensor_correct

logcat -v time -f /dev/kmsg | cat /proc/kmsg > /sdcard/log.txt&

dynamic debug:
CONFIG_DYNAMIC_DEBUG=y in the msm_defconfig


USB Solution Summary: 00031238
https://qualcomm-cdmatech-support.my.salesforce.com/50130000000Mmme?srPos=0&srKp=501

Enable SVI :
1/ 在build.prop里面加ro.qualcomm.svi=1 就开启这个功能了
2/ note: 8953 & 8996 need to add : ro.qcom.dpps.sensortype=2
3/ 要确保build.prop里面ro.qualcomm.cabl=2
4/ custom svi start point(lux)
	config.svi.xml=1 
	config.svi.path=/data/misc/display/SVIConfigFeero.xml 
	config.svi.xml.print=1 
	
拉高gpio42
1, 42 16进制2A
/system/bin/r 0x102A000 0x201
/system/bin/r 0x102A004 0x3
2，
adb shell
cd sys/class/gpio
echo 42 >export

efuse 机器抓dump:
http://confluence.longcheer.net:8090/pages/viewpage.action?pageId=6587147

dump PMIC register:
Mount debug file system
adb shell mount -t debugfs none /sys/kernel/debug cd /sys/kernel/debug/spmi/spmi-0
Set number of bytes to read/write
echo 1 > count
Set address
echo 0x8041 > address
Write
echo 0x11 > data
Read
Cat data
Example – Set GPIO1 to output high and read back other parameters
adb shell mount -t debugfs none /sys/kernel/debug cd /sys/kernel/debug/spmi/spmi-0
echo 1 > count
echo 0xC040 > address // MODE_CTL
echo 0x11 > data // DO + HIGH
echo 0xC041 > address // DIG_VIN_CTL
cat data // read back DIG_VIN_CTL to check voltage setting


SDM630:
dump internal codec register:
adb shell cat /d/regmap/msm_digital_codec/registers

audio kernel log:
echo -n "file msm-pcm-routing-v2.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file q6adm.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file soc-dapm.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file soc-pcm.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file msm8952.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file q6asm.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file q6afe.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file msm-pcm-q6-v2.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file msm-dai-q6-v2.c +p" > /sys/kernel/debug/dynamic_debug/control
echo -n "file msm-dai-fe.c +p" > /sys/kernel/debug/dynamic_debug/control


HAC function:
HAC stands for Hearing Aid Compatibility, which utilize a special device that is "Hearing Aid Compatible" 
is designed to output the required magnetic signal that the telecoil can hear in addition to an audio signal

1. UI change 
From the source code the services/Telephony/src/com/android/phone/CallFeaturesSetting.java 
The HAC is turned on/off through a button in call setting application 
public static final String HAC_KEY = "HACSetting";

2. Audio HAL change
Define in mixer_paths.xml the new device ID to separate the normal output device with HAC device
For example, 
<path name="hac"> 
<ctl name="SLIM_0_RX Channels" value="One" /> 
<ctl name="SLIM RX1 MUX" value="AIF1_PB" /> 
<ctl name="RX8 MIX1 INP1" value="RX1" /> 
<ctl name="RX8 Digital Volume" value="84" /> 
<ctl name="COMP0 Switch" value="1" /> 
</path> 
OEM HAC  mixer_paths could be different from above definition

After the "HACSetting" flag is enabled from the UI, Audio HAL will receive AUDIO_PARAMETER_KEY_HAC parameter key-and-value pair be set to "on" and 
OEM should use the flag as key to build logic for selecting a different SND_DEVICE for HAC use case in platform.c. (platform_get_output_snd_device)
	

Command to record PCM in PMIC codec like PM8953 etc.
1) Make code change below
diff --git a/sound/soc/msm/msm8952.c b/sound/soc/msm/msm8952.c
index 5caf607..6f28b34 100644
--- a/sound/soc/msm/msm8952.c
+++ b/sound/soc/msm/msm8952.c
@@ -161,7 +161,7 @@ static struct afe_clk_set wsa_ana_clk = {
};
static char const *rx_bit_format_text[] = {"S16_LE", "S24_LE", "S24_3LE"};
-static const char *const mi2s_ch_text[] = {"One", "Two"};
+static const char *const mi2s_ch_text[] = {"One", "Two", "Three", "Four"};
2) To capture the HPH loopback data
a, Play audio on HPH (RX1/RX2)
b, Recording
echo 0x3C8 0x01 > codec_reg
tinymix "DEC1 MUX" "ADC2"
tinymix "ADC2 Volume" "6"
tinymix "ADC2 MUX" "INP2"
tinymix "MultiMedia1 Mixer TERT_MI2S_TX" 1
tinymix "MI2S_TX Channels" "Four"
tinycap /sdcard/Music/rec_4ch.wav -r 48000 -c 4
(channel 3 and channel 4 will have RX_MIX1/RX_MIX2 data which is HPHL/HPHR data input
to codec).
3) To capture the RX3 loopback data from codec
a, Play 48K Audio on Lineout (RX3 path)
b, Recording
echo 0x3C8 0x10 > codec_reg
tinymix "DEC1 MUX" "ADC1"
tinymix "ADC1 Volume" "6"
tinymix "MultiMedia1 Mixer TERT_MI2S_TX" 1
tinymix "MI2S_TX Channels" "Four"
tinycap /sdcard/Music/rec_4ch.wav -r 48000 -c 4
(channel 4 will have RX_MIX3 data which is Lineout data input to codec).
 

#########################################常见问题汇总##########################################################
###############################################################################################################


