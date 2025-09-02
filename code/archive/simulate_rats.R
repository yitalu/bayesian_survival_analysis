simulate_rats <- function(n = 1e3, lambda = 0.01, censoring_time = 104) {
    t_true <- rexp(n, rate = lambda)
    cencored <- ifelse(t_true > censoring_time, 1, 0)
    t_obs <- ifelse(cencored == 0, t_true, censoring_time)
}

simulated_rats <- simulate_rats()
View(d)
