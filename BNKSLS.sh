#!/bin/bash
# BL16 BNKSLS.sh
# 2020/1/28  各会員区分、発売区分毎のUU数と売上

echo Started BL16 BNKSALES/BNKSLS.sh at `date`
set -x

LOGFILE=timecount.txt

# 振り分けコマンドサンプル
# mv rireki_YYYYMM*_0[23456]_0_1_0.csv AUTO
# mv rireki_YYYYMM*_0_1_0.csv TUJO
# mv rireki_YYYYMM*.csv JUSO

# フォルダ初期化
rm -rf AUTO TUJO JUSO ATRD
mkdir AUTO TUJO JUSO ATRD
rm -rf *_VOTE_ALL.csv

if [ x$TODAY = x ]; then
  TODAY=$(date +%Y%m%d)
fi
# 前日日付を取得
DNAME=$(date -d "$TODAY 1 day ago" +%Y%m%d)

# 投票履歴回収
cp -p ${HOME}/VRIREKI/$DNAME/rireki_*.csv ${HOME}/BNKSALES


###########################################################

# オート振り分け
mv rireki_$DNAME*_0[23456]_0_1_0.csv AUTO
# オート振り分け(当たるんです)
mv rireki_$DNAME*_0[23456]_*_4.csv ATRD
# 通常振り分け
mv rireki_$DNAME*_0_1_0.csv TUJO
# 重勝振り分け
mv rireki_$DNAME*.csv JUSO

###########################################################


## 会員・売上集計 ##
#### オート分 ####

date >> ${LOGFILE}
echo 'AUTO処理を開始します' >> ${LOGFILE}

cd AUTO

# 投票履歴結合（単純）
cat rireki*_0_1_0.csv > AUTO.csv

# 各会員分解
# 楽天
awk -F, '{if($2 <= 9999999) print}' AUTO.csv > RKAULIST.csv

# JNB
awk -F, '{if($2 >= 10000000 && $2 <= 19999999) print}' AUTO.csv > JNAULIST.csv

# チャリカ
awk -F, '{if($2 >= 20000000 && $2 <= 99999999) print}' AUTO.csv > CLAULIST.csv

# 04会員
awk -F, '{if($2 >= 400000000 && $2 <= 500000000) print}' AUTO.csv > 04AULIST.csv

##売上金額算出
# 購入合計値計算
RAALL=$(awk -F, '{sum+=$10} END{print sum}' RKAULIST.csv)
JAALL=$(awk -F, '{sum+=$10} END{print sum}' JNAULIST.csv)
CAALL=$(awk -F, '{sum+=$10} END{print sum}' CLAULIST.csv)
FAALL=$(awk -F, '{sum+=$10} END{print sum}' 04AULIST.csv)

# 返還合計値計算
RABACK=$(awk -F, '{sum+=$12} END{print sum}' RKAULIST.csv)
JABACK=$(awk -F, '{sum+=$12} END{print sum}' JNAULIST.csv)
CABACK=$(awk -F, '{sum+=$12} END{print sum}' CLAULIST.csv)
FABACK=$(awk -F, '{sum+=$12} END{print sum}' 04AULIST.csv)

# 購入-返還計算
RASel=`expr $RAALL - $RABACK`
JASel=`expr $JAALL - $JABACK`
CASel=`expr $CAALL - $CABACK`
FASel=`expr $FAALL - $FABACK`

# 各UU数算出
RAUser=$(awk -F "," {'print $2'} RKAULIST.csv |sort -n | uniq |wc -l)
JAUser=$(awk -F "," {'print $2'} JNAULIST.csv |sort -n | uniq |wc -l)
CAUser=$(awk -F "," {'print $2'} CLAULIST.csv |sort -n | uniq |wc -l)
FAUser=$(awk -F "," {'print $2'} 04AULIST.csv |sort -n | uniq |wc -l)

#フォルダ戻り
cd ..
echo '処理を終了しました' >> ${LOGFILE}


#### 通常分 ####

date >> ${LOGFILE}
echo 'TUJO処理を開始します' >> ${LOGFILE}
cd TUJO

# 投票履歴結合（単純）
cat rireki*_0_1_0.csv > TUJO.csv

# 各会員分解
# 楽天
awk -F, '{if($2 <= 9999999) print}' TUJO.csv > RKTJLIST.csv

# JNB
awk -F, '{if($2 >= 10000000 && $2 <= 19999999) print}' TUJO.csv > JNTJLIST.csv

# チャリカ
awk -F, '{if($2 >= 20000000 && $2 <= 99999999) print}' TUJO.csv > CLTJLIST.csv

# 04会員
awk -F, '{if($2 >= 400000000 && $2 <= 500000000) print}' TUJO.csv > 04TJLIST.csv

# 売上金額算出
# 購入合計値計算
RTALL=$(awk -F, '{sum+=$10} END{print sum}' RKTJLIST.csv)
JTALL=$(awk -F, '{sum+=$10} END{print sum}' JNTJLIST.csv)
CTALL=$(awk -F, '{sum+=$10} END{print sum}' CLTJLIST.csv)
FTALL=$(awk -F, '{sum+=$10} END{print sum}' 04TJLIST.csv)

# 返還合計値計算
RTBACK=$(awk -F, '{sum+=$12} END{print sum}' RKTJLIST.csv)
JTBACK=$(awk -F, '{sum+=$12} END{print sum}' JNTJLIST.csv)
CTBACK=$(awk -F, '{sum+=$12} END{print sum}' CLTJLIST.csv)
FTBACK=$(awk -F, '{sum+=$12} END{print sum}' 04TJLIST.csv)

# 購入-返還計算
RTSel=`expr $RTALL - $RTBACK`
JTSel=`expr $JTALL - $JTBACK`
CTSel=`expr $CTALL - $CTBACK`
FTSel=`expr $FTALL - $FTBACK`

# 各UU数算出
RTUser=$(awk -F "," {'print $2'} RKTJLIST.csv |sort -n | uniq |wc -l)
JTUser=$(awk -F "," {'print $2'} JNTJLIST.csv |sort -n | uniq |wc -l)
CTUser=$(awk -F "," {'print $2'} CLTJLIST.csv |sort -n | uniq |wc -l)
FTUser=$(awk -F "," {'print $2'} 04TJLIST.csv |sort -n | uniq |wc -l)

cd ..
echo '処理を終了しました' >> ${LOGFILE}

#### 重勝分 ####

date >> ${LOGFILE}
echo 'JUSO処理を開始します' >> ${LOGFILE}

cd JUSO

# 投票履歴結合（単純）
cat rireki*.csv > JUSO.csv

# 各会員分解
# 楽天
awk -F, '{if($2 <= 9999999) print}' JUSO.csv > RKJSLIST.csv

# JNB
awk -F, '{if($2 >= 10000000 && $2 <= 19999999) print}' JUSO.csv > JNJSLIST.csv

# チャリカ
awk -F, '{if($2 >= 20000000 && $2 <= 99999999) print}' JUSO.csv > CLJSLIST.csv

# 04会員
awk -F, '{if($2 >= 400000000 && $2 <= 500000000) print}' JUSO.csv > 04JSLIST.csv


# 売上金額算出
# 購入合計値計算
RJALL=$(awk -F, '{sum+=$11} END{print sum}' RKJSLIST.csv)
JJALL=$(awk -F, '{sum+=$11} END{print sum}' JNJSLIST.csv)
CJALL=$(awk -F, '{sum+=$11} END{print sum}' CLJSLIST.csv)
FJALL=$(awk -F, '{sum+=$11} END{print sum}' 04JSLIST.csv)

# 返還合計値計算
RJBACK=$(awk -F, '{sum+=$13} END{print sum}' RKJSLIST.csv)
JJBACK=$(awk -F, '{sum+=$13} END{print sum}' JNJSLIST.csv)
CJBACK=$(awk -F, '{sum+=$13} END{print sum}' CLJSLIST.csv)
FJBACK=$(awk -F, '{sum+=$13} END{print sum}' 04JSLIST.csv)

# 購入-返還計算
RJSel=`expr $RJALL - $RJBACK`
JJSel=`expr $JJALL - $JJBACK`
CJSel=`expr $CJALL - $CJBACK`
FJSel=`expr $FJALL - $FJBACK`

# 各UU数算出
RJUser=$(awk -F "," {'print $2'} RKJSLIST.csv |sort -n | uniq |wc -l)
JJUser=$(awk -F "," {'print $2'} JNJSLIST.csv |sort -n | uniq |wc -l)
CJUser=$(awk -F "," {'print $2'} CLJSLIST.csv |sort -n | uniq |wc -l)
FJUser=$(awk -F "," {'print $2'} 04JSLIST.csv |sort -n | uniq |wc -l)

cd ..
echo '処理を終了しました' >> ${LOGFILE}


#### 当たるんです分 ####

date >> ${LOGFILE}
echo 'ATRD処理を開始します' >> ${LOGFILE}
cd ATRD

# 投票履歴結合（単純）
cat rireki*.csv > ATRD.csv

# 各会員分解
# 楽天
awk -F, '{if($2 <= 9999999) print}' ATRD.csv > RKATLIST.csv

# JNB
awk -F, '{if($2 >= 10000000 && $2 <= 19999999) print}' ATRD.csv > JNATLIST.csv

# チャリカ
awk -F, '{if($2 >= 20000000 && $2 <= 99999999) print}' ATRD.csv > CLATLIST.csv

# 04会員
awk -F, '{if($2 >= 400000000 && $2 <= 500000000) print}' ATRD.csv > 04ATLIST.csv


# 売上金額算出
# 購入合計値計算
RRALL=$(awk -F, '{sum+=$10} END{print sum}' RKATLIST.csv)
JRALL=$(awk -F, '{sum+=$10} END{print sum}' JNATLIST.csv)
CRALL=$(awk -F, '{sum+=$10} END{print sum}' CLATLIST.csv)
FRALL=$(awk -F, '{sum+=$10} END{print sum}' 04ATLIST.csv)

# 返還合計値計算
RRBACK=$(awk -F, '{sum+=$12} END{print sum}' RKATLIST.csv)
JRBACK=$(awk -F, '{sum+=$12} END{print sum}' JNATLIST.csv)
CRBACK=$(awk -F, '{sum+=$12} END{print sum}' CLATLIST.csv)
FRBACK=$(awk -F, '{sum+=$12} END{print sum}' 04ATLIST.csv)

# 購入-返還計算
RRSel=`expr $RRALL - $RRBACK`
JRSel=`expr $JRALL - $JRBACK`
CRSel=`expr $CRALL - $CRBACK`
FRSel=`expr $FRALL - $FRBACK`

# 各UU数算出
RRUser=$(awk -F "," {'print $2'} RKATLIST.csv |sort -n | uniq |wc -l)
JRUser=$(awk -F "," {'print $2'} JNATLIST.csv |sort -n | uniq |wc -l)
CRUser=$(awk -F "," {'print $2'} CLATLIST.csv |sort -n | uniq |wc -l)
FRUser=$(awk -F "," {'print $2'} 04ATLIST.csv |sort -n | uniq |wc -l)

cd ..
echo '処理を終了しました' >> ${LOGFILE}

# ファイル出力
# チャリカ
echo $CTUser,$CTSel,$CJUser,$CJSel,$CAUser,$CASel,$CRUser,$CRSel > ${DNAME}_sel_user.csv

# 楽天
echo $RTUser,$RTSel,$RJUser,$RJSel,$RAUser,$RASel,$RRUser,$RRSel >> ${DNAME}_sel_user.csv

# JNB
echo $JTUser,$JTSel,$JJUser,$JJSel,$JAUser,$JASel,$JRUser,$JRSel >> ${DNAME}_sel_user.csv

# 04
echo $FTUser,$FTSel,$FJUser,$FJSel,$FAUser,$FASel,$FRUser,$FRSel >> ${DNAME}_sel_user.csv

# 後処理
mkdir $DNAME
mv AUTO JUSO TUJO ATRD $DNAME

date >> ${LOGFILE}
echo 'CSV作成処理が完了しました' >> ${LOGFILE}
echo '======================================' >> ${LOGFILE}

echo Finished BL16 BNKSALES/BNKSLS.sh at `date`

exit
