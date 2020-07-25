refresh_site_data <- function() {
  site_data    <- build_hunting_site_data()
  site_data    <- select(site_data,
                         site_name,
                         is_species,
                         lon,
                         lat,
                         popup)
  usethis::use_data(site_data, overwrite = TRUE)
  invisible(site_data)
}