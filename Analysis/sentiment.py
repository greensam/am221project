'''
@package sentiment
This code adapts example code from
Niek Sanders, njs@sananalytics.com,
originally source here: http://www.sananalytics.com/lab/twitter-sentiment/

It uses the labeled training corpus from that site as
the training set for the model, though this will be
at best imperfect, since those tweets were classified
against topics different from this topic. Should
be a reasonable baseline anyways. We ignore
dimensionality reduction for the moment. 

The module assumptions the existence of a 
training set called 'training.csv'
'''
import csv, random
import nltk
from nltk.corpus import stopwords
import tweet_features
import pandas as pd
from bs4 import BeautifulSoup     
import re        
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.ensemble import RandomForestClassifier

from sklearn.svm import LinearSVC
from nltk.classify.scikitlearn import SklearnClassifier
# SVM with a Linear Kernel and default parameters 

stops = set(stopwords.words("english"))

def tweet_to_words(tweet):
	twbs = BeautifulSoup(tweet)
	letters_only = re.sub("[^a-zA-Z]",           # The pattern to search for
                      " ",                   # The pattern to replace it with
                      twbs.get_text() )
	words = letters_only.lower().split()
	meaningful = [w for w in words if not w in stops]
	
	fset = {}
	for m in meaningful:
		fset['contains(%s)' % m.lower()] = True    

	return fset

"""
This method trains a classifier using
the data in training.csv

To classifer a tweet, call
the object that results from this call
with obj.classify(text) 
where text is the text of the tweet. 
"""
def sentiment_classifier(debug):
	# trainingfp = open('training.csv', 'rb')
	train = pd.read_csv( 'training.csv', delimiter=',', quotechar='"', escapechar='\\',header=0 )
	num_tweets = train['TweetText'].size
	
	cleantweets = []
	for i in xrange(0, num_tweets):
		if debug and ( (i+1)%1000 == 0 ):
			print "Tweet %d of %d\n" % ( i+1, num_tweets )          
		cleantweets.append((tweet_to_words(train['TweetText'][i]), train['Sentiment'][i]))

	# vectorizer = CountVectorizer(analyzer = "word",   \
 #                             tokenizer = None,    \
 #                             preprocessor = None, \
 #                             stop_words = None,   \
 #                             max_features = 5000) 

	# train_data_features = vectorizer.fit_transform([t for (t,_) in cleantweets])
	
	# feature_labels = [(m,l) for ((f,l),m) in zip(cleantweets, train_data_features)]

	# forest = RandomForestClassifier(n_estimators = sensitivity)
	# forest = forest.fit(train_data_features, train['Sentiment'])
	classif = SklearnClassifier(LinearSVC())
	classif.train(cleantweets)

	return (classif)

class Classifier():
	
	def __init__(self, debug=False):
		trained = sentiment_classifier(debug)
	
		self.forest = trained
		# self.vectorizer = trained[1]

	def classify(self,tweet):
		clean = tweet_to_words(tweet)
		# test_features = self.vectorizer.transform([clean])
		# test_features = test_features.toarray()

		# result = self.forest.predict(test_features)

		# return fvec
		return self.forest.classify(clean)

