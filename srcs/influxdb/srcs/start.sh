#!/bin/sh

telegraf &
influxd run -config /etc/influxdb.conf
