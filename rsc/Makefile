

CFG = noizebox.conf
all: conf termdb

conf:
	@printf "Building configuration database ..."
	@rm -f $(CFG)
	@sqlite3 $(CFG) "create table dsp (param varchar(12), val smallint);"
	@sqlite3 $(CFG) "insert into dsp values('device',1);"
	@sqlite3 $(CFG) "create table mixer (param varchar(12), val smallint);"
	@sqlite3 $(CFG) "insert into mixer values('left',100);"
	@sqlite3 $(CFG) "insert into mixer values('right',100);"
	@sqlite3 $(CFG) "create table midi (param varchar(12), val smallint);"
	@sqlite3 $(CFG) "insert into midi values('sensitivity',0);"
	@sqlite3 $(CFG) "insert into midi values('transpose',0);"
	@sqlite3 $(CFG) "insert into midi values('mode',1);"
	@sqlite3 $(CFG) "insert into midi values('breath_curve',1);"
	@sqlite3 $(CFG) "create table synth (param varchar(12), val smallint);"
	@sqlite3 $(CFG) "insert into synth values('detune',0);"
	@sqlite3 $(CFG) "create table soundfont (param varchar(12), val smallint);"
	@sqlite3 $(CFG) "insert into soundfont values('last_id',1);"
	@echo " done."
termdb:
	@printf "Building Termcap database ..."
	@cp /usr/share/misc/termcap .
	@cat termcap.tinyVT >> termcap
	@cap_mkdb termcap
	@echo " done."
clean:
	@rm -f $(CFG)
install:
