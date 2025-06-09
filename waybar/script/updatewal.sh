#!/bin/bash

imgpath=$(swww query)

if [ -z "$imgpath" ]; then
    echo "No image path found"
    exit 1
fi

imgpath=${imgpath##* }
wal -i "$imgpath"