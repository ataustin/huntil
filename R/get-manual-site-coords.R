get_manual_site_coords <- function() {
  tibble::tribble(
    ~site_name,                                                     ~lat,      ~lon,       ~season_added,
    "Adeline Jay Geo-Karis Illinois Beach State Park Archery Deer", 42.429931, -87.819456, 2019,
    "Black Crown Marsh State Natural Area"                        , 42.310560, -88.190950, 2020,
    "Black Crown Marsh Waterfowl"                                 , 42.321324, -88.207433, 2019,
    "Buffalo Prairie Pheasant Habitat Area"                       , 41.040309, -90.044469, 2019,
    "Burning Star"                                                , 37.886680, -89.219607, 2019,
    "Chatsworth State Habitat Area"                               , 40.684360, -88.284936, 2019,
    "Cretaceous Hills State Natural Area"                         , 37.225263, -88.529764, 2019,
    "Dixon Springs"                                               , 37.384384, -88.677415, 2019,
    "Embarras River Bottoms State Habitat Area"                   , 38.664059, -87.634106, 2019,
    "Embarras River Waterfowl"                                    , 38.664059, -87.634106, 2019,
    "Goode's Woods Nature Preserve"                               , 39.452854, -89.934803, 2019,
    "Henry Allen Gleason Nature Preserve"                         , 40.420748, -89.866082, 2019,
    "I&M Canal Trapping"                                          , 41.346342, -88.479828, 2019,
    "Maxine Loy Land and Water Reserve"                           , 38.810191, -88.807785, 2019,
    "Mitchell's Grove Nature Preserve"                            , 41.376292, -89.067765, 2019,
    "Revis Hill Prairie Nature Preserve"                          , 40.151623, -89.852346, 2019,
    "Sinnissippi Lake State Fish and Wildlife Area"               , 41.782581, -89.636067, 2019,
    "Sparks Pond Land and Water Reserve"                          , 40.387040, -89.813282, 2019,
    "Vesely Prairie LWR - Wilmington Shrub Prairie"               , 41.280036, -88.152821, 2019,
    "Witkowsky State Fish Wildlife Area"                          , 42.293676, -90.343588, 2019,
    "Zoeller State Natural Area"                                  , 38.451379, -90.168036, 2019
  )
}
