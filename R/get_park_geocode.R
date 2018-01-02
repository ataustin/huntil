check_geocode <- function(api_return) {
  length_one <- length(api_return$results) == 1
  status_ok <- api_return$status == "OK"
  state_il <- api_return$results[[1]]$address_components[[6]]$short_name == "IL"
}



geocode <- function(address) {
  url <- "http://maps.google.com/maps/api/geocode/json?address="
  url <- URLencode(paste(url, address, "&sensor=false", sep = ""))

  x <- fromJSON(url, simplify = FALSE)
  if (x$status == "OK") {
    address_components <- x$results[[1]]$address_components
    geometry           <- x$results[[1]]$geometry
    out <- data.frame(lat = geometry$location$lat,
                      lon = geometry$location$lng,
                      long_name = address_components[[1]]$long_name)
  } else {
    out <- data.frame(lat = NA, lon = NA, long_name = NA)
  }
  Sys.sleep(0.25)  # API only allows 5 requests per second, slow it down to max of 4 for safety
  out
}


clean_site_name <- function(site_name) {
  
}
