#!/bin/bash
# BL27 upload_plzbnk.sh
# /home/kovs/PLZVOTE, /home/kovs/BNKSALESの同期
# morimoto@biz.chariloto.com

echo Starting BL27 upload_plzbnk.sh at `date`

(
	cd $HOME/BNKSALES 
	./expire 90
	rclone -v sync --exclude-from rclone-exclude-list $HOME/BNKSALES chari-filemaster-gd224:/kovs/BNKSALES
)

sleep 60

echo Finished BL27 upload_plzbnk.sh at `date`

# eof
