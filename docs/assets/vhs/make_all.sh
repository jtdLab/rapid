#!/bin/bash

############################################################################################
# Run from docs/assets/vhs
# sh make_all.sh
############################################################################################
# Generates fresh GIFS for documentation
############################################################################################

sh make_activate.sh
sh make_begin.sh
sh make_create.sh
sh make_deactivate.sh
sh make_end.sh
sh make_pub_add.sh
sh make_pub_get.sh
sh make_pub_remove.sh
