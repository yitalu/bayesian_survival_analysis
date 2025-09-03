# Bayesian Survival Analysis with Stan

## Overview
This repository introduces Bayesian Survival Analysis using R and Stan. While frequentist survival analysis is well-documented, Bayesian methods, especially those implemented with Stan, are less commonly covered. This project addresses that gap by demonstrating exploratory analysis with standard packages and datasets, including Kaplan-Meier curves, followed by Bayesian implementations of parametric survival models such as Weibull and Exponential, as well as semi-parametric Cox proportional hazards models using Stan.

The project utilizes a very common dataset `veteran` from the `survival` package in R, which contains data on lung cancer patients. The dataset includes variables such as treatment type (chemotheory vs standard), age, cell type, and survival time, etc. For more details, refer to the documentation of the `survival` package.




<br>

## Kaplan-Meier Survival Curves
Kaplan-Meier survival curves visualize survival probabilities over time. The curves can also compare survival between different groups, such as treatment types. Using the veteran dataset, three Kaplan-Meier curves are plotted: overall survival, survival by treatment type (chemotherapy vs standard), and survival by age group (senior vs non-senior, with the threshold at age 65). These plots are generated using the `Surv` object and `survfit` function from the `survival` packages in R, and the code can be found in [02_plot_km_curve.R](code/02_plot_km_curve.R).

<p align="center">
    <img src="./figures/km_curve_all.png" alt="Kaplan-Meier Survival Curve" width="49%">
    <img src="./figures/km_curve_treatment.png" alt="Kaplan-Meier Survival Curves by Treatment" width="49%">
    <img src="./figures/km_curve_seniority.png" alt="Kaplan-Meier Survival Curves by Seniority" width="49%">
</p>




<br>

## Exponential Model

### The Model
Exponential survival models are the most basic parametric survival models that assume a constant hazard rate over time. The survival function and the hazard function are defined, respectively, as $S(t) = exp(-\lambda t)$ and $h(t) = \lambda$, where $\lambda$ is the rate parameter.

In [e01_fit_exponential.stan](code/e01_fit_exponential.stan), the observed survival time is modeled using an exponential distribution,

$$t_{obs} \sim Exponential(\lambda),$$

with prior

$$ \lambda \sim LogNormal(0, 1). $$

<br>

The Stan user guide provides tips on how to code the likelihood function for an exponential model. However, it uses a common censoring time for all cencored individuals, which is usually not the case. A modified version is followed and can be found in my Stan code [e01_fit_exponential.stan](code/e01_fit_exponential.stan).

Instead of a single cencoring time, $t_{cen}$, we need different cencoring times for different individuals, denoted as $t_{cen, \space j}$, $j = 1, 2, ..., N_{cen}$. For the observed event times, we keep the same notation, $t_{obs, \space i}$, $i = 1, 2, ..., N_{obs}$. The likelihood is then specified as 

$$ \space p(\space t_{obs}, t_{cen}, N_{obs}, N_{cen} \space | \space \lambda) = \prod_{i=1}^{N_{obs}} exp(t_{obs, \space i} | \lambda) \space \prod_{j=1}^{N_{cen}} (1 - F_{T}(t_{cen, \space j} | \lambda)) ,$$

where $F_{T}(t_{cen} | \lambda)$ is the cumulative distribution function (CDF) of the exponential distribution evaluated at the censored times.

Taking logarithm of the likelihood, we have:

$$ \space log \space p(\space t_{obs, \space i}, t_{cen, \space j}, N_{obs}, N_{cen} \space | \space \lambda) = \sum_{i=1}^{N_{obs}} log \space [\space exp(t_{obs, \space i} | \lambda) \space] + \sum_{j=1}^{N_{cen}} log \space [ \space 1 - F_{T}(t_{cen, \space j} | \lambda) \space]. $$

which belongs to the model block in the Stan script.



<br>

### The Estimates
The model produces a posterior sample for the $\lambda$ parameter, with a mean $0.008$ and a $95\%$ credible interval between $0.007$ and $0.009$.

<p align="center">
    <img src="./figures/estimate_table_exponential.png" alt="Estimate Table Exponential" width="45%">
</p>

<p align="center">
    <img src="./figures/estimate_barplot_exponential.png" alt="Estimate Barplot Exponential" width="45%">
</p>

Using this sample of the $\lambda$ parameter, we can also plot the posterior distribution of event time and a posterior survival curve:

<p align="center">
    <img src="./figures/posterior_event_time_exponential.png" alt="Posterior Event Time Exponential" width="49%">
    <img src="./figures/posterior_survival_exponential.png" alt="Posterior Survival Curve Exponential" width="49%">
</p>



<br>

### Exponential Model with Covariates
From the [Kaplan-Meier Survival Curves](#kaplan-meier-survival-curves) section, we can tell that senior and non-senior patients have distinct survival probabilities. Here we estimate the respective survival curve for each of the age group by linking the covariate *senior* (see the beginning part of the R code [02_plot_km_curve.R](02_plot_km_curve.R)) to the rate parameter:

$$ \lambda = exp( \mu  + X \cdot \beta ),$$

where $\mu$ and $\beta$ have priors

$$\mu \sim Normal(0, \space 2),$$
$$\beta \sim Normal(0, \space 2).$$

<br>
This applies to both the observed and cencored covariate. Thus,

$$t_{obs} \sim Exponential(\space exp( \mu  + X_{obs} \cdot \beta ) \space),$$

and the cumulative distribution function in the likelihood

$$F_{T} = (\space t_{cen} \space | \space exp( \mu  + X_{cen} \cdot \beta ) \space).$$



### The Estimates of Age Effect
The estimates of the parameter $\mu$ and $\beta$ are shown in the below table and bar plot.

<p align="center">
    <img src="./figures/estimate_table_exponential_covariates.png" alt="Estimate Table Exponential" width="45%">
</p>

<p align="center">
    <img src="./figures/estimate_barplot_exponential_covariates.png" alt="Estimate Table Exponential" width="45%">
</p>

From these estimates, we can obtain the posterior distributions of event time and posterior survival curves for both the non-senior and senior age group accordingly:

<p align="center">
    <img src="./figures/posterior_event_time_exponential_by_seniority.png" alt="Estimate Table Exponential" width="49%">
    <img src="./figures/posterior_survival_exponential_by_seniority.png" alt="Estimate Table Exponential" width="49%">
</p>




<br>

## Weibull Model

### The Model
The Weibull model is in fact a more general form of the exponential model. It has a hazard function $h(t) = \lambda \alpha t^{\alpha - 1}$ and a survival function $S(t) = exp(-\lambda t^{\alpha})$, in which the shape parameter $\alpha$ can take any positive value, capturing a varying hazard (increasing, decreasing, or being constant) over time. When $\alpha = 1$, the hazard and survival functions reduce to their exponential counterpart introduced in the [Exponential Model](#exponential-model) section.

Due to this flexibility, in our `veteran` case, the Weibull model fits the data better than the basic exponential model as you will see. The survival time is modeled as

$$t_{obs} \sim Weibull(\alpha, \sigma),$$

in which the Weibull distribution takes the form

$$ \frac{\alpha}{\sigma} (\frac{t}{\sigma})^{\alpha - 1} exp [-(\frac{t}{\sigma})^{\alpha}]. $$

Note this looks somewhat different from the product of the hazard and survival functions laid out before, but it is just the same thing in disguise. We follow this later form because it is what is actually implemented in both R and Stan functions, making us easier to make sense of the choice of the parameters.

Again, the likelihood part needs some cares as we have different cencoring times for different individuals. By the same notations in [Exponential Model](#the-model), the likelihood function is

$$ \space p(\space t_{obs}, t_{cen}, N_{obs}, N_{cen} \space | \space \alpha, \sigma) = \prod_{i=1}^{N_{obs}} exp(t_{obs, \space i} | \alpha, \sigma) \space \prod_{j=1}^{N_{cen}} (1 - F_{T}(t_{cen, \space j} | \alpha, \sigma)) ,$$

with the logarithm

$$ \space log \space p(\space t_{obs, \space i}, t_{cen, \space j}, N_{obs}, N_{cen} \space | \space \alpha, \sigma) = \sum_{i=1}^{N_{obs}} log \space [\space exp(t_{obs, \space i} | \alpha, \sigma) \space] + \sum_{j=1}^{N_{cen}} log \space [ \space 1 - F_{T}(t_{cen, \space j} | \alpha, \sigma) \space]. $$

This looks scary but it is rather straightforward when calling written functions in R and Stan, as in [w02_fit_weibull.stan](code/w02_fit_weibull.stan) and [w03_analyze_weibull.R](code/w03_analyze_weibull.R).



<br>

### The Estimates
Using priors $\alpha \sim LogNormal(0, 1)$ and $\sigma \sim LogNormal(0, 10)$, the Weibull model produces the estimates

<p align="center">
    <img src="./figures/estimate_table_weibull.png" alt="Estimate Table Weibull" width="45%">
</p>

<p align="center">
    <img src="./figures/estimate_barplot_weibull.png" alt="Estimate Table Weibull" width="45%">
</p>

<br>

The posterior distribution of event time and the posterior survival curve can then be graphed according to the above samples of $\alpha$ and $\sigma$

<p align="center">
    <img src="./figures/posterior_event_time_weibull.png" alt="Posterior Event Time Weibull" width="49%">
    <img src="./figures/posterior_survival_weibull.png" alt="Posterior Survival Curve Weibull" width="49%">
</p>

With the flexibility brought by the $\alpha$ parameter, the posterior survival curve by Weibull model fits the observed survival curve better than by the [exponential model](#the-estimates).



<br>

## Weibull Model with Covariates
As in the [Exponential Model with Covariates](#exponential-model-with-covariates) section, we can estimate a survival curve for each of the age group similarly. This can be done by linking the covariate to the $\sigma$ parameter in the Weibull distribution function:

$$
\sigma = exp( \mu  + X \cdot \beta ),$$

where $\mu$ and $\beta$ have priors

$$\mu \sim Normal(-4, \space 2),$$
$$\beta \sim Normal(0, \space 2).$$

And again, this applies to both the observed and cencored covariate, hence

$$t_{obs} \sim Weibull(\alpha, \space exp( \mu  + X_{obs} \cdot \beta ) \space)$$

and

$$F_{T} = (\space t_{cen} \space | \alpha, \space exp( \mu  + X_{cen} \cdot \beta ) \space),$$

where $F_{T}$ stands for the cumulative distribution function.





<br>

### The Estimated Age Effect
<p align="center">
    <!-- <img src="./figures/posterior_event_time_weibull_by_seniority.png" alt="Estimate Table Exponential" width="49%"> -->
    <img src="./figures/posterior_survival_weibull_by_seniority.png" alt="Posterior Survival Curve Exponential" width="49%">
</p>















<br>

<!-- ## Cox Proportional Hazard Model
[CONTENT TO BE ADDED SOON.] -->