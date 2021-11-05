/*
// Copyright (c) 2021 Intel Corporation
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
// Abstract:   oom test application
//
*/

#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

void Usage(char* progname)
{
    printf("Usage:\n");
    printf("%s -s <size>\n", progname);
    printf("Options:\n");
    printf("\t%-12s%s\n", "-h", "Display this help information");
    printf("\t%-12s%s\n", "-s <size>",
           "Allocation unit size for getting heap in infinite loop");
    printf("\n");
}

int main(int argc, char** argv)
{
    int c, i, unitSize = 0, allocSize = 0;

    while (-1 != (c = getopt(argc, argv, "h:s:")))
    {
        switch (c)
        {
            case 'h':
                Usage(argv[0]);
                return 0;

            case 's':
                if (optarg != NULL)
                {
                    unitSize = (int)strtoul(optarg, NULL, 0);
                }
                break;

            default:
                Usage(argv[0]);
                return 1;
        }
    }

    if (!unitSize)
    {
        printf("Error: Invalid allocation unit size\n");
        Usage(argv[0]);
        return 1;
    }

    while (1)
    {
        char* buf = (char*)malloc(unitSize);
        if (!buf)
        {
            printf("Can't allocate memory!\n");
            exit(0);
        }

        printf("Filling allocated memory...\n");
        for (i = 0; i < unitSize; i++)
            buf[i] = 1;

        printf("Allocated %d MB\n", (++allocSize * 10));

        /* continue looping without freeing to make OOM condition */
    }

    return 0;
}
