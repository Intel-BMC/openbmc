SRCREV = "46342ec359c8e0ed543ebb352cfba8f26ce85afe"
SRC_URI = "git://github.com/openbmc/dbus-sensors.git"

DEPENDS_append = " i2c-tools"

# turn this back on when we have a need, but disable it now
# as no shipping platforms use it and it will take cpu cycles
EXTRA_OECMAKE_append = " -DDISABLE_INTRUSION=ON"
