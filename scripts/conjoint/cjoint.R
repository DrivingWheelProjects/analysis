library(jsonlite)
library(cjoint)
library(dplyr)

# ---- Usage in analysis (once response data is collected) ----
# simulate survey data, random response to pairwise questions
df_ci_cjoint<- fromJSON("./data/conjoint_CI.json")
pair_ids = as.data.frame(t(combn(df_ci_cjoint$id,2)))
colnames(pair_ids) <- c("id1","id2")

#all possible comparison pairs
df_pairs <- pair_ids[sample(nrow(pair_ids)), ] 

#empty dataframe for winners/losers from pairwise comparisons
results <- data.frame(matrix(ncol = 8, nrow = 0)) 
colnames(results) <- c("c1","c2","c3","c4","c5","c6","response_id","chosen")
results <- results %>%
  mutate(
    c1 = as.character(c1),
    c2 = as.character(c2),
    c3 = as.character(c3),
    c4 = as.character(c4),
    c5 = as.character(c5),
    c6 = as.character(c6),
    response_id = as.integer(response_id),
    chosen = as.numeric(chosen)
  )

# fill survey results dataframe with simulated results
# select random comparison pair to pairwise comparison 
# then choose winner randomly
howmany <- 40 #survey participants
for (i in 1:howmany) {
  df_survey <- df_pairs[sample(nrow(df_pairs), 6), ] # 6 comparisons in each survey
  df_survey$winner <- df_survey[cbind(1:nrow(df_survey), sample(1:2, nrow(df_survey), replace = TRUE))]
  df_survey <- df_survey %>%
    mutate(loser = if_else(id1 == winner, id2, id1))
  df_response <- as.data.frame(t(df_survey[,c("winner","loser")])) %>%
    setNames(c("c1","c2","c3","c4","c5","c6")) %>%
    mutate(
      response_id = i,
      chosen = c(1,0)
    )
  results <- bind_rows(results,df_response)
}

# simulated survey data, random winner/loser to pairwise comparisons needs attribute-level info from df_ci_cjoint
# resulting dataframe, with attribute-level info as factor, is analysis data structure
ci_factors_cjoint <- results %>%
  pivot_longer(
    cols = c(c1,c2,c3,c4,c5,c6),
    names_to = "choice number",
    values_to = "id"
  ) %>%
  left_join(df_ci_cjoint, by = "id") %>%
  mutate(across(c(sender,purpose,recipient),as.factor)) %>%
  # refactor with new reference levels: strength coach, load management, head coach
  mutate(sender = fct_relevel(sender, "strength coach")) %>%
  mutate(purpose = fct_relevel(purpose, "load management")) %>%
  mutate(recipient = fct_relevel(recipient, "head coach"))

# results <- read_csv("qualtrics_export.csv") will need to transform to this data structure
# amce = Average Marginal Component Effects, from cjoint package
# "design" parameter incorporates model constraints
amce_out <- amce(
  chosen ~ sender + purpose + recipient,
  data = ci_factors_cjoint,
  design = design,
  respondent.id = "response_id",
  cluster = TRUE
)
plot(amce_out)
# summary(amce_out)
