get_park_url_data <- function(fact_sheet_url_data) {
  site_url_nested <- dplyr::mutate(fact_sheet_url_data,
                                   site_url = purrr::map(region_url, get_region_url_data))
  site_url_data <- tidyr::unnest(site_url_nested, cols = site_url)

  site_url_data
}


get_region_url_data <- function(region_url) {
  html             <- xml2::read_html(region_url)
  region_name_node <- rvest::html_node(html, xpath = "//div/div/h1")
  region_name      <- rvest::html_text(region_name_node)
  site_url_nodes   <- rvest::html_nodes(html, xpath = "//div[@class='menu']/a")
  site_urls        <- rvest::html_attr(site_url_nodes, name = "href")
  site_names       <- rvest::html_text(site_url_nodes)
  link_data        <- data.frame(region_name = clean_region_names(region_name),
                                 site_name   = trimws(site_names, which = "both"),
                                 site_url    = site_urls)

  link_data
}


clean_region_names <- function(region_names) {
  ws_removed <- trimws(region_names, which = "both")
  name_only  <- gsub("\\s.*", "", ws_removed)

  name_only
}