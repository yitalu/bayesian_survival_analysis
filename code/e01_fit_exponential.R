library(rstan)

# data_list <- list(
#     n_observed = sum(d$status == 1),
#     t_observed = d$time[d$status == 1],
#     n_censored = sum(d$status == 0),
#     t_censored = d$time[d$status == 0]
# )

data_list <- list(
    n_all = nrow(d),
    n_observed = sum(d$status == 1),
    n_censored = sum(d$status == 0),
    t_all = d$time,
    t_observed = d$time[d$status == 1],
    t_censored = d$time[d$status == 0],
    observed = d$status,
    censored = ifelse(d$status == 1, 0, 1)
)

fit_exponential <- rstan::stan(
    file = "code/e02_fit_exponential.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)
