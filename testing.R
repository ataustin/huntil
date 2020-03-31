library(rvest)
library(jsonlite)
library(dplyr)
library(purrr)
library(leaflet)
library(htmltools)

devtools::load_all()

# to refresh everything:
# site_data <- build_huting_site_data()

load("site_data.rda")
site_data$site_html <- lapply(site_data$site_html_char, xml2::read_html)


# make HTML map
site_data %>%
  filter(is_species) %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addMarkers(~lon, ~lat,
             popup = ~popup,
             label = ~site_name) %>%
  htmlwidgets::saveWidget(file = "test.html",
                          selfcontained = FALSE)
 

# Use shady join (first word of park only) to match KML to site_data
sites_without_kml_match <-  # site data with no KML data
  site_data %>%
  mutate(no_gps = is.na(lat) | is.na(lon),
         shady_join_key = gsub("(\\w+).*", "\\1", site_name)) %>%
  filter(no_gps)

remaining_kml_sites_with_gps <- # KML data with no matching site URL
  get_geocoded_data(read_hunting_area_kml()) %>%
  mutate(kml_not_matched = !(site_url_base_kml %in% site_data$site_url_base),
         shady_join_key = gsub("(\\w+).*", "\\1", site_name_kml)) %>%
  filter(kml_not_matched,
         site_name_kml != "") %>%
  group_by(shady_join_key) %>%
  summarize(lat = mean(lat),
            lon = mean(lon))

sites_without_kml_match <-
  sites_without_kml_match %>%
  select(-lat, -lon) %>%
  left_join(remaining_kml_sites_with_gps, by = "shady_join_key") %>%
  mutate(no_gps = is.na(lat) | is.na(lon),
         site_name_first_two = gsub("(\\w+) (\\w+).*", "\\1 \\2", site_name)) %>%
  filter(no_gps)


# use self-join (site_data to site_data) to match same sites
approx_site_gps <-
  site_data %>%
  mutate(site_name_first_two = gsub("(\\w+) (\\w+).*", "\\1 \\2", site_name)) %>%
  group_by(site_name_first_two) %>%
  summarize(lat = mean(lat, na.rm = TRUE),
            lon = mean(lon, na.rm = TRUE)) %>%
  filter(!is.na(lat) | !is.na(lon)) %>%
  semi_join(sites_without_kml_match, by = "site_name_first_two")


sites_without_approx_match <-
  sites_without_kml_match %>%
  select(-lat, -lon) %>%
  left_join(approx_site_gps, by = "site_name_first_two") %>%
  mutate(no_gps = is.na(lat) | is.na(lon)) %>%
  filter(no_gps)


sites_requiring_manual_input <- sort(sites_without_approx_match$site_name)


get_manual_site_gps <- function() {
  tibble::tribble(
    ~site_name,                                                     ~lat,      ~lon,
    "Adeline Jay Geo-Karis Illinois Beach State Park Archery Deer", 42.429931, -87.819456,
    "Black Crown Marsh Waterfowl"                                 , 42.321324, -88.207433,
    "Buffalo Prairie Pheasant Habitat Area"                       , 41.040309, -90.044469,
    "Burning Star"                                                , 37.886680, -89.219607,
    "Chatsworth State Habitat Area"                               , 40.684360, -88.284936,
    "Cretaceous Hills State Natural Area"                         , 37.225263, -88.529764,
    "Dixon Springs"                                               , 37.384384, -88.677415,
    "Embarras River Bottoms State Habitat Area"                   , 38.664059, -87.634106,
    "Embarras River Waterfowl"                                    , 38.664059, -87.634106,
    "Goode's Woods Nature Preserve"                               , 39.452854, -89.934803,
    "Henry Allen Gleason Nature Preserve"                         , 40.420748, -89.866082,
    "I&M Canal Trapping"                                          , 41.346342, -88.479828,
    "Maxine Loy Land and Water Reserve"                           , 38.810191, -88.807785,
    "Mitchell's Grove Nature Preserve"                            , 41.376292, -89.067765,
    "Revis Hill Prairie Nature Preserve"                          , 40.151623, -89.852346,
    "Sinnissippi Lake State Fish and Wildlife Area"               , 41.782581, -89.636067,
    "Sparks Pond Land and Water Reserve"                          , 40.387040, -89.813282,
    "Vesely Prairie LWR - Wilmington Shrub Prairie"               , 41.280036, -88.152821,
    "Witkowsky State Fish Wildlife Area"                          , 42.293676, -90.343588,
    "Zoeller State Natural Area"                                  , 38.451379, -90.168036
  )
}

# TODO
# fix GPS for no-show locations like Iroquois -- requires manual table match!
# get seasons data to display
# get windshield card sites data
  # use crosstalk to link DT and leaflet for selecting sites -- windshield card

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
