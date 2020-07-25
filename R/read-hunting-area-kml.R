read_hunting_area_kml <- function() {
  kml_path <- system.file("kml", "public-hunting-areas-il.kml",
                          package = "huntil"
  )
  kml_html <- xml2::read_html(kml_path)

  kml_html
}