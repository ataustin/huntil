read_park_kml <- function() {
  kml_path <- system.file("kml", "public-hunting-areas-il.kml",
                          package = "huntil")

  xml2::read_html(kml_path)
}


extract_park_name <- function(park_kml) {
  get_kml_text(park_kml, "//folder/placemark/name")
}


extract_park_url <- function(park_kml) {
  url_text       <- get_kml_text(park_kml, "//folder/placemark/description")
  url_text_clean <- clean_park_url(url_text)

  url_text_clean
}


clean_park_url <- function(park_url) {
  url_raw   <- stringr::str_extract(park_url, "http.*aspx")
  url_https <-  gsub("http\\:", "https:", url_raw)

  url_https
}


extract_park_coordinates <- function(park_kml) {
  coord_text <- get_kml_text(park_kml, "//folder/placemark/point/coordinates")
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


get_geocoded_data <- function(park_kml) {
  park_name  <- extract_park_name(park_kml)
  park_url   <- extract_park_url(park_kml)
  park_coord <- extract_park_coordinates(park_kml)

  park_df <- data.frame(name = park_name,
                        url  = park_url,
                        stringsAsFactors = FALSE)
  park_df[3:4] <- convert_coords_to_data(park_coord)

  park_df
}


convert_coords_to_data <- function(raw_coord_text) {
  coord_split <- strsplit(raw_coord_text, split = ",")
  coord_mat   <- do.call(rbind, coord_split)
  coord_df    <- setNames(as.data.frame(coord_mat), c("lon", "lat"))

  coord_df
}
