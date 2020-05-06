list_unknown_sites <- function(site_data, site_data_patched) {
  all_names       <- site_data$site_name
  known_names     <- site_data_patched$site_name
  remaining_names <- all_names[!all_names %in% known_names]

  remaining_names
}