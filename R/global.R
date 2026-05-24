# Mutable environment for app-wide data populated by cyclestats_init().
# Using an environment avoids <<- assignments to the global env, which are
# flagged by R CMD check and break when the package namespace is locked.
.cyclestats_data <- new.env(parent = emptyenv())

# Suppress R CMD check notes for bare column names used in dplyr pipelines.
utils::globalVariables(c(
  # dplyr column names referenced bare in cyclestats_init
  "activity_type", "activity_id", "activity_datetime", "activity_name",
  "activity_distance", "activity_moving_time", "activity_date",
  "activity_month", "activity_avg_speed",
  # dplyr column names referenced bare in app_server
  "activity_year", "activity_year_month",
  "ride_count", "total_distance", "total_rides"
))

#' Prepare data for use within the app
#'
#' Reads the Strava activities CSV, filters to cycling rides, converts units,
#' and creates the global objects used by the UI and server.
#'
#' @export
#' @importFrom dplyr arrange filter group_by mutate rename select summarise
#' @importFrom readr read_csv
cyclestats_init <- function() {
  .cyclestats_data$activities <- readr::read_csv(
    system.file("extdata/activities.csv", package = "cyclestatsv2"),
    show_col_types = FALSE,
    col_select = c(1:7, 17),
    name_repair = "minimal"
  ) |>

    dplyr::rename(
      "activity_id"          = "Activity ID",
      "activity_datetime"    = "Activity Date",
      "activity_name"        = "Activity Name",
      "activity_type"        = "Activity Type",
      "activity_distance"    = "Distance",
      "activity_moving_time" = "Moving Time"
    ) |>

    dplyr::filter(activity_type == "Ride") |>
    dplyr::select(activity_id, activity_datetime, activity_name,
                  activity_distance, activity_moving_time) |>

    # Strava exports descending; sort ascending by ID.
    dplyr::arrange(activity_id) |>

    # Fix a known data error
    dplyr::mutate(
      activity_moving_time = ifelse(activity_id == "2949643229", 3271, activity_moving_time)
    ) |>

    dplyr::mutate(
      activity_id         = as.character(activity_id),
      activity_date       = format(as.Date(lubridate::mdy(
                              stringr::str_sub(activity_datetime, 1L, 12L)), "%Y-%m-%d")),
      activity_year       = format(as.Date(activity_date), "%Y"),
      activity_month      = format(as.Date(activity_date), "%m"),
      activity_year_month = format(as.Date(activity_date), "%Y-%m"),
      # Convert km to miles
      activity_distance   = round(activity_distance * 0.6214, digits = 2),
      activity_avg_speed  = round(activity_distance / (activity_moving_time / 3600), digits = 2)
    ) |>

    dplyr::select(activity_id, activity_name, activity_datetime, activity_date,
                  activity_year, activity_month, activity_year_month,
                  activity_distance, activity_avg_speed)

  .cyclestats_data$available_years <- as.list(unique(.cyclestats_data$activities$activity_year))

  # Template of every year-month with zero values; merged with actuals in
  # the server so months with no rides still appear on the chart.
  activity_year <- c()
  activity_year_month <- c()
  for (year in .cyclestats_data$available_years) {
    for (month in 1:12) {
      year_month <- paste(year, formatC(month, width = 2, flag = 0), sep = "-")
      activity_year_month <- append(activity_year_month, year_month)
      activity_year       <- append(activity_year, year)
    }
  }

  .cyclestats_data$activity_year_month_zero <- data.frame(activity_year, activity_year_month) |>
    dplyr::arrange(activity_year_month)
}
