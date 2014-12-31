import sys
from math import sqrt, log

# Reference: http://www.cs.princeton.edu/~schapire/papers/good-turing.ps.gz
# McAllester, David A., and Robert E. Schapire. "On the Convergence Rate of Good-Turing Estimators." COLT. 2000.


# Computes the bounds for |G_k - M_k|.
def bound_width(d, m, k):
  d = float(d)
  m = float(m)
  k = float(k)
  p1 = (k+2) / (m-k)
  p2 = sqrt(2. * log(3. / d) / m)
  p3 = (k+1) / (1-k/m)
  p3 += k
  p3 += sqrt(2 * k * log(3 * m / d))
  p3 += 2 * log(3 * m / d)
  return p1 + p2 * p3

if __name__ == "__main__":
  if len(sys.argv) != 3:
    print >>sys.stderr, "Usage: %s <num_samples> <good_turing_estimator>" % sys.argv[0]

  try:
    m = int(sys.argv[1])
    mean = float(sys.argv[2])
  except:
    print "N/A"
    exit(0)

  width = bound_width(0.05, m, 0)
  left = max(0, mean - width)
  right = min(1, mean + width)
  print "[%.3f, %.3f]" % (left, right)
  
