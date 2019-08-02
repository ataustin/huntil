clean_border_blanks <- function(char) {
  gsub("^\\s*|\\s*$", "", char)
}
