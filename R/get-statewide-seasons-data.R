get_statewide_seasons_data <- function(statewide_seasons_url) {
  seasons_html  <- xml2::read_html(statewide_seasons_url)
  seasons_nodes <- rvest::html_nodes(seasons_html, xpath = "//div[@class='item link-item']")
  seasons_text  <- rvest::html_text(seasons_nodes)

  seasons_data <-
    if(!length(seasons_text)) {
      data.frame(season = "No data",
                 start  = "No data",
                 end    = "No data")
    } else {
      parse_seasons_text(seasons_text)
    }

  seasons_data
}


parse_seasons_text <- function(raw_seasons) {
  seasons_clean <- gsub("[\r\t\n]", "", raw_seasons)
  seasons_split <- strsplit(seasons_clean, " - | to ")
  seasons_mat   <- do.call(rbind, seasons_split)
  seasons_df    <- as.data.frame(seasons_mat, stringsAsFactors = FALSE)

  names(seasons_df) <- c("season", "start", "end")
  seasons_df$start  <- as.Date(seasons_df$start, format = "%m/%d/%Y")
  seasons_df$end    <- as.Date(seasons_df$end, format = "%m/%d/%Y")

  seasons_df
}
