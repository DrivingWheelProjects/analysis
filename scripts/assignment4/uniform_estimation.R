library(pracma)

samples = runif(10)
prior = rnorm(10, 1.5, 0.5)
a = 0
b = max(prior)
plot(0, b, xlim=c(0,10), ylim=c(0,4))

for (i in 1:length(samples)) {
  likelihood <- 1/(b-a)
  evidence <- ((1/samples[i]) + (1/(b-a)))/2
#  evidence <- (b - samples[i])*(1/(b-a))
  posterior <- likelihood*prior/evidence
  b <- max(posterior)
  prior <- posterior
  par(new=T)
  plot(i, b, xlim=c(0,10), ylim=c(0,4))
}
