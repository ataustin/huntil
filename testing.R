# NOTE: I had to re-install selectr in order to get html_table to work

library(colorout)
# library(huntil)
# library(RJSONIO)

devtools::load_all()

park_links <-
  get_fact_sheet_html() %>%
  get_fact_sheet_link("all regions") %>%
  get_park_links()

links      <- park_links[2:3]
park_htmls <- get_park_htmls(links)
species_tables <- get_species_tables(park_htmls)


seasons_link <-
  get_fact_sheet_html() %>%
  get_fact_sheet_link("statewide seasons") %>%
  get_statewide_seasons_data()


geocode("Anderson Lake State Park Illinois")
