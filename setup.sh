#!/bin/sh

# TODO: discover the latest available Java version automatically (currently hardcoded)

# http://www.java.com/pl/download/manual.jsp
JAVADIR="jre1.8.0_77"



arch=`uname -m`
if [ "$arch" = "x86_64" ]; then
	JAVAFILE="jre-8u77-linux-x64"
	BUNDLEID="207221"
elif [ "$arch" = "i586" ] || [ "$arch" = "i686" ]; then
	JAVAFILE="jre-8u77-linux-i586"
	BUNDLEID="207219"
else
	echo "architecture $arch is not supported, skipping Java setup"
	exit 1
fi

if [ -d /opt/java ] && [ ! -h /opt/java ]; then
	mv /opt/java /opt/java.disabled
fi

if [ ! -d /opt/$JAVADIR ]; then
	DIR="`pwd`"
	cd /opt
	wget -O $JAVAFILE.tar.gz http://javadl.sun.com/webapps/download/AutoDL?BundleId=$BUNDLEID
	tar xzf $JAVAFILE.tar.gz
	rm -f $JAVAFILE.tar.gz
	ln -sf $JAVADIR java
	cd "$DIR"
fi

if ! grep -q JAVA_HOME /etc/environment; then
	echo 'JAVA_HOME="/opt/java"' >>/etc/environment
	echo 'JAVA_OPTS="-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true"' >>/etc/environment
fi
