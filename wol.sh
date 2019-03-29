#! /bin/bash

### BEGIN INIT INFO
# Provides:		wol
# Required-Start:	$remote_fs $syslog
# Required-Stop:	$remote_fs $syslog
# Default-Start:	2 3
# Default-Stop:		0 6
# Short-Description:	Wake On Lan Functionality
### END INIT INFO

set -e

# /etc/init.d/wol: Ensure NIC will respond to Wake on LAN request

test -x /sbin/ethtool || exit 0

get_interface() {
  UPLINKS="$(ip link | grep ",UP,")"
  while IFS= read -r LINK; do
    if [[ $LINK != *"LOOPBACK"* ]]; then
      ARR=($LINK)
      INTF=${ARR[1]%?}
    fi
  done <<<"${UPLINKS}"
}

get_interface


case "$1" in
  start)
	ethtool -s $INTF wol g
    ;;

  stop)
	ifconfig $INTF down
	;;

  status)
	ethtool $INTF | grep Wake-on
	;;

  *)
	echo "Usage: /etc/init.d/ssh {start|stop|status}"
	exit 1
esac

exit 0