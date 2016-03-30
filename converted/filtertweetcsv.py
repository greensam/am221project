import unicodecsv as csv
import numpy as np
import pandas as pd

def filtertweets(inpath, outfile, tags):
	def filtertweetcsv(treader, filtertags, outfile):
        with open(outfile, 'w') as f:
            wr = csv.DictWriter(f,fieldnames=['text','time'])
            wr.writeheader()
            for row in treader:
                if any(tag in row['text'] for tag in filtertags):
                    wr.writerow(row)

	with open(infile) as f:
   		rdr = csv.DictReader(f)
    	filtertweetcsv(rdr, friday_first ,outfile)