get_fact_sheet_url_data <- function(fact_sheet_html,
                                    link_base = "https://www2.illinois.gov") {
  candidates   <- rvest::html_nodes(fact_sheet_html,
                                    xpath = "//div/ul/li/a[@href]")
  all_facts    <- candidates[grepl("FactSheets", candidates)]
  target_nodes <- all_facts[!grepl("All Regions", all_facts)]
  url_suffix   <- rvest::html_attr(target_nodes, name = "href")
  urls         <- paste0(link_base, url_suffix)
  url_data     <- tibble::tibble(region_url = urls)

  url_data
}