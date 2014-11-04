#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

# turn off debugging
set +x

[ ! -d /etc/cmdline.d ] && return

echo -n "dracut command line:"
for f in /etc/cmdline.d/*; do
	echo -n " $(cat $f)"
done
echo

