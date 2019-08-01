# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/phosphor-sel-logger.git"
SRCREV = "3d300fca24b30864b3e9a4f5768cfe5e769458ae"

# Enable threshold monitoring
EXTRA_OECMAKE += "-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON"
EXTRA_OECMAKE += "-DREDFISH_LOG_MONITOR_PULSE_EVENTS=ON"
