library(cjoint)   # install.packages("cjoint") if not already installed
library(dplyr)

# ... follows example from https://search.r-project.org/CRAN/refmans/cjoint/html/makeDesign.html
attribute_list <- list()
attribute_list[["sender"]] <- c("physician","athletic trainer","strength coach","sports scientist","head coach")
attribute_list[["purpose"]] <- c("health concern","load management","team readiness")
attribute_list[["recipient"]] <- c("physician","athletic trainer","strength coach","sports scientist","head coach","whole team")
#attribute_list[["recipient"]] <- c("physician","athletic trainer","strength coach","sports scientist","head coach","whole team", "you, the athlete")

constraint_list <- list()
constraint_list[[1]] <- list()
constraint_list[[1]]["purpose"] <- c("health concern")
constraint_list[[1]]["sender"] <- c("strength coach","sports scientist","head coach")
constraint_list[[2]] <- list()
constraint_list[[2]]["purpose"] <- c("load management")
constraint_list[[2]]["sender"] <- c("physician","athletic trainer")
constraint_list[[3]] <- list()
constraint_list[[3]]["purpose"] <- c("team readiness")
constraint_list[[3]]["sender"] <- c("physician","athletic trainer","head coach")
constraint_list[[4]] <- list()
constraint_list[[4]]["purpose"] <- c("health concern")
constraint_list[[4]]["recipient"] <- c("sports scientist","whole team")
constraint_list[[5]] <- list()
constraint_list[[5]]["purpose"] <- c("load management")
constraint_list[[5]]["recipient"] <- c("whole team")
#constraint_list[[6]] <- list()
#constraint_list[[6]]["purpose"] <- c("team readiness")
#constraint_list[[6]]["recipient"] <- c("you, the athlete")

design <- makeDesign(
  type = "constraints",
  attribute.levels = attribute_list,
  constraints = constraint_list
)

indices <- which(design$J > 0, arr.ind = TRUE)
combinations <- apply(indices, 1, function(idx) {
  sapply(seq_along(idx), function(dim_i) {
    dimnames(design$J)[[dim_i]][[idx[dim_i]]]
  })
})
df <- as.data.frame(t(combinations), stringsAsFactors = FALSE)
colnames(df) <- names(dimnames(design$J))
rownames(df) <- paste0("V", sprintf("%03d", nrow(df)))
phrases <- c(
  "sender_readiness" = ", along with the rest of the team's data",
  "health concern" = " evaluates the data for a health concern",
  "load management" = " evaluates the data to decide whether to increase or reduce your training load that day",
  "team readiness" = " aggregates the data"
)

df %>%
  select(sender, purpose, recipient) %>%
  mutate(qualtrics = paste0(
    "You send your menstrual cycle data to your team's ",
    sender,
    if_else(purpose = "team readiness", phrases["sender_readiness"]),
    ". The ",
    sender,
    phrases[purpose],
    if_else(sender = recipient, "and does not share the information further.", paste("and passes it along to your", recipient))
  ))
