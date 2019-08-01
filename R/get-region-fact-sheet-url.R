get_region_fact_sheet_url <- function(fact_sheet_html, search_term,
                                       url_base = "https://www.dnr.illinois.gov") {
  candidates  <- rvest::html_nodes(fact_sheet_html,
                                   xpath = "//div/ul/li/a[@href]")
  target_node <- candidates[grepl(search_term, candidates, ignore.case = TRUE)]
  url_suffix  <- rvest::html_attr(target_node, name = "href")
  url         <- paste0(url_base, url_suffix)

  url
}
