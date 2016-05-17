#!/bin/bash
method="upgrade"

c() {
    read input
    dpkg -l ${input} | grep " ${input} " | awk '{$1=$2=$3=$4="";print $0}' | sed 's/^ *//'
    unset input
}

a() {
    apt-get --just-print $method 2>&1 | perl -ne 'if (/Inst\s([\w,\-,\d,\.,~,:,\+]+)\s\[([\w,\-,\d,\.,~,:,\+]+)\]\s\(([\w,\-,\d,\.,~,:,\+]+)\)? /i) {print "$1 (\e[1;34m$2\e[0m -> \e[1;32m$3\e[0m)\n"}'
}

apt-get update
echo
a | while read -r line; do echo -en "$line $(echo $line | awk '{print $1}' | c )\n"; done
echo
apt-get $method

# vim: sw=4 et
