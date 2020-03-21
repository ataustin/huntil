get_geocoded_data <- function(kml) {
  site_name     <- extract_site_name(kml)
  site_url      <- extract_site_url(kml)
  site_kml_data <- tibble::tibble(site_name_kml = site_name,
                                  site_url_kml  = site_url)

  raw_coords <- extract_site_coordinates(kml)
  coord_data <- convert_coords_to_data(raw_coords)

  site_df <- mutate(site_kml_data,
                    lat = coord_data$lat,
                    lon = coord_data$lon)

  site_df
}


extract_site_name <- function(kml) {
  get_kml_text(kml, "//folder/placemark/name")
}


extract_site_url <- function(kml) {
  url_text       <- get_kml_text(kml, "//folder/placemark/description")
  url_text_clean <- clean_site_url(url_text)

  url_text_clean
}


clean_site_url <- function(site_url) {
  url_raw   <- stringr::str_extract(site_url, "http.*aspx")
  url_https <-  gsub("http\\:", "https:", url_raw)

  url_https
}


extract_site_coordinates <- function(kml) {
  coord_text       <- get_kml_text(kml, "//folder/placemark/point/coordinates")
  coord_text_clean <- clean_coordinates(coord_text)

  coord_text_clean
}


clean_coordinates <- function(coordinate_text) {
  coord_no_whitespace <- gsub("[[:space:]]", "", coordinate_text)
  coord_no_elevation  <- gsub(",0", "", coord_no_whitespace)

  coord_no_elevation
}


get_kml_text <- function(kml, xpath) {
  kml_nodes <- xml2::xml_find_all(kml, xpath)
  kml_text  <- xml2::xml_text(kml_nodes)

  kml_text
}


convert_coords_to_data <- function(raw_coord_text) {
  coord_split <- strsplit(raw_coord_text, split = ",")
  coord_mat   <- do.call(rbind, coord_split)
  coord_df    <- setNames(as.data.frame(coord_mat), c("lon", "lat"))

  coord_df
}
