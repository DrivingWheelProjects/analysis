library(pracma)

#uniform distribution
sigma <- seq(0,10, length.out=10)
fl <- dunif(x, 0, 10)
plot(sigma,fl,type="l")
#abline(h=dunif(0,0,10))

variance = 4
sd = sqrt(variance)
samples <- rnorm(10, 10, sd)
for (sample in samples) {
  likelihood <- (1/sqrt(2*pi*(sigma^2)))*exp(-((sample^2)/(2*(sigma^2))))
  posterior <- likelihood * fl
  evidence <- trapz(posterior)*0.1
  post <- posterior/evidence
  par(new=T)
  plot(sigma, posterior,type="l")
  fl = posterior
}
par(new=T)
plot(sigma,posterior,type="l",col="red")
