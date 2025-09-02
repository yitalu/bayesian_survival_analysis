n <- 10
set.seed(124)
row_selected <- sample(1:nrow(d), n)
d_selected <- d[row_selected, ]


plot(NULL, xlim = c(0, max(d$time) + 50), ylim = c(1, n + 1), xlab = "Time", ylab = "Rats", main = "Rats Survival Data", yaxt = "n")


abline(v = max(d$time), col = "black", lty = 2, lwd = 2)
text(x = max(d$time), y = 0, labels = "Study Ends", pos = 4, col = "black")

for (i in 1:n) {
    lines(x = c(0, d_selected$time[i]),
          y = c(i, i),
          col = ifelse(d_selected$trt[i] == 1, "blue", "#f55670"),
          lwd = 3)

    if (d_selected$tumor[i] == 1) {
        points(x = d_selected$time[i],
               y = i,
               pch = 19,
               col = "red")
    }
}


axis(side = 2, at = 1:n, labels = 1:n, las = 1, tck = -0.01)
