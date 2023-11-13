#!/bin/bash
#########################################
# BL19 PLZVOTE/PLZSLS.sh
#  2020/6/23  plaza会員区分、発売区分毎のUU数と売上(04会員除く)
#  2020/9/3　当たるんです対応（オートに含む）

echo Starting BL19 PLZVOTE/PLZSLS.sh at `date`
set -x
LOGFILE='timecount.txt'

# 振り分けコマンドサンプル
# mv rireki_YYYYMM*_0[23456]_0_1_0.csv ./AUTO
# mv rireki_YYYYMM*_0[23456]_0_1_0.csv ./AUTO
# mv rireki_YYYYMM*_0_1_0.csv ./TUJO
# mv rireki_YYYYMM*.csv ./JUSO

# 14日前のファイルを消す（問答無用）
RNAME=`date -d '14 day ago' "+%Y%m%d"`
rm -rf $RNAME ${RNAME}_sel_user.csv

# フォルダ初期化
rm -rf AUTO TUJO JUSO 
mkdir AUTO TUJO JUSO
rm -rf *_VOTE_ALL.csv 

if [ x$TODAY = x ]; then
  TODAY=$(date +%Y%m%d)
fi

# 前日日付を取得
DNAME=$(date -d "$TODAY 1 day ago" +%Y%m%d)

# 投票履歴回収
cp -p ${HOME}/VRIREKI/$DNAME/rireki_*.csv ${HOME}/PLZVOTE

###########################################################
# オート振り分け
mv rireki_$DNAME*_0[23456]_0_1_0.csv AUTO
# 当たるんです振り分け
mv rireki_$DNAME*_0[23456]_*_4.csv AUTO
# 通常振り分け
mv rireki_$DNAME*_0_1_0.csv TUJO
# 重勝振り分け
mv rireki_$DNAME*.csv JUSO

###########################################################
# 会員・売上集計 ##
#### オート分 ####

# デバッグ用
date >> ${LOGFILE}
echo 'AUTO処理を開始します' >> ${LOGFILE}
cd AUTO

# 投票履歴結合（単純）
cat rireki*_0_1_0.csv > AUTO.csv

# 各会員分解
# PLAZA
awk -F, '{if($2 >= 100000000 && $2 <= 399999999) print}' AUTO.csv > PLAULIST.csv
awk -F, '{if($2 >= 500000000 && $2 <= 9999999999) print}' AUTO.csv >> PLAULIST.csv

# 売上金額算出
# 購入合計値計算
PAALL=$(awk -F, '{sum+=$10} END{print sum}' PLAULIST.csv)
# 返還合計値計算
PABACK=$(awk -F, '{sum+=$12} END{print sum}' PLAULIST.csv)
# 購入-返還計算
PASel=`expr $PAALL - $PABACK`

# 各UU数算出
PAUser=$(awk -F "," {'print $2'} PLAULIST.csv | sort -n | uniq | wc -l )

cd ..
echo '処理を終了しました' >> ${LOGFILE}


#### 通常分 ####

date >> ${LOGFILE}
echo 'TUJO処理を開始します' >> ${LOGFILE}
cd TUJO

# 投票履歴結合（単純）
cat rireki*_0_1_0.csv > TUJO.csv

# 各会員分解
# PLAZA
awk -F, '{if($2 >= 100000000 && $2 <= 399999999) print}' TUJO.csv > PLTJLIST.csv
awk -F, '{if($2 >= 500000000 && $2 <= 9999999999) print}' TUJO.csv >> PLTJLIST.csv

# 売上金額算出
# 購入合計値計算
PTALL=$(awk -F, '{sum+=$10} END{print sum}' PLTJLIST.csv )
# 返還合計値計算
PTBACK=$(awk -F, '{sum+=$12} END{print sum}' PLTJLIST.csv )
# 購入-返還計算
PTSel=`expr $PTALL - $PTBACK`
# 各UU数算出
PTUser=$(awk -F "," {'print $2'} PLTJLIST.csv | sort -n | uniq | wc -l )
cd ..
echo '処理を終了しました' >> ${LOGFILE}

#### 重勝分 ####
date >> ${LOGFILE}
echo 'JUSO処理を開始します' >> ${LOGFILE}
cd JUSO

# 投票履歴結合（単純）
cat rireki*.csv > JUSO.csv

# 各会員分解
# PLAZA
awk -F, '{if($2 >= 100000000 && $2 <= 399999999) print}' JUSO.csv > PLJSLIST.csv
awk -F, '{if($2 >= 500000000 && $2 <= 9999999999) print}' JUSO.csv >> PLJSLIST.csv

# 売上金額算出
# 購入合計値計算
PJALL=$(awk -F, '{sum+=$11} END{print sum}' PLJSLIST.csv )
# 返還合計値計算
PJBACK=$(awk -F, '{sum+=$13} END{print sum}' PLJSLIST.csv )
# 購入-返還計算
PJSel=`expr $PJALL - $PJBACK`
# 各UU数算出
PJUser=$(awk -F "," {'print $2'} PLJSLIST.csv | sort -n | uniq | wc -l )
cd ..
echo '処理を終了しました' >> ${LOGFILE}

# ファイル出力
# PLAZA
echo $PTUser,$PTSel,$PJUser,$PJSel,$PAUser,$PASel > ${DNAME}_sel_user.csv

# 後処理
mkdir $DNAME
mv AUTO JUSO TUJO $DNAME

date >> ${LOGFILE}
echo 'CSV作成処理が完了しました' >> ${LOGFILE}
echo '======================================' >> ${LOGFILE}

echo Finished BL19 PLZVOTE/PLZSLS.sh at `date`
