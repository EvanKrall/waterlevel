waterlevel-00A0.dtbo: waterlevel.dts
	dtc -O dtb -o $@ -b 0 -@ $<
