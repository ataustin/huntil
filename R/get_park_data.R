is_species_site <- function(html, species) {
  grepl(species, html, ignore.case = TRUE)
}


get_park_htmls <- function(all_park_links, species = "squirrel") {
  htmls <- vector(mode = "list", length = length(all_park_links))
  names(htmls) <- names(all_park_links)
  
  for(i in seq_along(all_park_links)) {
    htmls[[i]] <- read_html(all_park_links[i])
    Sys.sleep(5)
  }
  
  has_species   <- vapply(htmls, is_species_site, logical(1), species = species)
  species_htmls <- htmls[has_species]
  
  species_htmls
}



check_table <- function(table) {
  names_are_blank <- all(names(table) == "")
  has_few_rows    <- nrow(table) < 2
  has_no_contents <- !any(!is.na(table))
  
  table_check <- !names_are_blank || !has_few_rows || !has_no_contents
  table_check
}


clean_tables <- function(park_tables) {
  table_is_good <- sapply(park_tables, check_table)
  table_output  <- park_tables[table_is_good]
  
  if(!length(table_output)) {
    return(NULL)
  } else if(length(table_output) == 1) {
    return(table_output[[1]])
  } else {
    return(table_output)
  }
}


get_species_tables <- function(park_htmls) {
  park_tables_list <- lapply(park_htmls, html_table, header = TRUE, fill = TRUE)
  table_list       <- lapply(park_tables_list, clean_tables)
  table_list
}
