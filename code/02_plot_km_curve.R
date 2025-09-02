rm(list = ls())
source("./code/01_load_data.R")

head(d)

d$treat_chemo <- ifelse(d$trt == 2, 1, 0) # 1: chemotherapy, 0: standard treatment
d$senior <- ifelse(d$age >= 65, 1, 0) # 1: senior (age >= 65), 0: non-senior (age < 65)

Surv(time = d$time, event = d$status, type = "right")




# Plot Kaplan-Meier curve with all data
km_curve_all <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ 1, data = d)
summary(km_curve_all)
list(km_curve_all)

png("./figures/km_curve_all.png", width = 1800, height = 1200, res = 150)

plot(km_curve_all, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Curve for the Veteran Dataset", col = "#1e90ff", lwd = 2)
grid()

dev.off()




# Plot Kaplan-Meier curves by Treatment group (chemotherapy vs standard treatment)
km_plot_treatment <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ treat_chemo, data = d)
summary(km_plot_treatment)
list(km_plot_treatment)

png("./figures/km_curve_treatment.png", width = 1800, height = 1200, res = 150)

plot(km_plot_treatment, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Curves by Treatment Group", col = c("#1e90ff", "#f45e77"), lwd = 2)
legend("topright", legend = c("Standard Treatment", "Chemotherapy"), col = c("#1e90ff", "#f45e77"), lwd = 2)
grid()

dev.off()




# Plot Kaplan-Meier curves by Age group (senior vs non-senior)
km_plot_seniority <- survfit(Surv(time = d$time, event = d$status, type = "right") ~ senior, data = d)
summary(km_plot_seniority)
list(km_plot_seniority)

png("./figures/km_curve_seniority.png", width = 1800, height = 1200, res = 150)

plot(km_plot_seniority, xlab = "Time", ylab = "Survival Probability", main = "Kaplan-Meier Curves by Age Group", col = c("#1e90ff", "#f45e77"), lwd = 2)
legend("topright", legend = c("Non-Senior (Age < 65)", "Senior (Age ≥ 65)"), col = c("#1e90ff", "#f45e77"), lwd = 2)
grid()

dev.off()