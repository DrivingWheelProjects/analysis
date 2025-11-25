library(greybox)

x <- seq(-10,10,length.out=1000)
pdf_g <- dnorm(x, 0, 2)
plot(x, pdf_g, type="l")
scale = sqrt(2)
pdf_l <- dlaplace(x, 0, scale)
par(new=T)
plot(x, pdf_l, type="l", col="red")
