# Change this according to your device
################
# Variables
################

# Keyboard input name
keyboard_input_name="49396:1269:Usb_KeyBoard_Usb_KeyBoard"

# Date and time
date_and_week=$(date "+%Y/%m/%d (w%-V)")
current_time=$(date "+%H:%M")

#############
# Commands
#############

# Battery or charger
# battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
# battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
ping=$(ping -c 1 www.google.es | tail -1 | awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)

# Others
language=$(swaymsg -r -t get_inputs | awk '/49396:1269:Usb_KeyBoard_Usb_KeyBoard/;/xkb_active_layout_name/' | grep -A1 '\b49396:1269:Usb_KeyBoard_Usb_KeyBoard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')
loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')

# Removed weather because we are requesting it too many times to have a proper
# refresh on the bar
#weather=$(curl -Ss 'https://wttr.in/Pontevedra?0&T&Q&format=1')

# if [ $battery_status = "discharging" ]; then
#   battery_pluggedin='⚠'
# else
#   battery_pluggedin='⚡'
# fi

if ! [ $network ]; then
  network_active="⛔"
else
  network_active="⇆"
fi

if [ $audio_is_muted = "true" ]; then
  audio_active='🔇'
else
  audio_active='🔊'
fi

echo "⌨ $language | $network_active $interface_easyname ($ping ms) | 🔥 $loadavg_5min | $date_and_week $current_time"
