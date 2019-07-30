library(rvest)
library(jsonlite)

devtools::load_all()

park_links <-
  get_fact_sheet_html() %>%
  get_fact_sheet_link("all regions") %>%
  get_park_links()

species_tables <-
  park_links[2:3] %>%
  get_park_htmls(species = "squirrel") %>%
  get_species_tables()


seasons_link <-
  get_fact_sheet_html() %>%
  get_fact_sheet_link("statewide seasons") %>%
  get_statewide_seasons_data()


geocoded_data <-
  read_park_kml() %>%
  get_geocoded_data()


clean_site_name <- function(site_name) {
  site_name <- gsub(" - .*", "", site_name)
  site_name <- gsub("(.*)", "", site_name)
  site_name <- gsub(" /.*", "", site_name)
  site_name <- gsub("sfwa", "", ignore.case = TRUE)
}
