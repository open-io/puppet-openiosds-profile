#!/bin/bash
#set -x

### Vars
OIOCLUSTER="/usr/bin/oio-cluster"
OIOMETA0INIT="/usr/bin/oio-meta0-init"
GRIDINITCMD="/usr/bin/gridinit_cmd"
PUPPET="/usr/bin/puppet"
TOUCH="/bin/touch"
CAT="/usr/bin/cat"
SUDO="/usr/bin/sudo"
LS="/bin/ls"
BASENAME="/bin/basename"
NS="OPENIO"
TIMEOUT=20
WAIT=2
NBREPLICAS=3
IGNOREDISTANCE="on"
GRIDINIT_SOCKET="/run/gridinit/gridinit.sock"
PROFILE="standalone"
PROFILE_PATH="/usr/share/puppet/modules/openiosds/profiles"


### Preflight checks
# Profile checks
if [ $# -ne 1 ]; then
  echo "Usage: $0 <profile>"
  exit 1
fi
if [ ! -d ${PROFILE_PATH}/$1 ]; then
  echo "Profile $1 does not exists."
  exit 1
fi
PROFILE=$1

# Check if using root or sudo rights
if [ $EUID -ne 0 ]; then
  sudo -v
  if [ $? -ne 0 ]; then
    echo "User has no privileges to run this script. Aborting."
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

# Deploy services
for manifest in $($LS ${PROFILE_PATH}/${PROFILE}/manifests/*.pp)
do
  echo "Deploying service $($BASENAME $manifest .pp) ..."
  $PUPPET apply $manifest || \
    echo "Error: Failed to deploy service $($BASENAME $manifest .pp)."
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
