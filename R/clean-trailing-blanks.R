clean_trailing_blanks <- function(char) {
  gsub("^\\s*|\\s*$", "", char)
}
