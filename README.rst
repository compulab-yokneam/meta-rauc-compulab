This README file contains information on the contents of the meta-rauc-compulab layer.

Please see the corresponding sections below for details.

Dependencies
============

  URI: https://git.yoctoproject.org/poky
  branch: kirkstone

  URI: https://github.com/rauc/meta-rauc.git
  branch: kirkstone

  URI: https://git.yoctoproject.org/meta-freescale
  branch: kirkstone

  URI: https://github.com/Freescale/meta-fsl-arm-extra.git
  branch: kirkstone


Disclaimers
===========

Note that this is just an example layer that shows a possible RAUC
configuration.
Actual requirements may differ from project to project and will
probably need a much different RAUC/bootloader/system configuration.


Currently this layer supports only compulab/HummingBoard boards.


I. Adding the meta-rauc-compulab layer to your build
===============================================

Run 'bitbake-layers add-layer meta-rauc-compulab'


II. Build The CompuLab Demo System
===============================================
::

    $ . oe-init-build-env

Set ``MACHINE`` to ``iot-gate-imx8plus`` in your local.conf::

    MACHINE = "iot-gate-imx8plus"

Accept end user agreement for meta-freescale::

    ACCEPT_FSL_EULA = "1"

It is recommended, but not necessary, to enable 'systemd'::

    INIT_MANAGER = "systemd"

Add configuration required for RAUC to your local.conf::

    IMAGE_INSTALL:append = " rauc"
    DISTRO_FEATURES:append = " rauc"
    # ext4 image format required
    IMAGE_FSTYPES:append = " ext4"

Append the u-boot script to boot files::

    IMAGE_BOOT_FILES:append = " boot.scr"

Select the Kickstart file::

    WKS_FILE = "sdimage-dual-compulab.wks.in"
    WKS_FILES:prepend = "sdimage-dual-compulab.wks.in "

You can increase the size of rootfs to contain software added when updating::

    # Add 150 000 Kbytes free space to rootfs
    IMAGE_ROOTFS_EXTRA_SPACE:append = " + 150000"

Create example authentication keys (from sourced environment)::

    $ ../meta-rauc-community/create-example-keys.sh

Build the minimal system image::

    $ bitbake core-image-minimal


III. Flash & Run the Demo System
================================

Before flashing it's recommended to make sure that any traces
of u-boot environment that may have been left from prevous use
of the SD card with the CompuLab board are erased::

    $ dd if=/dev/zero of=/dev/sdX count=10000

You can either flash using bmaptool (recommended)::

    $ bmaptool copy /path/to/core-image-minimal-compulab.wic.gz /dev/sdX

or zcat::

    $ zcat /path/to/core-image-minimal-compulab.wic.gz | dd of=/dev/sdX

Then power-on the board and log in.
To see that RAUC is configured correctly and can interact
with the bootloader, run::

    # rauc status


IV. Build and Install the Demo Bundle
=====================================

To build the bundle, run::

    $ bitbake update-bundle

Transfer ``update-bundle-compulab.raucb`` to the board and install it::

    # rauc install /path/to/update-bundle-compulab.raucb

As alternative, you can host the bundle on a web server and update
without downloading it::

    # rauc install http://192.168.1.2/update-bundle-compulab.raucb

A convenient way to host HTTP server is::

    $ cd tmp/deploy/images/${MACHINE}
    $ python3 -m http.server


After the update is complete reboot the board to boot from the updated rootfs.

