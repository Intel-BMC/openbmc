# Initialization
AC_PREREQ([2.69])
AC_INIT([obmc-ikvm], [1.0], [https://github.com/openbmc/obmc-ikvm/issues])
AC_LANG([C++])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([subdir-objects -Wall -Werror foreign dist-xz])
AM_SILENT_RULES([yes])

# Checks for programs.
AC_PROG_CXX
AM_PROG_AR
AC_PROG_INSTALL
AC_PROG_MAKE_SET

# Checks for typedefs, structures, and compiler characteristics.
AX_CXX_COMPILE_STDCXX_17([noext])
AX_APPEND_COMPILE_FLAGS([-Wall -Werror], [CXXFLAGS])

# Checks for libraries.
AC_CHECK_LIB([pthread], [pthread_create])
PKG_CHECK_MODULES([LIBVNCSERVER], [libvncserver], , AC_MSG_ERROR(["Requires libvncserver package."]))
PKG_CHECK_MODULES([SDBUSPLUS], [sdbusplus], , AC_MSG_ERROR(["Requires sdbusplus package."]))
PKG_CHECK_MODULES([PHOSPHOR_LOGGING], [phosphor-logging], , AC_MSG_ERROR(["Requires phosphor-logging package."]))
PKG_CHECK_MODULES([PHOSPHOR_DBUS_INTERFACES], [phosphor-dbus-interfaces], , AC_MSG_ERROR(["Requires phosphor-dbus-interfaces package."]))

LT_INIT

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
