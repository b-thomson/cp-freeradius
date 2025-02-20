#!/bin/sh
set -e

PATH=/opt/sbin:/opt/bin:$PATH
export PATH

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- radiusd "$@"
fi

# check for the expected command
if [ "$1" = 'radiusd' ]; then
    shift
    exec radiusd -X "$@"
fi

# else default to run whatever the user wanted like "bash" or "sh"
exec "$@"
