#!/bin/bash

SAVEIF=$IFS
IFS=$(echo -en "\n\b")

for file in $(ls *wav)
do
  	name=${file%%.wav}
	ffmpeg -i "${name}.wav" -vn -ar 44100 -ac 1 -ab 64k -f mp3 "${name}_podcast.mp3"
done


IFS=$SAVEIFS

