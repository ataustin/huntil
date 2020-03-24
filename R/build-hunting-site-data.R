build_huting_site_data <- function(url = "https://www.dnr.illinois.gov/hunting/FactSheets/Pages/default.aspx") {
  fact_sheet_html     <- get_fact_sheet_top_level_html(url)
  fact_sheet_url_data <- get_fact_sheet_url_data(fact_sheet_html)
  site_url_data       <- get_site_url_data(fact_sheet_url_data)

  hunting_area_kml   <- read_hunting_area_kml()
  geocoded_site_data <- get_geocoded_data(hunting_area_kml)

  site_data <- left_join(site_url_data, geocoded_site_data,
                         by = c("site_url_base" = "site_url_base_kml"))

  site_data
}