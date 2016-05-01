## AM 221 Work (Empirics Section)
## David Freed and Samuel Green
## April 30, 2016

library(stargazer)

# bring in the data
sgdf_data0430 = read.csv("tweetdata.csv", header=TRUE)

##################################################
##################################################
###########	    					 	##########
###########	    REGRESSION FAMILY 1 	##########
###########	    					 	##########
##################################################
##################################################

##################################################
##################################################
# Table 1 Regressions
# Test: Sentiment Responsiveness to Game Events
##################################################
##################################################

# no controls
# SentDiff_T ~ Margin_T-1
fitSentMargin <- lm(SentDiff_Period~Margin_Period_Lag1, data=sgdf_data0430)

# add standard controls
# SentDiff_T ~ Margin_T-1 + Controls
fitSentMarginControls <- lm(SentDiff_Period ~ Margin_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# add a second lag + controls
# SentDiff_T ~ Margin_T-1 + Margin_T-2 + Controls
fitSentMarginControls <- lm(SentDiff_Period ~ Margin_Period_Lag2 + Margin_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

###################################################

##################################################
##################################################
# Table 2 Regressions 
# Test: Volume Responsiveness to Game Events
##################################################
##################################################

# no controls
# VolDiff_T ~ Margin_T-1
fitVolMargin <- lm(VolDiff_Period~Margin_Period_Lag1, data=sgdf_data0430)

# add standard controls
# VolDiff_T ~ Margin_T-1 + Controls
fitVolMarginControls <- lm(VolDiff_Period ~ Margin_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# add a second lag + controls
# VolDiff_T ~ Margin_T-1 + Margin_T-2 + Controls
fitVolMarginMultipleControls <- lm(VolDiff_Period ~ Margin_Period_Lag2 + Margin_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

##################################################
##################################################
# Table 3 Regressions 
# Test: End of Game Behavior
##################################################
##################################################

# subset the data
dataEndOfGame = sgdf_data0430[sgdf_data0430$Min_End > 30, ]

# SentDiff_T ~ Margin_T + Controls
fitSentMarginControlsSubset <- lm(SentDiff_Period ~ Margin_Period +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=dataEndOfGame)

# SentDiff_T ~ Margin_T-1 + Controls
fitSentMarginLagControlsSubset <- lm(SentDiff_Period ~ Margin_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=dataEndOfGame)

# VolDiff_T ~ Margin_T + Controls
fitVolMarginControlsSubset <- lm(VolDiff_Period ~ Margin_Period+  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=dataEndOfGame)

# VolDiff_T ~ Margin_T-1 + Controls
fitVolMarginLagControlsSubset <- lm(VolDiff_Period ~ Margin_Period_Lag1+  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=dataEndOfGame)


###################################################
			# End Regression Family 1 # 
###################################################

##################################################
##################################################
###########	    					 	##########
###########	    REGRESSION FAMILY 2 	##########
###########	    					 	##########
##################################################
##################################################

##################################################
##################################################
# Table 4  Regressions
# Test: Margin/Game Events on Sentiment
##################################################
##################################################

# margin on previous sentiment 
# no controls
# Margin_T ~ Sentiment_T-1
fitMarginSent <- lm(Margin_Period~SentDiff_Period_Lag1,data= sgdf_data0430)

# margin on senitment with controls
# Margin_T ~ Sentiment_T-1 + Controls 
fitMarginSentControls <- lm(Margin_Period_Lag1 ~ SentDiff_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# margin on sentiment, multiple lags, with controls
# Margin_T ~ Sentiment_T-1 + Sentiment_T-2 + Sentiment_T-3 + Controls
fitMarginSentMultipleControls <- lm(Margin_Period_Lag1 ~ SentDiff_Period_Lag1 + SentDiff_Period_Lag2 + SentDiff_Period_Lag3 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)


##################################################
##################################################
# Table 5 Regressions
# Test: Margin/Game Events on Volume and Combined
##################################################
##################################################
# Result 5: Regression Table
# Margin_T ~ VolDiff_T-1
# Margin_T ~ VolDiff_T-1 + Controls
# Margin_T ~ VolDiff_T-1 + Sentiment_T-1 + Controls
# Margin_T ~ VolDiff_T-1 + VolDiff_T-2 + VolDiff_T-3 + Controls

# no controls
fitMarginVol <- lm(Margin_Period~VolDiff_Period_Lag1,data= sgdf_data0430)

# margin on volume with controls
# Margin_T ~ Sentiment_T-1 + Controls 
fitMarginVolControls <- lm(Margin_Period_Lag1 ~ VolDiff_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# margin on volume and sentiment with controls
fitMarginVolSentControls <- lm(Margin_Period_Lag1 ~ VolDiff_Period_Lag1 + SentDiff_Period_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# margin on volume, multiple lags, with controls
# Margin_T ~ Volume_T-1 + Volume_T-2 + Volume_T-3 + Controls
fitMarginVolMultipleControls <- lm(Margin_Period_Lag1 ~ VolDiff_Period_Lag1 + VolDiff_Period_Lag2 + VolDiff_Period_Lag3 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)



##################################################
##################################################
# Table 6 Regressions
# Test: Margin/Game Events on Volume and Combined
##################################################
##################################################
# Result 6: Regression Table
# Margin_T ~ MarginTOT_T-1 + Controls
# Margin_T ~ SentTOT_T-1 + Controls
# Margin_T ~ VolDiffTOT_T-1 + Controls
# Margin_T ~ VolTOT_T-1 + MarginTOT_T-1 + SentTOT_T-1 + Controls

# Margin_T ~ MarginTOT_T-1 + Controls
fitMarginMarginTot <- lm(Margin_Period~Margin_TOT_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# Margin_T ~ SentTOT_T-1 + Controls
fitMarginSentTot <- lm(Margin_Period~SentDiff_Total_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# Margin_T ~ VolDiffTOT_T-1 + Controls
fitMarginVolTot <- lm(Margin_Period~VolDiff_Total_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

# # Margin_T ~ VolTOT_T-1 + MarginTOT_T-1 + SentTOT_T-1 + Controls
fitMarginVolTot <- lm(Margin_Period~SentDiff_Total_Lag1+ VolDiff_Total_Lag1 +  Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)

###################################################
			# End Regression Family 2 # 
###################################################

##################################################
##################################################
###########	    					 	##########
###########	    REGRESSION FAMILY 3 	##########
###########	    					 	##########
##################################################
##################################################


##################################################
##################################################
# Table 9 Regressions
# Test: Margin/Game Events on Volume and Combined
##################################################
##################################################
# Logistic Regressions
# Indc_Winning ~ Vegas_Line + Margin_T
# Indc_Winning ~ Vegas_Line + Margin_T + SentDiff_TOT_T
# Indc_Winning ~ Vegas_Line + Margin_T + VolDiff_TOT_T

# Indc_Winning ~ Vegas_Line + Margin_T
glm.Standard = glm(Winner ~ Vegas_Line + Margin_TOT, family=binomial(logit), data=sgdf_data0430)

# Indc_Winning ~ Vegas_Line + Margin_T + SentDiff_TOT_T
glm.Sentiment = glm(Winner~Vegas_Line + Margin_TOT + SentDiff_Total, family=binomial(logit), data=sgdf_data0430)

# Indc_Winning ~ Vegas_Line + Margin_T + VolDiff_TOT_T
glm.Volume =  glm(Winner~Vegas_Line + Margin_TOT + VolDiff_Total, family=binomial(logit), data=sgdf_data0430)

# Indc_Winning ~ Vegas_Line + Margin_T + VolDiff_TOT_T + SentDiff_TOT_T
glm.VolumeSentiment =  glm(Winner~Vegas_Line + Margin_TOT + VolDiff_Total + SentDiff_Total, family=binomial(logit), data=sgdf_data0430)

###################################################
			# End Regression Family 2 # 
###################################################











