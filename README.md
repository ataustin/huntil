# Illinois Hunting

Simplify site identification for hunting in IL by viewing squirrel hunting sites on a map with pop-up site information.

Point your browser to [https://ataustin.github.io/huntil/](https://ataustin.github.io/huntil/).

### Updating the website

Use the function `refresh_dashboard()` to update the top-level `index.html` file.  To update the map, set `refresh_sites = TRUE`.  To update the seasons data, set `refresh_seasons = TRUE`.  Check in `index.html` to update the public-facing website.

After updating sites or seasons data, re-install the package to have the latest data available from the `data()` function.