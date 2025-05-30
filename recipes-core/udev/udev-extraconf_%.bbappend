FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://compulab-rauc.rules"

do_install:append() {
    install -m 0644 ${WORKDIR}/compulab-rauc.rules ${D}${sysconfdir}/udev/mount.blacklist.d/
}
