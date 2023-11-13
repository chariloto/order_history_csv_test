#!/bin/bash
# BL7 tohyojidou.sh
# 大内さんのtokyojidou.exeのkovs-svr移植版
# morimoto@biz.chariloto.com

# ~kovs でも ~kovsstg でも同一スクリプトで動かしてok

# race conditionを防ぐため、プログラム名のsubdirを掘って、その中で作業する
BASEDIR=tohyojidou
mkdir -p $BASEDIR
cd $BASEDIR

YESTERDAY_YYYYMMDD=`date --date=yesterday +%Y%m%d`

echo Starting BL7 tohyojidou.sh at `date`
echo Getting /s3-data/chariloto-prd-private/uploads/order_history_csv from s3...

rclone copy astrea-s3:/s3-data/chariloto-prd-private/uploads/order_history_csv/$YESTERDAY_YYYYMMDD $YESTERDAY_YYYYMMDD
cp -r $YESTERDAY_YYYYMMDD $HOME/VRIREKI/

( cd $HOME/VRIREKI ; ./RIREKI.sh )

# EOF
