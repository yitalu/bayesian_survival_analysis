library(rstan)

d <- veteran # randomised trial of two treatment regimens for lung cancer
# View(d)
colnames(d)


# covariates <- c("treat_chemo", "age")
covariates <- c("treat_chemo")
covariates <- c("senior")

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

fit_exponential_covariates <- rstan::stan(
    file = "code/e05_fit_exponential_covariates.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)
