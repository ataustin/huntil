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


find_species_record <- function(table, species) {
  if(!length(table)) return(NULL)

  column_has_species <- table[grepl(species, table, ignore.case = TRUE)]
  species_index      <- grep(species, column_has_species[[1]], ignore.case = TRUE)
  species_record     <- table[species_index, ]

  species_record
}



get_species_tables <- function(park_htmls) {
  park_tables_list <- lapply(park_htmls, rvest::html_table,
                             header = TRUE, fill = TRUE)
  table_list       <- lapply(park_tables_list, clean_tables)
  species_records  <- lapply(table_list, find_species_record,
                             species = attr(park_htmls, "species"))

  species_records
}
