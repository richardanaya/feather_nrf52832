build:
	cargo build --target thumbv7em-none-eabi --release
	cp target/thumbv7em-none-eabi/release/blinky blinky.bin
	adafruit-nrfutil dfu genpkg --dev-type 0x0052 --sd-req 0x00B7 --application blinky.bin blinky.zip
deps:
	# for compiling bare metal to M4-cortex
	rustup target add thumbv7em-none-eabi
	# tools for deploying to feather
	pip3 install --user adafruit-nrfutil
	# bootloader
	wget https://github.com/adafruit/Adafruit_nRF52_Bootloader/releases/download/0.2.13/feather_nrf52832_bootloader-0.2.13_s132_6.1.1.zip
	wget https://github.com/adafruit/Adafruit_nRF52_Bootloader/releases/download/0.2.13/feather_nrf52832_bootloader-0.2.13_s132_6.1.1.hex
deploy:
	adafruit-nrfutil --verbose dfu serial --package blinky.zip -p /dev/ttyUSB0 -b 115200 --singlebank
update-bootloader:
	adafruit-nrfutil --verbose dfu serial --package feather_nrf52832_bootloader-0.2.13_s132_6.1.1.zip -p /dev/ttyUSB0 -b 115200 --singlebank --touch 1200
clean:
	rm blinky.bin
	rm blinky.zip