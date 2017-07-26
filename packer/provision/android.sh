#!/bin/bash -eux
set -o pipefail

mkdir -p /extlibs/android/ndk
mkdir -p /extlibs/android/sdk
mkdir -p /extlibs/android/gradle

# Android NDK
#  ln -sv ${IOTIVITYEXTLIB}/android/android-ndk-r10d.bin ${WORKSPACE}/extlibs/android/ndk/android-ndk-r10d
cd /extlibs/android/ndk
wget -nv http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin \
&& chmod +x android-ndk-r10d-linux-x86_64.bin \
&& ./android-ndk-r10d-linux-x86_64.bin \
&& rm android-ndk-r10d-linux-x86_64.bin

# Android SDK Platform & Build Tools links taken from:
# https://dl.google.com/android/repository/repository-11.xml
# The repository monotonically increases. In the future it may be 12,
# 13, ect. for newer versions

# Android SDK
cd /extlibs/android/sdk
wget -nv http://dl.google.com/android/android-sdk_r24.2-linux.tgz \
&& tar zxvf android-sdk_r24.2-linux.tgz \
&& mv android-sdk-linux android-sdk_r24.2 \
&& rm android-sdk_r24.2-linux.tgz

cd /extlibs/android/sdk/android-sdk_r24.2/

# Android 5.0.1 Platform
wget -nv http://dl.google.com/android/repository/android-21_r02.zip \
&& unzip android-21_r02.zip -d platforms \
&& mv platforms/android-5.0.1 platforms/android-21

# Android SDK Build Tools
mkdir build-tools
wget -nv https://dl.google.com/android/repository/build-tools_r20-linux.zip \
&& unzip build-tools_r20-linux.zip -d build-tools/ \
&& mv build-tools/android-4.4W build-tools/20.0.0

# Gradle
cd /extlibs/android/gradle
wget -nv https://services.gradle.org/distributions/gradle-2.2.1-all.zip \
&& unzip gradle-2.2.1-all.zip \
&& rm gradle-2.2.1-all.zip
