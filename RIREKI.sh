#!/bin/bash

#########################################
#
# 投票履歴 自動採取
#
# 実行例:./RIREKI.sh
#
#  変更履歴
#  2017/10/12   三井 新規作成
#  2018/08/21   三井 一時停止
#  2023/11/13   越田 オート一日2回開催に向けた対応(ディレクトリ分割)
#  git/chariloto/kovs-svr/VRIREKI
#
########################################

# 変数初期化
VRIREKI_DIR=VRIREKI2

##14日前のファイルを消す（問答無用）
RNAME=`date -d '14 day ago' "+%Y%m%d"`

rm -rf $RNAME "$RNAME"_mkrireki.txt

### 前日日付を取得
if [ x$DNAME = x ]; then
  DNAME=`date -d '1 day ago' "+%Y%m%d"`
fi

### 実行開始時刻保存
date > "$DNAME"_mkrireki.txt

##プラザ利用者数出力
DNAME=$DNAME ./BRireki_COUNT.sh >> "$DNAME"_mkrireki.txt

##チャリカ利用者数出力
DNAME=$DNAME ./Brireki_charica.sh >> "$DNAME"_mkrireki.txt

##投票履歴移動
DNAME=$DNAME ./RIREKI_ftp.sh >> "$DNAME"_mkrireki.txt

### 実行終了時刻保存
date >> "$DNAME"_mkrireki.txt

exit
