#!/usr/bin/env python

import unicodecsv as csv
import sys

def clean(fname):
	outf = fname.split('.csv')
	outf[0] = outf[0]+'_clean'
	outf = "".join(outf) + '.csv'
	with open(outf, 'w') as f:
		writer = csv.writer(f)
		writer.writerow(['text','time'])

	with open(fname, 'r') as f:
		reader = csv.reader(f)
		next(reader)
		for line in reader:
			if not 'Trump' in line[0] and not 'WesleyRickard' in line[0]:
				with open(outf, 'a') as f:
					writer = csv.writer(f)
					writer.writerow(line)

 
if __name__ == "__main__":
	if len(sys.argv) < 2:
		print "Usage: ./cleantrump.py /file/to/clean"
		exit(1)

	for i,arg in enumerate(sys.argv):
		if i > 0:
			fname = sys.argv[i]
			clean(fname)