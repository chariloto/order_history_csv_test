#!/bin/bash
#　BL9 BRireki_COUNT.sh 利用者数出力
#
#  変更履歴
#  2018/8/23 三井 新規作成
#  2023/2/28 鈴木 小松島プラザ追加
#  2023/6/28 三井 名古屋プラザ追加
#  2023/10/17 竹田 四日市プラザ追加

# 前日日付を取得
if [ x$DNAME = x ]; then
  DNAME=`date -d '1 day ago' "+%Y%m%d"`
fi

echo `date` " BL9 利用者数集計を実施します"

if [ `hostname` = 'KOVS-SVR' ]; then
  RCLONE_OPTION='--dry-run'
fi

cd ${HOME}/VRIREKI/$DNAME

rm -f PUSER.txt ${DNAME}_OUT.csv

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
sort -n PUSER.txt | uniq > PUUSER.txt

# 各プラザ利用者カウント
SISHI=$(cat PUUSER.txt |grep ^01 |wc -l)
SYOKO=$(cat PUUSER.txt |grep ^02 |wc -l)
SKOUR=$(cat PUUSER.txt |grep ^06 |wc -l)
SKAWA=$(cat PUUSER.txt |grep ^07 |wc -l)
MATSU=$(cat PUUSER.txt |grep ^31 |wc -l)
KAWAS=$(cat PUUSER.txt |grep ^34 |wc -l)
HIRAT=$(cat PUUSER.txt |grep ^35 |wc -l)
I_TOU=$(cat PUUSER.txt |grep ^37 |wc -l)
TAMAN=$(cat PUUSER.txt |grep ^61 |wc -l)
MYAMA=$(cat PUUSER.txt |grep ^75 |wc -l)
KUMAM=$(cat PUUSER.txt |grep ^87 |wc -l)
NARAP=$(cat PUUSER.txt |grep ^53 |wc -l)
HIROP=$(cat PUUSER.txt |grep ^62 |wc -l)
CHIBA=$(cat PUUSER.txt |grep ^32 |wc -l)
KOUCI=$(cat PUUSER.txt |grep ^74 |wc -l)
SHIZU=$(cat PUUSER.txt |grep ^38 |wc -l)
SHIME=$(cat PUUSER.txt |grep ^57 |wc -l)
S_OGA=$(cat PUUSER.txt |grep ^14 |wc -l)
TAIRA=$(cat PUUSER.txt |grep ^13 |wc -l)
S_ICH=$(cat PUUSER.txt |grep ^41 |wc -l)
TKMTU=$(cat PUUSER.txt |grep ^71 |wc -l)
S_MIZ=$(cat PUUSER.txt |grep ^66 |wc -l)
S_KIM=$(cat PUUSER.txt |grep ^67 |wc -l)
S_KAG=$(cat PUUSER.txt |grep ^68 |wc -l)
S_SAT=$(cat PUUSER.txt |grep ^69 |wc -l)
S_FUK=$(cat PUUSER.txt |grep ^15 |wc -l)
TOYAM=$(cat PUUSER.txt |grep ^46 |wc -l)
SDORI=$(cat PUUSER.txt |grep ^18 |wc -l)
AKITA=$(cat PUUSER.txt |grep ^20 |wc -l)

#2023.2.28 小松島を追加
KOMAT=$(cat PUUSER.txt |grep ^73 |wc -l)
#2023.6.28 名古屋を追加
NAGOY=$(cat PUUSER.txt |grep ^42 |wc -l)
#2023.10.17 四日市を追加
YOKKA=$(cat PUUSER.txt |grep ^48 |wc -l)

SKASI=$(cat PUUSER.txt |grep ^19 |wc -l)
SMITO=$(cat PUUSER.txt |grep ^17 |wc -l)
SKADO=$(cat PUUSER.txt |grep ^76 |wc -l)
SMIMA=$(cat PUUSER.txt |grep ^77 |wc -l)
SMZAK=$(cat PUUSER.txt |grep ^78 |wc -l)
SROGO=$(cat PUUSER.txt |grep ^10 |wc -l)

# 結果表示
echo "サテライト石狩　　　$SISHI 人"
echo "サテライト横浜　　　$SYOKO 人"
echo "サテライト郡山　　　$SKOUR 人"
echo "サテライト川越　　　$SKAWA 人"
echo "サテライト姫路　　　$SHIME 人"
echo "サテライト男鹿　　　$S_OGA 人"
echo "サテライト六郷　　　$SROGO 人"
echo "サテライト秋田　　　$AKITA 人"
echo "サテライト石鳥谷　　$SDORI 人"
echo "サテライトかしま　　$SKASI 人"
echo "サテライト一宮　　　$S_ICH 人"
echo "サテライトみぞべ　　$S_MIZ 人"
echo "サテライトきもつき　$S_KIM 人"
echo "サテライト鹿児島　　$S_KAG 人"
echo "サテライト薩摩川内　$S_SAT 人"
echo "サテライト福島　    $S_FUK 人"
echo "サテライト水戸　    $SMITO 人"
echo "サテライト門川　    $SKADO 人"
echo "サテライト三股　    $SMIMA 人"
echo "サテライト宮崎　    $SMZAK 人"
echo "いわき平競輪場 　　 $TAIRA 人"
echo "松戸競輪場    　　　$MATSU 人"
echo "千葉競輪場    　　　$CHIBA 人"
echo "川崎競輪場    　　　$KAWAS 人"
echo "平塚競輪場    　　　$HIRAT 人"
echo "伊東競輪場    　　　$I_TOU 人"
echo "静岡競輪場    　　　$SHIZU 人"
echo "富山競輪場    　　　$TOYAM 人"
echo "玉野競輪場    　　　$TAMAN 人"
echo "高松競輪場    　　　$TKMTU 人"
echo "高知競輪場    　　　$KOUCI 人"
echo "松山競輪場   　　 　$MYAMA 人"
echo "熊本競輪場   　　 　$KUMAM 人"
echo "奈良競輪場    　　　$NARAP 人"
echo "広島競輪場    　　　$HIROP 人"
echo "小松島競輪場    　　　$KOMAT 人"
echo "名古屋競輪場    　　　$NAGOY 人"
#2023.10.17 四日市
echo "四日市競輪場    　　　$YOKKA 人"

# 処理結果CSV出力
# 場追加時は最下段に追加
echo "01,$SISHI" > ${DNAME}_OUT.csv
echo "02,$SYOKO" >> ${DNAME}_OUT.csv
echo "06,$SKOUR" >> ${DNAME}_OUT.csv
echo "07,$SKAWA" >> ${DNAME}_OUT.csv
echo "31,$MATSU" >> ${DNAME}_OUT.csv
echo "34,$KAWAS" >> ${DNAME}_OUT.csv
echo "35,$HIRAT" >> ${DNAME}_OUT.csv
echo "37,$I_TOU" >> ${DNAME}_OUT.csv
echo "61,$TAMAN" >> ${DNAME}_OUT.csv
echo "75,$MYAMA" >> ${DNAME}_OUT.csv
echo "87,$KUMAM" >> ${DNAME}_OUT.csv
echo "53,$NARAP" >> ${DNAME}_OUT.csv
echo "62,$HIROP" >> ${DNAME}_OUT.csv
echo "32,$CHIBA" >> ${DNAME}_OUT.csv
echo "74,$KOUCI" >> ${DNAME}_OUT.csv
echo "38,$SHIZU" >> ${DNAME}_OUT.csv
echo "57,$SHIME" >> ${DNAME}_OUT.csv
echo "14,$S_OGA" >> ${DNAME}_OUT.csv
echo "13,$TAIRA" >> ${DNAME}_OUT.csv
echo "41,$S_ICH" >> ${DNAME}_OUT.csv
echo "71,$TKMTU" >> ${DNAME}_OUT.csv
echo "66,$S_MIZ" >> ${DNAME}_OUT.csv
echo "67,$S_KIM" >> ${DNAME}_OUT.csv
echo "68,$S_KAG" >> ${DNAME}_OUT.csv
echo "69,$S_SAT" >> ${DNAME}_OUT.csv
echo "15,$S_FUK" >> ${DNAME}_OUT.csv
echo "46,$TOYAM" >> ${DNAME}_OUT.csv
echo "18,$SDORI" >> ${DNAME}_OUT.csv
echo "19,$SKASI" >> ${DNAME}_OUT.csv
echo "17,$SMITO" >> ${DNAME}_OUT.csv
echo "76,$SKADO" >> ${DNAME}_OUT.csv
echo "77,$SMIMA" >> ${DNAME}_OUT.csv
echo "78,$SMZAK" >> ${DNAME}_OUT.csv
echo "10,$SROGO" >> ${DNAME}_OUT.csv
echo "20,$AKITA" >> ${DNAME}_OUT.csv
#2023.2.28 小松島
echo "73,$KOMAT" >> ${DNAME}_OUT.csv
#2023.6.28 名古屋
echo "42,$NAGOY" >> ${DNAME}_OUT.csv
#2023.10.17 四日市
echo "48,$YOKKA" >> ${DNAME}_OUT.csv

# できた前日付のファイルをGoogle Driveにアップロード
rclone ${RCLONE_OPTION} copy ${HOME}/VRIREKI/${DNAME}/${DNAME}_OUT.csv 'chari-filemaster-gd250:/kovs/※(仮)作業日報/プラザ売上速報'
rclone ${RCLONE_OPTION} copy ${HOME}/VRIREKI/${DNAME}/${DNAME}_SUOUT.csv 'chari-filemaster-gd250:/kovs/※(仮)作業日報/【保存】売上報告シート'

# 前々日付のファイルをGoogle Driveから消すのは、
# filemaster名義でGASに仕込んだBL28がやってくれる

echo `date` " BL9 処理が完了しました"
exit
