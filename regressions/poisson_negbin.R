#install.packages("MASS")
library(MASS)
#install.packages("pscl")
library(pscl)
#install.packages("countreg")
library(countreg)
#install.packages("AER")
library(AER)
#install.packages("countreg", repos="http://R-Forge.R-project.org")
library(countreg)
#install.packages("blorr")
library(blorr)
#install.packages("rsq")
library(rsq)

getwd()
data <- read.csv("Documents/GitHub/strategy-business-models/datasets/final-df-count-models-2weeks.csv")
names(data)

# Descriptive statistics
summary(data)

# Look at mean and variance of y variable
mean(data$nr_reviews); var(data$nr_reviews)
var(data$nr_reviews)/mean(data$nr_reviews)

options(scipen = 999)

# Poisson coefficients
poisson <- glm(nr_reviews ~ user_sentiment_var*critic_sentiment_var + user_avg_grade + critic_avg_grade + critic_volume + is_action + is_pc,
               data=data, family='poisson')

summary(poisson)

# Visualize fit of poisson model
countreg::rootogram(poisson)

# Test for overdispersion (dispersion and alpha parameters) from AER package
dispersiontest(poisson)
dispersiontest(poisson, trafo=2)

# Negative binomial coefficients
negbin <- glm.nb(nr_reviews ~ user_sentiment_var*critic_sentiment_var + user_avg_grade + critic_avg_grade + critic_volume + is_action + is_pc,
                 data=data)
summary(negbin)

# Visualize fit of negative binomial model
countreg::rootogram(negbin)

# Checking model assumption
-2*(logLik(poisson)-logLik(negbin))
