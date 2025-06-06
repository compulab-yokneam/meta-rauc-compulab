FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://system.conf "

RDEPENDS:${PN} += "u-boot-fw-utils"
DEPENDS += "u-boot-compulab"

do_install:prepend() {
	sed -i "s/@@MACHINE@@/${MACHINE}/g" ${WORKDIR}/system.conf
}
