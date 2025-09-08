rm(list = ls())
source("./code/01_load_data.R")

# Levels of celltype: 1=squamous, 2=smallcell, 3=adeno, 4=large
d$cell_squamous <- ifelse(d$celltype == "squamous", 1, 0)
d$cell_small <- ifelse(d$celltype == "smallcell", 1, 0)
d$cell_adeno <- ifelse(d$celltype == "adeno", 1, 0)
d$cell_large <- ifelse(d$celltype == "large", 1, 0)
d$prior_therapy <- ifelse(d$prior == 10, 1, 0)
d$performance_score <- d$karno
d$disease_duration <- d$diagtime

d <- d[order(-d$time), ] # reorder d in descending order by time (for use in Stan)

covariates <- c("senior")
# covariates <- c("treat_chemo", "cell_squamous", "cell_small", "cell_adeno", "cell_large", "performance_score", "disease_duration", "age", "prior_therapy")

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
    x_all = d[, covariates],
    x_observed = d[d$status == 1, covariates],
    x_censored = d[d$status == 0, covariates]
)

fit_cox_covariates <- rstan::stan(
    file = "code/c02_fit_cox_covariates.stan",
    data = data_list,
    chains = 4,
    cores = 4,
    iter = 2000
)
