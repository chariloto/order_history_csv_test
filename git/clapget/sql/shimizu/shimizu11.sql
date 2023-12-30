#DBをクリアする

truncate table report_002a ;

truncate table report_002b ;

truncate table report_002d ;


#その日のデータで作成する。
INSERT INTO report_002a
SELECT
 uriage_002.race_date AS '開催日',
CASE
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Sunday' THEN '日曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Monday' THEN '月曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Tuesday' THEN '火曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Wednesday' THEN '水曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Thursday' THEN '木曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Friday' THEN '金曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Saturday' THEN '土曜日'
END AS '曜日',
uriage_002.jo_code AS '場',
uriage_002.user_number AS '会員番号',
calendar.grade AS 'グレード',
calendar.shurui AS '開催種類',
sum(uriage_002.bought_price) AS '購入金額',
sum(uriage_002.refund_price) AS '払戻金額',
sum(uriage_002.return_price) AS '返還金額'
FROM uriage_002
	LEFT OUTER JOIN calendar ON uriage_002.race_date = calendar.race_date AND uriage_002.jo_code = calendar.jo_code
	GROUP BY 開催日,曜日,場,会員番号,グレード,開催種類 ;




#投入

INSERT INTO report_002b
SELECT
distinct uriage_002.race_date AS '開催日',
CASE
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Sunday' THEN '日曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Monday' THEN '月曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Tuesday' THEN '火曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Wednesday' THEN '水曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Thursday' THEN '木曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Friday' THEN '金曜日'
WHEN DATE_FORMAT(uriage_002.race_date,'%W') = 'Saturday' THEN '土曜日'
END AS '曜日',
uriage_002.jo_code AS '場',
uriage_002.user_number AS '会員番号',
customer_002.age AS '年齢',
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
customer_002.sex AS '性別',
customer_002.lastvote AS '最終投票',
customer_002.moushikomi AS '入会日'
FROM uriage_002
	LEFT OUTER JOIN customer_002 ON uriage_002.user_number =customer_002.user_number ;


#投入

INSERT INTO report_002d
SELECT report_002a.*,report_002b.age,age2,sex,lastvote,moushikomi FROM
report_002a left outer JOIN report_002b ON report_002a.race_date = report_002b.race_date
AND  report_002a.user_number = report_002b.user_number
AND  report_002a.jo_code = report_002b.jo_code ;



