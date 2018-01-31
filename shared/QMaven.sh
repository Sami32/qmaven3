#!/bin/sh

# declare variables
QPKG_CONF="/etc/config/qpkg.conf"
QPKG_NAME="QMaven3"

# perform the given action
case "$1" in
	start)
		# disabled QPKG has no right to start...
		ENABLED="$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $QPKG_CONF)"
		if [ "$ENABLED" != "TRUE" ]; then
			echo "$QPKG_NAME is disabled."
			exit 1
		fi
		;;

	stop)
		;;
		
	test)
		;;

	restart)
		./$0 stop
		# Note: doesn't work properly without these additional commands...
		/bin/sleep 5
		/bin/sync
		./$0 start
		;;

	*)
		echo "Usage: $0 {start|stop|restart|test}"
		exit 1
esac

# if everything goes well...
exit 0
