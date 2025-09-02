summary(fit_exponential)
print(fit_exponential, pars = "lambda")


library(gridExtra)
library(grid)
library(ggplot2)

# Extract summary for lambda
lambda_summary <- as.data.frame(summary(fit_exponential)$summary["lambda", , drop = FALSE])
lambda_summary$Parameter <- rownames(lambda_summary)
lambda_summary <- lambda_summary[, c("Parameter", colnames(lambda_summary)[1:(ncol(lambda_summary)-1)])]
lambda_summary[ , -1] <- round(lambda_summary[ , -1], 3)

# Create table grob
table_grob <- tableGrob(lambda_summary, rows = NULL)

# Save as PNG
png("./figures/estimate_table_exponential.png", width = 1200, height = 200, res = 150)
grid.draw(table_grob)
dev.off()



png("./figures/estimate_barplot_exponential.png", width = 1200, height = 200, res = 150)
stan_plot(fit_exponential, pars = "lambda")
dev.off()

stan_trace(fit_exponential, pars = "lambda")


posterior_samples <- extract(fit_exponential)
lambda_posterior <- posterior_samples$lambda


png("./figures/estimate_density_exponential.png", width = 1800, height = 1200, res = 150)
plot(density(lambda_posterior), main = "Posterior Distribution of Lambda", xlab = "Lambda", col = "pink", lwd = 2)
grid()
dev.off()



# Posterior Distribution of Event Time
n_individual <- 1000
n_simulation <- 50

png("./figures/posterior_event_time_exponential.png", width = 1800, height = 1200, res = 150)

plot(NULL, xlim = c(0, 1000), ylim = c(0, 0.008), main = "Posterior Distribution of Event Time by Exponential Model", xlab = "Event Time", ylab = "Density")

for (i in 1:n_simulation) {
  lines(density(rexp(1000, rate = lambda_posterior[i])), main = "Posterior Distribution of Event Time", xlab = "Event Time", col = adjustcolor("#faa3b2", alpha = 0.8), lwd = 1)
}
# lines(density(rexp(1000, rate = mean(lambda_posterior))), col = "#f45e77", lwd = 2)
grid()

dev.off()





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