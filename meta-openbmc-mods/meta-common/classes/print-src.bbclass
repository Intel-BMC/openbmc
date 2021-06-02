python do_print_src () {
    srcuri = d.getVar('SRC_URI', True).split()
    srcrev = d.getVar('SRCREV', True).split()
    bb.warn("SRC_URI: %s SRCREV: %s" % (srcuri, srcrev))
}

addtask do_print_src before do_fetch
