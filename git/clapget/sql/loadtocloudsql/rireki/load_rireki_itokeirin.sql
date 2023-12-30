LOAD DATA LOCAL INFILE "~/git/clapget/itokeirin/tmp_rireki/total.csv"
INTO TABLE uriage_004
FIELDS
  TERMINATED BY ','
LINES
  TERMINATED BY '\n'
IGNORE 0 LINES
  (@fieldA, @fieldB, @fieldC, @fieldD, @fieldE, @fieldF, @fieldG, @fieldH, @fieldI)
set
  race_date = @fieldA,
  user_number = @fieldB,
  jo_code = @fieldC,
  race_number = @fieldD,
  voting_type = @fieldE,
  bought_unit = @fieldF,
  bought_price = @fieldG,
  refund_price = @fieldH,
  return_price = @fieldI ;

truncate table sum_004 ;

INSERT INTO sum_004
SELECT race_date,user_number,sum(bought_price),SUM(refund_price)
FROM uriage_004
GROUP BY race_date,user_number ;

truncate table sum2_004 ;

INSERT into sum2_004
SELECT race_date,jo_code,SUM(bought_price),SUM(refund_price),SUM(return_price)
from uriage_004
GROUP BY race_date,jo_code ;

