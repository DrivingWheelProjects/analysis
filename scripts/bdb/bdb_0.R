track <- read.csv("./data/nfl-big-data-bowl-2026-prediction/train/input_2023_w01.csv")
summary(track)

# game_id/play_id/frame_id to group by frame
# game_id/play_id/nfl_id to group by player

library(dplyr)
library(tidyr)
player <- track |>
  group_by(game_id, nfl_id)

play <- track |> 
  group_by(game_id, nfl_id, play_id)

receivers_offset <- play |>
  filter(player_role %in% c("Targeted Receiver", "Other Route Runner")) |>
  group_by(nfl_id) |>
  mutate(group_size = n()) |>
  ungroup() |>
  distinct(nfl_id, group_size) |>
  arrange(desc(group_size)) |>
  slice(1:60) |>
  inner_join(play, by="nfl_id") |>
  group_by(nfl_id, play_id) |>
  tally() |>
  mutate(csum = cumsum(n)) |>
  mutate(offset = c(0, csum[-length(csum)]))

receivers_top <- receivers_offset |>
  distinct(nfl_id) |>
  pull(nfl_id)

receivers <- play |>
  filter(nfl_id %in% receivers_top) |>
  mutate(dx = x - lag(x)) |>
  mutate(collision_x = round(x)) |>
  mutate(dy = y - lag(y)) |>
  mutate(collision_y = round(y)) |>
  mutate(dist = sqrt(dx^2 + dy^2)) |>
  summarize(game_id, nfl_id, play_id, x,y,dx,dy,collision_x,collision_y,dist,dir,frame_id, player_role, player_side)

defense <- track |>
  filter(player_side == "Defense") |>
  mutate(collision_x = round(x)) |>
  mutate(collision_y = round(y)) |>
  summarize(game_id, play_id, frame_id, collision_x, collision_y, nfl_id, player_role)

collisions <- defense |>
  semi_join(receivers, by = c("collision_x","collision_y","game_id","play_id","frame_id")) 

collisions <- collisions |>
  left_join(receivers, by = c("game_id", "play_id", "frame_id")) |>
  mutate("collision_id" = nfl_id.x) |>
  mutate("nfl_id" = nfl_id.y) |>
  summarize(game_id, play_id, frame_id, nfl_id, collision_id,x,y)

library(jsonlite)
#diggs <- diggs |> nest()
json <- toJSON(collisions, pretty=TRUE)
writeLines(json,"data/collisions.json")


#Stefon Diggs player_id = 42489
diggs_offset <- play |>
  filter(nfl_id == "42489") |>
  group_by(play_id) |>
  tally() |>
  mutate(csum = cumsum(n)) |>
  mutate(offset = c(0, csum[-length(csum)]))

diggs <- play |>
  filter(nfl_id == "42489") |>
  mutate(dx = x - lag(x)) |>
  mutate(dy = y - lag(y)) |>
  mutate(dist = sqrt(dx^2 + dy^2)) |>
  summarize(x,y,dx,dy,dist,dir,frame_id)

diggs_58 <- diggs |>
  filter(play_id == "58") |> 
  mutate(dx = x - lag(x)) |>
  mutate(dy = y - lag(y)) |>
  mutate(dist = sqrt(dx^2 + dy^2)) |>
  summarize(x,y,dx,dy,dist,dir,frame_id)
print(diggs_58)

library(jsonlite)
#diggs <- diggs |> nest()
json <- toJSON(receivers, pretty=TRUE)
writeLines(json,"data/receivers.json")
