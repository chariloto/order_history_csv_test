#!/bin/bash
# BL27 upload_plzbnk.sh
# /home/kovs/PLZVOTE, /home/kovs/BNKSALESの同期
# morimoto@biz.chariloto.com
#  2023/11/13 越田 オート一日2回開催に向けた対応(ディレクトリ分割)

echo Starting BL27 upload_plzbnk.sh at `date`
BNKSALES_DIR=BNKSALES2

(
	cd $HOME/$BNKSALES_DIR
	./expire 90
	rclone -v sync --exclude-from rclone-exclude-list $HOME/$BNKSALES_DIR chari-filemaster-gd224:/kovs/$BNKSALES_DIR
)

sleep 60

echo Finished BL27 upload_plzbnk.sh at `date`

# eof
