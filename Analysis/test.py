#! /usr/bin/env python

import utilities
import pandas as pd

gmetas = pd.read_csv("GameMetadata.csv")

fails = []
nones = []
for row in gmetas.iterrows():
	try:
		b,e, r1,r2 = utilities.fullgame(row[1], sam=True)
		print row[1]['Filename']
		if r2.shape[0] == 0:
			nones.append(row[1]['Filename'])
		print r1.shape, r2.shape
	except Exception as e:
		fails.append(row[1]['Filename'])
		print e

print fails
print 'There were {0} fails out of {1} attempts'.format(len(fails), len(gmetas))

print nones
print 'The above return empty tweet frames'