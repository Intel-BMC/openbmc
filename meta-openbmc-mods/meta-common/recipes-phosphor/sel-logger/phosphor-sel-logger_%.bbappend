# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/phosphor-sel-logger.git"
SRCREV = "2b9704d7eb666c945c73dd74a426a0af2292b0ea"

# Enable threshold monitoring
EXTRA_OECMAKE += "-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON"
