#!/usr/bin/python
import os
import glob
import time
import sys

HWMON_DIR = "/sys/class/hwmon/hwmon0"

count = 0
inputs = None
while not inputs:
    count += 1
    if count > 20:
        print("pwm missing!")
        sys.exit(0)

    inputs = glob.glob(os.path.join(HWMON_DIR, "pwm*"))
    time.sleep(5)

inputs = glob.glob(os.path.join(HWMON_DIR, "pwm*"))
for pwm in inputs:
    with open(pwm, 'w') as f:
        f.write(sys.argv[1])
