build_seasons_data <- function(url_keywords = "statewide seasons") {
  fact_sheet_html <- get_fact_sheet_top_level_html()
  seasons_url     <- get_fact_sheet_url(fact_sheet_html, url_keywords)
  seasons_data    <- get_statewide_seasons_data(seasons_url)

  seasons_data
}