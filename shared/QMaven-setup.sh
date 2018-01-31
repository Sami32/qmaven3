#!/bin/sh

# declare variables
QPKG_CONF="/etc/config/qpkg.conf"
QPKG_NAME="QMaven3"
QJDK7_NAME="QJDK7"
QJDK8_NAME="QJDK8"
QJDK9_NAME="QJDK9"
QPKG_ROOT="$(/sbin/getcfg $QPKG_NAME Install_Path -f $QPKG_CONF)"
QJDK7_ROOT="$(/sbin/getcfg $QJDK7_NAME Install_Path -f $QPKG_CONF)"
QJDK8_ROOT="$(/sbin/getcfg $QJDK8_NAME Install_Path -f $QPKG_CONF)"
QJDK9_ROOT="$(/sbin/getcfg $QJDK9_NAME Install_Path -f $QPKG_CONF)"

# declare data folders and files
MVN_DATA_FOLDER="$QPKG_ROOT/../.maven"
MVN_DATA_JH="$MVN_DATA_FOLDER/java_home.sh"
MVN_DATA_MO="$MVN_DATA_FOLDER/maven_opts.sh"

# setup Maven environment
echo "--- Setting up PATH..."
export PATH="$QPKG_ROOT/bin:$PATH"
if [ -f "$MVN_DATA_JH" ]; then
	echo "--- Setting up JAVA_HOME (user preference)..."
	/bin/sh "$MVN_DATA_JH"
fi
if [ -f "$MVN_DATA_MO" ]; then
	echo "--- Setting up MAVEN_OPTS (user preference)..."
	/bin/sh "$MVN_DATA_MO"
fi

# check that JAVA_HOME has been set (if so, exit)
if [ -z "$JAVA_HOME" ]; then
	echo "--- Checking JAVA_HOME... still empty! Let's set it up manually..."
else
	exit 0
fi

# otherwise, try to detect the installed JDK and set the variable manually
if [ ! -z "$QJDK7_ROOT" ]; then
	echo "--- Setting up JAVA_HOME to QJDK7..."
	export JAVA_HOME="$QJDK7_ROOT"
elif [ ! -z "$QJDK8_ROOT" ]; then
	echo "--- Setting up JAVA_HOME to QJDK8..."
	export JAVA_HOME="$QJDK8_ROOT"
elif [ ! -z "$QJDK9_ROOT" ]; then
	echo "--- Setting up JAVA_HOME to QJDK9..."
	export JAVA_HOME="$QJDK9_ROOT"	
else
	echo "Error: QJDK 7/8/9 was not found!"
	exit 1
fi

# and finish up
echo "Success!"
exit 0

# Run "mvn --version" to verify that it is correctly installed.
# Confirm with mvn -v in a new shell
