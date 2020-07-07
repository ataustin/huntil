append_map_popup <- function(site_data_with_coords) {
  site_data_popup <- dplyr::mutate(site_data_with_coords,
                                   popup = purrr::pmap_chr(list(site_name,
                                                                site_url,
                                                                species_row,
                                                                lat,
                                                                lon),
                                                    build_popup))

  site_data_popup
}


build_popup <- function(site_name, url, species_row, lat, lon) {
  paste(popup_style(),
    site_name,
    popup_site_url(url),
    popup_directions(lat, lon),
    popup_site_species_datum(species_row),
    sep = "<br/>"
  )
}


popup_style <- function() {
  "<style> div.leaflet-popup-content {width:auto !important;}</style>"
}


popup_site_url <- function(url) {
  paste0('<b><a href="', url, '" target="_blank">Area Website</a></b><br/>')
}


popup_site_species_datum <- function(species_row) {
  kbl <- knitr::kable(species_row, format = "html", row.names = FALSE)
  as.character(kbl)
}


popup_directions <- function(lat, lon) {
  url <- get_directions_url(lat, lon)
  paste0('<b><a href="', url, '" target="_blank">Directions</a></b><br/>')
}


get_directions_url <- function(lat, lon) {
  from_lat <- "41.83119"
  from_lon <- "-88.054425"
  url_base <- "https://www.google.com/maps/dir"
  url_ext <- paste(paste(from_lat, from_lon, sep = ","),
    paste(lat, lon, sep = ","),
    sep = "/"
  )
  url_out <- paste(url_base, url_ext, sep = "/")

  url_out
}