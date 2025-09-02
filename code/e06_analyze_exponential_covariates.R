summary(fit_exponential_covariates)
print(fit_exponential_covariates, pars = c("mu", "beta"))

stan_plot(fit_exponential_covariates, pars = c("mu", "beta"))
stan_trace(fit_exponential_covariates, pars = c("mu", "beta"))

posterior_samples <- extract(fit_exponential_covariates)
# beta_1_posterior <- posterior_samples$beta[,1]
# beta_2_posterior <- posterior_samples$beta[,2]
mu_posterior <- posterior_samples$mu
beta_posterior <- posterior_samples$beta

# png("./figures/post_dist_lambda.png", width = 1800, height = 1200, res = 150)
plot(density(beta_posterior), main = "Posterior Distribution of Effect for Chemotherapy", xlab = "Beta 1", col = "pink", lwd = 2)
grid()
# dev.off()


# png("./figures/post_dist_event_time.png", width = 1800, height = 1200, res = 150)
plot(density( rexp(1000, rate = exp(mean(mu_posterior) + 1 * mean(beta_posterior))) ), main = "Posterior Distribution of Event Time", xlab = "Event Time", col = "#f45e77", lwd = 2)
lines(density( rexp(1000, rate = exp(mean(mu_posterior) + 0 * mean(beta_posterior))) ), main = "Posterior Distribution of Event Time", xlab = "Event Time", col = "#47b2d5", lwd = 2)
grid()
# dev.off()







n_individual <- 1000
n_simulation <- 50

# By Treatment: Chemotherapy vs Standard Treatment ----

png("./figures/posterior_survival_exponential_by_treatment.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1), main = "Posterior Predictive Survival Curve by Exponential Model", xlab = "Time", ylab = "Survival")

for (i in 1:n_simulation) {

  rate_standard <- exp(mu_posterior[i] + beta_posterior[i] * 0) # assuming median age

  rate_chemo <- exp(mu_posterior[i] + beta_posterior[i] * 1) # assuming median age

  simulated_times_standard <- rexp(n_individual, rate = rate_standard)
  lines(survfit(Surv(simulated_times_standard) ~ 1), lty=2, col = adjustcolor("lightblue", alpha = 0.8), lwd = 1)

  simulated_times_chemo <- rexp(n_individual, rate = rate_chemo)
  lines(survfit(Surv(simulated_times_chemo) ~ 1), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)

}

KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ treat_chemo, data = d)
list(KM_curve_veteran)

lines(KM_curve_veteran[1]$time, KM_curve_veteran[1]$surv, col = "#47b2d5", lwd = 2)

lines(KM_curve_veteran[2]$time, KM_curve_veteran[2]$surv, col = "#f45e77", lwd = 2)

legend("topright", inset = 0.02, legend = c("Predicted Survival for Chemotherapy", "Predicted Survival for Standard Treatment", "Observed Survival for Chemotherapy", "Observed Survival for Standard Treatment"), col=c(adjustcolor("#faa3b2", alpha = 1), adjustcolor("lightblue", alpha = 1), "#f45e77", "#47b2d5"), lty=c(2, 2, 1, 1), lwd = c(2, 2, 2, 2), cex=1)

grid()
dev.off()





# By Age Group: Seniors (age >= 65) vs Non-Seniors (age < 65) ----
png("./figures/posterior_survival_exponential_by_seniority.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1), main = "Posterior Predictive Survival Curve by Exponential Model", xlab = "Time", ylab = "Survival")

for (i in 1:n_simulation) {

  rate_standard <- exp(mu_posterior[i] + beta_posterior[i] * 0) # assuming median age

  rate_chemo <- exp(mu_posterior[i] + beta_posterior[i] * 1) # assuming median age

  simulated_times_standard <- rexp(n_individual, rate = rate_standard)
  lines(survfit(Surv(simulated_times_standard) ~ 1), lty=2, col = adjustcolor("lightblue", alpha = 0.8), lwd = 1)

  simulated_times_chemo <- rexp(n_individual, rate = rate_chemo)
  lines(survfit(Surv(simulated_times_chemo) ~ 1), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)

}

KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ aged65, data = d)
list(KM_curve_veteran)

lines(KM_curve_veteran[1]$time, KM_curve_veteran[1]$surv, col = "#47b2d5", lwd = 2)

lines(KM_curve_veteran[2]$time, KM_curve_veteran[2]$surv, col = "#f45e77", lwd = 2)

legend("topright", inset = 0.02, legend = c("Predicted Survival for Seniors (Age ≥ 65)", "Predicted Survival for Non-Seniors (Age < 65)", "Observed Survival for Seniors (Age ≥ 65)", "Observed Survival for Non-Seniors (Age < 65)"), col=c(adjustcolor("#faa3b2", alpha = 1), adjustcolor("lightblue", alpha = 1), "#f45e77", "#47b2d5"), lty=c(2, 2, 1, 1), lwd = c(2, 2, 2, 2), cex=1)

grid()
dev.off()