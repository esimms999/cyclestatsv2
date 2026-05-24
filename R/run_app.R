#' Run the cyclestatsv2 Shiny Application
#'
#' Main entry point. Initialises data then launches the app.
#'
#' @param onStart Passed to [shiny::shinyApp()].
#' @param options Named list of options passed to [shiny::shinyApp()].
#' @param enableBookmarking Passed to [shiny::shinyApp()].
#' @param uiPattern Passed to [shiny::shinyApp()].
#' @param ... Additional arguments passed as golem options.
#'
#' @export
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  cyclestats_init()

  golem::with_golem_options(
    app = shiny::shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
