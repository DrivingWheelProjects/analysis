library(jsonlite)
library(tidyr)
library(dplyr)
library(cregg)
library(cmdstanr)
install_cmdstan()
library(tidybayes)
library(marginaleffects)

df_ci <- fromJSON("./data/conjoint_CI_cregg.json")
pair_ids = as.data.frame(t(combn(df_ci$id,2)))
colnames(pair_ids) <- c("id1","id2")
df_pairs <- pair_ids[sample(nrow(pair_ids)), ] #all possible comparison pairs
results <- data.frame(matrix(ncol = 8, nrow = 0)) #dataframe for winners from pairwise comparisons
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

ci_factors <- results %>%
  pivot_longer(
    cols = c(c1,c2,c3,c4,c5,c6),
    names_to = "choice number",
    values_to = "id"
  ) %>%
  left_join(df_ci, by = "id") %>%
  mutate(across(c(sender,purpose,recipient),as.factor)) %>%
# need to refactor with new reference levels: s:strength coach, load management, r:head coach
  mutate(sender = fct_relevel(sender, "s:strength coach")) %>%
  mutate(purpose = fct_relevel(purpose, "load management")) %>%
  mutate(recipient = fct_relevel(recipient, "r:head coach"))

# check attributes for uniqueness
check_attr <- c("sender","purpose","recipient")
for (attr in check_attr) {
  raw_levels <- ci_factors[attr]
  if (any(duplicated(unique(raw_levels)))) {
    print(paste("Problem found in attribute: ", attr))
  } else {
    print(paste("No problems."))
  }
}

# Heiss, average AMCE
# cregg cannot handle more than 2 related constrained attributes, produces error
# but model still plots
model_ci_amce <- amce(
  data = ci_factors,
  formula = chosen ~ sender + purpose + recipient,
  id = ~ response_id
)
plot(model_ci_amce)

# Heiss, survey::svglm objects
# ok for multi-attribute constraints
svy_design <- svydesign(
  ids = ~response_id,
  data = ci_factors
)
model_svy <- svyglm(
  chosen ~ sender * purpose * recipient,
  design = svy_design
)

# Heiss, coefficient plots
# based on model_svy
# shows interaction effects from constraints
variable_lookup <- tribble(
  ~variable,    ~variable_nice,
  "sender", "Sender",
  "purpose", "Purpose",
  "recipient", "Recipient"
) %>% 
  mutate(variable_nice = fct_inorder(variable_nice))
plot_data_manual <- model_svy %>% 
  tidy_and_attach() %>% 
  tidy_add_reference_rows() %>% 
  tidy_add_estimate_to_reference_rows() %>% 
  filter(term != "(Intercept)") %>% 
  mutate(term_nice = str_remove(term, variable)) %>% 
  left_join(variable_lookup, by = join_by(variable)) %>% 
  mutate(across(c(term_nice, variable_nice), ~fct_inorder(.)))

ggplot(
  plot_data_manual,
  aes(x = estimate, y = term_nice, color = variable_nice)
) +
  geom_vline(xintercept = 0) +
  geom_pointrange(aes(xmin = conf.low, xmax = conf.high)) +
  scale_x_continuous(labels = label_pp) +
  guides(color = "none") +
  labs(
    x = "Percentage point change in probability of candidate selection",
    y = NULL,
    title = "AMCEs with covariants"
  ) +
  # Automatically resize each facet height with ggforce::facet_col()
  facet_col(facets = "variable_nice", scales = "free_y", space = "free")

# Heiss, marginal means using cregg::mm ... simplest output
mm_cregg <- cregg::mm(
  ci_factors,
  chosen ~ sender * purpose * recipient,
  id = ~response_id
)
plot(mm_cregg)

# Heiss, model for Bayesian analysis
priors <- c(
  prior(normal(0, 1), class = Intercept),
  prior(normal(0, 1), class = b),
  prior(exponential(1), class = sd)
)

model_brms <- brm(
  bf(chosen ~ sender + purpose + recipient +
       (1 | response_id)),
  data = ci_factors,
  family = bernoulli(link = "logit"),
  prior = priors,
  chains = 4, cores = 4, iter = 2000, seed = 1234,
  backend = "cmdstanr", threads = threading(2), refresh = 0,
  file = "candidate_model_brms"
)

# There's probably a more efficient way to do with with mapping or loops or
# whatever but I don't want to figure it out right now, so we brute force it
posterior_mms <- bind_rows(
  sender = predictions(
    model_brms,
    by = "sender",
    allow_new_levels = TRUE
  ) %>% rename(value = sender) %>% posterior_draws(),
  purpose = predictions(
    model_brms,
    by = "purpose",
    allow_new_levels = TRUE
  ) %>% rename(value = purpose) %>% posterior_draws(),
  recipient = predictions(
    model_brms,
    by = "recipient",
    allow_new_levels = TRUE
  ) %>% rename(value = recipient) %>% posterior_draws(),
  .id = "term"
) %>% 
  as_tibble()


# Heiss, posterior marginal means by hand (no cregg, no marginaleffects)
plot_posterior_mms <- posterior_mms %>% 
  left_join(variable_lookup, by = join_by(term == variable)) %>% 
  mutate(across(c(value, variable_nice), ~fct_inorder(.)))

ggplot(
  plot_posterior_mms,
  aes(x = draw, y = value, fill = variable_nice)
) +
  geom_vline(xintercept = 0.5) +
  stat_halfeye(normalize = "groups") +  # Make the heights of the distributions equal within each facet
  facet_col(facets = "variable_nice", scales = "free_y", space = "free") +
  scale_x_continuous(labels = label_percent()) +
  guides(fill = "none") +
  labs(
    x = "Marginal means of probabilities",
    y = NULL,
    title = "Posterior marginal means"
  )

# Heiss, levels difference in marginal means
