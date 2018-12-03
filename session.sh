#!/bin/bash

cleanup() {
    rm -f $TMPFILE
    exit 0
}
trap cleanup EXIT INT QUIT TERM

if [ "$#" -ge 1 ]; then
    SQLFILE="$1"
else
    if tty -s; then
	SQLFILE=$(ls -t ~/.mozilla/firefox/*/cookies.sqlite | head -1)
    else
	SQLFILE="-" # Will use 'cat' below to read stdin
    fi
fi

if [ "$SQLFILE" != "-" -a ! -r "$SQLFILE" ]; then
    echo "Error. File $SQLFILE is not readable." >&2
    exit 1
fi

TMPFILE=$(mktemp /tmp/cookies.sqlite.XXXXXXXXXX)
cat $SQLFILE >> $TMPFILE

sqlite3 -separator $'\t' $TMPFILE <<- EOF
	.mode tabs
	.header off
	select
	value
	from moz_cookies
	where host = '.adventofcode.com' and name = 'session';
EOF

cleanup
