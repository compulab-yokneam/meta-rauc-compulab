FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Add a mount point for a shared data partition
dirs755 += "/data"

do_install:prepend() {
    sed -i "s|@@OS_BOOT_DEV@@|${OS_BOOT_DEV}|g" ${WORKDIR}/fstab
}
