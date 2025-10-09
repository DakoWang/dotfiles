#!/bin/bash
evsieve --input "/dev/input/by-path/platform-i8042-serio-0-event-kbd" grab persist=full --hook key:leftmeta key:leftshift key:f23 sequential period=0.032 send-key=key:menu --withhold key:leftmeta key:leftshift key:f23 --output create-link="/dev/input/by-path/platform-i8042-serio-0-event-kbd-evsieve"
