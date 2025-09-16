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
    
    // if more than one covariates:
    matrix[n_all, n_covariates] x_all; // covariate matrix for both observed and censored events
    matrix[n_observed, n_covariates] x_observed; // covariate matrix for the observed
    matrix[n_censored, n_covariates] x_censored; // covariate matrix for the censored

    // if only one covariate:
    // vector[n_all] x_all; // covariate matrix for both observed and censored events
    // vector[n_observed] x_observed; // covariate matrix for the observed
    // vector[n_censored] x_censored; // covariate matrix for the censored
}

parameters {
    // if more than one covariates:
    vector[n_covariates] beta; // coefficients for covariates
    
    // if only one covariate:
    // real beta; // coefficients for covariates
}

model {
    vector[n_all] xbeta_all = x_all * beta;
    real log_denominator = 0;

    for (i in 1:n_all) {
        log_denominator = log_sum_exp(log_denominator, xbeta_all[i]);

        if (observed[i] == 1) {
            target += xbeta_all[i] - log_denominator;
        }   
    }

    beta ~ normal(0, 2);
}
