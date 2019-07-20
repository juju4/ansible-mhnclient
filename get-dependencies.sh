#!/bin/sh
## one script to be used by travis, jenkins, packer...

umask 022

rolesdir=$(dirname $0)/..

[ ! -d $rolesdir/juju4.maxmind ] && git clone https://github.com/juju4/ansible-maxmind $rolesdir/juju4.maxmind
[ ! -d $rolesdir/juju4.redhat_epel ] && git clone https://github.com/juju4/ansible-redhat-epel $rolesdir/juju4.redhat_epel
[ ! -d $rolesdir/juju4.golang ] && git clone https://github.com/juju4/ansible-golang $rolesdir/juju4.golang
[ ! -d $rolesdir/juju4.mhn ] && git clone https://github.com/juju4/ansible-mhn $rolesdir/juju4.mhn
## galaxy naming: kitchen fails to transfer symlink folder
#[ ! -e $rolesdir/juju4.mhnclient ] && ln -s ansible-mhnclient $rolesdir/juju4.mhnclient
[ ! -e $rolesdir/juju4.mhnclient ] && cp -R $rolesdir/ansible-mhnclient $rolesdir/juju4.mhnclient

## don't stop build on this script return code
true

