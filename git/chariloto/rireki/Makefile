# chariloto/rireki/Makefile
# morimoto@biz.chariloto.com

.PHONY: all get insert clean
YESTERDAY ?= $(shell date +%Y%m%d -d yesterday)

all:
	@echo Starting BL31 at $(shell date)
	$(MAKE) get
	$(MAKE) insert
	$(MAKE) clean
	@echo Finished BL31 at $(shell date)

get:
    # keirin
	rclone copy astrea-s3:/s3-data/chariloto-prd-private/uploads/order_history_csv/keirin/$(YESTERDAY) $(YESTERDAY)/keirin
    # auto
	rclone copy astrea-s3:/s3-data/chariloto-prd-private/uploads/order_history_csv/auto/$(YESTERDAY) $(YESTERDAY)/auto

insert:
    # keirin
	echo $(YESTERDAY)/keirin/rireki_*.csv | xargs -n 1 ./insert -i
    # auto
	echo $(YESTERDAY)/auto/rireki_*.csv | xargs -n 1 ./insert -i

clean:
	rm -r $(YESTERDAY)

# eof
