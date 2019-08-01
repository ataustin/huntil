get_fact_sheet_top_level_html <- function(url = "https://www.dnr.illinois.gov/hunting/FactSheets/Pages/default.aspx") {
  error_fun <- function(e) {
    stop("Could not retrieve HTML; check the supplied URL.")
  }

  tryCatch(html <- xml2::read_html(url),
           error = error_fun)

  html
}
