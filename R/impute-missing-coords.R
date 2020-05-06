impute_missing_coords <- function(site_data) {
  sites_without_coords <- filter_to_no_coords(site_data)
  kml_without_match    <- compute_unmatched_kml_coordinates(site_data)
  sites_with_kml_patch <- patch_sites(sites_without_coords, kml_without_match, "first_word_key")

  sites_without_coords_2  <- filter_second(sites_without_coords, sites_with_kml_patch)
  sites_self_match_coords <- compute_self_match_coordinates(site_data, sites_without_coords_2)
  sites_with_self_patch   <- patch_sites(sites_without_coords_2, sites_self_match_coords, "first_two_words_key")

  sites_without_coords_3  <- filter_third(sites_without_coords, sites_with_kml_patch, sites_with_self_patch)
  sites_manual_coords     <- get_manual_site_coords()
  sites_with_manual_patch <- patch_sites(sites_without_coords_3, sites_manual_coords, "site_name")

  all_known_sites <- dplyr::bind_rows(sites_with_kml_patch,
                                      sites_with_self_patch,
                                      sites_with_manual_patch,
                                      dplyr::anti_join(site_data,
                                                        sites_without_coords,
                                                        by = "site_url"))

  original_columns <- all_known_sites[, names(site_data)]

  original_columns
}


filter_to_no_coords <- function(site_data) {
  # filter site_data to records with no coordinates and
  # create first-word join key for matching to KML data where URL is not enough
  site_data_coord_info <- dplyr::mutate(site_data,
                                        no_coords      = is.na(lat) | is.na(lon),
                                        first_word_key = gsub("(\\w+).*", "\\1", site_name))
  site_data_no_coords  <- dplyr::filter(site_data_coord_info, no_coords)

  site_data_no_coords
}


compute_unmatched_kml_coordinates <- function(site_data) {
  # filter KML data to records not matched via URL to site data
  # and compute approximate coordinates using means
  geocoded_data <- get_geocoded_data(read_hunting_area_kml())
  geocoded_info <- dplyr::mutate(geocoded_data,
                                 kml_not_matched = !(site_url_base_kml %in% site_data$site_url_base),
                                 first_word_key  = gsub("(\\w+).*", "\\1", site_name_kml))
  geocoded_unmatched <- dplyr::filter(geocoded_info,
                                      kml_not_matched,
                                      site_name_kml != "")
  geocoded_approx    <- dplyr::summarize(dplyr::group_by(geocoded_unmatched, first_word_key),
                                         lat = mean(lat),
                                         lon = mean(lon))

  geocoded_approx
}


patch_sites <- function(sites_without_coords, patching_sites, join_key) {
  sites_remove_coords <- dplyr::select(sites_without_coords, -lat, -lon)
  sites_patched       <- dplyr::inner_join(sites_remove_coords,
                                           patching_sites,
                                           by = join_key)

  sites_patched
}


filter_second <- function(sites_without_coords, sites_post_kml) {
  site_data_coord_info <- dplyr::mutate(sites_without_coords,
                                        first_two_words_key = gsub("(\\w+) (\\w+).*", "\\1 \\2", site_name))
  sites_without_coords <- dplyr::anti_join(site_data_coord_info,
                                           sites_post_kml,
                                           by = "first_word_key")

  sites_without_coords
}


compute_self_match_coordinates <- function(site_data, sites_without_coords) {
  data_with_key <- dplyr::mutate(site_data,
                                 first_two_words_key = gsub("(\\w+) (\\w+).*", "\\1 \\2", site_name))
  data_coords   <- dplyr::summarize(dplyr::group_by(data_with_key, first_two_words_key),
                                    lat = mean(lat, na.rm = TRUE),
                                    lon = mean(lon, na.rm = TRUE))
  self_match    <- dplyr::filter(data_coords,
                                 !is.na(lat) | !is.na(lon),
                                 first_two_words_key %in% sites_without_coords$first_two_words_key)

  self_match
}


filter_third <- function(sites_without_coords, sites_with_kml_patch, sites_with_self_patch) {
  sites_removing_kml_patches  <- dplyr::anti_join(sites_without_coords,
                                                  sites_with_kml_patch,
                                                  by = "site_url")
  sites_removing_self_patches <- dplyr::anti_join(sites_removing_kml_patches,
                                                  sites_with_self_patch,
                                                  by = "site_url")

  sites_removing_self_patches
}