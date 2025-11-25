library(gt)

nflfastR::load_pbp(2025) |>
#  dplyr::group_by(receiver, receiver_id, posteam) |>
  dplyr::filter(play_type == "pass", air_yards < yardline_100, fumble_lost == 1 | first_down == 1) |>
  dplyr::summarize(
    epa_fumble = sum(epa * fumble_lost) / sum(fumble_lost),
    epa_fd = sum(epa* first_down) / sum(first_down))  |>
    gt()            
  