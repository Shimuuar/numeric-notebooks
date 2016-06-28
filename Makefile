.PHONY: all clean

DAT = \
  data/gamma-5+5.dat    \
  data/gamma-17+5.dat   \
  data/gamma-20+20.dat  \
  data/igamma-0.1.dat   \
  data/igamma-1.0.dat   \
  data/igamma-10.dat

all : ${DAT}

clean :
	rm -rf data

data :
	mkdir -p data

${DAT} : data

data/gamma-5+5.dat :
	python utils/gen_loggamma_table.py -5 5 1000 > $@
data/gamma-17+5.dat :
	python utils/gen_loggamma_table.py -17 5 1000 > $@
data/gamma-20+20.dat :
	python utils/gen_loggamma_table.py -20 20 1000 > $@


data/igamma-0.1.dat :
	python utils/gen_igamma_table.py 0.1 -10 5 10000 > $@
data/igamma-1.0.dat :
	python utils/gen_igamma_table.py 1 -10 5 10000 > $@
data/igamma-10.dat :
	python utils/gen_igamma_table.py 10 -10 5 10000 > $@
