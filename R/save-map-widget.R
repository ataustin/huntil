save_map_widget <- function(site_data) {
  species_data <- dplyr::filter(site_data, is_species)
  site_map     <- leaflet::leaflet(species_data)
  map_tiles    <- leaflet::addProviderTiles(site_map, providers$CartoDB.Positron)
  map_markers  <- leaflet::addMarkers(map_tiles,
                                      lng   = ~lon,
                                      lat   = ~lat,
                                      popup = ~popup,
                                      label = ~site_name)

  root_dir  <- rprojroot::find_root(rprojroot::has_dir(".git"))
  save_path <- file.path(root_dir, "www", "map.html")
  htmlwidgets::saveWidget(widget = map_markers,
                          file   = save_path,
                          selfcontained = FALSE)
}