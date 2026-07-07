library(jsonlite)
library(tidyr)
library(dplyr)

json <- '{
    "datatype": ["journal","app","wearable","birth control"],
    "sender": ["strength coach","data analyst","athletic trainer"],
    "tp": ["player status","team analysis","health concern"],
    "recipient": ["head coach","whole team","strength coach","athletic trainer"],
    "purpose": ["training","game planning","performance review"]
}'
ci <- jsonlite::fromJSON(json)
combinations <- expand.grid(ci$datatype,ci$sender,ci$tp,ci$recipient)
names(combinations) <- c("datatype","sender","tp","recipient")
set.seed(1)
pair_ones <- combinations[sample(nrow(combinations), 300, replace = TRUE), ]
pair_twos <- combinations[sample(nrow(combinations), 300, replace = TRUE), ]
df <- tibble(
  pair_one = pair_ones,
  pair_two = pair_twos
)
winners <- df %>%
  rowwise() %>%
  mutate(winners = sample(list(pair_one, pair_two), size = 1)[[1]]) %>%
  ungroup()
winners
