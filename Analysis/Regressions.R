## AM 221 Work (Empirics Section)
## David Freed and Samuel Green
## April 30, 2016

# Import the relevant library for the following section
library(leaps)

library(stargazer)

# Read in the relevant dataset
sgdf_data0430 = read.csv("tweetdata.csv", header=TRUE)
colnames(sgdf_data0430)

fit1 <- lm(Margin_Period ~ SentDiff_Period + SentDiff_Total + VolDiff_Total + OPA_Margin, data = sgdf_data0430)
summary(fit1)

fit2 <- lm(Margin_Period ~ )

Margin_TOT
VolDiff_Period