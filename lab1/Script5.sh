#!/bin/bash

> info.log

awk '/info:/' /var/log/installer/syslog > info.log
