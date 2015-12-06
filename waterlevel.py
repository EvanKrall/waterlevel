#!/usr/bin/env python

import Adafruit_BBIO.GPIO as GPIO

PINS = ['P8_%d' % n for n in range(7, 17)]


def main():
    # Start out with each pin shorting to ground
    for pin in PINS:
        GPIO.setup(pin, GPIO.OUT)
        GPIO.output(pin, GPIO.LOW)

    # now check each pin's conductivity to ground
    for pin in PINS:
        GPIO.setup(pin, GPIO.IN)
        highlow = "high" if GPIO.input(pin) else "low"
        print "%s %s" % (pin, highlow)


if __name__ == '__main__':
    main()
