#' Get Hunter Fact Sheet URL
#'
#' Returns the URL corresponding to the top-level hunter fact sheet page
#' @details This URL is hard-coded in the function body.  If it changes at any
#'          point in the future this function will need to be updated.
#' @return The URL as a character string
#' @export
get_fact_sheet_html <- function(url = "https://www.dnr.illinois.gov/hunting/FactSheets/Pages/default.aspx") {  
  error_fun <- function(e) {
    stop("Could not retrieve HTML; check the supplied URL.")
  }
  
  tryCatch(html <- read_html(url),
           error = error_fun)
  
  html
}


get_fact_sheet_link <- function(fact_sheet_html, search_term) {
  candidates  <- html_nodes(fact_sheet_html, xpath = "//div/ul/li/a[@href]")
  target_node <- candidates[grepl(search_term, candidates, ignore.case = TRUE)]
  link_suffix <- html_attr(target_node, name = "href")
  link        <- paste0("https://www.dnr.illinois.gov", link_suffix)
  
  link
}



get_park_links <- function(all_regions_url) {
  html  <- read_html(all_regions_url)
  nodes <- html_nodes(html, xpath = "//div[@class='menu']/a")
  links <- html_attr(nodes, name = "href")
  names <- html_text(nodes)
  
  named_links <- setNames(links, names)
  named_links
}


get_statewide_seasons_link <- function(fact_sheet_html) {
  
}
