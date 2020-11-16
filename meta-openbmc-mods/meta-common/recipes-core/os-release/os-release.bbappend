# WARNING!
#
# These modifications to os-release disable the bitbake parse
# cache (for the os-release recipe only).  Before copying
# and pasting into another recipe ensure it is understood
# what that means!

require version-vars.inc

OS_RELEASE_FIELDS_append = " OPENBMC_VERSION IPMI_MAJOR IPMI_MINOR IPMI_AUX13 IPMI_AUX14 IPMI_AUX15 IPMI_AUX16"

OS_RELEASE_FIELDS_remove = "BUILD_ID"

python do_compile_append () {
    import glob
    with open(d.expand('${B}/os-release'), 'a') as f:
        corebase = d.getVar('COREBASE', True)
        f.write('\n# Build Configuration Details\n')
        repo_status(d, f, corebase, '')
        repo_status(d, f, os.path.join(corebase, 'meta-openbmc-mods'), '--tags')
        appends_dir = os.path.join(d.getVar('TOPDIR', True), 'workspace', 'appends')

        for fn in glob.glob(os.path.join(appends_dir, '*.bbappend')):
            with open(fn, 'r') as bb_f:
                for line in bb_f:
                    if line.startswith('# srctreebase: '):
                        srctreebase = line.split(':', 1)[1].strip()
                        repo_status(d, f, srctreebase, '--tags')
}


# Ensure the git commands run every time bitbake is invoked.
BB_DONT_CACHE = "1"

# Make os-release available to other recipes.
SYSROOT_DIRS_append = " ${sysconfdir}"
