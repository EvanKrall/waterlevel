#!/bin/bash

set -e

PINS=/sys/kernel/debug/pinctrl/44e10800.pinmux/pins
SLOTS=/sys/devices/platform/bone_capemgr/slots
FIRMWARE_DIR=/lib/firmware
GPIO=/sys/class/gpio

# Uninstall previous copies of the overlay
for layer in $(grep ',waterlevel$' "$SLOTS" | cut -f1 -d:) ; do
	echo -$layer > "$SLOTS"
done

cp waterlevel-00A0.dtbo "$FIRMWARE_DIR"
echo waterlevel > "$SLOTS"

GPIOS=(66 67 69 68 45 44 23 26 47 46)

BOTTOM_PIN=${GPIOS[0]}

for pin in "${GPIOS[@]}"; do
	echo "$pin" > $GPIO/export 2>/dev/null || true
	if [[ $pin == $BOTTOM_PIN ]]; then
		echo "out" > $GPIO/gpio$pin/direction
		echo "0" > $GPIO/gpio$pin/value
	else
		echo "in" > $GPIO/gpio$pin/direction
	fi
done

depth=0

for ((i=1; i<${#GPIOS[@]}; i++)); do
	pin="${GPIOS[i]}"
	echo 0 > $GPIO/gpio$BOTTOM_PIN/value
	value_1=$(< $GPIO/gpio$pin/value)
	echo 1 > $GPIO/gpio$BOTTOM_PIN/value
	value_2=$(< $GPIO/gpio$pin/value)
	echo 0 > $GPIO/gpio$BOTTOM_PIN/value

	if [[ $value_1 == 0 && $value_2 == 1 ]]; then
		depth=$i
	fi
done

echo $depth
