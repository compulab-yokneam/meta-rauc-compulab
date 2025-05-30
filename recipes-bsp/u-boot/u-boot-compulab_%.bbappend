FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "  \
    file://boot.cmd.in \
"

DEPENDS += "u-boot-mkimage-native"
PROVIDES += "u-boot-default-script"

DEPENDS += "bc-native dtc-native swig-native python3-native flex-native bison-native"
EXTRA_OEMAKE += 'HOSTLDSHARED="${BUILD_CC} -shared ${BUILD_LDFLAGS} ${BUILD_CFLAGS}"'

# The UBOOT_ENV_SUFFIX and UBOOT_ENV are mandatory in order to run the
# uboot-mkimage command from poky/meta/recipes-bsp/u-boot/u-boot.inc
UBOOT_ENV_SUFFIX = "scr"
UBOOT_ENV = "boot"

BOOT_DEV ?= "2"
OS_BOOT_DEV ?= "/dev/mmcblk2"

do_compile:prepend() {
    sed "s|@@BOOT_DEV@@|${BOOT_DEV}|g;s|@@OS_BOOT_DEV@@|${OS_BOOT_DEV}|g" ${WORKDIR}/boot.cmd.in > ${WORKDIR}/boot.cmd
}

do_deploy:append() {
    install -d ${DEPLOYDIR}
    install -m 0644 ${WORKDIR}/${UBOOT_ENV_BINARY} ${DEPLOYDIR}
}
