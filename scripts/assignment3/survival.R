J <- 1:22
yrs <- c()
surv <- c()
for (j in J) {
  yrs <- c(yrs, max(1,j-3))
  prob <- (1 - 0.98*exp(-0.025*j))*(0.98^(j-1))*prod(exp(-0.025*yrs))
  surv <- c(surv, prob)
}
surv


J <- 50:(50 + (5*17))
games <- c()
surv <- c()
for (j in J) {
  game <- j - 49
  games <- c(games, game)
  prob <- (1 - 0.995*exp(-0.001*game))*(0.995^(game-1))*prod(exp(-0.001*games))
  surv <- c(surv, prob)
}
chart_data <- rbind(surv)
barplot(chart_data)
