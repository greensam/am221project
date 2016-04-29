import requests
from bs4 import BeautifulSoup
from bs4 import NavigableString
import pandas as pd
import StringIO
import urllib
from datetime import date, datetime, timedelta
import itertools
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches
from scipy.stats.stats import pearsonr, describe
import math
import sys
import pytz
import ggplot
from dateutil import parser
from scipy import stats
import time

from sentiment import Classifier
from relevance import addrelevancedf

classifier = Classifier()

# define a useful timezone constant
eastern = pytz.timezone('US/Eastern')


# Simple lambda function
def split(x, num):
	return int(x.split('-')[num])

# Write a function that scrapes the team trend graph for each game
def ncaatrendgraph(gameid):

	# make sure that we're not sending too many requests
	time.sleep(0.1)

	# Scrape the reference team page
	url = 'http://espn.go.com/mens-college-basketball/playbyplay?gameId=' + str(gameid)
	html = urllib.urlopen(url)
	soup = BeautifulSoup(html, "html.parser") 

	# Identify which team is which from the basic page
	teams = soup.find_all('div', {'class', "team-container"})

	away = str(teams[0].find('span', {'class', 'long-name'}).contents[0]).split(';')[0]
	home = str(teams[1].find('span', {'class', 'long-name'}).contents[0]).split(';')[0]
	tps = (len(soup.find('div', {'class', 'game-status'}).find('table').find_all('td'))-2)/2

	# # Run through the table and get all the relevant events from that quarter
	qes = []
	for num in range(1,tps):
	    for item in soup.find_all('table')[num].find_all('tr')[1:]:
	        event = []
	        for td in item.find_all('td'):
	            if len(td.contents) > 0:
	                if 'img' in str(td.contents[0]):
	                    event.append(str(td.contents[0]['src']).split('/')[-1].split('.')[0].upper())
	                else:
	                    if ':' in str(td.contents[0]):
	                        if num > 2:
	                            minutes = 4-int(td.contents[0].split(':')[0]) + 40 + ((num-3)*5)
	                        else:
	                            minutes = 19-int(td.contents[0].split(':')[0]) +((num-1)*20)
	                        seconds = 60-int(td.contents[0].split(':')[1])

	                        # Make an adjustment for exact minute calculations
	                        if seconds == 60:
	                            minutes = minutes + 1
	                            seconds = 0

	                        event.append(minutes)
	                        event.append(seconds)
	                    else:
	                        event.append(str(td.contents[0]))
	        qes.append(event)

	# Make this data into a Dataframe
	bsd = pd.DataFrame(qes, columns = ['Minutes', 'Seconds', 'Team', 'Event', 'Score'])
	bsd[away] = bsd['Score'].apply(lambda x: split(x, 0))
	bsd[home] = bsd['Score'].apply(lambda x: split(x, 1))
	bsd = bsd.drop('Score', 1)

	# # Write a quick function converting the minutes and seconds to a percentage
	if (tps) == 3:
	    numminutes = 40
	else:
	    numminutes = 40 + 5*(tps-3)
	lengame = numminutes*60.0
	bsd['PercDone'] = [float(100*round((mins*60+sec)/lengame,4)) for (mins, sec) in zip(bsd['Minutes'], bsd['Seconds'])]
	return bsd

def classifydf(df):
	df['sentiment'] = df['text'].map(lambda x : classifier.classify(x))
	return df

def fullgame(row, sam = True):
  	
  	# convert DF slice into regular object if necessary
  	try:
  		eid = int(row['espn_id'])
  	except Exception as e:
  		print e
  		row = row[1]
  		eid = int(row['espn_id'])

    # Get the important metadata and define a useful constant
    # gmdat = pd.read_csv("GameMetadata.csv")
    # metadat = gmdat[((gmdat['Team1'] == gp1) | (gmdat['Team1'] == gp2)) & ((gmdat['Team2'] == gp1) | (gmdat['Team2'] == gp2))]
	
	begin, end = datetime.strptime(row['Start'], '%H:%M'), datetime.strptime(row['End'], '%H:%M')

	if end < begin:
		end = end + timedelta(days = 1)

	lenhalf = 20*60
    
    # Grab the game data for the time period
	dt1 = ncaatrendgraph(eid) # Usually gdata
	# dt1 = gamevents(gdata, tp1, tp2, begin, end)

    # Grab the relevant data from the twitter file
	fname = row['Filename']
	path = ''
	if sam:
		path = '../separated/'
	else:
		path = './'

	tweets =  pd.read_csv(path + fname)
	tweets['time_chg'] = tweets['time'].apply(lambda x: x.split(' ')[3])
    
	indices = []
	for num in range(0, len(tweets['time_chg'])):
		tweetstamp = datetime.strptime(tweets['time_chg'].iloc[num], "%H:%M:%S") - timedelta(hours=4)
		tweets['time_chg'].iloc[num] = "{:02d}:{:02d}:{:02d}".format(tweetstamp.hour, tweetstamp.minute, tweetstamp.second)

		if tweetstamp.hour >= 20:
		    tweetstamp = tweetstamp + timedelta(days=1)

		if (tweetstamp > begin) and (tweetstamp < end):
			indices.append(num)

	if len(indices) > 0:
		dt2 = tweets[tweets.index.isin(indices)]
		dt2['time'] = tweets['time'].map(lambda t : parser.parse(t).replace(tzinfo=None))
		return dt1, addrelevancedf(classifydf(dt2), eid)
	
	indices = []
	for num in range(0, len(tweets['time_chg'])):
		tweetstamp = datetime.strptime(tweets['time_chg'].iloc[num], "%H:%M:%S") + timedelta(hours=4)

		if (tweetstamp > begin) and (tweetstamp < end):
			indices.append(num)

	dt2 = tweets[tweets.index.isin(indices)]
	dt2['time'] = dt2['time'].map(lambda t : parser.parse(t).replace(tzinfo=None))
 
	return dt1, addrelevancedf(classifydf(dt2), eid)









