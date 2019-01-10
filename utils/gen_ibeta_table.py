#!/usr/bin/python
"""
"""

import mpmath as mp
import numpy  as np
import sys


mp.mp.dps = 30

a    = float(sys.argv[1])
b    = float(sys.argv[2])
x_lo = float(sys.argv[3])
n    = int  (sys.argv[4])

for x in np.logspace(x_lo, 0, n) :
    x = mp.mpf(x)
    with mp.extradps(300) :
        y = mp.betainc(a, b, 0, x, regularized=True)
    print x, y
