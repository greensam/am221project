## AM 221 Work (Empirics Section)
## David Freed and Samuel Green
## April 30, 2016

# Import the relevant library for the following section
install.packages('leaps')
library(leaps)

install.packages('stargazer')
library(stargazer)

# Read in the relevant dataset
sgdf_data0430 = read.csv("~/Dropbox/School/Harvard 15-16/Applied Mathematics 221/Final Project/am221project/Analysis/tweetdata.csv", header=TRUE)
colnames(sgdf_data0430)

fit1 <- lm(Margin_Period ~ SentDiff_Period + SentDiff_Total + VolDiff_Total + OPA_Margin, data = sgdf_data0430)
summary(fit1)

Margin_TOT
VolDiff_Period