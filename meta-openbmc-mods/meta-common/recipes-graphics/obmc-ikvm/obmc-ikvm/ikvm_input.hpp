#pragma once

#include <rfb/rfb.h>

#include <map>
#include <string>

namespace ikvm
{

/*
 * @class Input
 * @brief Receives events from RFB clients and sends reports to the USB input
 *        device
 */
class Input
{
  public:
    /*
     * @brief Constructs Input object
     *
     * @param[in] kbdPath - Path to the USB keyboard device
     * @param[in] ptrPath - Path to the USB mouse device
     */
    Input(const std::string& kbdPath, const std::string& ptrPath);
    ~Input();
    Input(const Input&) = default;
    Input& operator=(const Input&) = default;
    Input(Input&&) = default;
    Input& operator=(Input&&) = default;

    /*
     * @brief RFB client key event handler
     *
     * @param[in] down - Boolean indicating whether key is pressed or not
     * @param[in] key  - Key code
     * @param[in] cl   - Handle to the RFB client
     */
    static void keyEvent(rfbBool down, rfbKeySym key, rfbClientPtr cl);
    /*
     * @brief RFB client pointer event handler
     *
     * @param[in] buttonMask - Bitmask indicating which buttons have been
     *                         pressed
     * @param[in] x          - Pointer x-coordinate
     * @param[in] y          - Pointer y-coordinate
     * @param[in] cl         - Handle to the RFB client
     */
    static void pointerEvent(int buttonMask, int x, int y, rfbClientPtr cl);

    /* @brief Sends a wakeup data packet to the USB input device */
    void sendWakeupPacket();
    /* @brief Sends an HID report to the USB input device */
    void sendReport();

  private:
    static constexpr int NUM_MODIFIER_BITS = 4;
    static constexpr int KEY_REPORT_LENGTH = 8;
    static constexpr int PTR_REPORT_LENGTH = 5;

    /* @brief HID modifier bits mapped to shift and control key codes */
    static constexpr uint8_t shiftCtrlMap[NUM_MODIFIER_BITS] = {
        0x02, // left shift
        0x20, // right shift
        0x01, // left control
        0x10  // right control
    };
    /* @brief HID modifier bits mapped to meta and alt key codes */
    static constexpr uint8_t metaAltMap[NUM_MODIFIER_BITS] = {
        0x08, // left meta
        0x80, // right meta
        0x04, // left alt
        0x40  // right alt
    };
    /*
     * @brief Translates a RFB-specific key code to HID modifier bit
     *
     * @param[in] key - key code
     */
    static uint8_t keyToMod(rfbKeySym key);
    /*
     * @brief Translates a RFB-specific key code to HID scancode
     *
     * @param[in] key - key code
     */
    static uint8_t keyToScancode(rfbKeySym key);

    /* @brief Indicates whether or not to send a keyboard report */
    bool sendKeyboard;
    /* @brief Indicates whether or not to send a pointer report */
    bool sendPointer;
    /* @brief File descriptor for the USB keyboard device */
    int keyboardFd;
    /* @brief File descriptor for the USB mouse device */
    int pointerFd;
    /* @brief Data for keyboard report */
    uint8_t keyboardReport[KEY_REPORT_LENGTH];
    /* @brief Data for pointer report */
    uint8_t pointerReport[PTR_REPORT_LENGTH];
    /* @brief Path to the USB keyboard device */
    std::string keyboardPath;
    /* @brief Path to the USB mouse device */
    std::string pointerPath;
    /*
     * @brief Mapping of RFB key code to report data index to keep track
     *        of which keys are down
     */
    std::map<int, int> keysDown;
};

} // namespace ikvm
