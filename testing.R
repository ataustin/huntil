library(rvest)
library(jsonlite)
library(dplyr)
library(purrr)
library(leaflet)
library(htmltools)

devtools::load_all()

# site_url_data <-
#   get_fact_sheet_top_level_html() %>%
#   get_fact_sheet_url_data() %>%
#   get_site_url_data()

# geocoded_data <-
#   read_hunting_area_kml() %>%
#   get_geocoded_data()

# site_data <-
#   site_url_data %>%
#   left_join(geocoded_data, by = c("site_url_base" = "site_url_base_kml"))

site_data <- build_huting_site_data()

site_data$popup_link <-
  paste("<style> div.leaflet-popup-content {width:auto !important;}</style>",
        site_data$site_name,
        paste0('<b><a href="', site_data$site_url, '">Area Website</a></b><br/>'),
        sapply(site_data$species_row, function(x) knitr::kable(x, format = "html", row.names = FALSE)),
        sep = "<br/>")

site_data %>%
  filter(is_species) %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(~lon, ~lat,
             popup = ~popup_link) %>%
  htmlwidgets::saveWidget(file = "test.html",
                          selfcontained = FALSE)

# TODO
# try to extract each site's MAP URL
# try to extract other text elements that mention squirrel
# fix GPS for no-show locations like Iroquois -- requires manual table match!

seasons_data <-
  get_fact_sheet_html() %>%
  get_fact_sheet_link("statewide seasons") %>%
  get_statewide_seasons_data()


clean_site_name <- function(site_name) {
  site_name <- gsub(" - .*", "", site_name)
  site_name <- gsub("(.*)", "", site_name)
  site_name <- gsub(" /.*", "", site_name)
  site_name <- gsub("sfwa", "", ignore.case = TRUE)
}
