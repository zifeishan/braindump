#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys

TOO_MANY_WARNING = 3

def notEnoughNeg(pos, neg):
  ''' Define a filter that judge if the feature gains a high weight 
  because there are not enough negative examples.
  '''
  return pos < 200 and neg < 50

header = True
warn_features = []
header_map = {}
for line in sys.stdin:
  parts = line.strip().split('\t')
  if len(parts) == 0:
    break

  if header: 
    header = False
    if len(parts) != 5:
      break
    for i in range(len(parts)):
      # "weight, pos, neg, queries, description"
      header_map[parts[i]] = i
  else:
    pos = int(parts[header_map['pos_examples']])
    neg = int(parts[header_map['neg_examples']])
    description = parts[header_map['description']]
    if notEnoughNeg(pos, neg):
      warn_features.append(description)

if len(warn_features) >= TOO_MANY_WARNING:
  print '* WARNING: many top features may get a high weight because of not enough negative examples:'
  for f in warn_features:
    print '  * %s' % f 

  

