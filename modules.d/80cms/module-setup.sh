#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

# called by dracut
check() {
    arch=$(uname -m)
    [ "$arch" = "s390" -o "$arch" = "s390x" ] || return 1
    return 255
}

# called by dracut
depends() {
    arch=$(uname -m)
    [ "$arch" = "s390" -o "$arch" = "s390x" ] || return 1
    echo znet zfcp dasd dasd_mod
    return 0
}

# called by dracut
installkernel() {
    instmods zfcp
}

# called by dracut
install() {
    inst_hook pre-trigger 30 "$moddir/cmssetup.sh"
    inst_hook pre-pivot 95 "$moddir/cms-write-ifcfg.sh"
    inst_script "$moddir/cmsifup.sh" /sbin/cmsifup
    inst_multiple /etc/cmsfs-fuse/filetypes.conf /etc/udev/rules.d/99-fuse.rules /etc/fuse.conf \
        cmsfs-fuse fusermount ulockmgr_server bash insmod rmmod cat normalize_dasd_arg sed \
        $(rpm -ql s390utils-base)

    inst_libdir_file "gconv/*"
    #inst /usr/lib/locale/locale-archive
    dracut_need_initqueue
}
