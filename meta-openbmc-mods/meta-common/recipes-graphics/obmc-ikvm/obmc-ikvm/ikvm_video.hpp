#pragma once

#include "ikvm_input.hpp"

#include <mutex>
#include <string>
#include <vector>

namespace ikvm
{

/*
 * @class Video
 * @brief Sets up the V4L2 video device and performs read operations
 */
class Video
{
  public:
    /*
     * @brief Constructs Video object
     *
     * @param[in] p     - Path to the V4L2 video device
     * @param[in] input - Reference to the Input object
     * @param[in] fr    - desired frame rate of the video
     */
    Video(const std::string& p, Input& input, int fr = 30);
    ~Video();
    Video(const Video&) = default;
    Video& operator=(const Video&) = default;
    Video(Video&&) = default;
    Video& operator=(Video&&) = default;

    /*
     * @brief Gets the video frame data
     *
     * @return Pointer to the video frame data
     */
    char* getData();
    /* @brief Performs read to grab latest video frame */
    void getFrame();
    /*
     * @brief Gets whether or not the video frame needs to be resized
     *
     * @return Boolean indicating if the frame needs to be resized
     */
    bool needsResize();
    /* @brief Performs the resize and re-allocates framebuffer */
    void resize();
    /* @brief Starts streaming from the video device */
    void start();
    /* @brief Stops streaming from the video device */
    void stop();

    /* @brief Restart streaming from the video device */
    inline void restart()
    {
        stop();
        start();
    }
    /*
     * @brief Gets the desired video frame rate in frames per second
     *
     * @return Value of the desired frame rate
     */
    inline int getFrameRate() const
    {
        return frameRate;
    }
    /*
     * @brief Gets the size of the video frame data
     *
     * @return Value of the size of the video frame data in bytes
     */
    inline size_t getFrameSize() const
    {
        return buffers[lastFrameIndex].payload;
    }
    /*
     * @brief Gets the height of the video frame
     *
     * @return Value of the height of video frame in pixels
     */
    inline size_t getHeight() const
    {
        return height;
    }
    /*
     * @brief Gets the width of the video frame
     *
     * @return Value of the width of video frame in pixels
     */
    inline size_t getWidth() const
    {
        return width;
    }

    /* @brief Number of bits per component of a pixel */
    static const int bitsPerSample;
    /* @brief Number of bytes of storage for a pixel */
    static const int bytesPerPixel;
    /* @brief Number of components in a pixel (i.e. 3 for RGB pixel) */
    static const int samplesPerPixel;

  private:
    /*
     * @struct Buffer
     * @brief Store the address and size of frame data from streaming
     *        operations
     */
    struct Buffer
    {
        Buffer() : data(nullptr), queued(false), payload(0), size(0)
        {
        }
        ~Buffer() = default;
        Buffer(const Buffer&) = default;
        Buffer& operator=(const Buffer&) = default;
        Buffer(Buffer&&) = default;
        Buffer& operator=(Buffer&&) = default;

        void* data;
        bool queued;
        size_t payload;
        size_t size;
    };

    /*
     * @brief Boolean to indicate whether the resize was triggered during
     *        the open operation
     */
    bool resizeAfterOpen;
    /* @brief File descriptor for the V4L2 video device */
    int fd;
    /* @brief Desired frame rate of video stream in frames per second */
    int frameRate;
    /* @brief Buffer index for the last video frame */
    int lastFrameIndex;
    /* @brief Height in pixels of the video frame */
    size_t height;
    /* @brief Width in pixels of the video frame */
    size_t width;
    /* @brief Reference to the Input object */
    Input& input;
    /* @brief Path to the V4L2 video device */
    const std::string path;
    /* @brief Streaming buffer storage */
    std::vector<Buffer> buffers;
};

} // namespace ikvm
