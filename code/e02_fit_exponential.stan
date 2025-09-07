data {
    int<lower=0> n_all; // number of samples
    int<lower=0> n_observed; // number of observed events
    int<lower=0> n_censored; // number of censored events

    array[n_all] real t_all; // times for both observed and censored events
    array[n_observed] real t_observed; // times for observed events
    array[n_censored] real t_censored; // times for censored events
    
    array[n_all] int observed; // 1: event observed; 0: censored
    array[n_all] int censored; // 1: censored; 0: event observed
}

parameters {
    real<lower=0> lambda; // rate parameter for the exponential distribution
}

model {
    // Likelihood for observed event times
    t_observed ~ exponential(lambda);

    // Contribution of censored data to the likelihood
    for (j in 1:n_censored) {
        target += exponential_lccdf(t_censored[j] | lambda);
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
    lambda ~ lognormal(0, 1);
}
