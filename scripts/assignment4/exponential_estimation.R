library(pracma)

#uniform distribution
lambda <- seq(0,5, length.out=10)
prior <- c(dunif(lambda, 0, 5)[1:5],dunif(lambda, 0, 5)[1:5])
plot(lambda,prior,type="l")

rate = 2
samples <- rexp(10,rate)
for (sample in samples) {
  likelihood <- lambda*exp(-lambda*sample)
  evidence <- trapz(likelihood*prior)*0.2
  posterior <- likelihood*prior/evidence
  par(new=T)
  plot(lambda,prior,type="l", xlim=c(0,5))
  prior <- posterior
}
par(new=T)
plot(lambda,posterior,type="l", xlim=c(0,5), col="red")

summary(samples)

summary(posterior)
