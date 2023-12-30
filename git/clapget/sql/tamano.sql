.mode csv

.import user.csv tamano

.output tamano.csv

select substr(会員番号,3,10),'','','', "性別", "生年月日", substr(最終投票日時,1,10), substr(最終入金日時,1,10), "退会日時",'' from tamano  ;

.quit

