get_site_url_data <- function(fact_sheet_url_data, species = "squirrel") {
  site_url_nested <- dplyr::mutate(fact_sheet_url_data,
                                   site_url = purrr::map(region_url, get_region_url_data))
  site_url_data   <- tidyr::unnest(site_url_nested, cols = site_url)
  
  tmp <- site_url_data[1:10,]
  
  site_data <- dplyr::mutate(tmp,
                             site_html      = purrr::map(site_url, get_site_html),
                             site_table     = purrr::map(site_html, get_site_table),
                             site_html_char = purrr::map_chr(site_html, as.character),
                             is_species     = grepl(species, site_html_char, ignore.case = TRUE),
                             species_row    = purrr::map(site_table, reduce_table, species = species))

  site_data
}


get_region_url_data <- function(region_url) {
  html             <- xml2::read_html(region_url)
  region_name_node <- rvest::html_node(html, xpath = "//div/div/h1")
  region_name      <- rvest::html_text(region_name_node)
  site_url_nodes   <- rvest::html_nodes(html, xpath = "//div[@class='menu']/a")
  site_urls        <- rvest::html_attr(site_url_nodes, name = "href")
  site_urls_encode <- vapply(site_urls, URLencode, character(1))  # URLencode is not vectorized
  site_names       <- rvest::html_text(site_url_nodes)
  url_data         <- tibble::tibble(region_name   = clean_region_names(region_name),
                                     site_name     = trimws(site_names, which = "both"),
                                     site_url      = site_urls_encode,
                                     site_url_base = basename(site_url))

  url_data
}


clean_region_names <- function(region_names) {
  ws_removed <- trimws(region_names, which = "both")
  name_only  <- gsub("\\s.*", "", ws_removed)

  name_only
}


get_site_html <- function(site_url, sleep_interval = 1) {
  Sys.sleep(sleep_interval)
  site_html   <- xml2::read_html(site_url)

  site_html
}


get_site_table <- function(site_html) {
  site_table    <- rvest::html_table(site_html, header = TRUE, fill = TRUE)
  table_checked <- if(check_table(site_table)) site_table[[1]] else NULL
  
  table_checked
}


check_table <- function(table) {
  if(!length(table)) return(FALSE)

  names_are_blank <- all(names(table) == "")
  has_few_rows    <- nrow(table) < 2
  has_no_contents <- !any(!is.na(table))
  table_check     <- !names_are_blank || !has_few_rows || !has_no_contents
  
  table_check
}


reduce_table <- function(table, species = "squirrel") {
  species_ix <- apply(table, 1, function(row) any(grepl(species, row, ignore.case = TRUE)))
  species_row <- table[species_ix, ]
  row <- if (length(species_row) == 0) NULL else species_row

  row
}