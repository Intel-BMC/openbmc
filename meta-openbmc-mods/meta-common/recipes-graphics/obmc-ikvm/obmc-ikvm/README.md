# OpenBMC IpKVM Server

The obmc-ikvm application is a VNC server that provides access to the host
graphics output. The application interfaces with the video device on the BMC
that captures the host graphics, and then serves that video data on the RFB
(remote framebuffer, also known as VNC) protocol. The application also
interfaces with the BMC USB gadget device to pass HID events from the BMC to
the host, allowing the user to interact with the host system.

## Usage

Once the host is running and an appropriate HID gadget device is instantiated
on the BMC, the application can be started with the following command:
``` obmc-ikvm -v <video device path> -i <HID gadget device path> ```

For example:

``` obmc-ikvm -v /dev/video0 -i /dev/hidg0 ```
