# cyclestatsv2

Analysis of Cycling Rides

![R](https://img.shields.io/badge/R-%3E%3D4.1.0-blue)![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

## Overview

`cyclestatsv2` is a Shiny application for exploring and analyzing
personal cycling ride data. It is built as an R package using the
[golem](https://thinkr-open.github.io/golem/) framework and draws from
pre-downloaded [Strava](https://www.strava.com/) activity data.

## Features

The app has a sidebar layout with a year filter and three main tabs:

- **Sidebar** — Filter the analysis by one or more years. Summary value
  boxes display the total number of rides and miles for the selected
  years.
- **Graph tab** — An interactive bar chart (powered by plotly) showing
  total miles ridden per month. Hovering shows the year-month, distance,
  and ride count.
- **Table tab** — A searchable, sortable data table of individual ride
  activities.
- **About tab** — Background information about the app.

## Installation

Clone the repository and install dependencies:

``` r

remotes::install_deps()
```

## Running the App

``` r

pkgload::load_all()
run_app()
```

Or use the **Run App** button in RStudio with `app.R` open.

## Data

The app reads from a pre-downloaded `activities.csv` exported from
Strava. Place the file at:

    inst/extdata/activities.csv

This is the standard Strava bulk export format (available from your
Strava account settings under **My Account → Download or Delete Your
Account**). The app uses the following columns by position and name:

| Column | Strava export name   |
|--------|----------------------|
| 1      | Activity ID          |
| 2      | Activity Date        |
| 3      | Activity Name        |
| 4      | Activity Type        |
| 5      | Distance             |
| 6      | Moving Time          |
| 7      | *(reserved)*         |
| 17     | *(avg speed source)* |

Only rows where `Activity Type == "Ride"` are retained. Distances are
converted from kilometres to miles.

## Deployment

``` r

rsconnect::deployApp()
```

## Dependencies

Key packages used:

- **UI/App**: `shiny`, `bslib`, `bsicons`, `shinyjs`
- **Data**: `dplyr`, `readr`, `lubridate`, `stringr`
- **Visualization**: `ggplot2`, `plotly`
- **Tables**: `DT`

## License

MIT
