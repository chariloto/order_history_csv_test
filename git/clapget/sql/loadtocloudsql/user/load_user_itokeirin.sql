LOAD DATA LOCAL INFILE "~/git/clapget/itokeirin/tmp_users/itokeirin.csv"
replace
INTO TABLE customer_004
FIELDS
  TERMINATED BY ','
LINES
  TERMINATED BY '\n'
IGNORE 0 LINES
  (@fieldA, @fieldB, @fieldC, @fieldD, @fieldE, @fieldF, @fieldG, @fieldH, @fieldI, @fieldJ)
set
  user_number = nullif(@fieldA,""),
  bought_price = nullif(@fieldB,""),
  refund_price = nullif(@fieldC,""),
  moushikomi = nullif(@fieldD,""),
  sex = nullif(@fieldE,""),
  birthday = nullif(@fieldF,""),
  lastvote = nullif(@fieldG,""),
  lastpayment = nullif(@fieldH,""),
  taikai = nullif(@fieldI,""),
  age  = nullif(@fieldJ,"") ;

UPDATE customer_004,
(SELECT user_number,MIN(race_date) AS kaisai
FROM uriage_004
GROUP BY user_number) aaa
SET moushikomi = aaa.kaisai
WHERE
customer_004.user_number = aaa.user_number AND
customer_004.moushikomi IS null ;


UPDATE customer_004
SET age = TIMESTAMPDIFF(YEAR, `birthday`, CURDATE())
WHERE
age IS null ;

update customer_004,
(SELECT user_number,SUM(bought_price) AS kounyu ,sum(refund_price) AS harai FROM uriage_004 GROUP BY user_number) tbl1
set
customer_004.bought_price = tbl1.kounyu ,
customer_004.refund_price = tbl1.harai
where
customer_004.user_number = tbl1.user_number ;


delete
 FROM customer_004
 where
 user_number >= 49000001 ;

