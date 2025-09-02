# Parameters
shape <- 1.5                     # Keep shape fixed
scales <- c(1, 2, 3, 4, 5)       # Increasing scale values

# Support
x <- seq(0, 20, length.out = 1000)

# Set up empty plot
plot(x, dweibull(x, shape, scale = max(scales)), ylim = c(0, 1),
     type = "n", lwd = 2,
     xlab = "x", ylab = "Density",
     main = sprintf("Weibull PDFs with shape = %.1f and varying scale", shape))

# Colors for lines
cols <- rainbow(length(scales))

# Add lines for each scale
for (i in seq_along(scales)) {
  lines(x, dweibull(x, shape, scale = scales[i]),
        col = cols[i], lwd = 2)
}

# Add legend
legend("topright", legend = paste("scale =", scales),
       col = cols, lwd = 2, bty = "n")

# Add grid
grid()