truncate table report_004c ;


INSERT INTO report_004c(
race_date,
weekday,
user_number,
jo_code,
race_number,
voting_type,
bought_unit,
bought_price,
refund_price,
return_price)
SELECT 
race_date AS '開催日',
CASE
WHEN DATE_FORMAT(race_date,'%W') = 'Sunday' THEN '日曜日'
WHEN  DATE_FORMAT(race_date,'%W')= 'Monday' THEN '月曜日'
WHEN DATE_FORMAT(race_date,'%W') = 'Tuesday' THEN '火曜日'
WHEN DATE_FORMAT(race_date,'%W') = 'Wednesday' THEN '水曜日'
WHEN DATE_FORMAT(race_date,'%W') =  'Thursday' THEN '木曜日'
WHEN DATE_FORMAT(race_date,'%W') = 'Friday' THEN '金曜日'
WHEN DATE_FORMAT(race_date,'%W') = 'Saturday' THEN '土曜日'
END AS '曜日',
user_number AS '会員番号',
jo_code AS '場',
race_number AS 'レース番号',
voting_type AS '賭式',
bought_unit as '購入口数',
bought_price AS '売上金額',
refund_price AS '払戻金額',
return_price AS '返還金額'
FROM uriage_004;



