summary(fit_cox_covariates, par = "beta")
print(fit_cox_covariates, par = "beta")
stan_trace(fit_cox_covariates, pars = c("beta"))

library(gridExtra)
library(grid)
library(ggplot2)

# 
beta_summary <- as.data.frame(summary(fit_cox_covariates)$summary[c("beta"), , drop = FALSE])
beta_summary$Parameter <- rownames(beta_summary)
beta_summary <- beta_summary[, c("Parameter", colnames(beta_summary)[1:(ncol(beta_summary)-1)])]
beta_summary[ , -1] <- round(beta_summary[ , -1], 3)

# Create table grob
table_grob <- tableGrob(beta_summary, rows = NULL)

# Save as PNG
png("./figures/estimate_table_cox_covariates.png", width = 1300, height = 200, res = 150)
grid.draw(table_grob)
dev.off()

png("./figures/estimate_barplot_cox_covariates.png", width = 1200, height = 200, res = 150)
stan_plot(fit_cox_covariates, pars = c("beta"))
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
lines(cox_curve_veteran)
