/*
// Copyright (c) 2019 Intel Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Abstract:   pwm-beeper test application
//
*/

#include <fcntl.h>
#include <linux/input.h>
#include <stdio.h>
#include <unistd.h>

#include <cstring>
#include <iostream>

int main(int argc, char** argv)
{
    if (argc < 3)
    {
        std::cout << "usage: <input device> <sequence of 'tone in "
                     "Hz','duration in ms' pair>\n";
        std::cout << "example: beeper-test /dev/input/event0 "
                     "2100,100,0,150,2500,50,0,50,2200,100\n";
        return 1;
    }

    int fd;
    if ((fd = open(argv[1], O_RDWR | O_CLOEXEC)) < 0)
    {
        perror("Failed to open input device");
        return -1;
    }

    struct input_event event;
    event.type = EV_SND;
    event.code = SND_TONE;

    char* pch = strtok(argv[2], ",");
    while (pch != NULL)
    {
        event.value = atoi(pch);

        pch = strtok(NULL, ",");
        if (!pch)
        {
            std::cerr << "Invalid tone,duration pair\n";
            close(fd);
            return -1;
        }

        int durationMs = atoi(pch);

        if (write(fd, &event, sizeof(struct input_event)) !=
            sizeof(struct input_event))
        {
            perror("Failed to write a tone sound event");
            close(fd);
            return -1;
        }

        usleep(durationMs * 1000);

        pch = strtok(NULL, ",");
    }

    close(fd);

    return 0;
}
