# Load necessary libraries and datasets for survival analysis

# 1. Data from survival package ----
library(survival)
# https://www.rdocumentation.org/packages/survival/versions/3.8-3


# d <- aml # acute myelogenous leukemia
d <- veteran # randomised trial of two treatment regimens for lung cancer
# d <- lung # survival in patients with advanced lung cancer from the North Central Cancer Treatment Group
# View(d)


# 2. Data from KMsurv package ----
library(KMsurv) # Data sets from Klein and Moeschberger (1997), Survival Analysis
# https://www.rdocumentation.org/packages/KMsurv/versions/0.1-5
# interesting: rats, bfeed, baboon

d <- rats
View(d)




# 3. Data from rethinking package ----
library(rethinking)
# data(AustinCats)
# d <- AustinCats