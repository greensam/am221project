## AM 221 Work (Empirics Section)
## David Freed and Samuel Green
## April 30, 2016

# Import the relevant library for the following section
library(leaps)

library(stargazer)

# Read in the relevant dataset
sgdf_data0430 = read.csv("tweetdata.csv", header=TRUE)
colnames(sgdf_data0430)

fit1 <- lm(Margin_Period ~ SentDiff_Period + SentDiff_Total +
             VolDiff_Total + OPA_Margin, data = sgdf_data0430)
summary(fit1)

# Question 1a: Prediction Margin based on prev period sentiments 
fitQ1ai <- lm(Margin_Period~SentDiff_Period_Lag1, data=sgdf_data0430)
summary(fitQ1ai)

# Add Controls
fitQ1aiControls <- lm(Margin_Period~SentDiff_Period_Lag1 + Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)
summary(fitQ1ai)

# Check if adding a second and third lags improves prediction
fitQ1aiiControls <- lm(Margin_Period~SentDiff_Period_Lag1 + SentDiff_Period_Lag2 + SentDiff_Period_Lag3 + Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430)
summary(fitQ1aiiControls)

# Check if Volume is predictive
fitVolume<- lm(Margin_Period~ VolDiff_Period_Lag1, data=sgdf_data0430)
summary(fitVolume)

# Check Volume + Controls
fitVolumeControls <- lm(Margin_Period~VolDiff_Period_Lag1 +Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430 )
summary(fitVolumeControls)

# check a model with volume and sentiment
# Margin_T ~ VolDiff_T-1 + VolDiff_T-2 + VolDiff_T-3 + Controls
fitVolumeandSent <- lm(Margin_Period~SentDiff_Period_Lag1 + VolDiff_Period_Lag1 +Vegas_Line + QualityDiff + TwitterDiff + Min_End, data=sgdf_data0430 )
summary(fitVolumeandSent)



#### 
fitQ1aiii <- lm(Margin_Period~SentDiff_Period_Lag1 + SentDiff_Period_Lag2 
                + SentDiff_Period_Lag3, data=sgdf_data0430)
summary(fitQ1aiii)

fitQ1aiv <- lm(Margin_Period~SentDiff_Period_Lag1 + SentDiff_Period_Lag2 
               + SentDiff_Period_Lag3 + SentDiff_Period_Lag4, data=sgdf_data0430)
summary(fitQ1aiv)

fitQ1av <- lm(Margin_Period~SentDiff_Period_Lag1 + SentDiff_Period_Lag2 
              + SentDiff_Period_Lag3 + SentDiff_Period_Lag4 
              + SentDiff_Period_Lag5, data=sgdf_data0430)
summary(fitQ1av)

# Question 1b: can we improve when adding previous margins? 
fitQ1b <- lm(Margin_Period~SentDiff_Period_Lag1 + Margin_Period_Lag1, data=sgdf_data0430)
summary(fitQ1b)

# answer: nope, not really, though sentiment stays predictive

# Question 1c: how does total sentiment up to previous period do
fitQ1c <- lm(Margin_Period~SentDiff_Total_Lag1, data=sgdf_data0430)
summary(fitQ1c)
# answer: total sentiment up to previous period not significant.
# Might have to do with how the statistic is formulated.

# Question 1d: does volume in the last period interact with sentiment
fitQ1d <- lm(Margin_Period~SentDiff_Total_Lag1 + VolDiff_Period_Lag1, data=sgdf_data0430)
summary(fitQ1d)
# not prediction 

# Is volume significant on its own?

# Answer: yep

# Control for difference in team quality
fitVolumeQuality<- lm(Margin_Period~VolDiff_Period_Lag1 + QualityDiff, data=sgdf_data0430)
summary(fitVolumeQuality)

# Control for Difference in Number of Followers
fitVolumeFollows<- lm(Margin_Period~VolDiff_Period_Lag1 + TwitterDiff, data=sgdf_data0430)
summary(fitVolumeFollows)

# Is Total Sentiment Predictive on its own? 
fitTotal <-lm(Margin_Period~SentDiff_Total_Lag1, data=sgdf_data0430)
summary(fitTotal)
# Answer: nope

# Question 4: How much does current margin predict the next period's margin? 
fit4 <- lm(Margin_Period~Margin_Period_Lag1, data=sgdf_data0430)
summary(fit4)
# As expected, previous 

# and just for shits, how about total on total
fitMarginTotal <- lm(Margin_TOT~Margin_TOT_Lag1, data=sgdf_data0430)
summary(fitMarginTotal)
# This is obvious and extremely predictive. Woo hoo, results. 

# Controls
fitQuality <- lm(Margin_Period~SentDiff_Period_Lag1 + QualityDiff,data=sgdf_data0430)
summary(fitQuality)

fitTwitter <- lm(Margin_Period~SentDiff_Period_Lag1 + TwitterDiff,data=sgdf_data0430)
summary(fitTwitter)

# Winner Prediction Model
nmins <- 40
firstHalfData <- sgdf_data0430[sgdf_data0430$Min_End < 3*nmins/2, ]

library(ggplot2)
# Both models on all time periods
glm.Standard = glm(Winner ~ Vegas_Line + Margin_TOT, family=binomial(logit), data=sgdf_data0430)
glm.Sentiment = glm(Winner~Vegas_Line + Margin_TOT + SentDiff_Total, family=binomial(logit), data=sgdf_data0430)
glm.Volume =  glm(Winner~Vegas_Line + Margin_TOT + VolDiff_Total, family=binomial(logit), data=sgdf_data0430)
glm.VolumeSentiment =  glm(Winner~Vegas_Line + Margin_TOT + VolDiff_Total + SentDiff_Total, family=binomial(logit), data=sgdf_data0430)

# Logistic Regression: Standard model, vegas line and total margin
resids = rep(NA, 39)
for (i in 5:39){
  subst = sgdf_data0430[sgdf_data0430$Min_End == i, ]
  glm.out = glm(Winner ~ Vegas_Line + Margin_TOT, family=binomial(logit), data=subst)
  coef(summary(glm.out))
  resids[i] = mean(resid(glm.out))
}
# Logistic Regression: Standard Model with Sentiment Difference Total
residSent = rep(NA, 39)
ps = rep(NA, 39)
for (i in 5:39){
  subst = sgdf_data0430[sgdf_data0430$Min_End == i, ]
  glm.out = glm(Winner ~ Vegas_Line + Margin_TOT + SentDiff_Total, family=binomial(logit), data=subst)
  ps[i] = coef(summary(glm.out))[3,4]
  residSent[i] = mean(resid(glm.out))
}
# plot(1:length(resids), resids)
# points(1:length(residSent), residSent, pch=2)
# plot(1:length(ps), ps, col='red' )
# lines(1:length(ps), ps)
# abline(coef=c(0.05,0), col='blue',lty=2)
which(ps < 0.05)
write.csv(ps, 'pvaluesSentDiffSignifance.csv')

df = data.frame(SentResid = residSent, StandardResid = resids)
write.csv(df, 'Residuals.csv',row.names=FALSE)

## Testing Volume Model against Standard
# Logistic Regression: Standard Model with Sentiment Difference Total
residVolume = rep(NA, 39)
for (i in 5:39){
  subst = sgdf_data0430[sgdf_data0430$Min_End == i, ]
  glm.out = glm(Winner ~ Vegas_Line + Margin_TOT + VolDiff_Total, family=binomial(logit), data=subst)
  residVolume[i] = mean(resid(glm.out))
}
df = data.frame(standards=resids, volume=residVolume, sent=residSent)
write.csv(df, 'VolumeSentResiduals.csv')


residCombined = rep(NA, 39)
ps = rep(NA, 39)
for (i in 5:39){
  subst = sgdf_data0430[sgdf_data0430$Min_End == i, ]
  glm.out = glm(Winner ~ Vegas_Line + Margin_TOT + VolDiff_Total + SentDiff_Total, family=binomial(logit), data=subst)
  residCombined[i] = mean(resid(glm.out))
}
df = data.frame(standards=resids, volume=residVolume, sent=residSent, combined=residCombined)
write.csv(df, 'CombinedResiduals.csv')


# Question 3
# Does Twitter volume result to big events (which we'll call magnitude of margin)
fitBigEvent <- lm(Vol_Total~abs(Margin_Period_Lag1), data=sgdf_data0430)
summary(fitBigEvent)
# answer with no controls: kind of. 

# what about when controlling for team followers
fitBigEvent <- lm(Vol_Total~abs(Margin_Period_Lag1) + Team1Twitter + Team2Twitter, data=sgdf_data0430)
summary(fitBigEvent)
# still kind of, which is a good sign! 

# What about total margin? 
fitBigEventTotal <- lm(Vol_Total~abs(Margin_TOT_Lag1), data=sgdf_data0430)
summary(fitBigEventTotal)

# Interactions with team twitter statistics? 
fitBigEventTotalTwitter <- lm(Vol_Total~abs(Margin_TOT) + Team1Twitter + Team2Twitter, data=sgdf_data0430)
summary(fitBigEventTotalTwitter)

# How about some lags
fitVolMarginLabs <- lm(Vol_Total~abs(Margin_Period) + abs(Margin_Period_Lag1) + abs(Margin_Period_Lag2), data=sgdf_data0430)
summary(fitVolMarginLabs)

# Sentiment Analysis Reactions
fitSentReact <- lm(SentDiff_Period ~ Margin_Period_Lag1, data=sgdf_data0430)
summary(fitSentReact)

# Sentiment Analysis Reaction, control for Tweet Volume in the same period
fitSentReact <- lm(SentDiff_Period ~ Margin_Period_Lag1 + Vol_Period, data=sgdf_data0430)
summary(fitSentReact)





