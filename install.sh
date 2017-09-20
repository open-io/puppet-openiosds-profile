#!/bin/bash
#set -x

### Vars
OPENIOCMD="/usr/bin/openio"
OIOCLUSTER="/usr/bin/oio-cluster"
OIOMETA0INIT="/usr/bin/oio-meta0-init"
GRIDINITD="/usr/bin/gridinit"
GRIDINITD_CONF="/etc/gridinit.conf"
GRIDINITCMD="/usr/bin/gridinit_cmd"
GRIDINIT_SOCKET="/run/gridinit/gridinit.sock"
PUPPET="/usr/bin/puppet"
TOUCH="/bin/touch"
CAT="/usr/bin/cat"
SUDO="/usr/bin/sudo"
SED="/usr/bin/sed"
IPCALC="/usr/bin/ipcalc"
LS="/bin/ls"
BASENAME="/bin/basename"
NS="OPENIO"
TIMEOUT=20
WAIT=2
NBREPLICAS=3
IGNOREDISTANCE="on"
PROFILE="standalone"
PROFILE_PATH="/usr/share/puppet/modules/openiosds/profiles"
SETENFORCE="/sbin/setenforce"
MODULEPATH="/usr/share/puppet/modules:/etc/puppet/modules"
PUPPETOPTS=""


### Preflight checks
# Profile checks
if [ $# -lt 1 ]; then
  echo "Usage: $0 <profile>"
  exit 1
fi
if [ ! -d "${PROFILE_PATH}/$1" ]; then
  echo "Profile $1 does not exists."
  exit 1
fi
PROFILE=$1

# Disable SELinux
if [ -x $SETENFORCE ]; then
  $SETENFORCE 0
fi
if [ -f /etc/selinux/config ]; then
  $SED -i -e 's@enforcing@permissive@' /etc/selinux/config
fi

# Check if using root or sudo rights
if [ $EUID -ne 0 ]; then
  sudo -v
  if [ $? -ne 0 ]; then
    echo "User has not enough privileges to run this script. Aborting."
    exit 1
  fi
  if [ -z "$SUDO_COMMAND" ]
  then
    $SUDO $0 $*
    exit 0
  fi
fi


### deployment
echo "########## Starting deployment ..."

# Fix Hiera warning
$TOUCH -a /etc/puppet/hiera.yaml

# predeploy
[ -f ${PROFILE_PATH}/${PROFILE}/predeploy.sh ] && \
  . ${PROFILE_PATH}/${PROFILE}/predeploy.sh


# Deploy services
for manifest in $($LS ${PROFILE_PATH}/${PROFILE}/manifests/*.pp)
do
  echo "Deploying service $($BASENAME $manifest .pp) ..."
  PUPPET_VERSION=$($PUPPET --version)
  res=$(echo -e "4\n$PUPPET_VERSION" | sort -V | head -n 1)
  if [ "$res" != '4' ]; then
    PUPPETOPTS="$PUPPETOPTS --no-stringify_facts"
  fi
  $PUPPET apply $PUPPETOPTS --modulepath=$MODULEPATH $manifest || \
    (echo "Error: Failed to deploy service $($BASENAME $manifest .pp)." ; exit 1)
done

# postdeploy
if [ -f ${PROFILE_PATH}/${PROFILE}/postdeploy.sh ]; then
  echo "#### Post deployment install ..."
  . ${PROFILE_PATH}/${PROFILE}/postdeploy.sh
fi

echo "########## Deployment finished."


### motd
[ -f ${PROFILE_PATH}/${PROFILE}/motd ] && \
  $CAT ${PROFILE_PATH}/${PROFILE}/motd >>/etc/motd

### Banner time
. ${PROFILE_PATH}/banner.sh
sleep 1

### postinstall
[ -f ${PROFILE_PATH}/${PROFILE}/postinstall.sh ] && \
  . ${PROFILE_PATH}/${PROFILE}/postinstall.sh

exit 0
