build_hunting_site_data <- function(url = "https://www.dnr.illinois.gov/hunting/FactSheets/Pages/default.aspx") {
  fact_sheet_html <- get_fact_sheet_top_level_html(url)
  fact_sheet_urls <- vapply(get_region_names(),
                            function(nm) get_fact_sheet_url(fact_sheet_html, nm),
                            character(1))

  site_url_data        <- get_site_data(fact_sheet_urls)
  site_data_kml_coords <- append_kml_coords(site_url_data)
  site_data_imputed    <- impute_missing_coords(site_data_kml_coords)
  site_data_popup      <- append_map_popup(site_data_imputed)

  unknown_sites <- list_unknown_sites(site_url_data, site_data_imputed)
  if(length(unknown_sites) > 0) {
    msg <- paste0("The following sites do not have coordinates:\n",
                  paste(unknown_sites, collapse = ", "))
    warning(msg)
  }

  site_data_popup
}


get_region_names <- function() {
  region_names <- c("Northwest",
                    "Northeast",
                    "East Central",
                    "West Central",
                    "South")

  region_names
}


append_kml_coords <- function(site_url_data) {
  hunting_area_kml     <- read_hunting_area_kml()
  geocoded_site_data   <- get_geocoded_data(hunting_area_kml)
  site_data_kml_coords <- left_join(site_url_data, geocoded_site_data,
                                    by = c("site_url_base" = "site_url_base_kml"))

  site_data_kml_coords
}