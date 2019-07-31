RDEPENDS_${PN} = ""
do_install_append() {
    F=$(find ${D} -name check_for_unsafe_apis)
    if [ -n "${F}" ]; then
        # remove the unused perl script
        rm -f "${F}"
        # remove the script's destination directory, only if it is empty
        rmdir "$(dirname ${F})" 2>/dev/null || :
    fi
}

