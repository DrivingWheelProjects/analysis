

# view comparison winners as histogram 
winners_list <- unlist(unname(winners))
barplot(table(winners_list))

ci_factors <- data.frame(id = winners_list) %>%
  left_join(df_ci, by = "id") %>%
  mutate(across(c("sender","purpose","recipient"), as.factor))





barplot(table(result_df$sender))
barplot(table(result_df$purpose))
barplot(table(result_df$recipient))




# Convert vector to a dataframe, join, and pull the result back out
result_df <- data.frame(fruit = items) %>%
  left_join(lookup_df, by = "fruit")

# Extract the looked-up column back as a vector
result <- result_df$code


random_pairs$winner <- random_pairs[cbind(1:nrow(random_pairs), sample(1:2, nrow(random_pairs), replace = TRUE))]

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
