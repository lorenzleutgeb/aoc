#! /usr/bin/env bash

for word in $(cat words-small.txt)
do
	echo "$word" | java -Xmx500M -cp "antlr-4.9-complete.jar:." org.antlr.v4.gui.TestRig bar r0 2> $word.out

	if ! grep line $word.out
	then
		echo "YE: $word"
	else
		echo "NO: $word"
	fi
done
