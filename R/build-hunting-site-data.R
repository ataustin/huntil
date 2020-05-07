build_hunting_site_data <- function(url = "https://www.dnr.illinois.gov/hunting/FactSheets/Pages/default.aspx") {
  fact_sheet_html <- get_fact_sheet_top_level_html(url)
  fact_sheet_urls <- vapply(get_region_names(),
                            function(nm) get_fact_sheet_url(fact_sheet_html, nm),
                            character(1))
  site_url_data   <- get_site_data(fact_sheet_urls)

  hunting_area_kml   <- read_hunting_area_kml()
  geocoded_site_data <- get_geocoded_data(hunting_area_kml)

  site_data <- left_join(site_url_data, geocoded_site_data,
                         by = c("site_url_base" = "site_url_base_kml"))

  site_data
}


get_region_names <- function() {
  region_names <- c("Northwest",
                    "Northeast",
                    "East Central",
                    "West Central",
                    "South")

  region_names
}