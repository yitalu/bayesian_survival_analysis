data {
    int<lower=0> n_all; // number of samples
    int<lower=0> n_observed; // number of observed events
    int<lower=0> n_censored; // number of censored events

    array[n_all] real t_all; // times for both observed and censored events
    array[n_observed] real t_observed; // times for observed events
    array[n_censored] real t_censored; // times for censored events
    
    array[n_all] int observed; // 1: event observed; 0: censored
    array[n_all] int censored; // 1: censored; 0: event observed

    int<lower=0> n_covariates; // number of covariates
    // matrix[n_observed, n_covariates] x_observed; // covariate matrix for the observed
    // matrix[n_censored, n_covariates] x_censored; // covariate matrix for the censored
    vector[n_observed] x_observed; // covariate matrix for the observed
    vector[n_censored] x_censored; // covariate matrix for the censored
}

parameters {
    // real<lower=0> lambda; // rate parameter for the exponential distribution
    // vector[n_covariates] beta; // coefficients for covariates
    real mu; # intercept
    real beta; // coefficients for covariates
}

model {
    // Likelihood for observed event times
    t_observed ~ exponential( exp(mu + x_observed * beta) );

    // Contribution of censored data to the likelihood
    for (j in 1:n_censored) {
        target += exponential_lccdf(t_censored[j] | exp(mu + x_censored[j] * beta));
    }

    // for (i in 1:n_all) {
    //     if (observed[i] == 1) {
    //         t_all[i] ~ exponential(lambda);
    //     }
    //     if (censored[i] == 1) {
    //         target += exponential_lccdf(t_all[i] | lambda);
    //     }
    // }

    // Prior for the rate parameter
    // lambda ~ lognormal(0, 1);
    // beta[1] ~ normal(0, 1);
    // beta[2] ~ normal(0, 2);
    mu ~ normal(0, 2);
    beta ~ normal(0, 2);
}
