get_fact_sheet_html <- function(url = "https://www.dnr.illinois.gov/hunting/FactSheets/Pages/default.aspx") {
  error_fun <- function(e) {
    stop("Could not retrieve HTML; check the supplied URL.")
  }

  tryCatch(html <- xml2::read_html(url),
           error = error_fun)

  html
}


get_fact_sheet_link <- function(fact_sheet_html, search_term,
                                link_base = "https://www.dnr.illinois.gov") {
  candidates  <- rvest::html_nodes(fact_sheet_html,
                                   xpath = "//div/ul/li/a[@href]")
  target_node <- candidates[grepl(search_term, candidates, ignore.case = TRUE)]
  link_suffix <- rvest::html_attr(target_node, name = "href")
  link        <- paste0(link_base, link_suffix)

  link
}



get_park_links <- function(region_url) {
  html  <- xml2::read_html(region_url)
  nodes <- rvest::html_nodes(html, xpath = "//div[@class='menu']/a")
  links <- rvest::html_attr(nodes, name = "href")
  names <- rvest::html_text(nodes)

  named_links <- setNames(links, names)
  named_links
}
