data {
   int<lower=0> N_obs; // number of observations
   vector[N_obs] t_obs;
   int<lower=0> N_cen;
   vector[N_cen] t_cen;
}

parameters {
    real<lower=0> lambda;
}

model {
    t_obs ~ exponential(lambda);
    lambda ~ lognormal(0, 1);
    target += N_cen * exponential_lccdf(t_cen | lambda);
}
