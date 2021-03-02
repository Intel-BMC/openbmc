SRC_URI = "git://github.com/Intel-BMC/phosphor-webui;protocol=ssh;branch=intel2"
FILESEXTRAPATHS_prepend_intel := "${THISDIR}/${PN}:"

SRCREV = "6313c9df615fd85a8617c46444f964b972abdebd"

# Adding the code below as a workaround as
# favicon gets corrupted during emit due to issue with html-webpack-plugin.
# This workaround needs to be removed once this issue is fixed in the
# newer version of  html-webpack-plugin
do_compile_append() {
	rm -rf ${S}/dist/favicon.ico.gz
	mv ${S}/dist/favicon.gz ${S}/dist/favicon.ico.gz
	rm -rf ${S}/dist/app.bundle.js.LICENSE.txt.gz
}
