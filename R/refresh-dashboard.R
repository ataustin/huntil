refresh_dashboard <- function(refresh_sites = FALSE, refresh_seasons = FALSE) {
  data(site_data, envir = environment())
  data(seasons_data, envir = environment())

  if(refresh_sites) site_data <- refresh_site_data()
  if(refresh_seasons) seasons_data <- refresh_seasons_data()

  rmarkdown::render(system.file("rmd", "index.Rmd", package = "huntil"),
                    output_dir = rprojroot::find_root(rprojroot::has_dir(".git")),
                    envir = environment())
}