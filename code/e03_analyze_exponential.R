summary(fit_exponential)
print(fit_exponential, pars = "lambda")

stan_plot(fit_exponential, pars = "lambda")
stan_trace(fit_exponential, pars = "lambda")


posterior_samples <- extract(fit_exponential)
lambda_posterior <- posterior_samples$lambda


# png("./figures/post_dist_lambda.png", width = 1800, height = 1200, res = 150)
plot(density(lambda_posterior), main = "Posterior Distribution of Lambda", xlab = "Lambda", col = "pink", lwd = 2)
grid()
# dev.off()


# png("./figures/post_dist_event_time.png", width = 1800, height = 1200, res = 150)
plot(density(rexp(1000, rate = mean(lambda_posterior))), main = "Posterior Distribution of Event Time", xlab = "Event Time", col = "#f45e77", lwd = 2)
grid()
# dev.off()





# Posterior Predictive Check: Survival Curve
n_individual <- 1000
n_simulation <- 50

png("./figures/posterior_survival_exponential.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 1), main = "Posterior Predictive Survival Curve by Exponential Model", xlab = "Time", ylab = "Survival")

for (i in 1:n_simulation) {
  simulated_event_times <- rexp(n_individual, rate = lambda_posterior[i])
  lines(survfit(Surv(simulated_event_times) ~ 1), lty=2, col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)
}

KM_curve_veteran <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ 1, data = d)

lines(KM_curve_veteran$time, KM_curve_veteran$surv, col = "#f45e77", lwd = 2)
grid()

legend("topright", inset = 0.02, legend = c("Predicted Survival Curve (Model)", "Observed Survival Curve (Data)"), col=c(adjustcolor("#faa3b2", alpha = 1), "#f45e77"), lty=c(2, 1), lwd = c(2, 2), cex=1)

dev.off()