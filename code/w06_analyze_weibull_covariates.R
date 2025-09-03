summary(fit_weibull_covariates)
print(fit_weibull_covariates, pars = c("alpha", "mu", "beta"))
print(fit_weibull_covariates, pars = c("sigma"))



library(gridExtra)
library(grid)
library(ggplot2)

# 
parameter_summary <- as.data.frame(summary(fit_weibull_covariates)$summary[c("alpha", "mu", "beta"), , drop = FALSE])
parameter_summary$Parameter <- rownames(parameter_summary)
parameter_summary <- parameter_summary[, c("Parameter", colnames(parameter_summary)[1:(ncol(parameter_summary)-1)])]
parameter_summary[ , -1] <- round(parameter_summary[ , -1], 3)

# Create table grob
table_grob <- tableGrob(parameter_summary, rows = NULL)

# Save as PNG
png("./figures/estimate_table_weibull_covariates.png", width = 1200, height = 200, res = 150)
grid.draw(table_grob)
dev.off()





png("./figures/estimate_barplot_weibull_covariates.png", width = 1200, height = 200, res = 150)
stan_plot(fit_weibull_covariates, pars = c("alpha", "mu", "beta"))
dev.off()


stan_trace(fit_weibull_covariates, pars = c("alpha", "mu", "beta"))

posterior_samples <- extract(fit_weibull_covariates)
alpha_posterior <- posterior_samples$alpha
mu_posterior <- posterior_samples$mu
beta_posterior <- posterior_samples$beta




n_individual <- 1000
n_simulation <- 50


# Posterior Distribution of Event Time
png("./figures/posterior_event_time_weibull_by_seniority.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 0.011), main = "Posterior Distribution of Event Time by Weibull Model", xlab = "Event Time", ylab = "Density")

for (i in 1:n_simulation) {
  
    scale_nonsenior <- exp( -(mu_posterior[i] + beta_posterior[i] * 0)/alpha_posterior[i] )
    scale_senior <- exp( -(mu_posterior[i] + beta_posterior[i] * 1)/alpha_posterior[i] )

    simulated_times_nonsenior <- rweibull(n_individual, shape = alpha_posterior[i], scale = scale_nonsenior)
    lines(density(simulated_times_nonsenior), lty=2, col = adjustcolor("lightblue", alpha = 0.8), lwd = 1)

    simulated_times_senior <- rweibull(n_individual, shape = alpha_posterior[i], scale = scale_senior)
    lines(density(simulated_times_senior), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)

}

legend("topright", inset = 0.02, legend = c("Non-Senior (Age < 65)", "Senior (Age ≥ 65)"), col = c(adjustcolor("lightblue", alpha = 1), adjustcolor("#faa3b2", alpha = 1)), lty=c(2, 2), lwd = 2, cex = 1)

grid()

dev.off()



# Survival Curve by Treatment: Chemotherapy vs Standard Treatment ----
png("./figures/posterior_survival_weibull_by_treatment.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1), main = "Posterior Predictive Survival Curve by Weibull Model", xlab = "Time", ylab = "Survival")

for (i in 1:n_simulation) {

    scale_standard <- exp( -(mu_posterior[i] + beta_posterior[i] * 0)/alpha_posterior[i] )
    scale_chemo <- exp( -(mu_posterior[i] + beta_posterior[i] * 1)/alpha_posterior[i] )

    simulated_times_standard <- rweibull(n_individual, shape = alpha_posterior[i], scale = scale_standard)
    lines(survfit(Surv(simulated_times_standard) ~ 1), lty=2, col = adjustcolor("lightblue", alpha = 0.8), lwd = 1)

    simulated_times_chemo <- rweibull(n_individual, shape = alpha_posterior[i], scale = scale_chemo)
    lines(survfit(Surv(simulated_times_chemo) ~ 1), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)
    
}

KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ treat_chemo, data = d)
list(KM_curve_veteran)

lines(KM_curve_veteran[1]$time, KM_curve_veteran[1]$surv, col = "#47b2d5", lwd = 2)

lines(KM_curve_veteran[2]$time, KM_curve_veteran[2]$surv, col = "#f45e77", lwd = 2)

legend("topright", inset = 0.02, legend = c("Predicted Survival for Chemotherapy", "Predicted Survival for Standard Treatment", "Observed Survival for Chemotherapy", "Observed Survival for Standard Treatment"), col=c(adjustcolor("#faa3b2", alpha = 1), adjustcolor("lightblue", alpha = 1), "#f45e77", "#47b2d5"), lty=c(2, 2, 1, 1), lwd = c(2, 2, 2, 2), cex=1)

grid()
dev.off()





# Survival Curve by Age Group: Seniors (age >= 65) vs Non-Seniors (age < 65) ----
png("./figures/posterior_survival_weibull_by_seniority.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1), main = "Posterior Predictive Survival Curve by Weibull Model", xlab = "Time", ylab = "Survival")

for (i in 1:n_simulation) {

    scale_nonsenior <- exp( -(mu_posterior[i] + beta_posterior[i] * 0)/alpha_posterior[i] )
    scale_senior <- exp( -(mu_posterior[i] + beta_posterior[i] * 1)/alpha_posterior[i] )

    simulated_times_nonsenior <- rweibull(n_individual, shape = alpha_posterior[i], scale = scale_standard)
    lines(survfit(Surv(simulated_times_nonsenior) ~ 1), lty=2, col = adjustcolor("lightblue", alpha = 0.8), lwd = 1)

    simulated_times_senior <- rweibull(n_individual, shape = alpha_posterior[i], scale = scale_senior)
    lines(survfit(Surv(simulated_times_senior) ~ 1), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)
    
}

KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ aged65, data = d)
list(KM_curve_veteran)

lines(KM_curve_veteran[1]$time, KM_curve_veteran[1]$surv, col = "#47b2d5", lwd = 2)

lines(KM_curve_veteran[2]$time, KM_curve_veteran[2]$surv, col = "#f45e77", lwd = 2)

legend("topright", inset = 0.02, legend = c("Predicted Survival for Seniors (Age ≥ 65)", "Predicted Survival for Non-Seniors (Age < 65)", "Observed Survival for Seniors (Age ≥ 65)", "Observed Survival for Non-Seniors (Age < 65)"), col=c(adjustcolor("#faa3b2", alpha = 1), adjustcolor("lightblue", alpha = 1), "#f45e77", "#47b2d5"), lty=c(2, 2, 1, 1), lwd = c(2, 2, 2, 2), cex=1)

grid()
dev.off()