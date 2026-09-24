# updated_conjoint_design.R

# Constructs a restricted-randomization conjoint design object (cjoint::makeDesign)
# from the formalized constraint set in conjoint_constraints.json, so that
# amce() computes AMCEs relative to the TRUE (restricted) assignment
# distribution rather than assuming uniform independent randomization.

 
spec <- fromJSON("./data/attributes_levels.json")

# ---- Attribute levels (must match survey_design.json / vignette_items.json) ----
attribute_levels <- list(
  sender    = spec$attributes$sender,
  purpose   = spec$attributes$purpose,
  recipient = spec$attributes$recipient
)

# ---- Constraints, expressed in cjoint's constraint-list format ----
# Each constraint lists levels for one attribute that are jointly infeasible
# with levels for another attribute. cjoint expects one constraint entry per
# blocked (attribute_A level combination) -> (attribute_B levels) pairing.

constraints <- list(
  # C1: health concern purpose blocked for non-clinical senders (now excludes head coach too)
  list(
    purpose = "health concern",
    sender  = c("strength coach", "sports scientist")
  ),
  # C2a: load management blocked for clinical senders (head coach now ALLOWED here --
  # represents an athlete's direct, voluntary self-disclosure to her coach for a
  # practical training decision; this is the "ethical but plausible" pathway,
  # distinct from a third party forwarding clinical data without her involvement)
  list(
    purpose = "load management",
    sender  = c("physician", "athletic trainer")
  ),
  # C2b: team readiness blocked for clinical senders AND head coach (aggregation is
  # a performance-staff function only)
  # head coach not excluded, increases count from 35 to 39
  list(
    purpose = "team readiness",
  #  sender  = c("physician", "athletic trainer", "head coach")
    sender  = c("physician", "athletic trainer")
  ),
  # C4: health concern cannot route to sports scientist or whole team
  list(
    purpose   = "health concern",
    recipient = c("sports scientist", "whole team")
  ),
  # C5: load management cannot route to whole team
  list(
    purpose   = "load management",
    recipient = "whole team"
  ),
  # C6: sender = head coach and purpose = team readiness, recipient excludes all but head coach, whole team
  list(
    sender  = "head coach",
    purpose = "team readiness",
    recipient = c("physician","athletic trainer","sports scientist","strength coach")
  ),
  # C7: sender = head coach and purpose = health concern, recipient excludes all non-clinical including head coach
  list(
    sender  = "head coach",
    purpose = "health concern",
    recipient = c("sports scientist","strength coach","whole team","head coach")
  )
  # Note: C3 (recipient != sender) is enforced upstream in the item-generation
  # step (Python), since it is a same-row identity constraint rather than a
  # cross-attribute level exclusion — cjoint's constraint format handles
  # cross-attribute exclusions, not row-level self-reference, so it is not
  # re-declared here. Confirm this is still correctly excluded when you
  # validate design$J against the 35-profile feasible set below.
)

# ---- Marginal probabilities of each level BEFORE restriction ----
# cjoint uses these as the baseline distribution to reweight from when
# excluding the constrained combinations above.
level.probs <- list(
  sender    = rep(1 / length(attribute_levels$sender), length(attribute_levels$sender)),
  purpose   = rep(1 / length(attribute_levels$purpose), length(attribute_levels$purpose)),
  recipient = rep(1 / length(attribute_levels$recipient), length(attribute_levels$recipient))
)

design <- makeDesign(
  type = "constraints",
  attribute.levels = attribute_levels,
  constraints = constraints,
  level.probs = level.probs
)

# new/jbs, code for Pairwise comparison statements
# dataframe with all attributes-levels combinations
indices <- which(design$J > 0, arr.ind = TRUE)
combinations <- apply(indices, 1, function(idx) {
  sapply(seq_along(idx), function(dim_i) {
    dimnames(design$J)[[dim_i]][[idx[dim_i]]]
  })
})
df <- as.data.frame(t(combinations), stringsAsFactors = FALSE)
colnames(df) <- names(dimnames(design$J))
rownames(df) <- paste0("V", sprintf("%03d", 1:nrow(df)))

# transform attributes-levels to survey choices for pairwise comparison
phrases <- c(
  "sender_readiness" = ", along with the rest of the team's data",
  "health concern" = " evaluates the data for a health concern",
  "load management" = " evaluates the data to decide whether to increase or reduce your training load that day",
  "team readiness" = " aggregates the data"
)

df <- df %>%
  mutate(value = paste0(
    "You send your menstrual cycle data to your team's ",
    sender,
    if_else(purpose == "team readiness", phrases["sender_readiness"], ""),
    ". The ",
    sender,
    phrases[purpose],
    if_else(sender == recipient, 
            " and does not share the information further.", 
            paste0(" and passes it along to your ", recipient,".")
    )
  ))
json_df <- df %>%
  rownames_to_column(var = "id") %>%
  toJSON(auto_unbox = TRUE, pretty = TRUE)

# ---- Sanity check: does the restricted design's feasible profile count ----
# ---- match the 35-item vignette bank it should reproduce? ----
# ---- now it's 39
cat("Feasible profiles per design object:", design$J, "\n")
cat("Expected from conjoint_constraints.json:", spec$n_feasible, "\n")
if (design$J != spec$n_feasible) {
  warning("Design object profile count does not match the Python-generated ",
          "constraint spec — re-check constraint translation before running amce().")
}

saveRDS(design, "conjoint_design.rds")

# ---- Usage in analysis (once response data is collected) ----
# simulate survey data, random response to pairwise questions
df_ci_cjoint<- fromJSON("./data/conjoint_CI_cjoint.json")
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
