bin_PROGRAMS = obmc-ikvm
dist_bin_SCRIPTS = create_usbhid.sh

noinst_HEADERS = \
	ikvm_args.hpp \
	ikvm_input.hpp \
	ikvm_manager.hpp \
	ikvm_server.hpp \
	ikvm_video.hpp

obmc_ikvm_SOURCES = \
	ikvm_args.cpp \
	ikvm_input.cpp \
	ikvm_manager.cpp \
	ikvm_server.cpp \
	ikvm_video.cpp \
	obmc-ikvm.cpp

obmc_ikvm_CXXFLAGS = \
	$(PHOSPHOR_DBUS_INTERFACES_CFLAGS) \
	$(PHOSPHOR_LOGGING_CFLAGS) \
	$(PTHREAD_CFLAGS) \
	$(SDBUSPLUS_CFLAGS) \
	$(LIBVNCSERVER_CFLAGS)

obmc_ikvm_LDFLAGS = \
	$(PHOSPHOR_DBUS_INTERFACES_LIBS) \
	$(PHOSPHOR_LOGGING_LIBS) \
	$(PTHREAD_LIBS) \
	$(SDBUSPLUS_LIBS) \
	$(LIBVNCSERVER_LIBS)
