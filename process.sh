#!/bin/bash

cat vid.txt | grep 'N_m3u8DL-RE "https://iframe' | grep video.drm | grep -oP 'header "Referer: \K[^"]+' | sort -u | cut -d'?' -f1 | sort -u > to_extract.txt

for i in $(cat to_extract.txt); do
    echo "Processing URL: $i"
    while true; do
        timeout 200 python3 b-cdn-drm-vod-dl.py -eu "$i" -r "$i"
        if [ $? -eq 0 ]; then
            echo "Successfully processed: $i"
            break
        else
            echo "Failed to process $i. Retrying..."
            sleep 5
        fi
        rm -rf /home/user/Videos/Bunny\ CDN/.[!.]*
    done
done
