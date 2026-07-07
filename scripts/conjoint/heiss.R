library(tidyverse)        # ggplot, dplyr, and friends
library(haven)            # Read Stata files
library(broom)            # Convert model objects to tidy data frames
library(cregg)            # Automatically calculate frequentist conjoint AMCEs and MMs
library(survey)           # Panel-ish regression models
library(scales)           # Nicer labeling functions
library(marginaleffects)  # Calculate marginal effects
library(broom.helpers)    # Add empty reference categories to tidy model data frames
library(ggforce)          # For facet_col()
library(brms)             # The best formula-based interface to Stan
library(tidybayes)        # Manipulate Stan results in tidy ways
library(ggdist)           # Fancy distribution plots
library(patchwork)        # Combine ggplot plots


# Custom ggplot theme to make pretty plots
# Get the font at https://fonts.google.com/specimen/Jost
theme_nice <- function() {
  theme_minimal(base_family = "Jost") +
    theme(panel.grid.minor = element_blank(),
          plot.title = element_text(family = "Jost", face = "bold"),
          axis.title = element_text(family = "Jost Medium"),
          axis.title.x = element_text(hjust = 0),
          axis.title.y = element_text(hjust = 1),
          strip.text = element_text(family = "Jost", face = "bold",
                                    size = rel(0.75), hjust = 0),
          strip.background = element_rect(fill = "grey90", color = NA))
}

# Set default theme and font stuff
theme_set(theme_nice())
update_geom_defaults("text", list(family = "Jost", fontface = "plain"))
update_geom_defaults("label", list(family = "Jost", fontface = "plain"))

# Party colors from the Urban Institute's data visualization style guide, for fun
# http://urbaninstitute.github.io/graphics-styleguide/
parties <- c("#1696d2", "#db2b27")

# Functions for formatting things as percentage points
label_pp <- label_number(accuracy = 1, scale = 100, 
                         suffix = " pp.", style_negative = "minus")

label_amce <- label_number(accuracy = 0.1, scale = 100, suffix = " pp.", 
                           style_negative = "minus", style_positive = "plus")

# Data from https://doi.org/10.7910/DVN/THJYQR
# It's public domain
candidate <- read_stata("scripts/conjoint/candidate.dta") %>% 
  as_factor()  # Convert all the Stata categories to factors

# Make a little lookup table for nicer feature labels
variable_lookup <- tribble(
  ~variable,    ~variable_nice,
  "atmilitary", "Military",
  "atreligion", "Religion",
  "ated",       "Education",
  "atprof",     "Profession",
  "atmale",     "Gender",
  "atinc",      "Income",
  "atrace",     "Race",
  "atage",      "Age"
) %>% 
  mutate(variable_nice = fct_inorder(variable_nice))
