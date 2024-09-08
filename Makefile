BUILD_DIR = ../build
BOARD = esp8266:esp8266:d1_mini

# Serial uploads
UPLOAD_PORT = /dev/ttyUSB0
TARGET_FLAGS += -b $(BOARD)

ESPOTA = $(HOME)/.arduino15/packages/esp8266/hardware/esp8266/3.0.2/tools/espota.py
JARVISDESK = jarvis.local

# Note: can specify another target with
#  make upload JARVISDESK=192.168.1.179

COMPILE_FLAGS = --build-cache-path $(BUILD_DIR) --output-dir $(BUILD_DIR)
COMPILE_FLAGS += $(TARGET_FLAGS) --warnings default

.PHONY: all build upload
all: upload

prepare:
	arduino-cli core install esp8266:esp8266 --config-file ./.cli-config.yml \
	&& arduino-cli lib install "Adafruit IO Arduino"

build:
	arduino-cli compile $(COMPILE_FLAGS) --config-file ./.cli-config.yml .

upload: build
	$(ESPOTA) -i $(JARVISDESK) -p 8266 -f $(BUILD_DIR)/Jarvis.ino.bin

upload-serial: build
	arduino-cli upload --port $(UPLOAD_PORT) $(TARGET_FLAGS) .
