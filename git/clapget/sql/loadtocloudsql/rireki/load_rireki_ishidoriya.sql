LOAD DATA LOCAL INFILE "~/git/clapget/ishidoriya/tmp_rireki/total.csv"
INTO TABLE uriage_001
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

truncate table sum_001 ;

INSERT INTO sum_001
SELECT race_date,user_number,sum(bought_price),SUM(refund_price)
FROM uriage_001
GROUP BY race_date,user_number ;

truncate table sum2_001 ;

INSERT into sum2_001
SELECT race_date,jo_code,SUM(bought_price),SUM(refund_price),SUM(return_price)
from uriage_001
GROUP BY race_date,jo_code ;

#eof