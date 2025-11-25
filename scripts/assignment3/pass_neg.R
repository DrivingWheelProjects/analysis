library(gt)

nflfastR::load_pbp(2025) |>
  dplyr::group_by(receiver, receiver_id, posteam) |>
  dplyr::filter(play_type == "pass", air_yards < yardline_100, posteam == "DET") |>
  dplyr::mutate(neg_play = ifelse(sack == 1, 1, 
                                  ifelse(fumble_lost == 1, 1, 
                                         ifelse(interception == 1, 1, 0)))) |>
  dplyr::mutate(exp_fd = ifelse(xyac_fd >= 0.99, 1, 0)) |>
  dplyr::mutate(actual_exp_fd = ifelse(xyac_fd >= 0.99 & first_down, 1, 0)) |>
  dplyr::mutate(not_fd = ifelse(xyac_fd < 0.99, 1, 0)) |>
  dplyr::mutate(actual_not_fd = ifelse(xyac_fd < 0.99 & first_down, 1, 0)) |>
#  dplyr::mutate(exp_fd = if_else((!is.na(xyac_fd)) AND (xyac_fd > 0), 1, 0)) |>
#  dplyr::summarize(play_id, play_type, neg_play, epa, desc)
  dplyr::summarize(
      passes = dplyr::n(),
      neg_pct = sum(neg_play) / dplyr::n(),
      fum_epa = sum(neg_epa) / sum(neg_play),
      gt_com = sum(exp_fd*(complete_pass)),
      gt_fd = sum(exp_fd, na.rm=TRUE),
      actual_gt_fd = sum(actual_exp_fd, na.rm=TRUE),
      gt_fd_pct = actual_gt_fd / gt_fd,
      lt_com = sum(not_fd*(complete_pass)),
      lt_fd = sum(not_fd, na.rm=TRUE),
      actual_lt_fd = sum(actual_not_fd, na.rm=TRUE),
      lt_fd_pct = actual_lt_fd / lt_fd
  ) |>
  dplyr::ungroup() |>
  dplyr::select(receiver, posteam, passes, neg_pct, fum_epa, gt_com, gt_fd, actual_gt_fd, gt_fd_pct, lt_com, lt_fd, actual_lt_fd, lt_fd_pct) |>
  gt()
  