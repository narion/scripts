#!/bin/bash

# file: ttfb.sh
# note: to deploy this, add the following line to your crontab
# * 10-17 * * 1-5 /path/to/monitor-ttfb.sh "https://domain-to-monitor.com" /path/to/log-file.log
# the above cronjob runs every minute from 10AM to 5PM only on weekdays

# Folder structure must be in place prior to use scripts & logs directories in running users /home

function ttfb() {
    curl -o /dev/null \
         -H 'Cache-Control: no-cache' \
         -H 'Accept-Encoding: gzip, deflate, sdch' \
         -H 'Accept-Language: en-US,en;q=0.8' \
         -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36' \
         -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
         --compressed \
         -s \
         -w "%{time_connect} %{time_starttransfer} %{time_total}" \
         $1
}

function clean_url() {
    echo $1 | sed 's~http[s]*://~~g' | sed 's~/$~~g' | sed -e 's/\//-/g'
}

function clean_trailing_slash() {
    echo $1 | sed 's~/$~~g' | sed -e 's/\//-/g'
}

echo $(date "+%Y-%m-%d %H:%M:%S") $1 $(ttfb $1) | tr '\n' ' ' | sed 's/$/\n/g' >> ~/scripts/logs/$(date "+%Y-%m-%d")-$(clean_url $1).log
