# rpi4_bm

Bare metal ziggy fun with the main goal of learning and building a radio receiver based on https://www.rpi4os.com/

Most of the code is original to see how implementing bare metal projects in zig feels like.

The steps to the goal(read to the end):
* Build files.
* Boot and debug using qemu.
* Write hello world using mini uart.
* Use actual hardware.
* Add irq handling
* Write gdbserver to allow debugging on the device.
* Enable the main uart module.
* Test uart on real hardware.
* Connect display.
* Enable usb support.
* Enable speakers support.
* Use sdr library and finish the project.
* Ignore the steps after a while and do random things from https://www.rpi4os.com/.

### notes
* qemu version 9+ needed for rpi4.