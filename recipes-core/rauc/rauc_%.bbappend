FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append := "  \
	file://rauc-grow-data-partition.service \
"

# additional dependencies required to run RAUC on the target
RDEPENDS:${PN}:append = " u-boot-fw-utils u-boot-compulab-env"
RRECOMMENDS:${PN}:append = " ${PN}-grow-data-part"

inherit systemd

SYSTEMD_PACKAGES += "${PN}-grow-data-part"
SYSTEMD_SERVICE:${PN}-grow-data-part = "rauc-grow-data-partition.service"

PACKAGES += "${PN}-grow-data-part"

RDEPENDS:${PN}-grow-data-part += "parted"

do_install:append() {
	sed -i "s|@@OS_BOOT_DEV@@|${OS_BOOT_DEV}|g" ${WORKDIR}/rauc-grow-data-partition.service
	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/rauc-grow-data-partition.service ${D}${systemd_unitdir}/system/
}
