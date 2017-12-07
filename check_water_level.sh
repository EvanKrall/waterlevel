#!/bin/bash

max_distance=336  # The distance from rangefinder to the bottom of the bowl.
threshold=50  # Depth at which we want to alert.

distance="$(spi_hcsr04 --speed-of-sound 343000)"
depth="$(echo $max_distance - $distance | bc -l)"


echo "water level is $depth mm"

if (( $(echo "$depth < $threshold" | bc -l) )); then
    exit 2
else
    exit 0
fi
