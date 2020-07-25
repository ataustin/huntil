refresh_seasons_data <- function() {
  seasons_data <- build_seasons_data()
  usethis::use_data(seasons_data, overwrite = TRUE)
  invisible(seasons_data)
}