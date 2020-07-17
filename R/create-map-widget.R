create_map_widget <- function(site_data) {
  species_data <- dplyr::filter(site_data, is_species)
  site_map     <- leaflet::leaflet(species_data)
  map_tiles    <- leaflet::addProviderTiles(site_map, providers$CartoDB.Positron)
  widget       <- leaflet::addMarkers(map_tiles,
                                      lng   = ~lon,
                                      lat   = ~lat,
                                      popup = ~popup,
                                      label = ~site_name)

  widget
}