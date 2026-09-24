# build_conjoint_design.R
# Constructs a restricted-randomization conjoint design object (cjoint::makeDesign)
# from the formalized constraint set in conjoint_constraints.json, so that
# amce() computes AMCEs relative to the TRUE (restricted) assignment
# distribution rather than assuming uniform independent randomization.

library(jsonlite)
library(cjoint)   # install.packages("cjoint") if not already installed

spec <- fromJSON("conjoint_constraints.json")

# ---- Attribute levels (must match survey_design.json / vignette_items.json) ----
attribute.levels <- list(
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
    sender  = c("strength coach", "sports scientist", "head coach")
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
  list(
    purpose = "team readiness",
    sender  = c("physician", "athletic trainer", "head coach")
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
  sender    = rep(1 / length(attribute.levels$sender), length(attribute.levels$sender)),
  purpose   = rep(1 / length(attribute.levels$purpose), length(attribute.levels$purpose)),
  recipient = rep(1 / length(attribute.levels$recipient), length(attribute.levels$recipient))
)

design <- makeDesign(
  type = "array",
  attribute.levels = attribute.levels,
  constraints = constraints,
  level.probs = level.probs
)

# ---- Sanity check: does the restricted design's feasible profile count ----
# ---- match the 35-item vignette bank it should reproduce? ----
cat("Feasible profiles per design object:", design$J, "\n")
cat("Expected from conjoint_constraints.json:", spec$n_feasible, "\n")
if (design$J != spec$n_feasible) {
  warning("Design object profile count does not match the Python-generated ",
          "constraint spec — re-check constraint translation before running amce().")
}

saveRDS(design, "conjoint_design.rds")

# ---- Usage in analysis (once response data is collected) ----
# results <- read_csv("qualtrics_export.csv")
# amce_out <- amce(
#   chosen ~ sender + purpose + recipient,
#   data = results,
#   design = design,
#   respondent.id = "respondent_id",
#   cluster = TRUE
# )
# summary(amce_out)
