#!/bin/bash

# Colors
COLOR_GOOD='#88b090'
COLOR_DEGRADED='#ccdc90'
COLOR_BAD='#e89393'

get_load() {
    uptime | awk -F'load average:' '{ print "Load: " $2 }' | awk '{ print $1, $2, $3 }'
}

get_wifi() {
    iface=$(iw dev | awk '$1=="Interface"{print $2}' | head -n1)
    if [[ -n "$iface" ]]; then
        essid=$(iw dev "$iface" link | grep SSID | cut -d' ' -f2-)
        quality=$(awk '/^\s*w/ { print int($3 * 100 / 70) "%"}' /proc/net/wireless)
        echo " $quality » $essid"
    else
        echo ""
    fi
}

get_eth() {
    iface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^en' | head -n1)
    ipaddr=$(ip -4 addr show "$iface" 2>/dev/null | grep inet | awk '{print $2}' | cut -d/ -f1)
    if [[ -n "$ipaddr" ]]; then
        echo "🔌 $ipaddr"
    else
        echo ""
    fi
}

get_volume() {
    if amixer sget Master | grep -q '\[off\]'; then
        amixer sget Master | grep -oP '\[\d+%\]' | head -1 | sed 's/\[//;s/\]/ /' | awk '{print "♪: muted (" $1 ")"}'
    else
        amixer sget Master | grep -oP '\[\d+%\]' | head -1 | sed 's/\[//;s/\]/ /' | awk '{print "♪: " $1}'
    fi
}

get_weather() {
    [[ -f ~/.weather.cache ]] && cat ~/.weather.cache || echo "No weather info"
}

get_time() {
    date +"  %d.%m %H:%M"
}

echo "[$(get_weather)] | $(get_load) | $(get_wifi) | $(get_eth) | $(get_volume) | $(get_time)"

