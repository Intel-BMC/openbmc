python do_print_src () {
    srcuri = d.getVar('SRC_URI', True).split()
    srcrev = d.getVar('SRCREV', True).split()
    thisdir = d.getVar('THISDIR', True).split()
    bb.warn("THISDIR: %s SRC_URI: %s SRCREV: %s" % (thisdir, srcuri, srcrev))
}

addtask do_print_src before do_fetch
