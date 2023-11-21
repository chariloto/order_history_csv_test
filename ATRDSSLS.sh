#!/bin/bash
#########################################
# BL17 ATRDS/ATRDSSLS.sh
# 2020/1/28       各会員区分、発売区分毎のUU数と売上
# 2023/11/13 越田 オート一日2回開催に向けた対応(ディレクトリ分割)
########################################

echo Starting BL17 ATRDS/ATRDSSLS.sh at `date`
set -x

# 変数初期化
ATRDS_DIR=ATRDS2
BNKSALES_DIR=BNKSALES2
VRIREKI_DIR=VRIREKI2
LOGFILE='timecount.txt'

# 振り分けコマンドサンプル
# mv rireki_YYYYMM*_0[23456]_0_1_0.csv ./AUTO
# mv rireki_YYYYMM*_0_1_0.csv ./TUJO
# mv rireki_YYYYMM*.csv ./JUSO

if [ x$TODAY = x ]; then
  TODAY=$(date +%Y%m%d)
fi

# 前日日付を取得
DNAME=$(date -d "$TODAY 1 day ago" +%Y%m%d)

# フォルダ初期化
rm -rf ${DNAME}
mkdir -p ${DNAME}/AUTO

# 投票履歴回収(当たるんです)
cp -p ${HOME}/${VRIREKI_DIR}/${DNAME}/auto/rireki_*_*_*_4.csv ${HOME}/${ATRDS_DIR}/${DNAME}/AUTO


# 会員・売上集計 ##
#### オート分 ####

date >> ${LOGFILE}
echo 'AUTO処理を開始します' >> ${LOGFILE}


cd ${DNAME}/AUTO

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

cd ${HOME}/${ATRDS_DIR}
echo '処理を終了しました' >> ${LOGFILE}


# あたるんです
echo $ATUser,$ATSel > ${DNAME}_ATsel_user.csv

# リモート対応
cp -p ${DNAME}_ATsel_user.csv ${HOME}/${BNKSALES_DIR}

# 
date >> ${LOGFILE}
echo 'CSV作成処理が完了しました' >> ${LOGFILE}
echo '======================================' >> ${LOGFILE}

echo Finished BL17 ATRDS/ATRDSSLS.sh at `date`
