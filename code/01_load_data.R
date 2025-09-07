# Load necessary libraries and datasets
library(rstan)


# 1. survival ----
library(survival)
# https://www.rdocumentation.org/packages/survival/versions/3.8-3
# d <- aml # acute myelogenous leukemia
# d <- lung # survival in patients with advanced lung cancer from the North Central Cancer Treatment Group
d <- veteran # randomised trial of two treatment regimens for lung cancer
d$treat_chemo <- ifelse(d$trt == 2, 1, 0) # 1: chemotherapy, 0: standard treatment
d$senior <- ifelse(d$age >= 65, 1, 0) # 1: senior (age >= 65), 0: non-senior (age < 65)

# d$cell_squamous




# 2. KMsurv ----
# library(KMsurv) # Data sets from Klein and Moeschberger (1997), Survival Analysis
# https://www.rdocumentation.org/packages/KMsurv/versions/0.1-5
# interesting: rats, bfeed, baboon

# d <- rats