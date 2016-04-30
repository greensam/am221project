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

# None of these add significance
fitQ1aii <- lm(Margin_Period~SentDiff_Period_Lag1 + SentDiff_Period_Lag2, data=sgdf_data0430)
summary(fitQ1aii)

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
fitVolume<- lm(Margin_Period~ VolDiff_Period_Lag1, data=sgdf_data0430)
summary(fitVolume)
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
firstHalfData <- sgdf_data0430[sgdf_data0430$Min_End < nmins/2, ]

# Logistic Regression of Winner
glm.out = glm(Winner ~ Age, family=binomial(logit), data=menarche)









