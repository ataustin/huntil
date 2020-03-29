get_site_url_data <- function(fact_sheet_url_data, species = "squirrel") {
  site_url_nested <- dplyr::mutate(fact_sheet_url_data,
                                   site_url = purrr::map(region_url, get_region_url_data))
  site_url_data   <- tidyr::unnest(site_url_nested, cols = site_url)
  
  site_data <- dplyr::mutate(site_url_data,
                             site_html      = purrr::map(site_url, get_site_html),
                             site_html_char = purrr::map_chr(site_html, as.character),
                             is_species     = purrr::map_lgl(site_html_char, grep_species,
                                                             species = species),
                             site_tables    = purrr::map(site_html, get_site_tables),
                             site_table     = purrr::map(site_tables, select_table),
                             species_row    = purrr::map(site_table, reduce_table,
                                                         species = species),
                             popup          = purrr::pmap_chr(list(site_name, url, species_row, lat, lon),
                                                              build_popup))

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


get_site_html <- function(site_url, sleep_interval = 0.5) {
  Sys.sleep(sleep_interval)
  site_html   <- xml2::read_html(site_url)

  site_html
}


grep_species <- function(html_char, species) {
  html_mentions_species    <- grepl(species, html_char, ignore.case = TRUE)
  needs_special_adjustment <- grepl("Matthiessen Deer/Turkey Map", html_char, fixed = TRUE)

  is_species <- html_mentions_species & !needs_special_adjustment

  is_species
}


get_site_tables <- function(site_html) {
  site_tables <- tryCatch(rvest::html_table(site_html, header = TRUE, fill = TRUE, trim = TRUE),
                          error = function(e) NULL)
  tables_checked <- if(check_tables(site_tables)) site_tables else NULL
  
  tables_checked
}


check_tables <- function(table) {
  if(!length(table)) return(FALSE)

  names_are_blank <- all(names(table) == "")
  has_few_rows    <- nrow(table) < 2
  has_no_contents <- !any(!is.na(table))
  table_check     <- !names_are_blank || !has_few_rows || !has_no_contents
  
  table_check
}


select_table <- function(tables) {
  # in the case in which there are multiple tables on a given location's page,
  # the table with more rows contains a column indicating species.
  if(length(tables) > 1) {
    row_counts <- vapply(tables, nrow, integer(1))
    max_row_ix <- which.max(row_counts)
    table      <- tables[[max_row_ix]]
  } else {
    table <- tables[[1]]
  }

  table
}


reduce_table <- function(table, species = "squirrel") {
  if(is.null(table)) return(NULL)

  col_is_species <- grepl("species|program", names(table), ignore.case = TRUE)
  if(!any(col_is_species)) return(NULL)

  species_col <- table[, col_is_species]
  species_ix  <- which(grepl(species, species_col, ignore.case = TRUE))
  species_row <- table[species_ix, ]
  reduced_row <- if(nrow(species_row) == 0) NULL else clean_row(species_row, col_is_species)
  cleaned_row <- 

  reduced_row
}


clean_row <- function(row, which_col) {
  row[, which_col] <- gsub("1.*", "", row[, which_col])
  row
}


build_popup <- function(site_name, url, species_row, lat, lon) {
  paste(popup_style(),
    site_name,
    popup_site_url(url),
    popup_directions(lat, lon),
    popup_site_species_datum(species_row),
    sep = "<br/>"
  )
}


popup_style <- function() {
  "<style> div.leaflet-popup-content {width:auto !important;}</style>"
}


popup_site_url <- function(url) {
  paste0('<b><a href="', url, '" target="_blank">Area Website</a></b><br/>')
}


popup_site_species_datum <- function(species_row) {
  kbl <- knitr::kable(species_row, format = "html", row.names = FALSE)
  as.character(kbl)
}


popup_directions <- function(lat, lon) {
  url <- get_directions_url(lat, lon)
  paste0('<b><a href="', url, '" target="_blank">Directions</a></b><br/>')
}


get_directions_url <- function(lat, lon) {
  from_lat <- "41.83119"
  from_lon <- "-88.054425"
  url_base <- "https://www.google.com/maps/dir"
  url_ext <- paste(paste(from_lat, from_lon, sep = ","),
    paste(lat, lon, sep = ","),
    sep = "/"
  )
  url_out <- paste(url_base, url_ext, sep = "/")

  url_out
}