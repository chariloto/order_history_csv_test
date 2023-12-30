#DBをクリアする

truncate table report_003a ;

truncate table report_003b ;

truncate table report_003d ;


#その日のデータで作成する。
INSERT INTO report_003a
SELECT
 uriage_003.race_date AS '開催日',
CASE
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Sunday' THEN '日曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Monday' THEN '月曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Tuesday' THEN '火曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Wednesday' THEN '水曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Thursday' THEN '木曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Friday' THEN '金曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Saturday' THEN '土曜日'
END AS '曜日',
uriage_003.jo_code AS '場',
uriage_003.user_number AS '会員番号',
calendar.grade AS 'グレード',
calendar.shurui AS '開催種類',
sum(uriage_003.bought_price) AS '購入金額',
sum(uriage_003.refund_price) AS '払戻金額',
sum(uriage_003.return_price) AS '返還金額'
FROM uriage_003
	LEFT OUTER JOIN calendar ON uriage_003.race_date = calendar.race_date AND uriage_003.jo_code = calendar.jo_code
	GROUP BY 開催日,曜日,場,会員番号,グレード,開催種類 ;




#投入

INSERT INTO report_003b
SELECT
distinct uriage_003.race_date AS '開催日',
CASE
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Sunday' THEN '日曜日'
WHEN  DATE_FORMAT(uriage_003.race_date,'%W')= 'Monday' THEN '月曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Tuesday' THEN '火曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Wednesday' THEN '水曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') =  'Thursday' THEN '木曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Friday' THEN '金曜日'
WHEN DATE_FORMAT(uriage_003.race_date,'%W') = 'Saturday' THEN '土曜日'
END AS '曜日',
uriage_003.jo_code AS '場',
uriage_003.user_number AS '会員番号',
customer_003.age AS '年齢',
CASE
when age <= 29 then '20代'
when age BETWEEN 30 AND 39 then '30代'
when age BETWEEN 40 AND 49 then '40代'
when age BETWEEN 50 AND 59 then '50代'
when age BETWEEN 60 AND 69 then '60代'
when age BETWEEN 70 AND 79 then '70代'
when age BETWEEN 80 AND 89 then '80代'
when age BETWEEN 90 AND 99 then '90代'
when age  >100  then '100代'
END'年代',
customer_003.sex AS '性別',
customer_003.lastvote AS '最終投票',
customer_003.moushikomi AS '入会日'
FROM uriage_003
	LEFT OUTER JOIN customer_003 ON uriage_003.user_number =customer_003.user_number ;


#投入

INSERT INTO report_003d
SELECT report_003a.*,report_003b.age,age2,sex,lastvote,moushikomi FROM
report_003a left outer JOIN report_003b ON report_003a.race_date = report_003b.race_date
AND  report_003a.user_number = report_003b.user_number
AND  report_003a.jo_code = report_003b.jo_code ;



