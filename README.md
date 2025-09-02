# Bayesian Survival Analysis with Stan

## Overview
This repository introduces Bayesian Survival Analysis using R and Stan. While frequentist survival analysis is well-documented, Bayesian methods, especially those implemented with Stan, are less commonly covered. This project addresses that gap by demonstrating exploratory analysis with standard packages and datasets, including Kaplan-Meier curves, followed by Bayesian implementations of parametric survival models such as Weibull and Exponential, as well as semi-parametric Cox proportional hazards models using Stan.

The project utilizes a very common dataset `veteran` from the `survival` package in R, which contains data on lung cancer patients. The dataset includes variables such as treatment type (chemotheory vs standard), age, cell type, and survival time, etc. For more details, refer to the documentation of the `survival` package.




<br>

## Kaplan-Meier Survival Curves
Kaplan-Meier survival curves visualize survival probabilities over time. The curves can also compare survival between different groups, such as treatment types. Using the veteran dataset, three Kaplan-Meier curves are plotted: overall survival, survival by treatment type (chemotherapy vs standard), and survival by age group (senior vs non-senior, with the threshold at age 65). These plots are generated using the `Surv` object and `survfit` function from the `survival` packages in R, and the code can be found in [02_plot_km_curve.R](code/02_plot_km_curve.R).

<p align="center">
    <img src="./figures/km_curve_all.png" alt="Kaplan-Meier Survival Curve" width="30%">
    <img src="./figures/km_curve_treatment.png" alt="Kaplan-Meier Survival Curves by Treatment" width="30%">
    <img src="./figures/km_curve_seniority.png" alt="Kaplan-Meier Survival Curves by Seniority" width="30%">
</p>




<br>

## Exponential Model

Exponential survival models are the most basic parametric survival models that assume a constant hazard rate over time. The model is defined as:

$$ S(t) = e^{-\lambda t} $$
$$ h(t) = \lambda $$

where $S(t)$ is the survival function, $h(t)$ is the hazard function, and $\lambda$ is the rate parameter.

In Stan code [04_fit_exponential.stan](code/04_fit_exponential.stan), the observed survival times are modeled using an exponential distribution,

$$t_{observed} \sim Exponential(\lambda),$$

with prior

$$ \lambda \sim LogNormal(0, 1). $$

<br>

The likelihood is specified as:

$$ \space p(\space t_{obs}, t_{cen}, N_{cen} \space | \space \lambda) = \prod_{n_{obs}=1}^{N_{obs}} exp(t_{obs} | \lambda) \space \prod_{n_{cen}=1}^{N_{cen}} (1 - F_{T}(t_{cen} | \lambda)) ,$$

where $t_{obs}$ are the observed survival times, $t_{cen}$ are the censored survival times, $N_{obs}$ and $N_{cen}$ are the number of observed and censored data points, and $F_{T}(t_{cen} | \lambda)$ is the cumulative distribution function (CDF) of the exponential distribution evaluated at the censored times.

Taking logarithm of the likelihood, we have:

$$ \space log \space p(\space t_{obs}, t_{cen}, N_{cen} \space | \space \lambda) = \sum_{n_{obs}=1}^{N_{obs}} log(exp(t_{obs} | \lambda)) + \sum_{n_{cen}=1}^{N_{cen}} log(1 - F_{T}(t_{cen} | \lambda)), $$

which belongs to the model block in Stan code [04_fit_exponential.stan](code/04_fit_exponential.stan).

(*Note: In Stan user guide, there is only one cencoring time while in reality, we usually have multiple censored times. Therefore, we need to specify a vector of censored times and loop through them to calculate the log-likelihood contribution from each censored time.*)

