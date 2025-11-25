X <- rnorm(1)
X

curve(dnorm(x, 0, 1), -4, 4, ylim=c(0,4))
Y <- seq(-4, 4, length.out=10000)
meanlog <- 0
sdlog <- 1
par(new=TRUE)
plot((1 / (Y * sdlog * sqrt(2 * pi))) * exp(-((log(Y) - meanlog)^2 / (2 * sdlog^2))), 
     Y,
     xlim=c(-4,4), 
     ylim=c(0,4), 
     cex=0.1, 
     col="gray")
par(new=TRUE)
plot(dlnorm(Y, meanlog=0, sdlog = 1), Y, xlim=c(-4,4), ylim=c(0,4), cex=0.1, col="red")

curve(dnorm(x, 0, 1), -4, 4, ylim=c(0,4))
Y <- seq(-4, 4, length.out=10000)
meanlog <- 0
sdlog <- 1
par(new=TRUE)
plot(-1*(1 / (Y * sdlog * sqrt(2 * pi))) * exp(-((log(Y) - meanlog)^2 / (2 * sdlog^2))), 
     Y,
     xlim=c(-4,4), 
     ylim=c(0,4), 
     cex=0.1, 
     col="gray")
par(new=TRUE)
plot(-1*dlnorm(Y, meanlog=0, sdlog = 1), Y, xlim=c(-4,4), ylim=c(0,4), cex=0.1, col="red")

curve(dnorm(x, 0, 1), -4, 4, ylim=c(-0.1,4))
sd <- 1
Y <- seq(0,4, length.out=1000)
X <- (sqrt(2) / (sd * sqrt(pi))) * exp(-Y^2 / (2 * sd^2))
par(new=TRUE)
plot(X, Y, type="l", xlim=c(-4,4), ylim=c(-0.1,4), col="red")
