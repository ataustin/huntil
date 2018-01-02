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
