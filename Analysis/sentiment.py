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
import tweet_features

"""
This method trains a classifier using
the data in training.csv

To classifer a tweet, call
the object that results from this call
with obj.classify(text) 
where text is the text of the tweet. 
"""
def sentiment_classifier():
	trainingfp = open('training.csv', 'rb')
	reader = csv.reader( trainingfp, delimiter=',', quotechar='"', escapechar='\\' )
	trainingtweets = []
	for row in reader:
		trainingtweets.append([row[1], row[4]])
	random.shuffle(trainingtweets)

	fvecs = [(tweet_features.make_tweet_dict(t),s) for (t,s) in trainingtweets]
	classifier = nltk.NaiveBayesClassifier.train(fvecs);
	return classifier