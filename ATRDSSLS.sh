#!/bin/bash
#########################################
# BL17 ATRDS/ATRDSSLS.sh
# 2020/1/28  各会員区分、発売区分毎のUU数と売上
########################################

echo Starting BL17 ATRDS/ATRDSSLS.sh at `date`
set -x

LOGFILE='timecount.txt'

# 振り分けコマンドサンプル
# mv rireki_YYYYMM*_0[23456]_0_1_0.csv ./AUTO
# mv rireki_YYYYMM*_0_1_0.csv ./TUJO
# mv rireki_YYYYMM*.csv ./JUSO

# フォルダ初期化
rm -rf AUTO TUJO JUSO 
rm -rf *_VOTE_ALL.csv 

mkdir AUTO

if [ x$TODAY = x ]; then
  TODAY=$(date +%Y%m%d)
fi

# 前日日付を取得
DNAME=$(date -d "$TODAY 1 day ago" +%Y%m%d)

# 投票履歴回収
cp -p ${HOME}/VRIREKI/$DNAME/rireki_*_0[23456]_*_4.csv ${HOME}/ATRDS/

###########################################################
# オート振り分け(当たるんです)
mv rireki_$DNAME*_0[23456]_*_4.csv AUTO

###########################################################

# 会員・売上集計 ##
#### オート分 ####

date >> ${LOGFILE}
echo 'AUTO処理を開始します' >> ${LOGFILE}


cd AUTO

# 投票履歴結合（単純）
cat rireki*_*_4.csv > AUTO.csv

# 売上金額算出
# 購入合計値計算
ATALL=$(awk -F, '{sum+=$10} END{print sum}' AUTO.csv)

# 返還合計値計算
ATBACK=$(awk -F, '{sum+=$12} END{print sum}' AUTO.csv)

# 購入-返還計算
ATSel=`expr $ATALL - $ATBACK`

# 各UU数算出
ATUser=$(awk -F "," {'print $2'} AUTO.csv | sort -n | uniq | wc -l )
# 2020/7/27 ヘッダ行の対応（処理漏れ）追加
ATUser=$(($ATUser - 1))

cd ..
echo '処理を終了しました' >> ${LOGFILE}


# あたるんです
echo $ATUser,$ATSel > ${DNAME}_ATsel_user.csv

# 後処理
mkdir $DNAME
mv AUTO $DNAME

# リモート対応
cp -p ${DNAME}_ATsel_user.csv ${HOME}/BNKSALES

# 
date >> ${LOGFILE}
echo 'CSV作成処理が完了しました' >> ${LOGFILE}
echo '======================================' >> ${LOGFILE}

echo Finished BL17 ATRDS/ATRDSSLS.sh at `date`
