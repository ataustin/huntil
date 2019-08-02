get_park_url_data <- function(region_url) {
  html <- xml2::read_html(region_url)

  region_name_node <- rvest::html_node(html, xpath = "//div/div/h1")
  region_name      <- rvest::html_text(region_name_node)

  url_nodes  <- rvest::html_nodes(html, xpath = "//div[@class='menu']/a")
  park_urls  <- rvest::html_attr(url_nodes, name = "href")
  park_names <- rvest::html_text(url_nodes)

  tibble::tibble(region         = clean_border_blanks(region_name),
                 park_name      = clean_border_blanks(park_names),
                 fact_sheet_url = park_urls)
}
