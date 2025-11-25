library(gt)

data.frame(
  receiver = c("A.St.Brown","J.Gibbs","J.Williams","S.LaPorta"),
  abbrev = c("ASB", "JG", "JW", "SLP"),
  gt_fd = c(0.79, 0.33, 0.47, 0.69),
  lt_fd = c(0.35, 0.18, 0.55, 0.26),
  fumble = c(0.02, 0, 0.03, 0)
) |>
  gt()
