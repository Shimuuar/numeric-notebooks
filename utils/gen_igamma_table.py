#!/usr/bin/python
"""
"""

import mpmath as mp
import numpy  as np
import sys


mp.mp.dps = 60

z    = float(sys.argv[1])
a_lo = float(sys.argv[2])
a_hi = float(sys.argv[3])
n    = int  (sys.argv[4])

for x in np.logspace(a_lo, a_hi, 1000) :
    x = mp.mpf(x)
    print x, mp.gammainc(z, 0, x, regularized=True)
