# Enable downstream autobump
SRC_URI = "git://github.com/openbmc/phosphor-sel-logger.git"
SRCREV = "f2552a50fde35d665b5fc3ac6852f2f6bb229cae"

# Enable threshold monitoring
EXTRA_OECMAKE += "-DSEL_LOGGER_MONITOR_THRESHOLD_EVENTS=ON"
