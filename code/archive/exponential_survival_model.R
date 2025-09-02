library(rstan)
library(rethinking)
library(KMsurv)
data(rats)


# Data description
d <- rats
head(d)
colnames(d)
nrow(d)
View(d)
# time: Time to tumor development 
# tumor: Indicator of tumor development (1=yes, 0=no) 
# trt: Treatment (1=treated with drug, 0=given placebo) 
# litter: Litter (group of rats)


# Expected time to event: 10
dens(rexp(1e4, rate = 0.1))
mean(rexp(1e4, rate = 0.1))


# Expected time to event: 1
dens(rexp(1e4, rate = 1))
mean(rexp(1e4, rate = 1))

dens(rlnorm(1e4, meanlog = 0, sdlog = 1))


# Prepare data
d$censored <- ifelse(d$tumor == 1, 0, 1)

sum(d$censored == 0)
sum(d$censored == 1)

data_list <- list(
  N_obs = sum(d$censored == 0),
  t_obs = d$time[d$censored == 0],
  N_cen = sum(d$censored == 1),
  t_cen = d$time[d$censored == 1]
)

fit.1 <- rstan::stan(
    file = "code/exponential_survival_model.stan",
    data = data_list,
    chains = 4,
    core = 4,
    iter = 2000
)

summary(fit.1)
stan_plot(fit.1, pars = c("lambda"))

params <- extract(fit.1)
lambda <- params$lambda

dens(lambda) 

n_plot <- 100
dens(rexp(1e4, lambda[1]))

source("code/simulate_rats.R")

n <- 10
for (i in 1:n) {
    simulated_data <- simulate_rats(n = 1e3, lambda = lambda[i], censoring_time = 200)
    x <- sur
}
