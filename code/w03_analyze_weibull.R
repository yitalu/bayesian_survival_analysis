summary(fit_weibull)
print(fit_weibull, pars = c("alpha", "sigma"))

stan_plot(fit_weibull, pars = c("alpha", "sigma"))
stan_trace(fit_weibull, pars = c("alpha", "sigma"))

posterior_samples <- extract(fit_weibull)
# beta_1_posterior <- posterior_samples$beta[,1]
# beta_2_posterior <- posterior_samples$beta[,2]
alpha_posterior <- posterior_samples$alpha
sigma_posterior <- posterior_samples$sigma




n_individual <- 1000
n_simulation <- 50


# png("./figures/post_dist_event_time_weibull.png", width = 1800, height = 1200, res = 150)

n_simulation <- 50

plot(NULL, xlim = c(0, 1000), ylim = c(0, 0.01), main = "Posterior Distribution of Event Time by Weibull Model", xlab = "Event Time", ylab = "Density")

for (i in 1:n_simulation) {
  lines(density( rweibull(n_individual, shape = alpha_posterior[i], scale = sigma_posterior[i]) ), col = adjustcolor("#f45e77", alpha = 0.3), lwd = 1)
}

lines(density( rweibull(n_individual, shape = mean(alpha_posterior), scale = mean(sigma_posterior)) ), main = "Posterior Distribution of Event Time by Weibull Model", xlab = "Event Time", col = "#f70830", lwd = 3)

grid()
# dev.off()






# Posterior Predictive Survival Curves
png("./figures/posterior_survival_weibull.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1), main = "Posterior Predictive Survival Curve by Weibull Model", xlab = "Time", ylab = "Survival")

for (i in 1:n_simulation) {
  simulated_times <- rweibull(n_individual, shape = alpha_posterior[i], scale = sigma_posterior[i])
  
  lines(survfit(Surv(simulated_times) ~ 1), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)
}

KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ 1, data = d)
# list(KM_curve_veteran)

lines(KM_curve_veteran$time, KM_curve_veteran$surv, col = "#f45e77", lwd = 2)

legend("topright", inset = 0.02, legend = c("Predicted Survival Curve (Model)", "Observed Survival Curve (Data)"), col=c(adjustcolor("#faa3b2", alpha = 1), "#f45e77"), lty=c(2, 1), lwd = c(2, 2), cex=1)

grid()

dev.off()