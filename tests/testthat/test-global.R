test_that("imported/cleaned data does not have invalid values for distance", {
  invalid_data_distance <- .cyclestats_data$activities |>
    dplyr::filter(is.na(activity_distance) | activity_distance <= 0)
  expect_equal(nrow(invalid_data_distance), 0)
})
