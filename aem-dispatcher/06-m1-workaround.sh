#!/bin/sh

if ! grep -q "GenuineIntel" /proc/cpuinfo; then
    echo "Detected M1 host"
    if [[ -f /etc/httpd/conf.modules.d/00-qos.conf ]]
    then
      mv /etc/httpd/conf.modules.d/00-qos.conf /etc/httpd/conf.modules.d/00-qos.conf.disabled
      echo "Mutex file:/tmp/mutex" >> /etc/httpd/conf/httpd.conf
      mkdir /tmp/mutex
      echo "Disabling mod_qos and using /tmp/mutex for Mutex locks [M1 workaround]"
    fi
fi