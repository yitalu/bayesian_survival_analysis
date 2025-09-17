summary(fit_cox_covariates, par = "beta")
print(fit_cox_covariates, par = "beta")
stan_trace(fit_cox_covariates, pars = c("beta"))

library(gridExtra)
library(grid)
library(ggplot2)

# Coefficient summary table
beta_summary <- as.data.frame(summary(fit_cox_covariates)$summary[paste0("beta[", 1:9, "]"), , drop = FALSE])
# beta_summary$Parameter <- covariates # see ./code/c01_fit_cox_covariates.R
beta_summary$Parameter <- c("Chemotherapy", "Squamous Cell", "Small Cell", "Adeno Cell", "Large Cell", "Performance Score", "Disease Duration", "Age", "Prior Therapy")
beta_summary <- beta_summary[, c("Parameter", colnames(beta_summary)[1:(ncol(beta_summary)-1)])]
beta_summary[ , -1] <- round(beta_summary[ , -1], 2)

# Create table grob
table_grob <- tableGrob(beta_summary, rows = NULL)

# Save as PNG
png("./figures/estimate_table_cox_covariates.png", width = 1200, height = 500, res = 150)
grid.draw(table_grob)
dev.off()



# Bar plot of coefficients
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




# Hazard ratios
# Exponentiate the coefficients to get hazard ratios

hazard_ratios <- data.frame(
    Parameter = beta_summary$Parameter
)
hazard_ratios$`Hazard Ratio` <- exp(beta_summary$mean)
hazard_ratios$`Lower 2.5%` <- exp(beta_summary$`25%`)
hazard_ratios$`Upper 97.5%` <- exp(beta_summary$`97.5%`)
hazard_ratios[ , -1] <- round(hazard_ratios[ , -1], 2)


# Create table grob
table_grob_hr <- tableGrob(hazard_ratios, rows = NULL)


# Save the table as PNG
png("./figures/estimate_table_cox_hazard_ratios.png", width = 1200, height = 500, res = 150)
grid.draw(table_grob_hr)
dev.off()



# Bar plot of hazard ratios
png("./figures/estimate_barplot_cox_hazard_ratios.png", width = 1200, height = 500, res = 150)
posterior_samples <- as.matrix(fit_cox_covariates, pars = paste0("beta[", 1:9, "]"))
hazard_ratio_samples <- exp(posterior_samples)

bayesplot::mcmc_intervals(
    hazard_ratio_samples, 
    pars = paste0("beta[", 9:1, "]")
) + scale_y_discrete(
    labels = rev(c("Chemotherapy", "Squamous Cell", "Small Cell", "Adeno Cell", "Large Cell", "Performance Score", "Disease Duration", "Age", "Prior Therapy"))
) + theme(panel.grid.major = element_line(color = "grey90", size = 0.5))

dev.off()

