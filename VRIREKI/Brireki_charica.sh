#!/bin/bash
# BL10 Brireki_charica.sh チャリカ利用者数出力
#
#  変更履歴
#  2019/2/2 三井 新規作成
#  2022/4/8 三井 当たるんですをJS→ATへ
#  2023/11/13 越田 オート一日2回開催に向けた対応(ディレクトリ分割)

# 変数初期化
VRIREKI_DIR=VRIREKI2

# 前日日付を取得
if [ x$DNAME = x ]; then
  DNAME=`date -d '1 day ago' "+%Y%m%d"`
fi

echo `date` " BL10 チャリカ利用者数集計を実施します"

# 集計用フォルダ作成
cd ${HOME}/${VRIREKI_DIR}/${DNAME}
mkdir -p rireki/AT rireki/JS rireki/TJ
# cp -p rireki_*.csv rireki
# cd rireki
# mkdir AT JS TJ

# mv rireki_${DNAME}_0[23456]_0_1_0.csv AT
# mv rireki_${DNAME}_0[23456]_1_*.csv AT
# mv rireki_${DNAME}_*_0_1_0.csv TJ
# mv rireki_${DNAME}_*.csv JS
cp auto/rireki*.csv rireki/AT
cp keirin/rireki*_0_1_0.csv rireki/TJ
# cpコマンドだと特定のファイルを除く処理が出来ないためrsyncコマンドでコピーする
rsync -av --exclude 'rireki_*_0_1_0.csv' ./keirin/ ./rireki/JS/ > /dev/null

# 集計オート=ここから
cd rireki/AT

for file in `\find . -maxdepth 1 -type f`; do
  nkf -S -w $file > ${file}_U
  grep -e ^${DNAME} ${file}_U > ${file}_CU
  awk -F "," {'print $2'} ${file}_CU > ${file}_sort_CU
  BOTELT=$(sort -n ${file}_sort_CU | uniq | wc -l)
  echo "${file},$BOTELT" >> ${DNAME}_UOUT.csv
  cat ${file}_sort_CU >> PUSER.txt
done

rm -f *.csv*U
sort -n ${DNAME}_UOUT.csv | uniq > ${DNAME}_SUOUT.csv
sort -n PUSER.txt | uniq > CAUSER.txt

CLAUTO=$(cat CAUSER.txt |grep ^002 |wc -l)
cd ..
# 集計オート=ここまで

# 集計重勝=ここから
cd JS

for file in `\find . -maxdepth 1 -type f`; do
  nkf -S -w $file > ${file}_U
  grep -e ^${DNAME} ${file}_U > ${file}_CU
  awk -F "," {'print $2'} ${file}_CU > ${file}_sort_CU
  BOTELT=$(sort -n ${file}_sort_CU | uniq | wc -l)
  echo "${file},$BOTELT" >> ${DNAME}_UOUT.csv
  cat ${file}_sort_CU >> PUSER.txt
done

rm -f *.csv*U
sort -n ${DNAME}_UOUT.csv | uniq > ${DNAME}_SUOUT.csv
sort -n PUSER.txt | uniq > CJUSER.txt

CLJUSO=$(cat CJUSER.txt |grep ^002 |wc -l)
cd ..
# 集計重勝=ここまで

# 集計通常=ここから
cd TJ

for file in `\find . -maxdepth 1 -type f`; do
  nkf -S -w $file > ${file}_U
  grep -e ^${DNAME} ${file}_U > ${file}_CU
  awk -F "," {'print $2'} ${file}_CU > ${file}_sort_CU
  BOTELT=$(sort -n ${file}_sort_CU | uniq | wc -l)
  echo "${file},$BOTELT" >> ${DNAME}_UOUT.csv
  cat ${file}_sort_CU >> PUSER.txt
done

rm -f *.csv*U
sort -n ${DNAME}_UOUT.csv | uniq > ${DNAME}_SUOUT.csv
sort -n PUSER.txt | uniq > CTUSER.txt

CLTUJO=$(cat CTUSER.txt |grep ^002 |wc -l)

cd ..
# 集計通常=ここまで

# 集計トータル=ここから
cp -p AT/CAUSER.txt .
cp -p JS/CJUSER.txt .
cp -p TJ/CTUSER.txt .
cat CAUSER.txt CJUSER.txt CTUSER.txt > CUSERALL.txt
sort -n CUSERALL.txt | uniq > CUSERALL_U.txt
CLALL=$(cat CUSERALL_U.txt |grep ^002 |wc -l)
# 集計トータル=ここまで

## 石原さん要望 2020/2/14
CTAU=$(cat CTUSER.txt |wc -l)
echo "TUJOAU,$CTAU" > ${DNAME}_CTAU.csv
## 石原さん要望 2020/2/14 ここまで

# 処理結果CSV出力
echo "AUTO,$CLAUTO" > ${DNAME}_CLC.csv
echo "JUSO,$CLJUSO" >> ${DNAME}_CLC.csv
echo "TUJO,$CLTUJO" >> ${DNAME}_CLC.csv
echo "ALL,$CLALL" >> ${DNAME}_CLC.csv

echo `date` " BL10 チャリカ利用者数集計を実施しました"
