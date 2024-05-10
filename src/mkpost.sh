#!/bin/sh

INPUT=$1
TMP=$2
OUT=$3

# Extract title from Markdown metadata
export TITLE=$(echo "/---/+1 s/title: \(.*\)$/\1/p" | ed -s $INPUT)
export DATE=$(basename $TMP | cut -c1-10)
export AUTHOR="Christopher Wilson"
export BODY=$(cat $TMP)

# Wrap fragment in post
envsubst < templates/post.html > $TMP

export MAIN=$(cat $TMP)

# Wrap post in standalone page
envsubst < templates/default.html > $OUT
