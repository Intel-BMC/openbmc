#!/bin/sh

# Copyright 2017-2020 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

CPUPART="CPU part"
AST2500_ID="0xb76"
AST2600_ID="0xc07"

if ([ $(grep "$CPUPART" /proc/cpuinfo | grep "$AST2500_ID" | wc -l) != 0 ] && \
    [ $(grep 192000000 /sys/class/tty/ttyS0/uartclk | wc -l) != 0 ]) || \
   ([ $(grep "$CPUPART" /proc/cpuinfo | grep "$AST2600_ID" | wc -l) != 0 ] && \
    [ $(grep 14769216 /sys/class/tty/ttyS0/uartclk | wc -l) != 0 ]); then
  echo "hs-uart"
  sed -i -e 's/115200/921600/g' /etc/obmc-console.conf
else
  echo "normal uart"
  sed -i -e 's/921600/115200/g' /etc/obmc-console.conf
fi
