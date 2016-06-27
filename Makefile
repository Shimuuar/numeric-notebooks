.PHONY: all clean

DAT = \
  data/gamma-5+5.dat   \
  data/gamma-17+5.dat   \
  data/gamma-20+20.dat

all : ${DAT}

clean :
	rm -rf data/*

data/gamma-5+5.dat :
	mkdir -p data
	python utils/gen_loggamma_table.py -5 5 1000 > $@
data/gamma-17+5.dat :
	mkdir -p data
	python utils/gen_loggamma_table.py -17 5 1000 > $@
data/gamma-20+20.dat :
	mkdir -p data
	python utils/gen_loggamma_table.py -20 20 1000 > $@
