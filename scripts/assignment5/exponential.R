n_samples = 1000
X <- rexp(n_samples, 1)
Y <- X + 1
plot(X,Y, xlim=c(0,10), ylim=c(0,10), cex=0.25, col="gray")
par(new=T)
x <- seq(0, 10, length.out=n_samples)
plot(x, 1 - exp(-x), xlim=c(0,10), ylim=c(0,10), cex=0.25)
par(new=T)
y <- seq(1,10, length.out=n_samples)
plot(1-exp(-(y-1)), y, xlim=c(0,10), ylim=c(0,10), cex=0.25, col="gray")

n_samples = 1000
X <- rexp(n_samples, 1)
Y <- X^2
plot(X,Y, xlim=c(0,10), ylim=c(0,10), cex=0.25, col="gray")
par(new=T)
x <- seq(0, 10, length.out=n_samples)
plot(x, 1 - exp(-x), xlim=c(0,10), ylim=c(0,10), cex=0.25)
par(new=T)
y <- seq(1,10, length.out=n_samples)
plot((1/(2*sqrt(y)))*exp(-(y-1)), y, xlim=c(0,10), ylim=c(0,10), cex=0.25)

n_samples = 1000
X <- rexp(n_samples, 1)
Y <- X^3
plot(X,Y, xlim=c(0,10), ylim=c(0,10), cex=0.25, col="gray")
par(new=T)
x <- seq(0, 10, length.out=n_samples)
plot(x, 1 - exp(-x), xlim=c(0,10), ylim=c(0,10), cex=0.25)
par(new=T)
y <- seq(1,10, length.out=n_samples)
plot((1/3)*(y^(-2/3))*exp(-y^(1/3)), y, xlim=c(0,10), ylim=c(0,10), cex=0.25, col="red")
