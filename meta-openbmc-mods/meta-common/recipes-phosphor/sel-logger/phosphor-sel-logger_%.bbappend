# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/phosphor-sel-logger.git"
SRCREV = "6afe9560852c6431c43c8e79a28e2b7cb498e355"

# Enable threshold monitoring
EXTRA_OECMAKE += "-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON"
EXTRA_OECMAKE += "-DREDFISH_LOG_MONITOR_PULSE_EVENTS=ON"
