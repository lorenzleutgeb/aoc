#!/bin/bash

if [ -f input.txt ]
then
	echo 'input.txt already exists, goodbye!'
	exit 0
fi

REL=$(realpath --relative-to=../.. $PWD)
curl \
	--verbose \
	--cookie "session=$(../../session.sh)" \
	--cookie-jar ../../cookies.txt \
	--user-agent 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:63.0) Gecko/20100101 Firefox/63.0' \
	https://adventofcode.com/${REL/\//\/day/}/input \
       | tee input.txt
