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
    // vector[n_covariates] beta; // coefficients for covariates
    real beta; // coefficients for covariates
}

model {
    vector[n_observed] x_beta_observed = x_observed * beta;
    vector[n_censored] x_beta_cencored = x_censored * beta;

    for (i in )
}