library(dplyr)

data <- read.csv("./data/hurricanes.csv")

hurricanes <- data %>%
  group_by(Year,Landfall.5,Landfall.4) %>%
  summarize(total = n())
print(hurricanes, n = Inf)