save_map_widget <- function(widget, file_base) {
  root_dir  <- rprojroot::find_root(rprojroot::has_dir(".git"))
  save_path <- file.path(root_dir, "www", "resources", paste0(file_base, ".html"))
  htmlwidgets::saveWidget(widget = widget,
                          file   = save_path,
                          selfcontained = FALSE)
}