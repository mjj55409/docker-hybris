#!/bin/sh

export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")

if [ "$1" = 'run' ]; then
  exec . ./hybrisserver.sh
  # exec gosu hybris ./hybrisserver.sh
else
  exec "$@"
fi
