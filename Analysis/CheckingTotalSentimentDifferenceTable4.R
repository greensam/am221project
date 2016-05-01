# bring in the data
sgdf_data0430 = read.csv("~/Dropbox/__JuniorSpring/AM221/project/Analysis/tweetdata.csv", header=TRUE)

# Margin_T ~ Sentiment_T-1
fitMarginSentTotal <- lm(Margin_Period~SentDiff_Total_Lag1,data= sgdf_data0430)
summary(fitMarginSentTotal)

# margin on senitment with controls
# Margin_T ~ Sentiment_T-1 + Controls 
fitMarginSentTotalControls <- lm(Margin_Period ~ SentDiff_Total_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)
summary(fitMarginSentTotalControls)


# margin on sentiment, multiple lags, with controls
# Margin_T ~ Sentiment_T-1 + Sentiment_T-2 + Sentiment_T-3 + Controls
fitMarginSentTotalMultipleControls <- lm(Margin_Period ~ SentDiff_Total_Lag1 + SentDiff_Period_Lag2 + SentDiff_Period_Lag3 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)
summary(fitMarginSentTotalMultipleControls)
