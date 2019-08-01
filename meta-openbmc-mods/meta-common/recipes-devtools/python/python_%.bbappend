# This commit pulls in the python world, and adds a very large chunk to our
# image size.  I suspect we can make most of our things rely on python-core
# instead of full python, but this is a temporary fix.
# https://git.yoctoproject.org/cgit/cgit.cgi/poky/commit/?id=f384e39ad1ca1514fb7b5d7fa0d63e0c863761ca

RPROVIDES_${PN}-core = "${PN}"
RPROVIDES_${PN}-modules = ""
