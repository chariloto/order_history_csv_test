#!/bin/bash
# BL11 VRIREKI/RIREKI_ftp.sh
# 投票履歴 自動格納
#
#  変更履歴
#  2017/10/26　　三井 新規作成
#  2017/11/06　　三井 月跨ぎ処理の変更
#  2018/01/05　　三井 格納先のフォルダ構成変更対応
#  2018/05/16　　三井 JNB売上csvの転送追加
#  2023/11/13    越田 オート一日2回開催に向けた対応(ディレクトリ分割)
#  git/chariloto/kovs-svr/VRIREKI/RIREKI_ftp.sh

# 変数初期化
VRIREKI_DIR=VRIREKI2

# 前日日付を取得
if [ x$DNAME = x ]; then
  DNAME=`date -d '1 day ago' "+%Y%m%d"`
fi

# さらにその1日まえ
BFILE=`date -d "$DNAME 1 day ago" "+%Y%m%d"`

# 当年月を取得 (格納日=実施日)
PDNAME=`date -d $DNAME "+%Y%m"`

# 年フォルダ名取得
PYNAME=`date -d $DNAME "+%Y"`

# Google Drive /kovs/投票履歴_Vote_Rireki/YYYY/YYYYMM にアップロードする
# まず、ローカルに、YYYYMMフォルダの下に、送りたいrireki_*.csvがコピーされている構造を作ってから、
# そのYYYYMMフォルダをrclone copyでGoogle Driveにコピーするようにする。
# こうすることで、「月初に、送り先フォルダをmkdirしてからファイルコピーしていくと、
# ファイルコピー工程において、送り先フォルダを既にmkdirしていることの認識にまれに失敗し、
# 送り先フォルダを改めて作ってしまい、重複フォルダができてしまう」ことを防げる。
# 実行時間も早くなる。
mkdir -p rclone-transmit-tmp/${PDNAME}/keirin rclone-transmit-tmp/${PDNAME}/auto
# 日毎のコピーなら、rireki_*.csvの数はせいぜい数十個なので、単純なファイルグロブで処理して構わない
# (月単位で扱う場合は、rireki_*.csvでグロブするとargument too longになるので注意)
cp ${DNAME}/keirin/rireki_*.csv rclone-transmit-tmp/${PDNAME}/keirin
cp ${DNAME}/auto/rireki_*.csv rclone-transmit-tmp/${PDNAME}/auto
rclone copy rclone-transmit-tmp/${PDNAME}/keirin chari-filemaster-gd250:/kovs/投票履歴_Vote_Rireki/${PYNAME}/${PDNAME}/keirin
rclone copy rclone-transmit-tmp/${PDNAME}/auto chari-filemaster-gd250:/kovs/投票履歴_Vote_Rireki/${PYNAME}/${PDNAME}/auto
rm -r rclone-transmit-tmp

# 石原さんのGoogle Driveフォルダにアップロード
rclone copy ${DNAME}/rireki/${DNAME}_CTAU.csv chari-filemaster-gd250:/kovs/ishihara

# EOF
