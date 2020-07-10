# libxcrypt fails to compile under gcc with the -Os flag.  Because we want to
# be able to compile the rest of the system with -Os, override the global
# setting here to fall back to -O3
CFLAGS_append = " --param max-inline-insns-single=1000"
FULL_OPTIMIZATION = "-O3 -pipe ${DEBUG_FLAGS}"
