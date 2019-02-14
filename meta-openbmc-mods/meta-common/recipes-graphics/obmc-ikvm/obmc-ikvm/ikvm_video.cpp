#include "ikvm_video.hpp"

#include <err.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/videodev2.h>
#include <poll.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

#include <phosphor-logging/elog-errors.hpp>
#include <phosphor-logging/elog.hpp>
#include <phosphor-logging/log.hpp>
#include <xyz/openbmc_project/Common/Device/error.hpp>
#include <xyz/openbmc_project/Common/File/error.hpp>

namespace ikvm
{

const int Video::bitsPerSample(8);
const int Video::bytesPerPixel(4);
const int Video::samplesPerPixel(3);

using namespace phosphor::logging;
using namespace sdbusplus::xyz::openbmc_project::Common::File::Error;
using namespace sdbusplus::xyz::openbmc_project::Common::Device::Error;

Video::Video(const std::string& p, Input& input, int fr) :
    resizeAfterOpen(false), fd(-1), frameRate(fr), lastFrameIndex(-1),
    height(600), width(800), input(input), path(p)
{
}

Video::~Video()
{
    stop();
}

char* Video::getData()
{
    if (lastFrameIndex >= 0)
    {
        return (char*)buffers[lastFrameIndex].data;
    }

    return nullptr;
}

void Video::getFrame()
{
    bool queue(false);
    int rc(0);
    v4l2_buffer buf;

    if (fd < 0)
    {
        return;
    }

    memset(&buf, 0, sizeof(v4l2_buffer));
    buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    buf.memory = V4L2_MEMORY_MMAP;

    while (rc >= 0)
    {
        rc = ioctl(fd, VIDIOC_DQBUF, &buf);
        if (rc >= 0)
        {
            buffers[buf.index].queued = false;

            if (!(buf.flags & V4L2_BUF_FLAG_ERROR))
            {
                lastFrameIndex = buf.index;
                buffers[lastFrameIndex].payload = buf.bytesused;
                queue = true;
                break;
            }
            else
            {
                buffers[buf.index].payload = 0;
            }
        }
        else
        {
            restart();
            return;
        }
    }

    if (queue)
    {
        for (unsigned int i = 0; i < buffers.size(); ++i)
        {
            if (i == (unsigned int)lastFrameIndex)
            {
                continue;
            }

            if (!buffers[i].queued)
            {
                memset(&buf, 0, sizeof(v4l2_buffer));
                buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
                buf.memory = V4L2_MEMORY_MMAP;
                buf.index = i;

                rc = ioctl(fd, VIDIOC_QBUF, &buf);
                if (rc)
                {
                    log<level::ERR>("Failed to queue buffer",
                                    entry("ERROR=%s", strerror(errno)));
                    elog<ReadFailure>(
                        xyz::openbmc_project::Common::Device::ReadFailure::
                            CALLOUT_ERRNO(errno),
                        xyz::openbmc_project::Common::Device::ReadFailure::
                            CALLOUT_DEVICE_PATH(path.c_str()));
                }

                buffers[i].queued = true;
            }
        }
    }
}

bool Video::needsResize()
{
    int rc;
    v4l2_dv_timings timings;

    if (fd < 0)
    {
        return false;
    }

    if (resizeAfterOpen)
    {
        return true;
    }

    memset(&timings, 0, sizeof(v4l2_dv_timings));
    rc = ioctl(fd, VIDIOC_QUERY_DV_TIMINGS, &timings);
    if (rc < 0)
    {
        log<level::ERR>("Failed to query timings",
                        entry("ERROR=%s", strerror(errno)));
        return false;
    }

    if (timings.bt.width != width || timings.bt.height != height)
    {
        width = timings.bt.width;
        height = timings.bt.height;

        if (!width || !height)
        {
            log<level::ERR>("Failed to get new resolution",
                            entry("WIDTH=%d", width),
                            entry("HEIGHT=%d", height));
            elog<Open>(
                xyz::openbmc_project::Common::File::Open::ERRNO(-EPROTO),
                xyz::openbmc_project::Common::File::Open::PATH(path.c_str()));
        }

        lastFrameIndex = -1;
        return true;
    }

    return false;
}

void Video::resize()
{
    int rc;
    unsigned int i;
    bool needsResizeCall(false);
    v4l2_buf_type type(V4L2_BUF_TYPE_VIDEO_CAPTURE);
    v4l2_requestbuffers req;

    if (fd < 0)
    {
        return;
    }

    if (resizeAfterOpen)
    {
        resizeAfterOpen = false;
        return;
    }

    for (i = 0; i < buffers.size(); ++i)
    {
        if (buffers[i].data)
        {
            needsResizeCall = true;
            break;
        }
    }

    if (needsResizeCall)
    {
        rc = ioctl(fd, VIDIOC_STREAMOFF, &type);
        if (rc)
        {
            log<level::ERR>("Failed to stop streaming",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }
    }

    for (i = 0; i < buffers.size(); ++i)
    {
        if (buffers[i].data)
        {
            munmap(buffers[i].data, buffers[i].size);
            buffers[i].data = nullptr;
            buffers[i].queued = false;
        }
    }

    if (needsResizeCall)
    {
        v4l2_dv_timings timings;

        memset(&req, 0, sizeof(v4l2_requestbuffers));
        req.count = 0;
        req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req.memory = V4L2_MEMORY_MMAP;
        rc = ioctl(fd, VIDIOC_REQBUFS, &req);
        if (rc < 0)
        {
            log<level::ERR>("Failed to zero streaming buffers",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }

        memset(&timings, 0, sizeof(v4l2_dv_timings));
        rc = ioctl(fd, VIDIOC_QUERY_DV_TIMINGS, &timings);
        if (rc < 0)
        {
            log<level::ERR>("Failed to query timings",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }

        rc = ioctl(fd, VIDIOC_S_DV_TIMINGS, &timings);
        if (rc < 0)
        {
            log<level::ERR>("Failed to set timings",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }

        buffers.clear();
    }

    memset(&req, 0, sizeof(v4l2_requestbuffers));
    req.count = 3;
    req.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    req.memory = V4L2_MEMORY_MMAP;
    rc = ioctl(fd, VIDIOC_REQBUFS, &req);
    if (rc < 0 || req.count < 2)
    {
        log<level::ERR>("Failed to request streaming buffers",
                        entry("ERROR=%s", strerror(errno)));
        elog<ReadFailure>(
            xyz::openbmc_project::Common::Device::ReadFailure::CALLOUT_ERRNO(
                errno),
            xyz::openbmc_project::Common::Device::ReadFailure::
                CALLOUT_DEVICE_PATH(path.c_str()));
    }

    buffers.resize(req.count);

    for (i = 0; i < buffers.size(); ++i)
    {
        v4l2_buffer buf;

        memset(&buf, 0, sizeof(v4l2_buffer));
        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buf.memory = V4L2_MEMORY_MMAP;
        buf.index = i;

        rc = ioctl(fd, VIDIOC_QUERYBUF, &buf);
        if (rc < 0)
        {
            log<level::ERR>("Failed to query buffer",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }

        buffers[i].data = mmap(NULL, buf.length, PROT_READ | PROT_WRITE,
                               MAP_SHARED, fd, buf.m.offset);
        if (buffers[i].data == MAP_FAILED)
        {
            log<level::ERR>("Failed to mmap buffer",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }

        buffers[i].size = buf.length;

        rc = ioctl(fd, VIDIOC_QBUF, &buf);
        if (rc < 0)
        {
            log<level::ERR>("Failed to queue buffer",
                            entry("ERROR=%s", strerror(errno)));
            elog<ReadFailure>(
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_ERRNO(errno),
                xyz::openbmc_project::Common::Device::ReadFailure::
                    CALLOUT_DEVICE_PATH(path.c_str()));
        }

        buffers[i].queued = true;
    }

    rc = ioctl(fd, VIDIOC_STREAMON, &type);
    if (rc)
    {
        log<level::ERR>("Failed to start streaming",
                        entry("ERROR=%s", strerror(errno)));
        elog<ReadFailure>(
            xyz::openbmc_project::Common::Device::ReadFailure::CALLOUT_ERRNO(
                errno),
            xyz::openbmc_project::Common::Device::ReadFailure::
                CALLOUT_DEVICE_PATH(path.c_str()));
    }
}

void Video::start()
{
    int rc;
    size_t oldHeight = height;
    size_t oldWidth = width;
    v4l2_capability cap;
    v4l2_format fmt;
    v4l2_streamparm sparm;

    if (fd >= 0)
    {
        return;
    }

    fd = open(path.c_str(), O_RDWR);
    if (fd < 0)
    {
        input.sendWakeupPacket();

        fd = open(path.c_str(), O_RDWR);
        if (fd < 0)
        {
            log<level::ERR>("Failed to open video device",
                            entry("PATH=%s", path.c_str()),
                            entry("ERROR=%s", strerror(errno)));
            elog<Open>(
                xyz::openbmc_project::Common::File::Open::ERRNO(errno),
                xyz::openbmc_project::Common::File::Open::PATH(path.c_str()));
        }
    }

    memset(&cap, 0, sizeof(v4l2_capability));
    rc = ioctl(fd, VIDIOC_QUERYCAP, &cap);
    if (rc < 0)
    {
        log<level::ERR>("Failed to query video device capabilities",
                        entry("ERROR=%s", strerror(errno)));
        elog<ReadFailure>(
            xyz::openbmc_project::Common::Device::ReadFailure::CALLOUT_ERRNO(
                errno),
            xyz::openbmc_project::Common::Device::ReadFailure::
                CALLOUT_DEVICE_PATH(path.c_str()));
    }

    if (!(cap.capabilities & V4L2_CAP_VIDEO_CAPTURE) ||
        !(cap.capabilities & V4L2_CAP_STREAMING))
    {
        log<level::ERR>("Video device doesn't support this application");
        elog<Open>(
            xyz::openbmc_project::Common::File::Open::ERRNO(errno),
            xyz::openbmc_project::Common::File::Open::PATH(path.c_str()));
    }

    memset(&fmt, 0, sizeof(v4l2_format));
    fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    rc = ioctl(fd, VIDIOC_G_FMT, &fmt);
    if (rc < 0)
    {
        log<level::ERR>("Failed to query video device format",
                        entry("ERROR=%s", strerror(errno)));
        elog<ReadFailure>(
            xyz::openbmc_project::Common::Device::ReadFailure::CALLOUT_ERRNO(
                errno),
            xyz::openbmc_project::Common::Device::ReadFailure::
                CALLOUT_DEVICE_PATH(path.c_str()));
    }

    memset(&sparm, 0, sizeof(v4l2_streamparm));
    sparm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
    sparm.parm.capture.timeperframe.numerator = 1;
    sparm.parm.capture.timeperframe.denominator = frameRate;
    rc = ioctl(fd, VIDIOC_S_PARM, &sparm);
    if (rc < 0)
    {
        log<level::WARNING>("Failed to set video device frame rate",
                            entry("ERROR=%s", strerror(errno)));
    }

    height = fmt.fmt.pix.height;
    width = fmt.fmt.pix.width;

    resize();

    if (oldHeight != height || oldWidth != width)
    {
        resizeAfterOpen = true;
    }
}

void Video::stop()
{
    int rc;
    unsigned int i;
    v4l2_buf_type type(V4L2_BUF_TYPE_VIDEO_CAPTURE);

    if (fd < 0)
    {
        return;
    }

    lastFrameIndex = -1;

    rc = ioctl(fd, VIDIOC_STREAMOFF, &type);
    if (rc)
    {
        log<level::ERR>("Failed to stop streaming",
                        entry("ERROR=%s", strerror(errno)));
    }

    for (i = 0; i < buffers.size(); ++i)
    {
        if (buffers[i].data)
        {
            munmap(buffers[i].data, buffers[i].size);
            buffers[i].data = nullptr;
            buffers[i].queued = false;
        }
    }

    close(fd);
    fd = -1;
}

} // namespace ikvm
