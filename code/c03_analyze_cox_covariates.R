summary(fit_cox_covariates, par = "beta")
print(fit_cox_covariates, par = "beta")
stan_trace(fit_cox_covariates, pars = c("beta"))

library(gridExtra)
library(grid)
library(ggplot2)

# 
beta_summary <- as.data.frame(summary(fit_cox_covariates)$summary[paste0("beta[", 1:9, "]"), , drop = FALSE])
# beta_summary$Parameter <- covariates # see ./code/c01_fit_cox_covariates.R
beta_summary$Parameter <- c("Chemotherapy", "Squamous Cell", "Small Cell", "Adeno Cell", "Large Cell", "Performance Score", "Disease Duration", "Age", "Prior Therapy")
beta_summary <- beta_summary[, c("Parameter", colnames(beta_summary)[1:(ncol(beta_summary)-1)])]
beta_summary[ , -1] <- round(beta_summary[ , -1], 3)

# Create table grob
table_grob <- tableGrob(beta_summary, rows = NULL)

# Save as PNG
png("./figures/estimate_table_cox_covariates.png", width = 1300, height = 500, res = 150)
grid.draw(table_grob)
dev.off()

library(bayesplot)


png("./figures/estimate_barplot_cox_covariates.png", width = 1200, height = 500, res = 150)
# stan_plot(fit_cox_covariates, pars = c("beta[1]", "beta[2]", "beta[3]", "beta[4]", "beta[5]", "beta[6]", "beta[7]", "beta[8]", "beta[9]"))

posterior_samples <- as.matrix(fit_cox_covariates, pars = paste0("beta[", 1:9, "]"))

bayesplot::mcmc_intervals(
    posterior_samples, 
    pars = paste0("beta[", 9:1, "]")
) + scale_y_discrete(
    labels = rev(c("Chemotherapy", "Squamous Cell", "Small Cell", "Adeno Cell", "Large Cell", "Performance Score", "Disease Duration", "Age", "Prior Therapy"))
) + theme(panel.grid.major = element_line(color = "grey90", size = 0.5))

dev.off()









posterior_samples <- extract(fit_cox_covariates)
beta_posterior <- posterior_samples$beta
hazard_ratio_posterior <- exp(beta_posterior)
summary(beta_posterior)
summary(hazard_ratio_posterior)

plot(density(hazard_ratio_posterior))


# Estimating the baseline survival function
KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ senior, data = d)

cox_curve_veteran <- coxph(Surv(time = d$time, event = d$status, type = "right") ~ senior, data = d)

list(KM_curve_veteran)
summary(KM_curve_veteran[1])

list(cox_curve_veteran)

plot(KM_curve_veteran[1])
plot(survfit(cox_curve_veteran))

