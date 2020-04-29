#!/usr/bin/env bash
set -e

# Arch Linux Install Script (alis) installs unattended, automated
# and customized Arch Linux system.
# Copyright (C) 2018 picodotdev

rm -f archdeploy.conf
rm -f archdeploy.sh

wget https://raw.githubusercontent.com/picodotdev/alis/master/archdeploy.conf
wget https://raw.githubusercontent.com/picodotdev/alis/master/archdeploy.sh

chmod +x archdeploy.sh
