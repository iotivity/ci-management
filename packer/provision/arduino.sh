#!/bin/bash -ex
set -o pipefail

# Arduino
mkdir -p /extlibs/arduino
cd /extlibs/arduino
wget -nv http://downloads.arduino.cc/arduino-1.5.8-linux64.tgz \
&& tar zxf arduino-1.5.8-linux64.tgz \
&& rm arduino-1.5.8-linux64.tgz

# Arduino Libs
cd /extlibs/arduino/arduino-1.5.8/
wget -nv http://playground.arduino.cc/uploads/Code/Time.zip \
&& unzip Time.zip -d libraries/Time \
&& rm Time.zip
find libraries/Time/Time/DateStrings.cpp -type f -exec dos2unix {} \;

# Arduino RedBearLib
wget -nv https://github.com/RedBearLab/nRF8001/archive/25643e7b1b7da3740406325a471e3faa4b948747.zip \
&& unzip 25643e7b1b7da3740406325a471e3faa4b948747.zip \
&& mv nRF8001-25643e7b1b7da3740406325a471e3faa4b948747/Arduino/libraries/RBL_nRF8001/ libraries/ \
&& rm -r nRF8001-25643e7b1b7da3740406325a471e3faa4b948747 \
&& rm 25643e7b1b7da3740406325a471e3faa4b948747.zip
find libraries/RBL_nRF8001 -type f -exec dos2unix {} \;

# Arduino BLE
wget -nv https://github.com/NordicSemiconductor/ble-sdk-arduino/archive/0.9.5.beta.zip \
&& unzip 0.9.5.beta.zip \
&& mv ble-sdk-arduino-0.9.5.beta/libraries/BLE/ libraries/BLE \
&& rm -r ble-sdk-arduino-0.9.5.beta \
&& rm 0.9.5.beta.zip
find libraries/BLE -type f -exec dos2unix {} \;

# Apply Arduino Patches
PATCH_BASE_URL=https://git.iotivity.org/cgit/iotivity/plain/resource/csdk/connectivity/lib/arduino
curl -sSL ${PATCH_BASE_URL}/arduino_libraries.patch | patch -N -p1 --directory=/extlibs/arduino/arduino-1.5.8
curl -sSL ${PATCH_BASE_URL}/RBL_nRF8001.patch | patch -N -p1 --directory=/extlibs/arduino/arduino-1.5.8/libraries/RBL_nRF8001
curl -sSL ${PATCH_BASE_URL}/arduino_due_ble.patch | patch -N -p1 --directory=/extlibs/arduino/arduino-1.5.8/libraries/BLE
