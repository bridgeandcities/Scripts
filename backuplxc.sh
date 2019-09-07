#!/bin/bash

# ----------------------------------------------------------------------------------
# Script backing up all lxc containers on proxmox, run once a week via cron.
# Stores the snapshot backups to /storage/backuplxc/dump directory. 
# "snapshot" mode keeps the container running while backing up.
# ----------------------------------------------------------------------------------

 vzdump --all --dumpdir /storage/backuplxc/dump --mode snapshot
