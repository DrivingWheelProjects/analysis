# 1.
nflfastR::load_pbp(2025) |>
  dplyr::group_by(receiver, receiver_id, posteam) |>
  dplyr::mutate(tgt = sum(complete_pass + incomplete_pass)) |>
  dplyr::filter(tgt >= 5) |>
#  dplyr::filter(complete_pass == 1, air_yards < yardline_100, !is.na(xyac_epa)) |>
  dplyr::filter(complete_pass == 1, air_yards < yardline_100, !is.na(xyac_epa), posteam == "DET") |>
  dplyr::summarize(
    epa_oe = mean(yac_epa - xyac_epa),
    actual_fd = mean(first_down),
    expected_fd = mean(xyac_fd),
    fd_oe = mean(first_down - xyac_fd),
    rec = dplyr::n(),
    tgt_pct = mean(rec / tgt)
  ) |>
  dplyr::ungroup() |>
  dplyr::select(receiver, posteam, actual_fd, expected_fd, fd_oe, epa_oe, rec, tgt_pct) |>
  dplyr::slice_max(epa_oe, n = 100) |>
  knitr::kable(digits = 3)
