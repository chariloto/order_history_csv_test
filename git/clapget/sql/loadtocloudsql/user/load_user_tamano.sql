LOAD DATA LOCAL INFILE "~/git/clapget/tamano/tmp_users/tamano.csv"
replace
INTO TABLE customer_003
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

UPDATE customer_003,
(SELECT user_number,MIN(race_date) AS kaisai
FROM uriage_003
GROUP BY user_number) aaa
SET moushikomi = aaa.kaisai
WHERE
customer_003.user_number = aaa.user_number AND
customer_003.moushikomi IS null ;


UPDATE customer_003
SET age = TIMESTAMPDIFF(YEAR, `birthday`, CURDATE())
WHERE
age IS null ;

update customer_003,
(SELECT user_number,SUM(bought_price) AS kounyu ,sum(refund_price) AS harai FROM uriage_003 GROUP BY user_number) tbl1
set
customer_003.bought_price = tbl1.kounyu ,
customer_003.refund_price = tbl1.harai
where
customer_003.user_number = tbl1.user_number ;


delete
 FROM customer_003
 where
 user_number >= 39000001 ;

