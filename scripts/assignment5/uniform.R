# Set the number of random samples to generate
n_samples <- 1000

X <- runif(n_samples, min = 0, max = 2 * pi)
Y <- X + 1
plot(X,Y, cex=0.25, col="gray")
par(new=T)
plot(seq(0,2*pi, length.out=n_samples), rep(1/2*pi, times=n_samples), cex=0.25)
par(new=T)
plot(rep(1/2*pi, times=n_samples), seq(1, 1+2*pi, length.out=n_samples), cex=0.25, col="red")

X <- runif(n_samples, min = 0, max = 2 * pi)
Y <- X^2
plot(X,Y, cex=0.25, xlim=c(-2*pi,2*pi), ylim=c(0,4*pi*pi), col="gray")
par(new=T)
x <- seq(0,2*pi, length.out=n_samples)
plot(x, x/(2*pi), xlim=c(-2*pi,2*pi), ylim=c(0,4*pi*pi), cex=0.25)
par(new=T)
y <- seq(0, 4*pi*pi, length.out=n_samples)
plot(1/(4*pi*sqrt(y)), y, xlim=c(-2*pi,2*pi), ylim=c(0,4*pi*pi), cex=0.25, col="red")

X <- runif(n_samples, min = 0, max = 2 * pi)
Y <- sin(X)
plot(X,Y, cex=0.25, xlim=c(-2*pi,2*pi), ylim=c(-1.5,1.5), col="gray")
par(new=T)
x <- seq(0,2*pi, length.out=n_samples)
plot(x, x/(2*pi), xlim=c(-2*pi,2*pi), ylim=c(-1.5, 1.5), cex=0.25)
par(new=T)
y <- seq(-1, 1, length.out=n_samples)
plot(1/(pi*sqrt(1-y^2)), y, xlim=c(-2*pi,2*pi), ylim=c(-1.5, 1.5), cex=0.25, col="red")

# Create a histogram to visualize the distribution
# breaks: specifies the number of bins or a vector of breakpoints.
# main: title of the plot.
# xlab: label for the x-axis.
# ylab: label for the y-axis.
# col: color of the histogram bars.
hist(random_variables,
     breaks = 50, # You can adjust the number of breaks for desired detail
     main = "Histogram of Uniform Random Variables on [0, 2π]",
     xlab = "Value",
     ylab = "Frequency",
     col = "lightblue")
