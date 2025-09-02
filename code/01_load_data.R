# Load necessary libraries and datasets

# 1. survival ----
library(survival)
# https://www.rdocumentation.org/packages/survival/versions/3.8-3

d <- veteran # randomised trial of two treatment regimens for lung cancer
# d <- aml # acute myelogenous leukemia
# d <- lung # survival in patients with advanced lung cancer from the North Central Cancer Treatment Group




# 2. KMsurv ----
# library(KMsurv) # Data sets from Klein and Moeschberger (1997), Survival Analysis
# https://www.rdocumentation.org/packages/KMsurv/versions/0.1-5
# interesting: rats, bfeed, baboon

# d <- rats