#!/bin/bash
# BL7 tohyojidou.sh
# 大内さんのtokyojidou.exeのkovs-svr移植版
# morimoto@biz.chariloto.com

# ~kovs でも ~kovsstg でも同一スクリプトで動かしてok

# race conditionを防ぐため、プログラム名のsubdirを掘って、その中で作業する
VRIREKI_DIR=VRIREKI2
tohyojidou_DIR=tohyojidou2
BASEDIR=tohyojidou
mkdir -p $BASEDIR
cd $BASEDIR

YESTERDAY_YYYYMMDD=`date --date=yesterday +%Y%m%d`

echo Starting BL7 tohyojidou.sh at `date`
echo Getting /s3-data/chariloto-prd-private/uploads/order_history_csv from s3...

# 本番仕様(一時的にコメントアウト)
# rclone copy astrea-s3:/s3-data/chariloto-prd-private/uploads/order_history_csv/keirin/$YESTERDAY_YYYYMMDD $YESTERDAY_YYYYMMDD
# rclone copy astrea-s3:/s3-data/chariloto-prd-private/uploads/order_history_csv/auto/$YESTERDAY_YYYYMMDD $YESTERDAY_YYYYMMDD
# cp -r keirin/$YESTERDAY_YYYYMMDD $HOME/$VRIREKI_DIR/$YESTERDAY_YYYYMMDD/keirin
# cp -r auto/$YESTERDAY_YYYYMMDD $HOME/$VRIREKI_DIR/$YESTERDAY_YYYYMMDD/auto

rclone copy astrea-s3:/s3-data/chariloto-prd-private/uploads/order_history_csv/$YESTERDAY_YYYYMMDD $YESTERDAY_YYYYMMDD
mkdir $YESTERDAY_YYYYMMDD/auto $YESTERDAY_YYYYMMDD/keirin
#振り分け
mv $YESTERDAY_YYYYMMDD/rireki_$DNAME*_0[23456]_0_1_0.csv $YESTERDAY_YYYYMMDD/auto
mv $YESTERDAY_YYYYMMDD/rireki_$DNAME*_0[23456]_*_4.csv $YESTERDAY_YYYYMMDD/auto
mv $YESTERDAY_YYYYMMDD/rireki_$DNAME*_0_1_0.csv $YESTERDAY_YYYYMMDD/keirin
mv $YESTERDAY_YYYYMMDD/rireki_$DNAME*.csv $YESTERDAY_YYYYMMDD/keirin

cp -r $YESTERDAY_YYYYMMDD $HOME/$VRIREKI_DIR/


( cd $HOME/$VRIREKI_DIR ; ./RIREKI.sh )

# EOF
