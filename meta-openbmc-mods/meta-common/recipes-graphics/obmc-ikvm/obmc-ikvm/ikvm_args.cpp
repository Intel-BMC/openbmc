#include "ikvm_args.hpp"

#include <getopt.h>
#include <rfb/rfb.h>
#include <stdio.h>
#include <stdlib.h>

namespace ikvm
{

Args::Args(int argc, char* argv[]) : frameRate(30), commandLine(argc, argv)
{
    int option;
    const char* opts = "f:h:k:p:v:";
    struct option lopts[] = {{"frameRate", 1, 0, 'f'},   {"help", 0, 0, 'h'},
                             {"keyboard", 1, 0, 'k'},    {"mouse", 1, 0, 'p'},
                             {"videoDevice", 1, 0, 'v'}, {0, 0, 0, 0}};

    while ((option = getopt_long(argc, argv, opts, lopts, NULL)) != -1)
    {
        switch (option)
        {
            case 'f':
                frameRate = (int)strtol(optarg, NULL, 0);
                if (frameRate < 0 || frameRate > 60)
                    frameRate = 30;
                break;
            case 'h':
                printUsage();
                exit(0);
            case 'k':
                keyboardPath = std::string(optarg);
                break;
            case 'p':
                pointerPath = std::string(optarg);
                break;
            case 'v':
                videoPath = std::string(optarg);
                break;
        }
    }
}

void Args::printUsage()
{
    // use fprintf(stderr to match rfbUsage()
    fprintf(stderr, "OpenBMC IKVM daemon\n");
    fprintf(stderr, "Usage: obmc-ikvm [options]\n");
    fprintf(stderr, "-f frame rate          try this frame rate\n");
    fprintf(stderr, "-h, --help             show this message and exit\n");
    fprintf(stderr, "-k device              HID keyboard gadget device\n");
    fprintf(stderr, "-p device              HID mouse gadget device\n");
    fprintf(stderr, "-v device              V4L2 device\n");
    rfbUsage();
}

} // namespace ikvm
