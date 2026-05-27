#' Application UI
#'
#' @param request Internal Shiny request object.
#' @return A Shiny UI definition.
#'
#' @import bslib
#' @import bsicons
#' @import shiny
#' @importFrom DT DTOutput
#' @rawNamespace import(shinyjs, except = c(runExample))
#' @rawNamespace import(plotly, except = last_plot)
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    useShinyjs(),
    page_sidebar(
      title = "Cycling Analysis",
      bg = "lightblue",
      sidebar = checkboxGroupInput(
        inputId = "selected_years",
        label = "Selected Year(s):",
        choices = .cyclestats_data$available_years
      ),
      layout_columns(
        fill = FALSE,
        value_box(
          title = "Rides",
          value = textOutput("number_of_rides"),
          showcase = bsicons::bs_icon("bicycle")
        ),
        value_box(
          title = "Miles",
          value = textOutput("number_of_miles"),
          showcase = bsicons::bs_icon("speedometer2")
        )
      ),
      navset_card_pill(
        id = "tab_being_displayed",
        nav_panel("Graph", plotly::plotlyOutput("miles_graph", width = "auto", height = "auto")),
        nav_panel("Table", div(DT::DTOutput("miles_table"), style = "font-size:80%")),
        nav_panel("About", uiOutput("about_text"))
      )
    )
  )
}

# Register inst/app/www/ as the "www" resource path so the browser can
# resolve static assets (images, CSS, etc.) under that prefix.
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )
  tags$head(
    golem::favicon()
  )
}
