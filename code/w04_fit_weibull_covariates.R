library(survival)
library(rstan)

d <- veteran # randomised trial of two treatment regimens for lung cancer
# View(d)
colnames(d)

d$treat_chemo <- ifelse(d$trt == 2, 1, 0) # 1: chemotherapy, 0: standard treatment
d$aged65 <- ifelse(d$age >= 65, 1, 0) # 1: age >= 65, 0: age < 65

# covariates <- c("treat_chemo", "age")
covariates <- c("treat_chemo")
covariates <- c("aged65")

data_list <- list(
    n_all = nrow(d),
    n_observed = sum(d$status == 1),
    n_censored = sum(d$status == 0),
    t_all = d$time,
    t_observed = d$time[d$status == 1],
    t_censored = d$time[d$status == 0],
    observed = d$status,
    censored = ifelse(d$status == 1, 0, 1),
    n_covariates = length(covariates),
    x_observed = d[d$status == 1, covariates],
    x_censored = d[d$status == 0, covariates]
)

fit_weibull_covariates <- rstan::stan(
    file = "code/10_fit_weibull_covariates.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)
