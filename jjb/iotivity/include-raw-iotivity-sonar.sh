#!/bin/bash -eux
set -o pipefail

JENKINS_CPUS=$(grep -c ^processor /proc/cpuinfo)

# Vera++
find . -not -path "./extlibs/*" -type f -name "*.cpp" | vera++ -s -c vera-report.xml

# Cppcheck
cppcheck -j ${JENKINS_CPUS:-2} -v --enable=all --force --xml \
    -I /usr/include \
    -I /usr/include/linux \
    -I /usr/include/c++ \
    -I /usr/include/boost \
    -i service/soft-sensor-manager/SSMCore/src/Common/sqlite3.c \
    -i extlibs . 2> cppcheck-report.xml
