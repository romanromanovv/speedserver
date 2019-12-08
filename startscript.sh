#!/bin/bash

./OoklaServer start | /usr/sbin/apache2ctl -D FOREGROUND
