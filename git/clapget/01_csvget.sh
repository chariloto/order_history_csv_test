#!/bin/bash
# coding: utf-8
# 01_start
# takashi.suzuki@biz.chariloto.com
# 各競輪場のcsvファイルを取得してきてワークディレクトリに格納する。
# 格納されたファイルをDBに取り込める形式に変換する。
# cloudSQLにデータロード
# 最後にreportシリーズを作成する。

BASEDIR=~/git/clapget/
SQLDIR=~/git/clapget/sql
CSVtoSQL=~/git/clapget/sql/loadtocloudsql
cd $BASEDIR

#日付を設定
TODAY_YYYYMMDD=`date +%Y%m%d`
yesterday=`date +%Y%m%d --date '1 day ago'`

#リカバリ時に変数を指定できるように定義だけしておく。
#2023.4.6現在処理では使っていない
while getopts nd: OPT
do
  case $OPT in
    "n" ) NO_NCUCON=1 ;;
    "d" ) TODAY_YYYYMMDD=$OPTARG ;;
  esac
done
######ここまで

#前処理
# テキストファイルを読み込んで配列に格納する
file_names=`cat clapkyoten.txt|xargs`

# 配列の要素でディレクトリを作成する
for kyoten in $file_names
do
    mkdir -p "$kyoten"
    mkdir -p "$kyoten"/tmp_rireki
    mkdir -p "$kyoten"/tmp_users
    mkdir -p "$kyoten"/users_${TODAY_YYYYMMDD}
    mkdir -p "$kyoten"/rireki_${yesterday}
#rcloneを使い必要なファイル名を取得して各ディレクトリにコピーする
#全拠点のユーザー情報を毎日取得する。
    filename1=`rclone lsf astrea-s3:/s3-data/${kyoten}-prd-private/uploads/profiles/all_users_csv --include "all_users_csv_${TODAY_YYYYMMDD}*.csv"`
    rclone copy astrea-s3:/s3-data/${kyoten}-prd-private/uploads/profiles/all_users_csv/${filename1} ${kyoten}/users_${TODAY_YYYYMMDD}

#ユーザーリストをmysqlで取り込める形に整形する。
    cd ${kyoten}/users_${TODAY_YYYYMMDD}

#1ファイルしかできないので、ファイル名を変数に投入
    userlist=`ls -1`
#編集用ディレクトリに一時保存
    cp $userlist ../tmp_users/user.csv

#SQLITEでテキスト編集 
    cd ${BASEDIR}/${kyoten}/tmp_users
    sqlite3 tmp.db < ${SQLDIR}/${kyoten}.sql

#せっかくsqliteで整形したけど、作成されたファイルからダブルクォーテーションを取り除く
    sed -i -e' s/"//g' ${kyoten}.csv 
    echo "${kyoten}の累計ユーザ数（退会者含む）は以下のとおりです。"  >> ${BASEDIR}/today.log
    echo `wc -l ${kyoten}.csv | cut -d ' ' -f1`  >> ${BASEDIR}/today.log


#CloudSQLにデータロードする
#顧客情報を読み込み
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${CSVtoSQL}/user/load_user_${kyoten}.sql

#############ここまでがユーザーcsvを作成する部分
#############同じループで投票履歴も作成する。
#全拠点の投票履歴を取得する。
    cd $BASEDIR
        filename2=`rclone lsf astrea-s3:/s3-data/${kyoten}-prd-private/uploads/vote_history/nanakake --include "rireki_${yesterday}*.csv"`
            if [ -n "$filename2" ]; then
                for i in $filename2 
                do
	                rclone copy astrea-s3:/s3-data/${kyoten}-prd-private/uploads/vote_history/nanakake/${i} ${kyoten}/rireki_${yesterday}
                done
                    cd ${BASEDIR}/${kyoten}/rireki_${yesterday}
                    filename3=`ls -1`
                        for k in $filename3
                            do
                                sed -e '1d' -e 's/"//g' -e 's/=//g' $k > ../tmp_rireki/$k
                        done
                    cat ${BASEDIR}/${kyoten}/tmp_rireki/rireki*.csv > ${BASEDIR}/${kyoten}/tmp_rireki/total.csv
##取り込むデータの件数を出力
                    echo "${kyoten}の投票数合算件数は以下のとおりです。"  >> ${BASEDIR}/today.log
                    echo `wc -l ${BASEDIR}/${kyoten}/tmp_rireki/total.csv | cut -d ' ' -f1`  >> ${BASEDIR}/today.log

#CloudSQLにデータロードする
#履歴情報を読み込み
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${CSVtoSQL}/rireki/load_rireki_${kyoten}.sql

#履歴データが存在する（CLAP販売をした拠点名を変数に入力する。）
            else
                echo "${kyoten}はfileがありません。販売されなかったかもしれません。" >> ${BASEDIR}/today.log
            fi
#後処理でBASEDIRに戻る
    cd $BASEDIR
done

#あまり意味が無いが100秒待ってから作業ファイルをすべて消す

sleep 100

cd $BASEDIR

for kyoten in $file_names
    do
    rm -rf $kyoten
    done

echo "中間ファイルをすべて削除しました" >> ${BASEDIR}/today.log

#最後にreportシリーズを作成する


mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu01.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu02.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu11.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu12.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu21.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu22.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu31.sql
mysql -udaikoku -h ebisu.chariloto.com -Dclap --enable-local-infile --ssl-ca=~/.ssh/eliza-ebisu-20210830/server-ca.pem --ssl-cert=~/.ssh/eliza-ebisu-20210830/client-cert.pem --ssl-key=~/.ssh/eliza-ebisu-20210830/client-key.pem < ${SQLDIR}/shimizu/shimizu32.sql

echo "reportシリーズを更新しました" >> ${BASEDIR}/today.log

ruby 02_monitor.rb

sleep 50

rm today.log





#eof