rm(list = ls())
source("./code/01_load_data.R")

head(d)


# Function for building stepwise (stair) coordinates for the CI band so the fill follows the KM steps
step_coords <- function(t, v, start = 1) {
  x <- c(0, as.vector(rbind(t, t)))
  y <- c(start, as.vector(rbind(c(start, v[-length(v)]), v)))
  list(x = x, y = y)
}




# Plot Kaplan-Meier curve with all data
km_curve_all <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ 1, data = d)
# summary(km_curve_all)
# list(km_curve_all)
id_keep <- !(is.na( km_curve_all$time ) | is.na( km_curve_all$lower ) | is.na( km_curve_all$upper ))
times <- km_curve_all$time[id_keep]
lower <- km_curve_all$lower[id_keep]
upper <- km_curve_all$upper[id_keep]

lower_step <- step_coords(times, lower, start = 1)
upper_step <- step_coords(times, upper, start = 1)


png("./figures/km_curve_all.png", width = 1800, height = 1200, res = 150)

plot(km_curve_all, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Curve for the Veteran Dataset", col = "#1e90ff", lwd = 2, conf.int = FALSE)

# Shade area between confidence intervals
polygon(
  x = c(lower_step$x, rev(upper_step$x)),
  y = c(lower_step$y, rev(upper_step$y)),
  col = adjustcolor("#1e90ff", alpha = 0.2),
  border = NA
)

lines(km_curve_all, col = "#1e90ff", lwd = 2)
grid()

dev.off()







# Plot Kaplan-Meier curves by Treatment group (chemotherapy vs standard treatment)
km_plot_treatment <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ treat_chemo, data = d)
summary(km_plot_treatment)
list(km_plot_treatment)


png("./figures/km_curve_treatment.png", width = 1800, height = 1200, res = 150)

plot(km_plot_treatment, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Curves by Treatment Group", col = c("#1e90ff", "#f45e77"), lwd = 2, conf.int = FALSE)

# Shade area between confidence intervals
id_keep <- !(is.na( km_plot_treatment[1]$time ) | is.na( km_plot_treatment[1]$lower ) | is.na( km_plot_treatment[1]$upper ))
times <- km_plot_treatment[1]$time[id_keep]
lower <- km_plot_treatment[1]$lower[id_keep]
upper <- km_plot_treatment[1]$upper[id_keep]

lower_step <- step_coords(times, lower, start = 1)
upper_step <- step_coords(times, upper, start = 1)

polygon(
  x = c(lower_step$x, rev(upper_step$x)),
  y = c(lower_step$y, rev(upper_step$y)),
  col = adjustcolor("#1e90ff", alpha = 0.2),
  border = NA
)

id_keep <- !(is.na( km_plot_treatment[2]$time ) | is.na( km_plot_treatment[2]$lower ) | is.na( km_plot_treatment[2]$upper ))
times <- km_plot_treatment[2]$time[id_keep]
lower <- km_plot_treatment[2]$lower[id_keep]
upper <- km_plot_treatment[2]$upper[id_keep]

lower_step <- step_coords(times, lower, start = 1)
upper_step <- step_coords(times, upper, start = 1)

polygon(
  x = c(lower_step$x, rev(upper_step$x)),
  y = c(lower_step$y, rev(upper_step$y)),
  col = adjustcolor("#f45e77", alpha = 0.2),
  border = NA
)

lines(km_plot_treatment[1], col = adjustcolor("#1e90ff", alpha = 0.3), lwd = 2)
lines(km_plot_treatment[2], col = adjustcolor("#f45e77", alpha = 0.3), lwd = 2)

legend("topright", inset = 0.02, legend = c("Standard Treatment", "Chemotherapy"), col = c("#1e90ff", "#f45e77"), lwd = 2)
grid()

dev.off()




# Plot Kaplan-Meier curves by Age group (senior vs non-senior)
km_plot_seniority <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ senior, data = d)
summary(km_plot_seniority)
list(km_plot_seniority)

png("./figures/km_curve_seniority.png", width = 1800, height = 1200, res = 150)

plot(km_plot_seniority, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Curves by Age Group", col = c("#1e90ff", "#f45e77"), lwd = 2, conf.int = FALSE)

# Shade area between confidence intervals
id_keep <- !(is.na( km_plot_seniority[1]$time ) | is.na( km_plot_seniority[1]$lower ) | is.na( km_plot_seniority[1]$upper ))
times <- km_plot_seniority[1]$time[id_keep]
lower <- km_plot_seniority[1]$lower[id_keep]
upper <- km_plot_seniority[1]$upper[id_keep]

lower_step <- step_coords(times, lower, start = 1)
upper_step <- step_coords(times, upper, start = 1)

polygon(
  x = c(lower_step$x, rev(upper_step$x)),
  y = c(lower_step$y, rev(upper_step$y)),
  col = adjustcolor("#1e90ff", alpha = 0.2),
  border = NA
)

id_keep <- !(is.na( km_plot_seniority[2]$time ) | is.na( km_plot_seniority[2]$lower ) | is.na( km_plot_seniority[2]$upper ))
times <- km_plot_seniority[2]$time[id_keep]
lower <- km_plot_seniority[2]$lower[id_keep]
upper <- km_plot_seniority[2]$upper[id_keep]

lower_step <- step_coords(times, lower, start = 1)
upper_step <- step_coords(times, upper, start = 1)

polygon(
  x = c(lower_step$x, rev(upper_step$x)),
  y = c(lower_step$y, rev(upper_step$y)),
  col = adjustcolor("#f45e77", alpha = 0.2),
  border = NA
)

lines(km_plot_seniority[1], col = adjustcolor("#1e90ff", alpha = 0.3), lwd = 2)
lines(km_plot_seniority[2], col = adjustcolor("#f45e77", alpha = 0.3), lwd = 2)

legend("topright", inset = 0.02, legend = c("Non-Senior (Age < 65)", "Senior (Age ≥ 65)"), col = c("#1e90ff", "#f45e77"), lwd = 2)
grid()

dev.off()