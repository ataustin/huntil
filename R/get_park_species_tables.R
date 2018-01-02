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
