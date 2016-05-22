import unicodecsv as csv

def filtertweetcsv(treader, filtertags, outfile):
	with open(outfile, 'w') as f:
		wr = csv.DictWriter(f,fieldnames=['text','time'])
		wr.writeheader()
		for row in treader:
			if any(tag in row['text'] for tag in filtertags):
				wr.writerow(row)
	return True

def filtertweets(inpath, outfile, tags):
	with open(inpath, 'r') as f:
		rdr = csv.DictReader(f)
		return filtertweetcsv(rdr, tags , outfile)