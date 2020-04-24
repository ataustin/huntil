get_manual_site_coords <- function() {
  tibble::tribble(
    ~site_name,                                                     ~lat,      ~lon,
    "Adeline Jay Geo-Karis Illinois Beach State Park Archery Deer", 42.429931, -87.819456,
    "Black Crown Marsh Waterfowl"                                 , 42.321324, -88.207433,
    "Buffalo Prairie Pheasant Habitat Area"                       , 41.040309, -90.044469,
    "Burning Star"                                                , 37.886680, -89.219607,
    "Chatsworth State Habitat Area"                               , 40.684360, -88.284936,
    "Cretaceous Hills State Natural Area"                         , 37.225263, -88.529764,
    "Dixon Springs"                                               , 37.384384, -88.677415,
    "Embarras River Bottoms State Habitat Area"                   , 38.664059, -87.634106,
    "Embarras River Waterfowl"                                    , 38.664059, -87.634106,
    "Goode's Woods Nature Preserve"                               , 39.452854, -89.934803,
    "Henry Allen Gleason Nature Preserve"                         , 40.420748, -89.866082,
    "I&M Canal Trapping"                                          , 41.346342, -88.479828,
    "Maxine Loy Land and Water Reserve"                           , 38.810191, -88.807785,
    "Mitchell's Grove Nature Preserve"                            , 41.376292, -89.067765,
    "Revis Hill Prairie Nature Preserve"                          , 40.151623, -89.852346,
    "Sinnissippi Lake State Fish and Wildlife Area"               , 41.782581, -89.636067,
    "Sparks Pond Land and Water Reserve"                          , 40.387040, -89.813282,
    "Vesely Prairie LWR - Wilmington Shrub Prairie"               , 41.280036, -88.152821,
    "Witkowsky State Fish Wildlife Area"                          , 42.293676, -90.343588,
    "Zoeller State Natural Area"                                  , 38.451379, -90.168036
  )
}
