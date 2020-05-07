get_fact_sheet_url <- function(fact_sheet_html,
                               search_term,
                               link_base = "https://www2.illinois.gov") {
  candidates   <- rvest::html_nodes(fact_sheet_html,
                                    xpath = "//div/ul/li/a[@href]")
  target_node  <- candidates[grepl(search_term, candidates, ignore.case = TRUE)]
  url_suffix   <- rvest::html_attr(target_node, name = "href")
  url         <- paste0(link_base, url_suffix)

  url
}